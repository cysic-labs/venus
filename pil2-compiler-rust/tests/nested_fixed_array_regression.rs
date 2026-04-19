//! Regression for nested fixed-column array indexing.
//!
//! `fixed_arr[col][row]` (the shape used by `std_connection.pil`'s
//! `CONN_<opid>[col][row]` reads) must:
//!   - on inner `[col]`: array-of-cols, return a single sub-
//!     column reference at `arr_base + col`.
//!   - on outer `[row]`: row-level read, return the scalar value
//!     at that row.
//!
//! Round 18 commit `6a8c7023` added a Fixed-col disambiguation in
//! `eval_expr`'s ArrayIndex match that incorrectly took the
//! array-of-cols path on the outer `[row]` index whenever the
//! base id fell inside an array-declared label range. Round 19
//! moves the stale-array-dims recovery to `eval_reference` so the
//! `ArrayRef` form is produced at reference time and the outer
//! `[row]` index is correctly handled by the existing row-read
//! branch in `eval_expr`.
//!
//! This test compiles a single-AIR fixture that constrains a
//! witness column against a compile-time `F[0][3]` read of a
//! `col fixed F[2]` array. The post-fix protobuf must not carry
//! a Fixed-col operand in the constraint expression — instead it
//! must carry a Constant for the row-3 value of sub-column 0.

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
fn nested_fixed_array_row_read_resolves_to_scalar() {
    let fixture = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("tests")
        .join("data")
        .join("minimal_nested_fixed_array.pil");

    let outdir = PathBuf::from(env!("CARGO_TARGET_TMPDIR"));
    let pilout_path = outdir.join("nested_fixed_array.pilout");
    let fixed_dir = outdir.join("nested_fixed_array_fixed");
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
        .find(|a| a.name() == "NestedFixedArrayAir")
        .expect("NestedFixedArrayAir not found");

    assert!(
        !air.constraints.is_empty(),
        "NestedFixedArrayAir emitted no constraints"
    );

    // Walk every constraint expression. Assert no Fixed-col
    // operand appears anywhere in the resolved tree, AND assert
    // that the Constant operand on the RHS of `W === F[0][3]`
    // carries the correct scalar `3` (not an empty / zero byte
    // slice that the Round 18 buggy disambiguation produced when
    // the outer index was wrongly treated as another array offset
    // and resolved to an out-of-range Fixed col id).
    let mut found_witness = false;
    let mut found_constant: Option<Vec<u8>> = None;
    for (ci, c) in air.constraints.iter().enumerate() {
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
            let mut ops: Vec<pb::operand::Operand> = Vec::new();
            collect_operands_in_expr(&air.expressions[idx], &mut ops);
            for op in ops {
                match op {
                    pb::operand::Operand::FixedCol(fc) => {
                        panic!(
                            "constraint #{} carries a FixedCol operand idx={} \
                             rowOffset={}: F[0][3] was resolved as a column \
                             reference instead of a scalar row read. The \
                             outer ArrayIndex must produce Value::Int(row), \
                             not ColRef{{Fixed, base + col + row}}.",
                            ci, fc.idx, fc.row_offset
                        );
                    }
                    pb::operand::Operand::Expression(e) => {
                        stack.push(e.idx as usize);
                    }
                    pb::operand::Operand::WitnessCol(_) => {
                        found_witness = true;
                    }
                    pb::operand::Operand::Constant(c) => {
                        found_constant = Some(c.value.clone());
                    }
                    _ => {}
                }
            }
        }
    }

    assert!(
        found_witness,
        "constraint did not carry the expected WitnessCol operand for `W`"
    );
    let constant = found_constant.expect(
        "constraint did not carry a Constant operand for the RHS of `W === F[0][3]`",
    );
    let scalar: u64 = if constant.is_empty() {
        0
    } else {
        let mut buf = [0u8; 8];
        let n = constant.len().min(8);
        buf[..n].copy_from_slice(&constant[..n]);
        u64::from_le_bytes(buf)
    };
    assert_eq!(
        scalar, 3,
        "constraint RHS Constant resolved to {} (raw bytes={:?}); expected 3 \
         (= F[0][3] = 0 * N + 3 with N=8). An empty / zero value here is the \
         Round 18 buggy ArrayIndex Fixed-col disambiguation: the outer [3] \
         index was treated as another array-of-cols offset, producing \
         ColRef{{Fixed, F_base + 3}} which the serializer then read as an \
         out-of-range fixed row.",
        scalar, constant
    );
}
