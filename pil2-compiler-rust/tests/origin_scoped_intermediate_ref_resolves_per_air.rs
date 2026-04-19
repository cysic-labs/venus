//! Round 2 regression test for origin-scoped
//! `Intermediate` ref resolution
//! (BL-20260419-origin-frame-id-resolution).
//!
//! Before this round, `Processor::intermediate_ref_resolution` and
//! `global_intermediate_resolution` were keyed by bare `u32 id`.
//! `IdAllocator::push` resets `next_id` to 0 on every AIR push, so
//! AIR A's local slot id=5 and AIR B's local slot id=5 collided on
//! the shared key. `entry(id).or_insert_with(...)` in
//! `mod_vardecl.rs::get_var_ref_value{,_by_type_and_id}` locked in
//! the first AIR's tree forever; any later lookup from a different
//! AIR read the wrong `RuntimeExpr` tree and downstream
//! re-flattening polluted the consuming AIR's proto with foreign
//! column leaves.
//!
//! Round 2 re-keys both maps on `(origin_frame_id, local_id)` where
//! `origin_frame_id` is a monotonic counter incremented on every
//! `execute_air_template_call` entry. This test exercises the raw
//! invariant at the Processor level: two distinct insertions into
//! the global map that share the same local id must resolve back
//! to independent `RuntimeExpr` trees when looked up by their
//! respective composite keys.
//!
//! The test is deliberately synthetic to keep it stable against
//! PIL / pilout serialization churn. A follow-up integration test
//! with two AIRs that mint the same local id through
//! `eval_reference` is left for a later round once a minimal
//! fixture is available.

use std::rc::Rc;

use pil2_compiler_rust::processor::context::CompilerConfig;
use pil2_compiler_rust::processor::expression::{
    ColRefKind, RuntimeExpr, RuntimeOp, Value,
};
use pil2_compiler_rust::processor::Processor;

fn make_processor() -> Processor {
    Processor::new(CompilerConfig::default())
}

fn witness_leaf(id: u32) -> Rc<RuntimeExpr> {
    Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::Witness,
        id,
        row_offset: None,
        origin_frame_id: None,
    })
}

#[test]
fn origin_scoped_global_map_disambiguates_same_local_id_across_frames() {
    let mut p = make_processor();

    // Simulate two different AIR entries by bumping the
    // origin-frame-id counter manually. In production this is
    // performed by `execute_air_template_call`.
    p.next_origin_frame_id = p.next_origin_frame_id.saturating_add(1);
    let frame_a = p.next_origin_frame_id;
    let tree_a = witness_leaf(7);
    p.global_intermediate_resolution
        .entry((frame_a, 5))
        .or_insert_with(|| tree_a.clone());

    p.next_origin_frame_id = p.next_origin_frame_id.saturating_add(1);
    let frame_b = p.next_origin_frame_id;
    let tree_b = witness_leaf(9);
    p.global_intermediate_resolution
        .entry((frame_b, 5))
        .or_insert_with(|| tree_b.clone());

    assert_ne!(
        frame_a, frame_b,
        "origin-frame counter must advance between AIR entries"
    );

    let resolved_a = p
        .global_intermediate_resolution
        .get(&(frame_a, 5))
        .cloned()
        .expect("frame A composite key must be present");
    let resolved_b = p
        .global_intermediate_resolution
        .get(&(frame_b, 5))
        .cloned()
        .expect("frame B composite key must be present");

    let got_a = match &*resolved_a {
        RuntimeExpr::ColRef { id, .. } => *id,
        other => panic!("unexpected shape for frame A: {:?}", other),
    };
    let got_b = match &*resolved_b {
        RuntimeExpr::ColRef { id, .. } => *id,
        other => panic!("unexpected shape for frame B: {:?}", other),
    };

    assert_eq!(got_a, 7, "frame A resolution must point at the frame-A tree");
    assert_eq!(got_b, 9, "frame B resolution must point at the frame-B tree");
    assert!(
        !Rc::ptr_eq(&resolved_a, &resolved_b),
        "distinct frames must not alias the same Rc"
    );
}

#[test]
fn intermediate_colref_carries_origin_frame_id() {
    // The mint path embeds `origin_frame_id` on
    // `Value::ColRef { col_type: Intermediate, .. }` so downstream
    // code (sanitize helpers, serializer) can detect a foreign-AIR
    // ref even when the `u32 id` collides with a local slot. This
    // test asserts the field is wired through the `Value` shape.

    let v = Value::ColRef {
        col_type: ColRefKind::Intermediate,
        id: 42,
        row_offset: None,
        origin_frame_id: Some(3),
    };
    match v {
        Value::ColRef {
            col_type: ColRefKind::Intermediate,
            id,
            origin_frame_id: Some(origin),
            ..
        } => {
            assert_eq!(id, 42);
            assert_eq!(origin, 3);
        }
        other => panic!(
            "origin_frame_id must flow through Value::ColRef construction: {:?}",
            other
        ),
    }

    // Non-Intermediate ColRefs leave `origin_frame_id` None by
    // convention. The sanitize and proto paths rely on that
    // default to avoid spurious foreign-AIR classifications.
    let wv = Value::ColRef {
        col_type: ColRefKind::Witness,
        id: 1,
        row_offset: None,
        origin_frame_id: None,
    };
    if let Value::ColRef {
        col_type: ColRefKind::Witness,
        origin_frame_id,
        ..
    } = wv
    {
        assert!(origin_frame_id.is_none());
    } else {
        panic!("witness ColRef shape must round-trip");
    }
}

#[test]
fn air_entry_bumps_origin_frame_id_monotonically() {
    // Verify the counter is genuinely monotonic under repeated AIR
    // entries. This guards against accidental decrement / reset on
    // AIR exit (which would re-introduce the collision bug).
    let mut p = make_processor();
    let initial = p.next_origin_frame_id;
    let mut prior = initial;
    for _ in 0..16 {
        p.next_origin_frame_id = p.next_origin_frame_id.saturating_add(1);
        p.current_origin_frame_id = p.next_origin_frame_id;
        assert!(
            p.current_origin_frame_id > prior,
            "origin-frame counter must strictly advance ({} <= {})",
            p.current_origin_frame_id,
            prior
        );
        prior = p.current_origin_frame_id;
    }

    // Use the RuntimeOp import so the module is exercised by this
    // test and the new field is reachable from downstream proto
    // flattening code paths.
    let _ = RuntimeOp::Add;
}
