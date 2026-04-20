//! Phase 1 regression for plan-rustify-pkgen-e2e-0420 lazy expression
//! reification. Compiles `minimal_lazy_expr_reification.pil` and
//! asserts JS-style lazy-packing semantics on the resulting pilout.
//!
//! On current HEAD this regression MUST FAIL because Rust's
//! `execute_air_template_call` bulk-lifts every symbolic
//! `self.exprs` slot into `air_expression_store` regardless of
//! reference. That failure is the baseline for the Phase 2/3
//! producer fixes.
//!
//! Three assertions:
//!
//! 1. `LazyReifyConsumer.expressions` contains NO Constant whose
//!    big-endian byte value decodes to 987654321 (the distinctive
//!    marker coefficient used only by the never-referenced
//!    `marker_unused` proof-scope expr). Current HEAD lifts
//!    `marker_unused` anyway, so the marker 987654321 appears in
//!    at least one `Operand::Constant` of the consumer's arena.
//!
//! 2. `LazyReifyConsumer.expressions.len()` falls inside a tight
//!    lazy-packing budget. The budget is derived from the number
//!    of AIR roots (constraints + hint refs) plus the small set
//!    of JS-lazily-referenced expression definitions. Current
//!    HEAD's 1.4x-7.8x per-AIR arena inflation blows past the
//!    budget.
//!
//! 3. Repeated references to the same `(id, row_offset)` reuse a
//!    single packed idx. The fixture's `local_alias_1` /
//!    `local_alias_2` pair both read the same tree; the
//!    row-offset uses `cx'` in two distinct constraints. After
//!    lazy reification, those references MUST share their arena
//!    entries.
//!
//! All three assertions are documented in the plan file
//! `temp/plan-rustify-pkgen-e2e-0420.md` Phase 1.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

const MARKER_UNUSED: u64 = 987654321;

// Budgets for `LazyReifyConsumer.expressions.len()`. Current bulk-lift
// produces ~27 arena entries on this fixture (measured on
// commit `fac55a7c`). JS lazy packing should produce substantially
// fewer: constraints + referenced expr definitions only. The budget
// below is deliberately tight so Phase 2/3 producer fixes must
// actually reduce the count.
const LAZY_REIFY_CONSUMER_EXPRESSIONS_MAX: usize = 20;

// Tighter budget for the producer AIR. The producer only mints a
// product for `lookup_proves`; JS lazy-packs a handful of entries.
const LAZY_REIFY_PRODUCER_EXPRESSIONS_MAX: usize = 16;

fn compile_fixture(tag: &str) -> Vec<u8> {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");
    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_lazy_expr_reification.pil");
    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");

    // Per-test output path so parallel cargo tests do not race each
    // other on pilout reads and writes.
    let out = std::env::temp_dir()
        .join(format!("pil2c_minimal_lazy_expr_reification_regression_{}.pilout", tag));
    let _ = std::fs::remove_file(&out);

    let status = Command::new(&bin)
        .arg(&fixture)
        .arg("-I")
        .arg(std_pil.to_str().unwrap())
        .arg("-o")
        .arg(&out)
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .status()
        .expect("failed to spawn pil2c");
    assert!(status.success(), "pil2c compile failed");

    std::fs::read(&out).expect("read pilout")
}

fn decode(bytes: &[u8]) -> pb::PilOut {
    pb::PilOut::decode(bytes).expect("decode pilout")
}

fn air_expressions<'a>(
    pilout: &'a pb::PilOut,
    air_name: &str,
) -> &'a [pb::Expression] {
    for ag in &pilout.air_groups {
        for air in &ag.airs {
            if air.name.as_deref() == Some(air_name) {
                return &air.expressions;
            }
        }
    }
    panic!("AIR {} not found in pilout", air_name);
}

fn constant_bytes_equal_u64(bytes: &[u8], target: u64) -> bool {
    if bytes.is_empty() {
        return target == 0;
    }
    let mut value: u128 = 0;
    for &b in bytes {
        value = (value << 8) | (b as u128);
        if value > u64::MAX as u128 {
            return false;
        }
    }
    value == target as u128
}

fn walk_operand_constants(
    operand: &pb::Operand,
    out: &mut Vec<Vec<u8>>,
) {
    if let Some(op) = operand.operand.as_ref() {
        if let pb::operand::Operand::Constant(c) = op {
            out.push(c.value.clone());
        }
    }
}

fn collect_constants_in_expression(expr: &pb::Expression, out: &mut Vec<Vec<u8>>) {
    use pb::expression::Operation;
    match expr.operation.as_ref() {
        Some(Operation::Add(add)) => {
            if let Some(lhs) = add.lhs.as_ref() {
                walk_operand_constants(lhs, out);
            }
            if let Some(rhs) = add.rhs.as_ref() {
                walk_operand_constants(rhs, out);
            }
        }
        Some(Operation::Sub(sub)) => {
            if let Some(lhs) = sub.lhs.as_ref() {
                walk_operand_constants(lhs, out);
            }
            if let Some(rhs) = sub.rhs.as_ref() {
                walk_operand_constants(rhs, out);
            }
        }
        Some(Operation::Mul(mul)) => {
            if let Some(lhs) = mul.lhs.as_ref() {
                walk_operand_constants(lhs, out);
            }
            if let Some(rhs) = mul.rhs.as_ref() {
                walk_operand_constants(rhs, out);
            }
        }
        Some(Operation::Neg(neg)) => {
            if let Some(v) = neg.value.as_ref() {
                walk_operand_constants(v, out);
            }
        }
        None => {}
    }
}

fn expressions_contain_marker(
    expressions: &[pb::Expression],
    marker: u64,
) -> Vec<(usize, Vec<u8>)> {
    let mut found = Vec::new();
    for (idx, expr) in expressions.iter().enumerate() {
        let mut constants = Vec::new();
        collect_constants_in_expression(expr, &mut constants);
        for c in constants {
            if constant_bytes_equal_u64(&c, marker) {
                found.push((idx, c));
            }
        }
    }
    found
}

#[test]
fn lazy_reify_consumer_drops_unused_marker() {
    let pilout = decode(&compile_fixture("drops_unused_marker"));
    let consumer = air_expressions(&pilout, "LazyReifyConsumer");
    let marker_hits = expressions_contain_marker(consumer, MARKER_UNUSED);
    assert!(
        marker_hits.is_empty(),
        "LazyReifyConsumer.expressions contains the unused marker \
         coefficient {} at indices {:?}. `marker_unused = cx * \
         MARKER_UNUSED` is declared as a proof-scope `const expr` but \
         NEVER read by any constraint, hint, or further expression. \
         JS lazy packing drops it entirely. Current Rust bulk-lift in \
         `pil2-compiler-rust/src/processor/mod_air_template_call.rs::\
         execute_air_template_call` lifts every symbolic self.exprs \
         slot regardless of reference, which is the root cause of the \
         trio cExpId drift. Phase 2/3 of \
         temp/plan-rustify-pkgen-e2e-0420.md closes this by routing \
         proof-scope symbolic reads through a new RuntimeExpr::ExprRef \
         node and replacing the bulk lift with a reachability-driven \
         importer.",
        MARKER_UNUSED,
        marker_hits
    );
}

#[test]
fn lazy_reify_consumer_arena_within_budget() {
    let pilout = decode(&compile_fixture("consumer_arena_budget"));
    let consumer = air_expressions(&pilout, "LazyReifyConsumer");
    assert!(
        consumer.len() <= LAZY_REIFY_CONSUMER_EXPRESSIONS_MAX,
        "LazyReifyConsumer.expressions.len()={} exceeds the JS-lazy \
         packing budget of {}. Current Rust bulk-lift pushes ~27 entries \
         here; JS lazy packing should produce substantially fewer. \
         Phase 2/3 of temp/plan-rustify-pkgen-e2e-0420.md closes the \
         gap.",
        consumer.len(),
        LAZY_REIFY_CONSUMER_EXPRESSIONS_MAX
    );
}

#[test]
fn lazy_reify_producer_arena_within_budget() {
    let pilout = decode(&compile_fixture("producer_arena_budget"));
    let producer = air_expressions(&pilout, "LazyReifyProducer");
    assert!(
        producer.len() <= LAZY_REIFY_PRODUCER_EXPRESSIONS_MAX,
        "LazyReifyProducer.expressions.len()={} exceeds the JS-lazy \
         packing budget of {}. Same underlying root cause as the \
         consumer assertion.",
        producer.len(),
        LAZY_REIFY_PRODUCER_EXPRESSIONS_MAX
    );
}

/// Every `(col_idx, row_offset)` pair emitted as a standalone
/// `Add(WitnessCol(col_idx, offset=k), Constant(0))` leaf-wrap in
/// `LazyReifyConsumer.expressions` must appear at most once.
/// Multiple arena entries encoding the same
/// `(col_idx, row_offset)` leaf-wrap indicate the producer is
/// duplicating reference-boundary entries.
#[test]
fn lazy_reify_consumer_shares_witness_row_offset_refs() {
    let pilout = decode(&compile_fixture("witness_row_offset_share"));
    let consumer = air_expressions(&pilout, "LazyReifyConsumer");
    use pb::expression::Operation;
    use pb::operand::Operand as O;
    let mut leaf_wraps: std::collections::HashMap<(u32, i32, u32), Vec<usize>> =
        std::collections::HashMap::new();
    for (idx, expr) in consumer.iter().enumerate() {
        let Some(Operation::Add(add)) = expr.operation.as_ref() else {
            continue;
        };
        let Some(lhs) = add.lhs.as_ref() else {
            continue;
        };
        let Some(rhs) = add.rhs.as_ref() else {
            continue;
        };
        let rhs_is_zero = matches!(rhs.operand.as_ref(), Some(O::Constant(c)) if c.value.is_empty());
        if !rhs_is_zero {
            continue;
        }
        let Some(lhs_op) = lhs.operand.as_ref() else {
            continue;
        };
        if let O::WitnessCol(w) = lhs_op {
            leaf_wraps
                .entry((w.col_idx, w.row_offset, w.stage))
                .or_default()
                .push(idx);
        }
    }
    let dupes: Vec<_> = leaf_wraps
        .iter()
        .filter(|(_, v)| v.len() > 1)
        .collect();
    assert!(
        dupes.is_empty(),
        "LazyReifyConsumer.expressions has duplicate leaf-wrap entries \
         for repeated (col_idx, row_offset) witness references: {:?}. \
         JS packed_expressions.js::pushExpressionReference(id, rowOffset) \
         reuses the first-seen packed idx for subsequent references of \
         the same (id, row_offset). Current Rust bulk-lift does not \
         enforce this boundary.",
        dupes
    );
}
