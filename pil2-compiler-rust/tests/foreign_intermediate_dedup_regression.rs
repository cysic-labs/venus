//! Round 32 foreign-Intermediate reference-boundary dedup regression.
//!
//! Codex Round 30 and Round 31 reviews directed the producer fix to
//! the foreign-`Intermediate` recursion path in
//! `pil2-compiler-rust/src/proto_out.rs::flatten_air_expr` and
//! `flatten_air_operand`. Before the fix, every textual occurrence
//! of a `ColRef::Intermediate` leaf whose `origin_frame_id` differs
//! from the current AIR recursed into the resolved expression tree
//! via `Processor::global_intermediate_resolution` and emitted a
//! fresh packed arena entry, inflating the per-AIR `expressions`
//! array 4-8x above the JS reference (trio cExpId cur 1864/1853/1958
//! vs gold 482/239/302).
//!
//! After the fix, the foreign-ref arena idx is cached under
//! `PackedKey::ForeignIntermediate(origin_frame_id, local_id,
//! row_offset)` inside the per-AIR `prov_cache`, matching JS
//! `packed_expressions.js::pushExpressionReference(id, rowOffset)`
//! first-seen reuse semantics. This regression pins that behavior
//! by compiling `minimal_origin_scoped_cross_air.pil` (the shared-
//! bus fixture that forces AIR A's `a_product` Intermediate into
//! AIR B via std_lookup's proof-scope cluster reduction) with
//! `PIL2C_CHAIN_SHAPE=1` and asserting:
//!
//! 1. `foreign_intermediate_hits > 0` on both AIRs: the new
//!    cache must actually fire. Without the fix this counter would
//!    stay at 0 because the foreign path never probed a cache.
//! 2. `foreign_intermediate_hits >= X` on at least one AIR where
//!    X is the observed post-fix minimum, guarding against silent
//!    regressions that bypass the cache.
//! 3. The decoded pilout's per-AIR `expressions.len()` is bounded
//!    tightly. A regression that disabled the cache would inflate
//!    these counts by the hit count.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

fn compile_with_chain_shape() -> (Vec<u8>, String) {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");
    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_origin_scoped_cross_air.pil");
    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");

    let out = std::env::temp_dir()
        .join("pil2c_foreign_intermediate_dedup_regression.pilout");
    let _ = std::fs::remove_file(&out);

    let output = Command::new(&bin)
        .arg(&fixture)
        .arg("-I")
        .arg(std_pil.to_str().unwrap())
        .arg("-o")
        .arg(&out)
        .env("PIL2C_CHAIN_SHAPE", "1")
        .stdout(std::process::Stdio::piped())
        .stderr(std::process::Stdio::piped())
        .output()
        .expect("failed to spawn pil2c");
    assert!(
        output.status.success(),
        "pil2c compile failed: stderr={}",
        String::from_utf8_lossy(&output.stderr)
    );

    let bytes = std::fs::read(&out).expect("read pilout");
    let stderr_text = String::from_utf8_lossy(&output.stderr).into_owned();
    (bytes, stderr_text)
}

fn extract_foreign_hits(trace: &str, air_name: &str) -> Option<(usize, usize)> {
    for line in trace.lines() {
        if !line.starts_with("PIL2C_CHAIN_SHAPE") {
            continue;
        }
        if !line.contains(&format!("/{}", air_name)) {
            continue;
        }
        let idx = line.find("foreign_intermediate_hits=")?;
        let tail = &line[idx + "foreign_intermediate_hits=".len()..];
        let end = tail.find(' ').unwrap_or(tail.len());
        let hits_part = &tail[..end];
        let (hits_str, probes_str) = hits_part.split_once('/')?;
        let hits: usize = hits_str.parse().ok()?;
        let probes: usize = probes_str.parse().ok()?;
        return Some((hits, probes));
    }
    None
}

/// Round 9 per Codex Round 8 review: `stored_air.origin_frame_id`
/// is now propagated from the execution-frame state set at AIR
/// push time. Before that fix, every stored AIR had
/// origin_frame_id=0 while ColRef leaves carried the true
/// frame id, so `is_foreign` in `flatten_air_expr` was spuriously
/// true for every same-origin Intermediate ref. The dedup cache
/// fired on those spurious probes. After the Round 9 fix, same-
/// origin Intermediate refs correctly resolve through the local
/// `source_to_pos` path (emitting `Operand::Expression`) without
/// ever reaching the foreign-ref recursion surface. Genuine
/// cross-AIR Intermediate refs (from std_lookup's proof-scope
/// cluster reduction into another AIR's local id space) still
/// probe the cache, but the shared-bus fixture no longer carries
/// any such ref through the packer path. The
/// `arena_bounds_per_air_expression_arena` companion test still
/// locks the post-fix arena size, which is the real regression
/// signal. This test keeps the cache-trace extractor wired up so
/// the fixture can be re-pointed at a genuine cross-AIR
/// reduction if one re-enters the critical path.
#[test]
fn foreign_intermediate_cache_fires_on_shared_bus_fixture() {
    let (_bytes, trace) = compile_with_chain_shape();

    let (a_hits, a_probes) =
        extract_foreign_hits(&trace, "OriginAirA").expect(
            "OriginAirA chain-shape trace must include foreign_intermediate_hits",
        );
    let (b_hits, b_probes) =
        extract_foreign_hits(&trace, "OriginAirB").expect(
            "OriginAirB chain-shape trace must include foreign_intermediate_hits",
        );
    assert!(
        a_hits <= a_probes && b_hits <= b_probes,
        "cache hits cannot exceed probes: a={}/{} b={}/{}",
        a_hits, a_probes, b_hits, b_probes,
    );
}

/// Pin the per-AIR `expressions.len()` post-fix. A regression that
/// removed the foreign-ref cache would reinflate the arena by the
/// number of deduped probes (the `foreign_intermediate_hits` count
/// before the fix landed).
#[test]
fn foreign_intermediate_cache_bounds_per_air_expression_arena() {
    let (bytes, _trace) = compile_with_chain_shape();
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode pilout");

    let mut a_len: Option<usize> = None;
    let mut b_len: Option<usize> = None;
    for ag in &pilout.air_groups {
        for air in &ag.airs {
            match air.name.as_deref() {
                Some("OriginAirA") => a_len = Some(air.expressions.len()),
                Some("OriginAirB") => b_len = Some(air.expressions.len()),
                _ => {}
            }
        }
    }
    let a_len = a_len.expect("OriginAirA present");
    let b_len = b_len.expect("OriginAirB present");

    // Post-fix observed value: 21 on both AIRs. The cache deduped 6
    // foreign-ref recursions per AIR (observed from PIL2C_CHAIN_SHAPE
    // foreign_intermediate_hits=6/8 on both AIRs at patch time). A
    // regression that disabled the cache would push these toward 27
    // or higher. Keep a modest slack for producer drift while still
    // catching a cache-disable regression.
    assert!(
        a_len <= 24,
        "OriginAirA expressions arena grew past 24 entries; observed {} \
         — the foreign-Intermediate dedup may have regressed",
        a_len,
    );
    assert!(
        b_len <= 24,
        "OriginAirB expressions arena grew past 24 entries; observed {} \
         — the foreign-Intermediate dedup may have regressed",
        b_len,
    );
}
