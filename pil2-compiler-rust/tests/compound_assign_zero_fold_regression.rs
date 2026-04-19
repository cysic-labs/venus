//! Regression for `expr` compound-assignment Mul-by-zero folding.
//!
//! `combine_symbolic` (`mod_vardecl.rs`) is the helper that
//! `exec_assignment` invokes for symbolic compound-assigns
//! (`+=`, `-=`, `*=`) on `expr`-typed variables. JS pil2-compiler
//! folds `mul, 0, x` and `mul, x, 0` to the literal 0 in its
//! analogous reduce step (`pil2-compiler/src/expression.js` lines
//! 924-932). Without the matching fold on the compound-assign
//! path, source patterns like `std_sum.pil`'s
//! `expr direct_num = 0; direct_num *= (gsum_e[idx] + std_gamma);`
//! produce a redundant `Mul(Number(0), key)` symbolic tree that
//! propagates into the pilout and downstream `qVerifier.code` as
//! `mul(number=0, ...)` ops.
//!
//! Round 20 added the fold to `eval_expr`'s BinaryOp arm but
//! missed the compound-assign path. Round 21 adds the fold to
//! `combine_symbolic` and locks the corrected behavior with this
//! regression. The fixture's `accum *= W` on a zero-initialized
//! `expr accum = 0` must reduce to literal 0; the resulting
//! constraint `X === accum` then becomes `Sub(X, 0)` and after
//! `Sub(x, 0) -> x` collapses to a single witness reference. The
//! post-fix proto must NOT carry any `WitnessCol` operand on the
//! RHS of the constraint (because that would mean `0 * W` was
//! emitted as `Mul(0, W)` and serialized).

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

fn collect_operands_in_expr(
    expr: &pb::Expression,
    out: &mut Vec<pb::operand::Operand>,
) {
    let Some(op) = &expr.operation else { return };
    let recurse_pair = |a: &Option<pb::Operand>, b: &Option<pb::Operand>, out: &mut Vec<_>| {
        for side in [a, b] {
            if let Some(operand) = side {
                if let Some(inner) = &operand.operand {
                    out.push(inner.clone());
                }
            }
        }
    };
    match op {
        pb::expression::Operation::Add(add) => recurse_pair(&add.lhs, &add.rhs, out),
        pb::expression::Operation::Sub(sub) => recurse_pair(&sub.lhs, &sub.rhs, out),
        pb::expression::Operation::Mul(mul) => recurse_pair(&mul.lhs, &mul.rhs, out),
        pb::expression::Operation::Neg(neg) => {
            if let Some(v) = &neg.value {
                if let Some(inner) = &v.operand {
                    out.push(inner.clone());
                }
            }
        }
    }
}

#[test]
fn compound_assign_zero_fold_collapses_mul_by_zero() {
    let fixture = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("tests")
        .join("data")
        .join("minimal_compound_assign_zero_fold.pil");

    let outdir = PathBuf::from(env!("CARGO_TARGET_TMPDIR"));
    let pilout_path = outdir.join("compound_assign_zero_fold.pilout");
    let fixed_dir = outdir.join("compound_assign_zero_fold_fixed");
    std::fs::create_dir_all(&fixed_dir).unwrap();

    let bin = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .join("target")
        .join("release")
        .join("pil2c");
    assert!(
        bin.exists(),
        "pil2c binary not built at {}; run cargo build --release first",
        bin.display()
    );

    let out = Command::new(&bin)
        .arg(&fixture)
        .arg("-o")
        .arg(&pilout_path)
        .arg("-u")
        .arg(&fixed_dir)
        .arg("-O")
        .arg("fixed-to-file")
        .output()
        .expect("pil2c spawn failed");
    assert!(
        out.status.success(),
        "pil2c failed: stdout={} stderr={}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );

    let bytes = std::fs::read(&pilout_path).expect("pilout read failed");
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("pilout decode failed");

    let air = pilout
        .air_groups
        .iter()
        .flat_map(|ag| ag.airs.iter())
        .find(|a| a.name() == "CompoundAssignZeroFoldAir")
        .expect("CompoundAssignZeroFoldAir not found");

    assert!(
        !air.constraints.is_empty(),
        "CompoundAssignZeroFoldAir emitted no constraints"
    );

    // Walk the constraint expression tree. Count WitnessCol leaves;
    // expect exactly ONE (X). If `accum *= W` did not fold to 0, the
    // tree carries a `Mul(Number(0), W)` subtree and we'd see TWO
    // WitnessCol leaves (X and W). Also ensure no Mul operation
    // appears in the resolved tree.
    let mut witness_count = 0usize;
    let mut mul_seen = false;
    for c in air.constraints.iter() {
        let exp_idx = c
            .constraint
            .as_ref()
            .and_then(|cv| match cv {
                pb::constraint::Constraint::FirstRow(r) => r.expression_idx.as_ref(),
                pb::constraint::Constraint::LastRow(r) => r.expression_idx.as_ref(),
                pb::constraint::Constraint::EveryRow(r) => r.expression_idx.as_ref(),
                pb::constraint::Constraint::EveryFrame(r) => r.expression_idx.as_ref(),
            })
            .map(|e| e.idx as usize)
            .expect("constraint missing expression idx");

        let mut stack: Vec<usize> = vec![exp_idx];
        let mut visited: Vec<bool> = vec![false; air.expressions.len()];

        while let Some(idx) = stack.pop() {
            if idx >= air.expressions.len() || visited[idx] {
                continue;
            }
            visited[idx] = true;
            let expr = &air.expressions[idx];
            if matches!(
                &expr.operation,
                Some(pb::expression::Operation::Mul(_))
            ) {
                mul_seen = true;
            }
            let mut ops: Vec<pb::operand::Operand> = Vec::new();
            collect_operands_in_expr(expr, &mut ops);
            for op in ops {
                match op {
                    pb::operand::Operand::WitnessCol(_) => {
                        witness_count += 1;
                    }
                    pb::operand::Operand::Expression(e) => {
                        stack.push(e.idx as usize);
                    }
                    _ => {}
                }
            }
        }
    }

    assert_eq!(
        witness_count, 1,
        "expected exactly ONE WitnessCol in the constraint tree (just X). \
         Got {} witness leaves, indicating `accum *= W` did NOT fold to literal \
         0 and the proto carries a `Mul(Number(0), W)` subtree (W is a leaked \
         witness leaf). Add Mul-by-zero folds to mod_vardecl.rs::combine_symbolic.",
        witness_count
    );
    assert!(
        !mul_seen,
        "constraint tree carries a `Mul` operation. The fixture's `accum *= W` \
         on a zero-initialized expr accumulator must reduce to literal 0, after \
         which `X === accum` becomes `Sub(X, 0)` and folds to a single \
         WitnessCol reference. A surviving `Mul` indicates the compound-assign \
         Mul-by-zero fold is missing."
    );
}
