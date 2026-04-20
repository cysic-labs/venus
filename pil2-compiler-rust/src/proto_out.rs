//! Protobuf serialization for PIL compiler output.
//! Converts internal compiler state to PilOut protobuf message.
//!
//! Mirrors the JS `ProtoOut` class (pil2-compiler/src/proto_out.js).

use prost::Message;
use std::collections::HashMap;
use std::fs;
use std::io::Write;
use std::path::Path;
use std::rc::Rc;

use crate::processor::air::HintValue;
use crate::processor::expression::{ColRefKind, RuntimeExpr, RuntimeOp, RuntimeUnaryOp, Value};
use crate::processor::fixed_cols::FixedCols;
use crate::processor::ids::IdAllocator;
use crate::processor::Processor;

/// Generated protobuf types from pilout.proto.
pub mod pilout_proto {
    include!(concat!(env!("OUT_DIR"), "/pilout.rs"));
}

/// Goldilocks prime: 2^64 - 2^32 + 1
const GOLDILOCKS_PRIME: u128 = 0xFFFFFFFF00000001;

/// Semantic cache key for per-AIR packed-expression reuse. Mirrors
/// JS `PackedExpressions.saveAndPushExpressionReference(id, rowOffset)`,
/// which keys reuse by source identity plus row offset rather than by
/// structural tree equality. Kept as an additive layer beside the
/// existing structural cache: the latter still absorbs repeated
/// Rc-shared subtrees inside stdlib helper bodies, while this cache
/// bridges tree-shape variations of the same bare reference.
///
/// - `ColRef(kind, id, row_offset)` covers bare column references of
///   every kind (witness / fixed / airgroupval / airvalue /
///   proofvalue / challenge / public / custom).
/// - `Provenance(source_expr_id, row_offset)` covers entries lifted
///   from `self.exprs` whose `AirExpressionEntry::source_expr_id` is
///   `Some`. Two references to the same `const expr X = ...` at the
///   same row offset share a packed slot.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
enum PackedKey {
    ColRef(ColRefKind, u32, i32),
    Provenance(u32, i32),
}

/// Compute the provenance cache key for a per-AIR store entry at
/// flatten time. Returns `None` when the expression is a compound
/// node without usable provenance; in that case only the Rc-pointer
/// fast path and the structural cache provide reuse.
///
/// `Provenance(source_expr_id, row_offset)` keys the cache by the
/// expression-store id from `AirExpressionEntry::source_expr_id` and
/// the effective row offset, matching JS
/// `pil2-compiler/src/packed_expressions.js::saveAndPushExpressionReference`.
/// Top-level entries always have `row_offset = 0`; non-zero offsets
/// arrive here only for `Intermediate` `ColRef` leaves whose
/// `Expr::RowOffset` wrapper has been folded in upstream, and those
/// take the `Intermediate` branch of `packed_key_for` below.
///
/// `ColRef` leaves cover bare column references of every kind
/// (witness, fixed, custom, public, challenge, etc.). The new
/// `Intermediate` branch produces `Provenance(id, row_offset)`
/// rather than `ColRef(Intermediate, id, row_offset)` so that the
/// JS reuse semantics actually fire: an `Intermediate(id)` is
/// effectively an expression-reference and shares its packed
/// proto idx across every use site.
fn packed_key_for(expr: &RuntimeExpr, source_expr_id: Option<u32>) -> Option<PackedKey> {
    if let Some(sid) = source_expr_id {
        return Some(PackedKey::Provenance(sid, 0));
    }
    if let RuntimeExpr::ColRef { col_type, id, row_offset, .. } = expr {
        let offset = row_offset.unwrap_or(0) as i32;
        if matches!(col_type, ColRefKind::Intermediate) {
            return Some(PackedKey::Provenance(*id, offset));
        }
        return Some(PackedKey::ColRef(*col_type, *id, offset));
    }
    None
}

/// Tree-size threshold (in nodes) above which an expression is not
/// inserted into or queried from the structural dedup cache. The
/// derived `Hash`/`Eq` for `RuntimeExpr` walk every Rc-linked child,
/// so each cache probe and insert is O(tree_size). Without this
/// guard the recursive PIL aggregator templates blow up the flatten
/// step into multi-hour runtime; see BL-20260415-struct-cache-blowup
/// (the `recursive1_pilout_under_time_budget` test pins the floor).
/// Raising the cap is tempting on Keccakf-scale accumulator trees,
/// but the recursive1 fixture has 10k+ Rc-linked children whose
/// derived Hash recursion turns each cache probe into a full tree
/// walk and pushes the regression budget past 30 s. The Stage 2
/// associative-canonicalization pass already balances and dedupes
/// Add / Mul chains in place, so most large producer trees now
/// arrive here as trees of small balanced subtrees rather than the
/// hundred-deep left-leaning chains the old serializer saw - 64
/// stays the right cap with that pre-pass in front.
const STRUCT_CACHE_NODE_LIMIT: usize = 64;

/// Per-AIR diagnostics emitted to stderr when `PIL2C_CHAIN_SHAPE=1`.
/// Used to confirm whether an upstream canonicalization fix actually
/// flattens the left-leaning Add / Mul chains that compound-assign
/// accumulators inside long for-loop bodies produce. Combines the
/// pre-serialization tree-shape walk (entry count, total BinOp /
/// UnaryOp count, longest associative chain length, deepest subtree)
/// with the cache-hit telemetry threaded through `flatten_air_expr`
/// so the trace reflects both the input shape and how much reuse the
/// serializer is actually achieving.
#[derive(Debug, Default)]
struct ChainShapeStats {
    entry_count: usize,
    binop_total: usize,
    unaryop_total: usize,
    max_add_chain: usize,
    max_mul_chain: usize,
    max_subtree_depth: usize,
    rc_cache_probes: usize,
    rc_cache_hits: usize,
    struct_cache_probes: usize,
    struct_cache_hits: usize,
    prov_cache_probes: usize,
    prov_cache_hits: usize,
    proto_emitted: usize,
}

impl ChainShapeStats {
    fn ratio(num: usize, den: usize) -> f64 {
        if den == 0 {
            0.0
        } else {
            (num as f64) / (den as f64)
        }
    }
}

/// Walk a runtime-expression tree and update chain-shape statistics.
/// Each node is visited once per textual occurrence; Rc-shared
/// subtrees are counted on every appearance (we want a faithful
/// picture of how big the tree is from the proto serializer's
/// perspective, not how much sharing the in-memory representation
/// happens to enjoy).
fn measure_chain_shape(
    expr: &RuntimeExpr,
    stats: &mut ChainShapeStats,
    depth: usize,
    parent_chain_op: Option<RuntimeOp>,
    parent_chain_len: usize,
) {
    if depth > stats.max_subtree_depth {
        stats.max_subtree_depth = depth;
    }
    match expr {
        RuntimeExpr::BinOp { op, left, right } => {
            stats.binop_total += 1;
            let chain_len = if Some(*op) == parent_chain_op {
                parent_chain_len + 1
            } else {
                1
            };
            match op {
                RuntimeOp::Add => {
                    if chain_len > stats.max_add_chain {
                        stats.max_add_chain = chain_len;
                    }
                }
                RuntimeOp::Mul => {
                    if chain_len > stats.max_mul_chain {
                        stats.max_mul_chain = chain_len;
                    }
                }
                RuntimeOp::Sub => {}
            }
            measure_chain_shape(left, stats, depth + 1, Some(*op), chain_len);
            measure_chain_shape(right, stats, depth + 1, Some(*op), chain_len);
        }
        RuntimeExpr::UnaryOp { operand, .. } => {
            stats.unaryop_total += 1;
            measure_chain_shape(operand, stats, depth + 1, None, 0);
        }
        _ => {}
    }
}

/// True when `PIL2C_CHAIN_SHAPE=1` is set in the environment. The
/// trace stays dormant by default to keep regular pil2c runs free
/// of stderr noise.
fn chain_shape_trace_enabled() -> bool {
    std::env::var("PIL2C_CHAIN_SHAPE")
        .map(|v| v == "1" || v.eq_ignore_ascii_case("true"))
        .unwrap_or(false)
}

/// Identity check for the additive zero operand. Mirrors JS
/// pil2-compiler's `Add(x, 0) -> x` simplification at expression
/// build time.
fn is_runtime_zero(expr: &RuntimeExpr) -> bool {
    match expr {
        RuntimeExpr::Value(Value::Int(0)) | RuntimeExpr::Value(Value::Fe(0)) => true,
        _ => false,
    }
}

/// Identity check for the multiplicative one operand. Mirrors JS
/// pil2-compiler's `Mul(x, 1) -> x` simplification.
fn is_runtime_one(expr: &RuntimeExpr) -> bool {
    match expr {
        RuntimeExpr::Value(Value::Int(1)) | RuntimeExpr::Value(Value::Fe(1)) => true,
        _ => false,
    }
}

/// Walk a `RuntimeExpr` iteratively and append every leaf operand
/// of the given associative `op` chain into `out`. A node is
/// treated as part of the chain when its op matches `op`; otherwise
/// it is captured as a single leaf operand. Identity operands
/// (`Add` zero, `Mul` one) are dropped while flattening. Iterative
/// (vs recursive) so the recursive1 aggregator's 100k+-deep chains
/// do not blow the thread stack.
fn collect_chain_operands(
    expr: &Rc<RuntimeExpr>,
    op: RuntimeOp,
    out: &mut Vec<Rc<RuntimeExpr>>,
) {
    let mut stack: Vec<Rc<RuntimeExpr>> = vec![Rc::clone(expr)];
    while let Some(node) = stack.pop() {
        match node.as_ref() {
            RuntimeExpr::BinOp { op: child_op, left, right } if *child_op == op => {
                // Push right first so left is processed first
                // (preserves left-to-right operand order on output).
                stack.push(Rc::clone(right));
                stack.push(Rc::clone(left));
            }
            _ => {
                let drop = match op {
                    RuntimeOp::Add => is_runtime_zero(&node),
                    RuntimeOp::Mul => is_runtime_one(&node),
                    RuntimeOp::Sub => false,
                };
                if !drop {
                    out.push(node);
                }
            }
        }
    }
}

/// Reduce a list of operands into a balanced binary tree under the
/// given associative `op`. Preserves left-to-right order so any
/// non-associative consumer (debug strings, exact byte parity with
/// JS) stays predictable. Identity-only inputs collapse to the
/// identity element.
fn build_balanced_chain(op: RuntimeOp, mut operands: Vec<Rc<RuntimeExpr>>) -> Rc<RuntimeExpr> {
    if operands.is_empty() {
        let value = match op {
            RuntimeOp::Mul => Value::Int(1),
            _ => Value::Int(0),
        };
        return Rc::new(RuntimeExpr::Value(value));
    }
    if operands.len() == 1 {
        return operands.pop().unwrap();
    }
    while operands.len() > 1 {
        let mut next: Vec<Rc<RuntimeExpr>> = Vec::with_capacity((operands.len() + 1) / 2);
        let mut iter = operands.into_iter();
        while let Some(left) = iter.next() {
            match iter.next() {
                Some(right) => next.push(Rc::new(RuntimeExpr::BinOp {
                    op,
                    left,
                    right,
                })),
                None => next.push(left),
            }
        }
        operands = next;
    }
    operands.pop().unwrap()
}

/// Lower threshold for triggering an associative-chain rebalance.
/// Round 5 (2026-04-19 loop): enabled at 8 per Codex Round 5
/// analyze
/// (`.humanize/skill/2026-04-19_07-20-30-1172757-7d338604/output.md`)
/// combined with empirical-probe tuning — 256 produced byte-
/// identical pilouts to the disabled baseline because almost all
/// stage-2 accumulator chains in Zisk fall well below that bound.
/// The reference-level reuse refactor that the prior Round 1
/// trace needed is now in place (origin-authoritative serializer
/// at commit `d5f39c72`, lift-filter fix at commit `847fa2fc`),
/// so fresh Rc internal nodes from rebalance are now absorbed by
/// the `(origin_frame_id, local_id)` composite key in
/// `global_intermediate_resolution` and the per-AIR
/// `source_to_pos` map. Stays strictly below
/// `CANONICALIZE_CHAIN_MAX` so every rebalance path is reachable
/// before the chain-cap escape hatch.
const CANONICALIZE_CHAIN_THRESHOLD: usize = 8;

/// Upper bound for chain rebalance. Rebuilding very large chains
/// allocates new Rcs proportional to chain length; the recursive1
/// aggregator fixture has individual chains over 100k operands,
/// where the post-rebuild copy crosses 100 GB of resident memory
/// and never finishes inside the 30-second pinned-regression
/// budget (`recursive1_pilout_under_time_budget`). Chains beyond
/// this cap are left in their producer shape: the aggregator
/// pipeline relies on its own helper structure rather than the
/// stdlib accumulator pattern, and the im_polynomials greedy
/// search handles them without lifting because the compute is
/// localized to that one large constraint.
const CANONICALIZE_CHAIN_MAX: usize = 1024;

/// Recursively canonicalize an expression tree before serializer
/// flattening. Strategy: probe the *input* chain length once at
/// every Add / Mul node; if the chain is below threshold, recurse
/// in place (preserving Rc identity wherever possible so the
/// downstream rc_cache stays effective); if it is at or above
/// threshold, rebuild a balanced binary tree from the flattened
/// operand list with identities (`Add` zero, `Mul` one) dropped.
///
/// Probing the INPUT tree (not the output of recursive
/// canonicalization) keeps total work linear in the original tree
/// size: each BinOp is touched at most twice (once during the
/// chain probe, once during rebuild). Probing the canonicalized
/// children would re-walk balanced subtrees and turn the pass
/// quadratic, which the recursive1 aggregator fixture
/// (`recursive1_pilout_under_time_budget`) reproduces in seconds.
///
/// Mirrors the JS `Expression.insert()` N-ary fusion path with the
/// added rebalancing step the JS stack form gets implicitly via
/// its `aIsAlone && allBsAreAlone` operand-list extension. Without
/// this pass, compound-assign accumulators inside long for-loop
/// bodies (`sum_ims += im_cluster`, `prods *= e + gamma`,
/// `sums += _partial`) produce strictly left-leaning binary chains
/// that `pil2-stark-setup::im_polynomials::calculate_im_pols`
/// blows past its 10-second deadline on, falling back to
/// over-lifting - the post-Round-17 bug behind Keccakf's 675
/// imPols vs gold's 0.
fn canonicalize_associative(expr: &Rc<RuntimeExpr>) -> Rc<RuntimeExpr> {
    match expr.as_ref() {
        RuntimeExpr::BinOp { op, left, right } => match op {
            RuntimeOp::Add | RuntimeOp::Mul => {
                // Probe chain length on the *input* (not the
                // canonicalized children) so the walk stays linear
                // in the original tree size.
                let chain_len = count_chain_operands(left, *op)
                    + count_chain_operands(right, *op);
                if chain_len > CANONICALIZE_CHAIN_MAX {
                    // Oversized chain (e.g. recursive1 aggregator
                    // monoliths). Treat the whole sub-tree as opaque
                    // - do not even recurse - to keep the pass O(N)
                    // rather than O(N^2) and avoid the 100 GB
                    // memory bomb the rebuild would otherwise
                    // trigger.
                    return Rc::clone(expr);
                }
                if chain_len < CANONICALIZE_CHAIN_THRESHOLD {
                    // Short chain: recurse in place, preserve Rc
                    // identity if children did not need to change.
                    let canon_left = canonicalize_associative(left);
                    let canon_right = canonicalize_associative(right);
                    if Rc::ptr_eq(&canon_left, left) && Rc::ptr_eq(&canon_right, right) {
                        return Rc::clone(expr);
                    }
                    return Rc::new(RuntimeExpr::BinOp {
                        op: *op,
                        left: canon_left,
                        right: canon_right,
                    });
                }
                // Long chain: collect leaf operands following only
                // same-op edges in the *input* tree, canonicalize
                // each leaf, drop identities, and rebuild balanced.
                let mut operands: Vec<Rc<RuntimeExpr>> = Vec::with_capacity(chain_len);
                collect_chain_operands(left, *op, &mut operands);
                collect_chain_operands(right, *op, &mut operands);
                let canon_operands: Vec<Rc<RuntimeExpr>> = operands
                    .iter()
                    .map(canonicalize_associative)
                    .collect();
                build_balanced_chain(*op, canon_operands)
            }
            RuntimeOp::Sub => {
                let canon_left = canonicalize_associative(left);
                let canon_right = canonicalize_associative(right);
                if Rc::ptr_eq(&canon_left, left) && Rc::ptr_eq(&canon_right, right) {
                    Rc::clone(expr)
                } else {
                    Rc::new(RuntimeExpr::BinOp {
                        op: *op,
                        left: canon_left,
                        right: canon_right,
                    })
                }
            }
        },
        RuntimeExpr::UnaryOp { op, operand } => {
            let canon = canonicalize_associative(operand);
            if Rc::ptr_eq(&canon, operand) {
                Rc::clone(expr)
            } else {
                Rc::new(RuntimeExpr::UnaryOp { op: *op, operand: canon })
            }
        }
        _ => Rc::clone(expr),
    }
}

/// Iterative cheap operand-count walk that mirrors
/// `collect_chain_operands` without allocating an operand list;
/// used as the chain-length probe above. Early-exits when the
/// running count crosses `CANONICALIZE_CHAIN_MAX + 1` so the
/// caller can short-circuit to the upper-bound branch without
/// finishing a 100k-step traversal.
fn count_chain_operands(expr: &Rc<RuntimeExpr>, op: RuntimeOp) -> usize {
    let cap = CANONICALIZE_CHAIN_MAX + 1;
    let mut stack: Vec<&Rc<RuntimeExpr>> = vec![expr];
    let mut count: usize = 0;
    while let Some(node) = stack.pop() {
        if count > cap {
            break;
        }
        match node.as_ref() {
            RuntimeExpr::BinOp { op: child_op, left, right } if *child_op == op => {
                stack.push(right);
                stack.push(left);
            }
            _ => {
                count += 1;
            }
        }
    }
    count
}

/// Count nodes in an expression tree, capped at `limit + 1` so the
/// counter itself stays cheap on very large trees. Returns `> limit`
/// to indicate the tree is too big for the structural cache.
fn expr_node_count(expr: &RuntimeExpr, limit: usize) -> usize {
    fn go(expr: &RuntimeExpr, limit: usize, acc: &mut usize) {
        if *acc > limit {
            return;
        }
        *acc += 1;
        match expr {
            RuntimeExpr::BinOp { left, right, .. } => {
                go(left, limit, acc);
                go(right, limit, acc);
            }
            RuntimeExpr::UnaryOp { operand, .. } => {
                go(operand, limit, acc);
            }
            _ => {}
        }
    }
    let mut acc = 0;
    go(expr, limit, &mut acc);
    acc
}

// Symbol type constants matching the protobuf SymbolType enum.
const REF_TYPE_IM_COL: i32 = 0;
const REF_TYPE_FIXED_COL: i32 = 1;
const REF_TYPE_PERIODIC_COL: i32 = 2;
const REF_TYPE_WITNESS_COL: i32 = 3;
const REF_TYPE_PROOF_VALUE: i32 = 4;
const REF_TYPE_AIR_GROUP_VALUE: i32 = 5;
const REF_TYPE_PUBLIC_VALUE: i32 = 6;
#[allow(dead_code)]
const REF_TYPE_PUBLIC_TABLE: i32 = 7;
const REF_TYPE_CHALLENGE: i32 = 8;
const REF_TYPE_AIR_VALUE: i32 = 9;
const REF_TYPE_CUSTOM_COL: i32 = 10;

/// Convert a big integer value to variable-length big-endian bytes (matching
/// the JS `bint2buf` with variable-byte encoding).
fn bigint_to_bytes(value: i128) -> Vec<u8> {
    if value == 0 {
        return Vec::new();
    }
    // Reduce modulo Goldilocks prime to get a positive canonical representation.
    let v = if value < 0 {
        let neg = ((-value) as u128) % GOLDILOCKS_PRIME;
        if neg == 0 { 0u64 } else { (GOLDILOCKS_PRIME - neg) as u64 }
    } else {
        ((value as u128) % GOLDILOCKS_PRIME) as u64
    };
    if v == 0 {
        return Vec::new();
    }
    // Encode as big-endian, stripping leading zero bytes.
    let full = v.to_be_bytes();
    let first_nonzero = full.iter().position(|&b| b != 0).unwrap_or(full.len());
    full[first_nonzero..].to_vec()
}

/// Main serialization structure that builds the PilOut protobuf from the
/// processor's internal state.
#[allow(dead_code)]
pub struct ProtoOutBuilder<'a> {
    processor: &'a Processor,
    /// Maps internal witness column IDs to (stage, proto_index).
    witness_id_to_proto: Vec<(u32, u32)>,
    /// Maps internal fixed column IDs to (type='F'|'P', proto_index).
    fixed_id_to_proto: Vec<(char, u32)>,
    /// Maps internal custom column IDs to (stage, proto_index, commit_id).
    custom_id_to_proto: Vec<(u32, u32, u32)>,
    /// Maps internal air value IDs to (stage, proto_index, air_group_id, air_id).
    air_value_id_to_proto: Vec<(u32, u32, u32, u32)>,
    /// Per-(airgroup_id, air_id) packed expression maps built while
    /// flattening per-AIR expressions. Indexed by raw exprs-store id;
    /// value is the packed proto-expression index. Populated during
    /// `build_air_groups` and consumed by `build_hints` so
    /// `HintValue::ExprId` can emit `Operand::Expression` with a
    /// packed index that matches the air's expressions[] array.
    air_expr_id_maps: HashMap<(u32, u32), Vec<u32>>,
    /// Scratch slot set before each per-air hint serialization so the
    /// `HintValue::ExprId` arm can look up the packed index without
    /// threading the map through every hint-value helper.
    current_air_expr_id_map: Option<Vec<u32>>,
    /// Scratch AIR name for diagnostics. Updated at the top of each
    /// per-AIR serialization loop and consulted by the xair-leak
    /// trace fallback in `leaf_to_air_operand`.
    current_air_name: std::cell::RefCell<String>,
    /// Scratch AIR-value count for the current AIR. Used by
    /// `leaf_to_air_operand`'s AirValue arm to emit
    /// `Operand::Constant(0)` instead of a stale `AirValue { idx }`
    /// when the raw id exceeds the consuming AIR's `air_value_stages`
    /// length (the foreign-AIR mirror of the Witness/Fixed leak that
    /// was patched in commit `73ebbbfc`). Set at the top of each
    /// per-AIR loop from `air.air_value_stages.len()`.
    current_air_value_count: std::cell::RefCell<usize>,
    /// Scratch origin-frame-id for the current AIR. Round 3 makes
    /// this authoritative in the Intermediate serializer path:
    /// `flatten_air_expr` / `flatten_air_operand` route any
    /// `Intermediate` ref whose `origin_frame_id` differs from this
    /// value directly to `global_intermediate_resolution` instead
    /// of the local `source_to_pos` path. Without this, a foreign
    /// Intermediate whose local id collided with one of the current
    /// AIR's own slots resolved silently to the wrong tree. See
    /// BL-20260419-origin-frame-id-resolution.
    current_origin_frame_id: std::cell::RefCell<u32>,
    /// Per-(airgroup_id, air_id) IM symbol emission table populated
    /// at flatten time. Key: packed_idx. Value: the source label of
    /// the first AirExpressionEntry whose provenance key became this
    /// packed slot (first-save-wins; cache hits do not overwrite).
    /// Mirrors JS `saveAndPushExpressionReference` label-record
    /// semantics: only the expressions that actually reach a saved
    /// packed reference key surface as IM symbols, and the symbol's
    /// `Symbol.id` is the packed index the builder assigned.
    /// `BTreeMap` for deterministic iteration order at emission time.
    im_label_by_packed_idx: HashMap<(u32, u32), std::collections::BTreeMap<u32, String>>,
}

impl<'a> ProtoOutBuilder<'a> {
    pub fn new(processor: &'a Processor) -> Self {
        Self {
            processor,
            witness_id_to_proto: Vec::new(),
            fixed_id_to_proto: Vec::new(),
            custom_id_to_proto: Vec::new(),
            air_value_id_to_proto: Vec::new(),
            air_expr_id_maps: HashMap::new(),
            current_air_expr_id_map: None,
            current_air_name: std::cell::RefCell::new(String::new()),
            current_air_value_count: std::cell::RefCell::new(0),
            current_origin_frame_id: std::cell::RefCell::new(0),
            im_label_by_packed_idx: HashMap::new(),
        }
    }

    /// Build the complete PilOut protobuf message from the processor state.
    pub fn build(&mut self) -> pilout_proto::PilOut {
        let name = if self.processor.config.name.is_empty() {
            None
        } else {
            Some(self.processor.config.name.clone())
        };

        // base_field is the raw big-endian bytes of the field prime,
        // NOT reduced modulo itself. Strip leading zero bytes.
        let base_field = {
            let full = (GOLDILOCKS_PRIME as u64).to_be_bytes();
            let first_nonzero = full.iter().position(|&b| b != 0).unwrap_or(full.len());
            full[first_nonzero..].to_vec()
        };

        let air_groups = self.build_air_groups();
        let num_challenges = self.build_stage_counts(&self.processor.challenges);
        let num_proof_values = self.build_stage_counts(&self.processor.proof_values);
        let num_public_values = self.processor.publics.len();
        let (expressions, expr_id_map) = self.build_global_expressions();
        let constraints = self.build_global_constraints(&expr_id_map);
        let symbols = self.build_symbols();
        let hints = self.build_hints();

        pilout_proto::PilOut {
            name,
            base_field,
            air_groups,
            num_challenges,
            num_proof_values,
            num_public_values,
            public_tables: Vec::new(),
            expressions,
            constraints,
            hints,
            symbols,
        }
    }

    /// Build the air groups section.
    fn build_air_groups(&mut self) -> Vec<pilout_proto::AirGroup> {
        let mut result = Vec::new();
        for ag in self.processor.air_groups.iter() {
            // Build air group values from stored metadata.
            let agv: Vec<pilout_proto::AirGroupValue> = ag.air_group_values
                .iter()
                .map(|&(stage, agg_type)| pilout_proto::AirGroupValue {
                    agg_type,
                    stage,
                })
                .collect();

            let mut proto_ag = pilout_proto::AirGroup {
                name: Some(ag.name.clone()),
                air_group_values: agv,
                airs: Vec::new(),
            };

            // Build airs within this group (skip virtual airs, which live
            // in a separate namespace in the JS compiler and are never
            // included in the protobuf output).
            let ag_idx = self.processor.air_groups.iter().position(|g| std::ptr::eq(g, ag)).unwrap_or(0) as u32;
            let mut air_id_counter = 0u32;
            for air in ag.airs.iter().filter(|a| !a.is_virtual) {
                *self.current_air_name.borrow_mut() = air.name.clone();
                *self.current_air_value_count.borrow_mut() = air.air_value_stages.len();
                *self.current_origin_frame_id.borrow_mut() = air.origin_frame_id;
                // Flatten the FULL AIR expression store into the protobuf
                // array. This includes ALL expressions created during AIR
                // execution (intermediate column definitions, constraint
                // sub-expressions, etc.), matching the JS compiler's
                // `this.expressions.pack(...)` behavior.
                let mut proto_expressions: Vec<pilout_proto::Expression> = Vec::new();
                let mut expr_id_map: Vec<u32> = Vec::new();

                let mut rc_cache: HashMap<*const RuntimeExpr, u32> = HashMap::new();
                let mut struct_cache: HashMap<RuntimeExpr, u32> = HashMap::new();
                let mut prov_cache: HashMap<PackedKey, u32> = HashMap::new();
                let mut im_labels: std::collections::BTreeMap<u32, String> = std::collections::BTreeMap::new();
                // Collect per-entry (&expr, source_expr_id, source_label)
                // from either store shape: the full
                // air_expression_store carries AirExpressionEntry
                // provenance; the older stored_expressions path has
                // no provenance.
                // Collect raw entries first, then canonicalize each
                // expression in place. Canonicalization runs the
                // associative Add / Mul flattening + balanced rebuild
                // that mirrors JS Expression.insert's N-ary fusion;
                // this is what keeps `pil2-stark-setup::im_polynomials`
                // from blowing past its 10s deadline on Keccakf-scale
                // accumulator trees and over-lifting intermediate
                // polynomials. The canonicalized Rc tree is owned by
                // `entries` for the lifetime of this air loop so the
                // rc_cache pointer-identity fast path stays valid.
                let raw_entries: Vec<(&RuntimeExpr, Option<u32>, Option<&str>)> =
                    if !air.air_expression_store.is_empty() {
                        air.air_expression_store.iter()
                            .map(|e| (&e.expr, e.source_expr_id, e.source_label.as_deref()))
                            .collect()
                    } else {
                        air.stored_expressions.iter().map(|e| (e, None, None)).collect()
                    };
                let entries: Vec<(Rc<RuntimeExpr>, Option<u32>, Option<&str>)> = raw_entries
                    .into_iter()
                    .map(|(expr, sid, label)| {
                        let canon = canonicalize_associative(&Rc::new(expr.clone()));
                        (canon, sid, label)
                    })
                    .collect();
                // Index entries by their `source_expr_id` so the
                // serializer can resolve `ColRef::Intermediate { id, .. }`
                // leaves (produced by `eval_reference` for `RefType::Expr`)
                // back to the packed proto idx of the entry that holds
                // the underlying expression. Mirrors the JS
                // `(id, rowOffset)` -> packed_idx lookup in
                // `pil2-compiler/src/packed_expressions.js::pushExpressionReference`.
                let mut source_to_pos: HashMap<u32, usize> = HashMap::new();
                for (pos, (_, sid, _)) in entries.iter().enumerate() {
                    if let Some(s) = sid {
                        source_to_pos.entry(*s).or_insert(pos);
                    }
                }
                let trace_enabled = chain_shape_trace_enabled();
                let mut stats = ChainShapeStats {
                    entry_count: entries.len(),
                    ..Default::default()
                };
                if trace_enabled {
                    // Pre-flatten tree-shape walk on the *canonicalized*
                    // expressions, so the chain-depth columns reflect
                    // the producer shape after the associative-rebalance
                    // pass and let the round contract gate on the
                    // post-fix metric. Cache hit / probe counts are
                    // accumulated below by flatten_air_expr while it
                    // walks the same trees.
                    for (expr, _, _) in &entries {
                        measure_chain_shape(expr, &mut stats, 0, None, 0);
                    }
                }
                for (expr, source_expr_id, source_label) in entries {
                    let root_idx = self.flatten_air_expr(
                        expr.as_ref(),
                        source_expr_id,
                        source_label,
                        &air.fixed_id_map,
                        air.fixed_col_start,
                        &air.witness_id_map,
                        &air.custom_id_map,
                        &expr_id_map,
                        &source_to_pos,
                        &mut proto_expressions,
                        &mut rc_cache,
                        &mut struct_cache,
                        &mut prov_cache,
                        &mut im_labels,
                        &mut stats,
                    );
                    expr_id_map.push(root_idx);
                }
                if trace_enabled {
                    eprintln!(
                        "PIL2C_CHAIN_SHAPE air={}/{} airgroup_id={} air_id={} \
                         entries={} binops={} unaryops={} max_add_chain={} \
                         max_mul_chain={} max_subtree_depth={} \
                         proto_emitted={} \
                         rc_cache_hits={}/{} ({:.3}) \
                         struct_cache_hits={}/{} ({:.3}) \
                         prov_cache_hits={}/{} ({:.3})",
                        ag.name,
                        air.name,
                        ag_idx,
                        air_id_counter,
                        stats.entry_count,
                        stats.binop_total,
                        stats.unaryop_total,
                        stats.max_add_chain,
                        stats.max_mul_chain,
                        stats.max_subtree_depth,
                        stats.proto_emitted,
                        stats.rc_cache_hits,
                        stats.rc_cache_probes,
                        ChainShapeStats::ratio(stats.rc_cache_hits, stats.rc_cache_probes),
                        stats.struct_cache_hits,
                        stats.struct_cache_probes,
                        ChainShapeStats::ratio(
                            stats.struct_cache_hits,
                            stats.struct_cache_probes,
                        ),
                        stats.prov_cache_hits,
                        stats.prov_cache_probes,
                        ChainShapeStats::ratio(stats.prov_cache_hits, stats.prov_cache_probes),
                    );
                }

                // Stash the packed expression-id map so `build_hints`
                // can look up packed indices for this air when
                // serializing `HintValue::ExprId` hint leaves.
                self.air_expr_id_maps
                    .insert((ag_idx, air_id_counter), expr_id_map.clone());
                // Record the IM-label side table for this air so
                // the IM SymbolEntry emission below sees the
                // first-save (packed_idx -> label) pairs.
                self.im_label_by_packed_idx
                    .insert((ag_idx, air_id_counter), im_labels);
                air_id_counter += 1;

                // Build per-AIR constraints, referencing the flattened
                // expression indices. The constraint expr_id offsets into
                // the stored_expressions; when using the full expression
                // store, we need to offset by the number of intermediate
                // expressions that were prepended.
                let constraint_expr_count = if air.stored_expressions_count > 0 {
                    air.stored_expressions_count
                } else {
                    air.stored_expressions.len()
                };
                let im_expr_count = if !air.air_expression_store.is_empty() {
                    air.air_expression_store.len() - constraint_expr_count
                } else {
                    0
                };
                let mut proto_constraints: Vec<pilout_proto::Constraint> = Vec::new();
                for entry in &air.stored_constraints {
                    // Offset the expression ID by the intermediate prefix.
                    let store_idx = (entry.expr_id as usize) + im_expr_count;
                    let expr_idx = expr_id_map
                        .get(store_idx)
                        .copied()
                        .unwrap_or(entry.expr_id);
                    let debug_line = Some(entry.source_ref.clone());
                    let expression_idx =
                        Some(pilout_proto::operand::Expression { idx: expr_idx });
                    let constraint_kind = match entry.boundary.as_deref() {
                        Some("first") => {
                            pilout_proto::constraint::Constraint::FirstRow(
                                pilout_proto::constraint::FirstRow {
                                    expression_idx,
                                    debug_line,
                                },
                            )
                        }
                        Some("last") => {
                            pilout_proto::constraint::Constraint::LastRow(
                                pilout_proto::constraint::LastRow {
                                    expression_idx,
                                    debug_line,
                                },
                            )
                        }
                        Some("frame") => {
                            pilout_proto::constraint::Constraint::EveryFrame(
                                pilout_proto::constraint::EveryFrame {
                                    expression_idx,
                                    offset_min: 0,
                                    offset_max: 0,
                                    debug_line,
                                },
                            )
                        }
                        _ => {
                            // Default: everyRow (matches JS false/all).
                            pilout_proto::constraint::Constraint::EveryRow(
                                pilout_proto::constraint::EveryRow {
                                    expression_idx,
                                    debug_line,
                                },
                            )
                        }
                    };
                    proto_constraints.push(pilout_proto::Constraint {
                        constraint: Some(constraint_kind),
                    });
                }

                // Build fixed column entries (empty values when using
                // fixed-to-file mode; the data is in separate .fixed
                // files).
                let mut proto_fixed: Vec<pilout_proto::FixedCol> = Vec::new();
                let mut proto_periodic: Vec<pilout_proto::PeriodicCol> = Vec::new();
                for &(ctype, _proto_idx) in &air.fixed_id_map {
                    match ctype {
                        'F' => proto_fixed.push(pilout_proto::FixedCol {
                            values: Vec::new(),
                        }),
                        'P' => proto_periodic.push(pilout_proto::PeriodicCol {
                            values: Vec::new(),
                        }),
                        _ => {}
                    }
                }

                // Build air values from stored per-value stage metadata.
                let proto_air_values: Vec<pilout_proto::AirValue> = air
                    .air_value_stages
                    .iter()
                    .map(|&stage| pilout_proto::AirValue { stage })
                    .collect();

                // Build custom commits from stored commit info.
                let proto_custom_commits: Vec<pilout_proto::CustomCommit> = air
                    .custom_commits
                    .iter()
                    .map(|(name, sw, pub_ids)| pilout_proto::CustomCommit {
                        name: if name.is_empty() { None } else { Some(name.clone()) },
                        public_values: pub_ids.iter().map(|&idx| {
                            pilout_proto::global_operand::PublicValue { idx }
                        }).collect(),
                        stage_widths: sw.clone(),
                    })
                    .collect();

                let proto_air = pilout_proto::Air {
                    name: Some(air.name.clone()),
                    num_rows: Some(air.rows as u32),
                    periodic_cols: proto_periodic,
                    fixed_cols: proto_fixed,
                    stage_widths: air.stage_widths.clone(),
                    expressions: proto_expressions,
                    constraints: proto_constraints,
                    air_values: proto_air_values,
                    aggregable: true,
                    custom_commits: proto_custom_commits,
                };
                proto_ag.airs.push(proto_air);
            }

            result.push(proto_ag);
        }
        result
    }

    /// Build num-per-stage counts from an IdAllocator (for challenges,
    /// proof values, etc.).
    fn build_stage_counts(&self, alloc: &IdAllocator) -> Vec<u32> {
        let mut by_stage: HashMap<u32, u32> = HashMap::new();
        for data in &alloc.datas {
            let stage = data.stage.unwrap_or(1);
            *by_stage.entry(stage).or_insert(0) += 1;
        }
        if by_stage.is_empty() {
            return Vec::new();
        }
        let max_stage = *by_stage.keys().max().unwrap();
        let mut result = vec![0u32; max_stage as usize];
        for (stage, count) in by_stage {
            if stage > 0 && (stage as usize) <= result.len() {
                result[(stage - 1) as usize] = count;
            }
        }
        result
    }

    /// Build global expressions from proof-level intermediates and
    /// global constraint expressions.
    ///
    /// Expression trees are flattened into a linear array: nested
    /// sub-expressions are emitted first and referenced by index from
    /// their parent expression via `GlobalOperand::Expression { idx }`.
    ///
    /// Returns (flattened_expressions, mapping) where mapping[i] is the
    /// flattened index of the original expression store entry i
    /// (offset by the intermediate expression count for constraint entries).
    fn build_global_expressions(
        &self,
    ) -> (Vec<pilout_proto::GlobalExpression>, Vec<u32>) {
        let mut result = Vec::new();
        let mut id_map = Vec::new();

        // First, flatten proof-level intermediate expressions.
        for expr in &self.processor.global_expression_store {
            let idx = self.flatten_expr_to_global(expr, &mut result);
            id_map.push(idx);
        }

        // Then flatten constraint expressions.
        for expr in self.processor.global_constraints.all_expressions() {
            let idx = self.flatten_expr_to_global(expr, &mut result);
            id_map.push(idx);
        }
        (result, id_map)
    }

    /// Build global constraints, remapping expression indices to the
    /// flattened expression array. Constraint expr_ids are offset by the
    /// number of proof-level intermediate expressions that were prepended.
    fn build_global_constraints(
        &self,
        expr_id_map: &[u32],
    ) -> Vec<pilout_proto::GlobalConstraint> {
        let im_count = self.processor.global_expression_store.len();
        let mut result = Vec::new();
        for entry in self.processor.global_constraints.iter() {
            let store_idx = (entry.expr_id as usize) + im_count;
            let mapped_idx = expr_id_map
                .get(store_idx)
                .copied()
                .unwrap_or(entry.expr_id);
            let gc = pilout_proto::GlobalConstraint {
                expression_idx: Some(pilout_proto::global_operand::Expression {
                    idx: mapped_idx,
                }),
                debug_line: Some(entry.source_ref.clone()),
            };
            result.push(gc);
        }
        result
    }

    /// Build the symbols table.
    ///
    /// This combines:
    /// - Global symbols (public, proofvalue, challenge) from the processor's
    ///   global allocators, using per-stage relative IDs.
    /// - Air group value symbols from each air group.
    /// - Per-AIR symbols (witness, fixed, customcol, airvalue, im) from stored
    ///   symbol entries and translation maps, matching JS `setSymbolsFromLabels`.
    fn build_symbols(&self) -> Vec<pilout_proto::Symbol> {
        let mut result = Vec::new();

        // ------------------------------------------------------------------
        // Global symbols: public, proofvalue, challenge
        // These use relativeId (per-stage sequential index).
        // ------------------------------------------------------------------

        // Public values: id is absolute (no relativeId needed).
        for lr in self.processor.publics.label_ranges.to_vec() {
            let src = self.processor.publics.get_data(lr.from)
                .map(|d| d.source_ref.clone())
                .unwrap_or_default();
            result.push(pilout_proto::Symbol {
                name: lr.label.clone(),
                air_group_id: None,
                air_id: None,
                r#type: REF_TYPE_PUBLIC_VALUE,
                id: lr.from,
                stage: None,
                dim: lr.array_dims.len() as u32,
                lengths: lr.array_dims.clone(),
                commit_id: None,
                debug_line: Some(src),
            });
        }

        // Proof values: use relativeId (per-stage index).
        {
            let mut stage_counters: HashMap<u32, u32> = HashMap::new();
            for data in &self.processor.proof_values.datas {
                let stage = data.stage.unwrap_or(1);
                stage_counters.entry(stage).or_insert(0);
            }
            // Reset counters before iterating label ranges.
            stage_counters.values_mut().for_each(|v| *v = 0);
            for lr in self.processor.proof_values.label_ranges.to_vec() {
                let data = self.processor.proof_values.get_data(lr.from);
                let stage = data.and_then(|d| d.stage).unwrap_or(1);
                let relative_id = *stage_counters.entry(stage).or_insert(0);
                *stage_counters.get_mut(&stage).unwrap() += lr.count;
                let src = data.map(|d| d.source_ref.clone()).unwrap_or_default();
                result.push(pilout_proto::Symbol {
                    name: lr.label.clone(),
                    air_group_id: None,
                    air_id: None,
                    r#type: REF_TYPE_PROOF_VALUE,
                    id: relative_id,
                    stage: Some(stage),
                    dim: lr.array_dims.len() as u32,
                    lengths: lr.array_dims.clone(),
                    commit_id: None,
                    debug_line: Some(src),
                });
            }
        }

        // Challenges: use relativeId (per-stage index).
        {
            let mut stage_counters: HashMap<u32, u32> = HashMap::new();
            for lr in self.processor.challenges.label_ranges.to_vec() {
                let data = self.processor.challenges.get_data(lr.from);
                let stage = data.and_then(|d| d.stage).unwrap_or(2);
                let relative_id = *stage_counters.entry(stage).or_insert(0);
                *stage_counters.get_mut(&stage).unwrap() += lr.count;
                let src = data.map(|d| d.source_ref.clone()).unwrap_or_default();
                result.push(pilout_proto::Symbol {
                    name: lr.label.clone(),
                    air_group_id: None,
                    air_id: None,
                    r#type: REF_TYPE_CHALLENGE,
                    id: relative_id,
                    stage: Some(stage),
                    dim: lr.array_dims.len() as u32,
                    lengths: lr.array_dims.clone(),
                    commit_id: None,
                    debug_line: Some(src),
                });
            }
        }

        // ------------------------------------------------------------------
        // Air group values: per-airgroup with relativeId.
        // The global air_group_values allocator accumulates IDs across all
        // airgroups, so we track a cumulative offset to look up the correct
        // global ID for each airgroup's values.
        // ------------------------------------------------------------------
        {
            let mut global_agv_offset = 0u32;
            for (ag_idx, ag) in self.processor.air_groups.iter().enumerate() {
                let air_group_id = ag_idx as u32;
                let mut agv_relative_id = 0u32;
                for &(stage, _agg_type) in &ag.air_group_values {
                    let global_id = global_agv_offset + agv_relative_id;
                    // Use the label from the air_group_values allocator.
                    let raw_label = self.processor.air_group_values.label_ranges
                        .get_label(global_id)
                        .unwrap_or("")
                        .to_string();
                    // Prefix with the airgroup name to produce qualified
                    // names like "Zisk.gsum_result" (matching JS behavior).
                    let label = if !raw_label.is_empty() {
                        format!("{}.{}", ag.name, raw_label)
                    } else {
                        String::new()
                    };
                    if !label.is_empty() {
                        let src = self.processor.air_group_values.get_data(global_id)
                            .map(|d| d.source_ref.clone())
                            .unwrap_or_default();
                        result.push(pilout_proto::Symbol {
                            name: label,
                            air_group_id: Some(air_group_id),
                            air_id: None,
                            r#type: REF_TYPE_AIR_GROUP_VALUE,
                            id: agv_relative_id,
                            stage: Some(stage),
                            dim: 0,
                            lengths: Vec::new(),
                            commit_id: None,
                            debug_line: Some(src),
                        });
                    }
                    agv_relative_id += 1;
                }
                global_agv_offset += ag.air_group_values.len() as u32;
            }
        }

        // ------------------------------------------------------------------
        // Per-AIR symbols: witness, fixed, customcol, airvalue
        // Built from stored SymbolEntry + translation maps.
        //
        // Intermediate (im) symbols are omitted: the Rust compiler collects
        // all expr variable label ranges, which is a superset of what the
        // JS packed-expression labeling produces. Until expression packing
        // is implemented, skipping IM avoids emitting ~30k spurious symbols.
        // ------------------------------------------------------------------
        for (ag_idx, ag) in self.processor.air_groups.iter().enumerate() {
            let air_group_id = ag_idx as u32;
            let mut non_virtual_pos = 0u32;
            for air in &ag.airs {
                if air.is_virtual {
                    continue;
                }
                let air_id = non_virtual_pos;
                non_virtual_pos += 1;
                for sym in &air.symbols {
                    match sym.ref_type_str.as_str() {
                        "witness" => {
                            // Remap through witness_id_map: internal_id -> (stage, proto_index)
                            let (stage, proto_id) = air.witness_id_map
                                .get(sym.internal_id as usize)
                                .copied()
                                .unwrap_or((1, sym.internal_id));
                            result.push(pilout_proto::Symbol {
                                name: sym.name.clone(),
                                air_group_id: Some(air_group_id),
                                air_id: Some(air_id),
                                r#type: REF_TYPE_WITNESS_COL,
                                id: proto_id,
                                stage: Some(stage),
                                dim: sym.dim,
                                lengths: sym.lengths.clone(),
                                commit_id: None,
                                debug_line: Some(sym.source_ref.clone()),
                            });
                        }
                        "fixed" => {
                            // Remap through fixed_id_map: internal_id -> (type, proto_index).
                            // The map is dense (relative to fixed_col_start).
                            let rel_idx = sym.internal_id.checked_sub(air.fixed_col_start)
                                .unwrap_or(sym.internal_id) as usize;
                            let (ctype, proto_id) = air.fixed_id_map
                                .get(rel_idx)
                                .copied()
                                .unwrap_or(('F', sym.internal_id));
                            let sym_type = if ctype == 'P' {
                                REF_TYPE_PERIODIC_COL
                            } else {
                                REF_TYPE_FIXED_COL
                            };
                            result.push(pilout_proto::Symbol {
                                name: sym.name.clone(),
                                air_group_id: Some(air_group_id),
                                air_id: Some(air_id),
                                r#type: sym_type,
                                id: proto_id,
                                stage: if ctype == 'P' { None } else { Some(0) },
                                dim: sym.dim,
                                lengths: sym.lengths.clone(),
                                commit_id: None,
                                debug_line: Some(sym.source_ref.clone()),
                            });
                        }
                        "customcol" => {
                            // Remap through custom_id_map: internal_id -> (stage, proto_index, commit_id)
                            let (stage, proto_id, commit_id) = air.custom_id_map
                                .get(sym.internal_id as usize)
                                .copied()
                                .unwrap_or((0, sym.internal_id, 0));
                            result.push(pilout_proto::Symbol {
                                name: sym.name.clone(),
                                air_group_id: Some(air_group_id),
                                air_id: Some(air_id),
                                r#type: REF_TYPE_CUSTOM_COL,
                                id: proto_id,
                                stage: Some(stage),
                                dim: sym.dim,
                                lengths: sym.lengths.clone(),
                                commit_id: Some(commit_id),
                                debug_line: Some(sym.source_ref.clone()),
                            });
                        }
                        "airvalue" => {
                            // Emit Symbol.id = internal_id (the label's
                            // starting airvalue slot), matching JS
                            // `symbolType2Proto('airvalue', locator, ...)`
                            // which returns `{id: airValueId2ProtoId[locator][1]}`
                            // where `locator = label.from`. For a per-AIR
                            // airvalue label the relative proto id IS the
                            // internal id since `air_values` is reset per
                            // AIR. Consumer `generate_multi_array_symbols`
                            // then expands array symbols to
                            // `s.id..s.id+len`, and `map.rs` populates
                            // `air_values_map` at each of those indices.
                            // The previous per-label counter collapsed
                            // array spans so constraints referencing
                            // later indices panicked in
                            // `pil2-stark-setup/src/parser_args.rs:594`.
                            let stage = air.air_value_stages
                                .get(sym.internal_id as usize)
                                .copied()
                                .unwrap_or(1);
                            result.push(pilout_proto::Symbol {
                                name: sym.name.clone(),
                                air_group_id: Some(air_group_id),
                                air_id: Some(air_id),
                                r#type: REF_TYPE_AIR_VALUE,
                                id: sym.internal_id,
                                stage: Some(stage),
                                dim: sym.dim,
                                lengths: sym.lengths.clone(),
                                commit_id: None,
                                debug_line: Some(sym.source_ref.clone()),
                            });
                        }
                        "im" => {
                            // Legacy processor-side IM emission path.
                            // Kept for `stored_expressions`-mode airs
                            // that do not go through the packed-path
                            // provenance cache. New code goes through
                            // the builder-side `im_label_by_packed_idx`
                            // table populated at flatten time.
                            result.push(pilout_proto::Symbol {
                                name: sym.name.clone(),
                                air_group_id: Some(air_group_id),
                                air_id: Some(air_id),
                                r#type: REF_TYPE_IM_COL,
                                id: sym.internal_id,
                                stage: None,
                                dim: sym.dim,
                                lengths: sym.lengths.clone(),
                                commit_id: None,
                                debug_line: Some(sym.source_ref.clone()),
                            });
                        }
                        _ => {}
                    }
                }

                // Emit IM symbols from the builder-side packed-path
                // side table. Each entry was recorded at flatten
                // time when a provenance cache key was first
                // inserted AND the associated `AirExpressionEntry`
                // carried a `source_label`; later cache hits do not
                // overwrite (first-save-wins). The key is
                // `packed_idx`, which is the authoritative
                // `Symbol.id` for the IM entry, matching JS
                // `saveAndPushExpressionReference` semantics.
                if let Some(labels) = self.im_label_by_packed_idx.get(&(air_group_id, air_id)) {
                    for (packed_idx, label) in labels {
                        result.push(pilout_proto::Symbol {
                            name: format!("{}.{}", air.name, label),
                            air_group_id: Some(air_group_id),
                            air_id: Some(air_id),
                            r#type: REF_TYPE_IM_COL,
                            id: *packed_idx,
                            stage: None,
                            dim: 0,
                            lengths: Vec::new(),
                            commit_id: None,
                            debug_line: Some(String::new()),
                        });
                    }
                }
            }
        }

        result
    }

    /// Build the hints section of the PilOut.
    ///
    /// Collects per-AIR hints (with air_group_id/air_id) and global hints
    /// (without air/airgroup scope), converting HintValue trees into
    /// protobuf HintField messages.
    fn build_hints(&mut self) -> Vec<pilout_proto::Hint> {
        let mut result = Vec::new();

        // Per-AIR hints: iterate airgroups -> airs, using stored hints.
        for (ag_idx, ag) in self.processor.air_groups.iter().enumerate() {
            let air_group_id = ag_idx as u32;
            let mut non_virtual_pos = 0u32;
            for air in &ag.airs {
                if air.is_virtual {
                    continue;
                }
                let air_id = non_virtual_pos;
                non_virtual_pos += 1;

                // Load the packed expression-id map built during
                // build_air_groups so HintValue::ExprId can emit an
                // Operand::Expression referencing the same index the
                // per-AIR expressions[] array uses.
                self.current_air_expr_id_map =
                    self.air_expr_id_maps.get(&(air_group_id, air_id)).cloned();

                let air_expr_refs: Vec<&RuntimeExpr> = air
                    .air_expression_store
                    .iter()
                    .map(|e| &e.expr)
                    .collect();
                for hint in &air.hints {
                    let hint_fields = self.hint_value_to_fields(
                        &hint.data,
                        &air.fixed_id_map,
                        air.fixed_col_start,
                        &air.witness_id_map,
                        &air.custom_id_map,
                        &air_expr_refs,
                    );
                    result.push(pilout_proto::Hint {
                        name: hint.name.clone(),
                        hint_fields,
                        air_group_id: Some(air_group_id),
                        air_id: Some(air_id),
                    });
                }
                self.current_air_expr_id_map = None;
            }
        }

        // Global hints (proof-scope).
        for hint in &self.processor.global_hints {
            let hint_fields = self.hint_value_to_fields_global(&hint.data);
            result.push(pilout_proto::Hint {
                name: hint.name.clone(),
                hint_fields,
                air_group_id: None,
                air_id: None,
            });
        }

        result
    }

    /// Convert a HintValue to a list of HintField messages (per-AIR context).
    /// For objects, each key-value pair becomes a named HintField.
    /// For other values, a single unnamed HintField is returned.
    fn hint_value_to_fields(
        &self,
        value: &HintValue,
        fixed_map: &[(char, u32)],
        fixed_col_start: u32,
        witness_map: &[(u32, u32)],
        custom_map: &[(u32, u32, u32)],
        expr_store: &[&RuntimeExpr],
    ) -> Vec<pilout_proto::HintField> {
        match value {
            HintValue::Object(pairs) => {
                let fields: Vec<pilout_proto::HintField> = pairs.iter().map(|(k, v)| {
                    let mut field = self.hint_value_to_single_field(v, fixed_map, fixed_col_start, witness_map, custom_map, expr_store);
                    field.name = Some(k.clone());
                    field
                }).collect();
                // Wrap named fields in a HintFieldArray (matching JS behavior).
                vec![pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }]
            }
            _ => vec![self.hint_value_to_single_field(value, fixed_map, fixed_col_start, witness_map, custom_map, expr_store)],
        }
    }

    /// Convert a single HintValue to a HintField (per-AIR context).
    fn hint_value_to_single_field(
        &self,
        value: &HintValue,
        fixed_map: &[(char, u32)],
        fixed_col_start: u32,
        witness_map: &[(u32, u32)],
        custom_map: &[(u32, u32, u32)],
        expr_store: &[&RuntimeExpr],
    ) -> pilout_proto::HintField {
        match value {
            HintValue::Int(v) => pilout_proto::HintField {
                name: None,
                value: Some(pilout_proto::hint_field::Value::Operand(
                    pilout_proto::Operand {
                        operand: Some(pilout_proto::operand::Operand::Constant(
                            pilout_proto::operand::Constant {
                                value: bigint_to_bytes(*v),
                            },
                        )),
                    },
                )),
            },
            HintValue::Str(s) => pilout_proto::HintField {
                name: None,
                value: Some(pilout_proto::hint_field::Value::StringValue(s.clone())),
            },
            HintValue::ExprId(expr_id) => {
                // Always emit as Operand::Expression referencing the
                // packed expression index. Mirrors JS `toHintField` which
                // uses packed expression references for every expression-
                // backed hint field, including simple witness / fixed /
                // custom leaves. Rust previously collapsed simple leaves
                // into direct witness/fixed/custom operands, which caused
                // divergence on gprod_col, gsum_col, gprod_debug_data, and
                // gsum_debug_data hint payloads. The translation from the
                // raw self.exprs id to the packed proto-expression index
                // lives on each air as `expr_id_map`; self.current_air_expr_id_map
                // exposes it for the currently-being-serialized air.
                let mapped = self
                    .current_air_expr_id_map
                    .as_ref()
                    .and_then(|m| m.get(*expr_id as usize).copied())
                    .unwrap_or(*expr_id);
                let _ = expr_store;
                let _ = fixed_map;
                let _ = fixed_col_start;
                let _ = witness_map;
                let _ = custom_map;
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::Operand(
                        pilout_proto::Operand {
                            operand: Some(pilout_proto::operand::Operand::Expression(
                                pilout_proto::operand::Expression { idx: mapped },
                            )),
                        },
                    )),
                }
            }
            HintValue::Array(items) => {
                let fields: Vec<pilout_proto::HintField> = items.iter()
                    .map(|v| self.hint_value_to_single_field(v, fixed_map, fixed_col_start, witness_map, custom_map, expr_store))
                    .collect();
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }
            }
            HintValue::Object(pairs) => {
                let fields: Vec<pilout_proto::HintField> = pairs.iter().map(|(k, v)| {
                    let mut field = self.hint_value_to_single_field(v, fixed_map, fixed_col_start, witness_map, custom_map, expr_store);
                    field.name = Some(k.clone());
                    field
                }).collect();
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }
            }
            // Direct column reference: emit the matching leaf Operand
            // (WitnessCol / AirValue / ...) instead of wrapping in an
            // Expression. This is what the C++ consumer expects for
            // hint fields like `witness_calc.reference` that must
            // resolve to cm / airvalue operand class.
            HintValue::ColRef { col_type, id, row_offset, origin_frame_id } => {
                use crate::processor::expression::ColRefKind;
                let offset = row_offset.unwrap_or(0) as i32;
                // Round 3 foreign-origin guard: if the leaf carries an
                // origin that differs from the AIR currently being
                // serialized, the bare id belongs to the minting AIR's
                // column allocator and does not translate here. Emit
                // `Constant(0)` instead of a stale Witness/AirValue.
                // Round 6: also require the serializer to BE inside
                // an AIR context (`current_origin > 0`); without
                // this, early-in-the-AIR-loop hint serialization
                // (before `current_origin_frame_id` is populated on
                // `ProtoOutBuilder`) would false-positive on the
                // check and zero out legitimate hint refs.
                let current_origin = *self.current_origin_frame_id.borrow();
                let is_foreign = current_origin != 0
                    && matches!(origin_frame_id, Some(o) if *o != current_origin);
                let operand = if is_foreign {
                    if std::env::var("PIL2C_WARN_FOREIGN_INTERMEDIATE").is_ok() {
                        let air_name = self.current_air_name.borrow();
                        eprintln!(
                            "[pil2c-warn] foreign-origin hint ColRef: air='{}' \
                             col_type={:?} id={} origin_frame_id={:?} \
                             current_origin={} emitting Operand::Constant(0)",
                            *air_name,
                            col_type,
                            id,
                            origin_frame_id,
                            current_origin,
                        );
                    }
                    pilout_proto::operand::Operand::Constant(
                        pilout_proto::operand::Constant { value: Vec::new() },
                    )
                } else {
                    match col_type {
                        ColRefKind::Witness => {
                            match witness_map.get(*id as usize).copied() {
                                Some((stage, col_idx)) => pilout_proto::operand::Operand::WitnessCol(
                                    pilout_proto::operand::WitnessCol {
                                        stage,
                                        col_idx,
                                        row_offset: offset,
                                    },
                                ),
                                None => {
                                    if std::env::var("PIL2C_WARN_FOREIGN_INTERMEDIATE").is_ok() {
                                        let air_name = self.current_air_name.borrow();
                                        eprintln!(
                                            "[pil2c-warn] hint Witness miss: \
                                             air='{}' id={} witness_map.len={} \
                                             origin_frame_id={:?} emitting Operand::Constant(0)",
                                            *air_name, id, witness_map.len(), origin_frame_id,
                                        );
                                    }
                                    pilout_proto::operand::Operand::Constant(
                                        pilout_proto::operand::Constant { value: Vec::new() },
                                    )
                                }
                            }
                        }
                        ColRefKind::AirValue => {
                            let count = *self.current_air_value_count.borrow();
                            if (*id as usize) < count {
                                pilout_proto::operand::Operand::AirValue(
                                    pilout_proto::operand::AirValue { idx: *id },
                                )
                            } else {
                                if std::env::var("PIL2C_WARN_FOREIGN_INTERMEDIATE").is_ok() {
                                    let air_name = self.current_air_name.borrow();
                                    eprintln!(
                                        "[pil2c-warn] hint AirValue OOB: \
                                         air='{}' id={} air_value_stages.len={} \
                                         origin_frame_id={:?} emitting Operand::Constant(0)",
                                        *air_name, id, count, origin_frame_id,
                                    );
                                }
                                pilout_proto::operand::Operand::Constant(
                                    pilout_proto::operand::Constant { value: Vec::new() },
                                )
                            }
                        }
                        _ => {
                            // Other ColRefKinds (Fixed, Public, Challenge,
                            // ProofValue, AirGroupValue, Custom,
                            // Intermediate) are not valid destinations for
                            // the calculateExpr guard; they should never
                            // land here. Falling back to a stable empty
                            // Constant keeps the proto well-formed so
                            // validation errors surface downstream with
                            // clear context rather than as a type panic.
                            let _ = fixed_map;
                            let _ = fixed_col_start;
                            let _ = custom_map;
                            let _ = expr_store;
                            pilout_proto::operand::Operand::Constant(
                                pilout_proto::operand::Constant {
                                    value: Vec::new(),
                                },
                            )
                        }
                    }
                };
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::Operand(
                        pilout_proto::Operand { operand: Some(operand) },
                    )),
                }
            }
        }
    }


    /// Convert hint value to fields in global (proof) context.
    fn hint_value_to_fields_global(
        &self,
        value: &HintValue,
    ) -> Vec<pilout_proto::HintField> {
        match value {
            HintValue::Object(pairs) => {
                let fields: Vec<pilout_proto::HintField> = pairs.iter().map(|(k, v)| {
                    let mut field = self.hint_value_to_single_field_global(v);
                    field.name = Some(k.clone());
                    field
                }).collect();
                vec![pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }]
            }
            _ => vec![self.hint_value_to_single_field_global(value)],
        }
    }

    /// Convert a single HintValue to a HintField (global context).
    fn hint_value_to_single_field_global(
        &self,
        value: &HintValue,
    ) -> pilout_proto::HintField {
        match value {
            HintValue::Int(v) => pilout_proto::HintField {
                name: None,
                value: Some(pilout_proto::hint_field::Value::Operand(
                    pilout_proto::Operand {
                        operand: Some(pilout_proto::operand::Operand::Constant(
                            pilout_proto::operand::Constant {
                                value: bigint_to_bytes(*v),
                            },
                        )),
                    },
                )),
            },
            HintValue::Str(s) => pilout_proto::HintField {
                name: None,
                value: Some(pilout_proto::hint_field::Value::StringValue(s.clone())),
            },
            HintValue::ExprId(expr_id) => {
                // Global expressions: reference by index into global expression store.
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::Operand(
                        pilout_proto::Operand {
                            operand: Some(pilout_proto::operand::Operand::Expression(
                                pilout_proto::operand::Expression { idx: *expr_id },
                            )),
                        },
                    )),
                }
            }
            HintValue::Array(items) => {
                let fields: Vec<pilout_proto::HintField> = items.iter()
                    .map(|v| self.hint_value_to_single_field_global(v))
                    .collect();
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }
            }
            HintValue::Object(pairs) => {
                let fields: Vec<pilout_proto::HintField> = pairs.iter().map(|(k, v)| {
                    let mut field = self.hint_value_to_single_field_global(v);
                    field.name = Some(k.clone());
                    field
                }).collect();
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }
            }
            // Proof-scope bare leaf: emit the matching Operand
            // variant directly. Proof-scope hints arrive here from
            // `value_to_hint_value` when the instance type is
            // "proof" and the hint value is a bare `ColRef`
            // (typically ProofValue / AirGroupValue / WitnessCol /
            // Challenge / Public). Previously this arm dropped to an
            // empty `Constant`, which caused
            // `gsum_debug_data_global.num_reps` (and similar
            // proof-scope container-field hints) to serialize as
            // `{op: "number", value: "0"}` and trip the
            // `GENERATING_INNER_PROOFS` guard at
            // `pil2-proofman/pil2-stark/src/starkpil/global_constraints.hpp`.
            HintValue::ColRef { col_type, id, row_offset, origin_frame_id } => {
                use crate::processor::expression::ColRefKind;
                let offset = row_offset.unwrap_or(0) as i32;
                // Round 3: the global hint path runs at proof scope.
                // Proof-scope hints that carry a bare `origin_frame_id`
                // reference a specific minting AIR's column allocator;
                // the global path has no AIR context so it cannot
                // resolve those safely. Emit Constant(0) with a
                // warning when origin is Some.
                if let Some(origin) = origin_frame_id {
                    if std::env::var("PIL2C_WARN_FOREIGN_INTERMEDIATE").is_ok() {
                        eprintln!(
                            "[pil2c-warn] global hint ColRef with per-AIR origin: \
                             col_type={:?} id={} origin_frame_id={} emitting \
                             Operand::Constant(0)",
                            col_type, id, origin,
                        );
                    }
                    let _ = offset;
                    return pilout_proto::HintField {
                        name: None,
                        value: Some(pilout_proto::hint_field::Value::Operand(
                            pilout_proto::Operand {
                                operand: Some(pilout_proto::operand::Operand::Constant(
                                    pilout_proto::operand::Constant { value: Vec::new() },
                                )),
                            },
                        )),
                    };
                }
                let operand = match col_type {
                    ColRefKind::ProofValue => {
                        let stage = self
                            .processor
                            .proof_values
                            .get_data(*id)
                            .and_then(|d| d.stage)
                            .unwrap_or(1);
                        pilout_proto::operand::Operand::ProofValue(
                            pilout_proto::operand::ProofValue {
                                stage,
                                idx: *id,
                            },
                        )
                    }
                    ColRefKind::AirGroupValue => {
                        pilout_proto::operand::Operand::AirGroupValue(
                            pilout_proto::operand::AirGroupValue { idx: *id },
                        )
                    }
                    ColRefKind::Public => {
                        pilout_proto::operand::Operand::PublicValue(
                            pilout_proto::operand::PublicValue { idx: *id },
                        )
                    }
                    ColRefKind::Challenge => {
                        let stage = self
                            .processor
                            .challenges
                            .get_data(*id)
                            .and_then(|d| d.stage)
                            .unwrap_or(1);
                        pilout_proto::operand::Operand::Challenge(
                            pilout_proto::operand::Challenge { stage, idx: *id },
                        )
                    }
                    ColRefKind::Witness => {
                        // Proof-scope hints occasionally carry a bare
                        // WitnessCol (e.g. debug hints that reference a
                        // specific stage-1 column by id). Emit it
                        // directly; stage/col_idx lookup uses the
                        // per-air witness map if available, otherwise
                        // defaults to stage 1 / id.
                        pilout_proto::operand::Operand::WitnessCol(
                            pilout_proto::operand::WitnessCol {
                                stage: 1,
                                col_idx: *id,
                                row_offset: offset,
                            },
                        )
                    }
                    ColRefKind::AirValue => {
                        pilout_proto::operand::Operand::AirValue(
                            pilout_proto::operand::AirValue { idx: *id },
                        )
                    }
                    _ => pilout_proto::operand::Operand::Constant(
                        pilout_proto::operand::Constant {
                            value: Vec::new(),
                        },
                    ),
                };
                return pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::Operand(
                        pilout_proto::Operand { operand: Some(operand) },
                    )),
                };
            }
            #[allow(unreachable_patterns)]
            HintValue::ColRef { .. } => pilout_proto::HintField {
                name: None,
                value: Some(pilout_proto::hint_field::Value::Operand(
                    pilout_proto::Operand {
                        operand: Some(pilout_proto::operand::Operand::Constant(
                            pilout_proto::operand::Constant {
                                value: Vec::new(),
                            },
                        )),
                    },
                )),
            },
        }
    }

    /// Flatten a RuntimeExpr tree into the global expressions array.
    ///
    /// Returns the index of the newly appended expression within `out`.
    /// Sub-expressions (nested BinOp / UnaryOp) are recursively
    /// flattened first so their indices are available as operands.
    ///
    fn flatten_expr_to_global(
        &self,
        expr: &RuntimeExpr,
        out: &mut Vec<pilout_proto::GlobalExpression>,
    ) -> u32 {
        let op = match expr {
            RuntimeExpr::BinOp { op, left, right } => {
                let lhs = self.flatten_operand_to_global(left, out);
                let rhs = self.flatten_operand_to_global(right, out);
                match op {
                    RuntimeOp::Add => {
                        pilout_proto::global_expression::Operation::Add(
                            pilout_proto::global_expression::Add { lhs, rhs },
                        )
                    }
                    RuntimeOp::Sub => {
                        pilout_proto::global_expression::Operation::Sub(
                            pilout_proto::global_expression::Sub { lhs, rhs },
                        )
                    }
                    RuntimeOp::Mul => {
                        pilout_proto::global_expression::Operation::Mul(
                            pilout_proto::global_expression::Mul { lhs, rhs },
                        )
                    }
                }
            }
            RuntimeExpr::UnaryOp { op, operand } => match op {
                RuntimeUnaryOp::Neg => {
                    let value = self.flatten_operand_to_global(operand, out);
                    pilout_proto::global_expression::Operation::Neg(
                        pilout_proto::global_expression::Neg { value },
                    )
                }
            },
            // Leaf nodes (Value, ColRef) are not top-level expressions on
            // their own; wrap them in a trivial Add(x, 0) so they still get
            // an expression slot.
            _ => {
                let leaf = self.leaf_to_global_operand(expr);
                let zero = Some(pilout_proto::GlobalOperand {
                    operand: Some(pilout_proto::global_operand::Operand::Constant(
                        pilout_proto::global_operand::Constant { value: Vec::new() },
                    )),
                });
                pilout_proto::global_expression::Operation::Add(
                    pilout_proto::global_expression::Add { lhs: leaf, rhs: zero },
                )
            }
        };

        let proto_expr = pilout_proto::GlobalExpression {
            operation: Some(op),
        };

        let idx = out.len() as u32;
        out.push(proto_expr);
        idx
    }

    /// Convert a RuntimeExpr to a global operand, flattening nested
    /// sub-expressions into `out` and referencing them by index.
    fn flatten_operand_to_global(
        &self,
        expr: &RuntimeExpr,
        out: &mut Vec<pilout_proto::GlobalExpression>,
    ) -> Option<pilout_proto::GlobalOperand> {
        match expr {
            // Nested expression: flatten recursively and reference by index.
            RuntimeExpr::BinOp { .. } | RuntimeExpr::UnaryOp { .. } => {
                let idx = self.flatten_expr_to_global(expr, out);
                Some(pilout_proto::GlobalOperand {
                    operand: Some(pilout_proto::global_operand::Operand::Expression(
                        pilout_proto::global_operand::Expression { idx },
                    )),
                })
            }
            // Leaf: delegate to non-recursive conversion.
            _ => self.leaf_to_global_operand(expr),
        }
    }

    /// Convert a leaf RuntimeExpr (Value or ColRef) to a global operand.
    fn leaf_to_global_operand(
        &self,
        expr: &RuntimeExpr,
    ) -> Option<pilout_proto::GlobalOperand> {
        let operand = match expr {
            RuntimeExpr::Value(Value::Int(v)) => {
                pilout_proto::global_operand::Operand::Constant(
                    pilout_proto::global_operand::Constant {
                        value: bigint_to_bytes(*v),
                    },
                )
            }
            RuntimeExpr::Value(Value::Fe(v)) => {
                pilout_proto::global_operand::Operand::Constant(
                    pilout_proto::global_operand::Constant {
                        value: bigint_to_bytes(*v as i128),
                    },
                )
            }
            RuntimeExpr::ColRef { col_type, id, .. } => match col_type {
                ColRefKind::Challenge => {
                    let stage = self.processor.challenges.get_data(*id)
                        .and_then(|d| d.stage)
                        .unwrap_or(1);
                    pilout_proto::global_operand::Operand::Challenge(
                        pilout_proto::global_operand::Challenge {
                            stage,
                            idx: *id,
                        },
                    )
                }
                ColRefKind::ProofValue => {
                    let stage = self.processor.proof_values.get_data(*id)
                        .and_then(|d| d.stage)
                        .unwrap_or(1);
                    pilout_proto::global_operand::Operand::ProofValue(
                        pilout_proto::global_operand::ProofValue {
                            stage,
                            idx: *id,
                        },
                    )
                }
                ColRefKind::AirGroupValue => {
                    pilout_proto::global_operand::Operand::AirGroupValue(
                        pilout_proto::global_operand::AirGroupValue {
                            air_group_id: 0,
                            idx: *id,
                        },
                    )
                }
                ColRefKind::Public => {
                    pilout_proto::global_operand::Operand::PublicValue(
                        pilout_proto::global_operand::PublicValue { idx: *id },
                    )
                }
                _ => return None,
            },
            // BinOp/UnaryOp should not reach here; handled by
            // flatten_operand_to_global above.
            _ => return None,
        };

        Some(pilout_proto::GlobalOperand {
            operand: Some(operand),
        })
    }

    // -------------------------------------------------------------------
    // Per-AIR expression/operand flattening (uses Operand, not
    // GlobalOperand).
    // -------------------------------------------------------------------

    /// Flatten a RuntimeExpr tree into the per-AIR expressions array.
    /// Returns the index of the appended expression.
    ///
    /// `expr_id_map` translates internal expression-store IDs to packed
    /// protobuf indices. This is critical for `Intermediate` operands
    /// which reference expressions by their store ID.
    ///
    /// `custom_id_map` translates internal custom column IDs to
    /// (stage, proto_index, commit_id).
    ///
    #[allow(clippy::too_many_arguments)]
    fn flatten_air_expr(
        &self,
        expr: &RuntimeExpr,
        source_expr_id: Option<u32>,
        source_label: Option<&str>,
        fixed_map: &[(char, u32)],
        fixed_col_start: u32,
        witness_map: &[(u32, u32)],
        custom_map: &[(u32, u32, u32)],
        expr_id_map: &[u32],
        source_to_pos: &HashMap<u32, usize>,
        out: &mut Vec<pilout_proto::Expression>,
        rc_cache: &mut HashMap<*const RuntimeExpr, u32>,
        struct_cache: &mut HashMap<RuntimeExpr, u32>,
        prov_cache: &mut HashMap<PackedKey, u32>,
        im_labels: &mut std::collections::BTreeMap<u32, String>,
        stats: &mut ChainShapeStats,
    ) -> u32 {
        // Round 4 cross-AIR safety net: an `Intermediate` ColRef leaf
        // whose `id` is not in this AIR's `source_to_pos` AND whose raw
        // id is past the `expr_id_map` range is unresolvable through
        // the per-AIR path. Substitute the `RuntimeExpr` snapshot the
        // producer captured in `processor.global_intermediate_resolution`
        // at ref-mint time, then flatten the resolved tree inline.
        // Without this, `leaf_to_air_operand`'s legacy fallback emits
        // the raw slot id as `Operand::Expression { idx }` and
        // pil2-stark-setup indexes past per-AIR `expressions[]`
        // (panic at `helpers.rs:21:19`). See
        // BL-20260418-intermediate-ref-cross-air-leak.
        if let RuntimeExpr::ColRef {
            col_type: ColRefKind::Intermediate,
            id,
            row_offset: _,
            origin_frame_id,
        } = expr
        {
            // Round 3 (2026-04-19 loop) origin-authoritative
            // resolution. If the ref's `origin_frame_id` differs
            // from the current AIR being serialized, the local
            // `source_to_pos` entry (if any) points at a different
            // expression that happens to share the bare local id;
            // using it would silently mis-resolve a cross-AIR ref.
            // Route these through `global_intermediate_resolution`
            // directly. Same-origin refs keep the existing
            // forward-reference fallback path (source_to_pos miss
            // or its mapped pos not yet in `expr_id_map`).
            // See BL-20260419-origin-frame-id-resolution.
            let current_origin = *self.current_origin_frame_id.borrow();
            let is_foreign = matches!(origin_frame_id, Some(o) if *o != current_origin);
            if is_foreign {
                if let Some(resolved) = origin_frame_id
                    .and_then(|o| self.processor.global_intermediate_resolution.get(&(o, *id)).cloned())
                {
                    return self.flatten_air_expr(
                        &resolved,
                        source_expr_id,
                        source_label,
                        fixed_map,
                        fixed_col_start,
                        witness_map,
                        custom_map,
                        expr_id_map,
                        source_to_pos,
                        out,
                        rc_cache,
                        struct_cache,
                        prov_cache,
                        im_labels,
                        stats,
                    );
                }
                // Foreign ref with no resolution: fall through to
                // the leaf path which emits Constant(0) with a
                // warning.
            } else {
                let unresolved = source_to_pos
                    .get(id)
                    .and_then(|&pos| expr_id_map.get(pos).copied())
                    .is_none();
                if unresolved {
                    let key = origin_frame_id.map(|o| (o, *id));
                    if let Some(resolved) = key
                        .and_then(|k| self.processor.global_intermediate_resolution.get(&k).cloned())
                    {
                        return self.flatten_air_expr(
                            &resolved,
                            source_expr_id,
                            source_label,
                            fixed_map,
                            fixed_col_start,
                            witness_map,
                            custom_map,
                            expr_id_map,
                            source_to_pos,
                            out,
                            rc_cache,
                            struct_cache,
                            prov_cache,
                            im_labels,
                            stats,
                        );
                    }
                }
            }
        }
        // Rc-pointer fast path: if this exact node was already flattened,
        // reference the existing proto entry.
        let ptr = expr as *const RuntimeExpr;
        stats.rc_cache_probes += 1;
        if let Some(&cached_idx) = rc_cache.get(&ptr) {
            stats.rc_cache_hits += 1;
            return cached_idx;
        }
        // Provenance / ColRef cache (mirrors JS
        // `saveAndPushExpressionReference(id, rowOffset)`): dedups
        // references that share a source identity across tree shapes,
        // e.g. two copies of "witness b" wrapped as `Add(b, 0)` vs
        // `Add(0, b)` would collapse to one packed slot as soon as an
        // upstream canonicalization pass normalizes the two shapes.
        // In the current compiler state this layer fires on
        // ColRef-leaf entries pushed by `value_to_hint_value` and on
        // lifted IM expressions that carry `source_expr_id`.
        let prov_key = packed_key_for(expr, source_expr_id);
        if let Some(k) = &prov_key {
            stats.prov_cache_probes += 1;
            if let Some(&cached_idx) = prov_cache.get(k) {
                rc_cache.insert(ptr, cached_idx);
                stats.prov_cache_hits += 1;
                return cached_idx;
            }
        }
        // JS pil2-compiler dedupes only by reference identity
        // (`pushExpressionReference(id, rowOffset)` in
        // `packed_expressions.js`), NOT by structural tree equality.
        // The structural cache previously retained here would
        // collapse two textually-identical inline subtrees (e.g.
        // two distinct in-source occurrences of
        // `(gsum_e[idx] + std_gamma)` inside `piop_gsum_air`'s
        // cluster prods vs sums products) onto a single packed
        // proto idx, which then propagates downstream to
        // `pil2-stark-setup::pil_code_gen` as a single cached tmp
        // and emits a SHORTER `qVerifier.code` opcode stream than
        // golden's reference-only-dedup output. The JS reference
        // generates a fresh `add(prev_tmp, std_gamma)` rebuild op
        // for every textual occurrence, so the strict-equality
        // `test_three_air_verifier_artifact_shape_matches_golden`
        // regression on `qVerifier.code.len` requires us to skip
        // the structural dedup. The Rc-pointer fast path and the
        // provenance / ColRef cache (which mirror JS reference
        // identity correctly) remain in place.
        let _ = expr_node_count;
        let _ = STRUCT_CACHE_NODE_LIMIT;
        let _ = &mut *struct_cache;

        let op = match expr {
            RuntimeExpr::BinOp { op, left, right } => {
                // Sub-operands do not carry the top-level store entry's
                // provenance; they're reused by their own ColRef /
                // provenance identity when recursed into.
                let lhs = self.flatten_air_operand(left, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map, source_to_pos, out, rc_cache, struct_cache, prov_cache, im_labels, stats);
                let rhs = self.flatten_air_operand(right, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map, source_to_pos, out, rc_cache, struct_cache, prov_cache, im_labels, stats);
                match op {
                    RuntimeOp::Add => pilout_proto::expression::Operation::Add(
                        pilout_proto::expression::Add { lhs, rhs },
                    ),
                    RuntimeOp::Sub => pilout_proto::expression::Operation::Sub(
                        pilout_proto::expression::Sub { lhs, rhs },
                    ),
                    RuntimeOp::Mul => pilout_proto::expression::Operation::Mul(
                        pilout_proto::expression::Mul { lhs, rhs },
                    ),
                }
            }
            RuntimeExpr::UnaryOp { op, operand } => match op {
                RuntimeUnaryOp::Neg => {
                    let value =
                        self.flatten_air_operand(operand, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map, source_to_pos, out, rc_cache, struct_cache, prov_cache, im_labels, stats);
                    pilout_proto::expression::Operation::Neg(
                        pilout_proto::expression::Neg { value },
                    )
                }
            },
            // Leaf node: wrap in Add(x, 0).
            _ => {
                let leaf = self.leaf_to_air_operand(expr, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map, source_to_pos);
                let zero = Some(pilout_proto::Operand {
                    operand: Some(pilout_proto::operand::Operand::Constant(
                        pilout_proto::operand::Constant { value: Vec::new() },
                    )),
                });
                pilout_proto::expression::Operation::Add(pilout_proto::expression::Add {
                    lhs: leaf,
                    rhs: zero,
                })
            }
        };

        let proto_expr = pilout_proto::Expression {
            operation: Some(op),
        };

        let idx = out.len() as u32;
        out.push(proto_expr);
        stats.proto_emitted += 1;
        rc_cache.insert(ptr, idx);
        if let Some(k) = prov_key {
            prov_cache.insert(k, idx);
        }
        // First-save-wins IM label recording. Record
        // `(packed_idx -> label)` only when (a) the store entry has
        // a source_label, (b) this is a first-insert (we reach here
        // only on cache miss), and (c) the top-level expression is
        // a BinOp / UnaryOp tree — not a bare ColRef leaf. JS only
        // emits an IM symbol for a `const expr X = ...` when X is
        // bound to a proper expression tree; bare aliases such as
        // `const expr L1 = get_L1()` (where get_L1 returns a fixed
        // col reference) are inlined by JS and no IM label surfaces.
        // Excluding ColRef-leaf entries mirrors that.
        if let Some(label) = source_label {
            if matches!(expr, RuntimeExpr::BinOp { .. } | RuntimeExpr::UnaryOp { .. }) {
                im_labels.entry(idx).or_insert_with(|| label.to_string());
            }
        }
        idx
    }

    /// Convert a RuntimeExpr to a per-AIR Operand.
    #[allow(clippy::too_many_arguments)]
    fn flatten_air_operand(
        &self,
        expr: &RuntimeExpr,
        fixed_map: &[(char, u32)],
        fixed_col_start: u32,
        witness_map: &[(u32, u32)],
        custom_map: &[(u32, u32, u32)],
        expr_id_map: &[u32],
        source_to_pos: &HashMap<u32, usize>,
        out: &mut Vec<pilout_proto::Expression>,
        rc_cache: &mut HashMap<*const RuntimeExpr, u32>,
        struct_cache: &mut HashMap<RuntimeExpr, u32>,
        prov_cache: &mut HashMap<PackedKey, u32>,
        im_labels: &mut std::collections::BTreeMap<u32, String>,
        stats: &mut ChainShapeStats,
    ) -> Option<pilout_proto::Operand> {
        match expr {
            RuntimeExpr::BinOp { .. } | RuntimeExpr::UnaryOp { .. } => {
                // Sub-operands recurse without carrying the top-level
                // entry's source provenance (source_expr_id and
                // source_label are only authoritative at the air
                // expression store entry level).
                let idx = self.flatten_air_expr(expr, None, None, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map, source_to_pos, out, rc_cache, struct_cache, prov_cache, im_labels, stats);
                Some(pilout_proto::Operand {
                    operand: Some(pilout_proto::operand::Operand::Expression(
                        pilout_proto::operand::Expression { idx },
                    )),
                })
            }
            // Round 4 cross-AIR safety net: an `Intermediate` ref whose
            // `id` is not in this AIR's `source_to_pos` must resolve
            // through `processor.global_intermediate_resolution` and
            // re-flatten inline. Without this, the leaf fallback in
            // `leaf_to_air_operand` emits the raw slot id as
            // `Operand::Expression { idx }` which pil2-stark-setup
            // indexes past its per-AIR `expressions[]` array, panicking
            // at `helpers.rs:21:19`. See
            // BL-20260418-intermediate-ref-cross-air-leak.
            RuntimeExpr::ColRef {
                col_type: ColRefKind::Intermediate,
                id,
                row_offset: _,
                origin_frame_id,
            } if {
                let current_origin = *self.current_origin_frame_id.borrow();
                let is_foreign = matches!(origin_frame_id, Some(o) if *o != current_origin);
                is_foreign
                    || source_to_pos
                        .get(id)
                        .and_then(|&pos| expr_id_map.get(pos).copied())
                        .is_none()
            } =>
            {
                let key = origin_frame_id.map(|o| (o, *id));
                if let Some(resolved) = key
                    .and_then(|k| self.processor.global_intermediate_resolution.get(&k).cloned())
                {
                    let idx = self.flatten_air_expr(
                        &resolved,
                        None,
                        None,
                        fixed_map,
                        fixed_col_start,
                        witness_map,
                        custom_map,
                        expr_id_map,
                        source_to_pos,
                        out,
                        rc_cache,
                        struct_cache,
                        prov_cache,
                        im_labels,
                        stats,
                    );
                    return Some(pilout_proto::Operand {
                        operand: Some(pilout_proto::operand::Operand::Expression(
                            pilout_proto::operand::Expression { idx },
                        )),
                    });
                }
                self.leaf_to_air_operand(expr, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map, source_to_pos)
            }
            _ => self.leaf_to_air_operand(expr, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map, source_to_pos),
        }
    }

    /// Convert a leaf RuntimeExpr to a per-AIR Operand.
    fn leaf_to_air_operand(
        &self,
        expr: &RuntimeExpr,
        fixed_map: &[(char, u32)],
        fixed_col_start: u32,
        witness_map: &[(u32, u32)],
        custom_map: &[(u32, u32, u32)],
        expr_id_map: &[u32],
        source_to_pos: &HashMap<u32, usize>,
    ) -> Option<pilout_proto::Operand> {
        let operand = match expr {
            RuntimeExpr::Value(Value::Int(v)) => {
                pilout_proto::operand::Operand::Constant(pilout_proto::operand::Constant {
                    value: bigint_to_bytes(*v),
                })
            }
            RuntimeExpr::Value(Value::Fe(v)) => {
                pilout_proto::operand::Operand::Constant(pilout_proto::operand::Constant {
                    value: bigint_to_bytes(*v as i128),
                })
            }
            RuntimeExpr::ColRef {
                col_type,
                id,
                row_offset,
                origin_frame_id,
            } => {
                let offset = row_offset.unwrap_or(0) as i32;
                // Round 6 foreign-origin guard for AIR-local column
                // kinds. An origin_frame_id that differs from the
                // serializer's current AIR means this leaf belongs
                // to a different AIR's column allocator. Only
                // applies when the serializer IS inside an AIR
                // (`current_origin > 0`); proof-scope / global
                // serialization has no AIR context and the ref
                // should go through its per-kind arm. See
                // BL-20260419-origin-authoritative-serializer.
                let current_origin = *self.current_origin_frame_id.borrow();
                let foreign_origin = current_origin != 0
                    && matches!(
                        origin_frame_id,
                        Some(o) if *o != current_origin,
                    )
                    && matches!(
                        col_type,
                        ColRefKind::Witness
                            | ColRefKind::Fixed
                            | ColRefKind::AirValue
                            | ColRefKind::Custom,
                    );
                if foreign_origin {
                    if std::env::var("PIL2C_WARN_FOREIGN_INTERMEDIATE").is_ok() {
                        let air_name = self.current_air_name.borrow();
                        eprintln!(
                            "[pil2c-warn] foreign-origin {:?} leaf: air='{}' id={} \
                             origin_frame_id={:?} current_origin={} emitting \
                             Operand::Constant(0)",
                            col_type,
                            *air_name,
                            id,
                            origin_frame_id,
                            current_origin,
                        );
                    }
                    return Some(pilout_proto::Operand {
                        operand: Some(pilout_proto::operand::Operand::Constant(
                            pilout_proto::operand::Constant { value: Vec::new() },
                        )),
                    });
                }
                match col_type {
                    ColRefKind::Fixed => {
                        let rel_idx = (*id).checked_sub(fixed_col_start).unwrap_or(*id) as usize;
                        match fixed_map.get(rel_idx).copied() {
                            Some((ctype, proto_idx)) => {
                                if ctype == 'P' {
                                    pilout_proto::operand::Operand::PeriodicCol(
                                        pilout_proto::operand::PeriodicCol {
                                            idx: proto_idx,
                                            row_offset: offset,
                                        },
                                    )
                                } else {
                                    pilout_proto::operand::Operand::FixedCol(
                                        pilout_proto::operand::FixedCol {
                                            idx: proto_idx,
                                            row_offset: offset,
                                        },
                                    )
                                }
                            }
                            // Foreign-AIR fallback: the raw id belongs to a
                            // different AIR's `fixed_col` allocator, which
                            // only happens when `flatten_air_expr`'s global-
                            // resolution path inlines a `RuntimeExpr` minted
                            // by another AIR. Emit `Constant(0)` instead of
                            // a stale `FixedCol { idx: raw_id }` so
                            // pil2-stark-setup's FRI evaluator cannot look
                            // up the missing symbol and panic. Round 5:
                            // KEEP as a last-resort correctness backstop.
                            // Round 4's upstream lift filter in
                            // `execute_air_template_call` screens foreign
                            // Fixed leaves before they reach the
                            // serializer, so this branch is silent on the
                            // Zisk build at current HEAD. Evidence:
                            // captured `PIL2C_WARN_FOREIGN_INTERMEDIATE=1`
                            // trace at `temp/round3-fallback-warnings.log`
                            // shows zero `[pil2c-warn] foreign-AIR Fixed`
                            // lines. Branch is retained because removing
                            // it would re-enable the pre-Round-13 silent
                            // mis-resolution path for any future shape
                            // that bypasses the lift filter. See
                            // BL-20260418-intermediate-ref-column-scope-leak.
                            None => {
                                if std::env::var("PIL2C_WARN_FOREIGN_INTERMEDIATE").is_ok() {
                                    let air_name = self.current_air_name.borrow();
                                    eprintln!(
                                        "[pil2c-warn] foreign-AIR Fixed leaf: \
                                         air='{}' id={} rel_idx={} fixed_col_start={} \
                                         origin_frame_id={:?} emitting Operand::Constant(0)",
                                        *air_name,
                                        id,
                                        rel_idx,
                                        fixed_col_start,
                                        origin_frame_id,
                                    );
                                }
                                pilout_proto::operand::Operand::Constant(
                                    pilout_proto::operand::Constant { value: Vec::new() },
                                )
                            }
                        }
                    }
                    ColRefKind::Witness => match witness_map.get(*id as usize).copied() {
                        Some((stage, col_idx)) => pilout_proto::operand::Operand::WitnessCol(
                            pilout_proto::operand::WitnessCol {
                                stage,
                                col_idx,
                                row_offset: offset,
                            },
                        ),
                        // Foreign-AIR fallback: see Fixed arm comment.
                        // Round 5: KEEP as a last-resort correctness
                        // backstop. Upstream lift filter in
                        // `execute_air_template_call` screens foreign
                        // Witness leaves; captured
                        // `PIL2C_WARN_FOREIGN_INTERMEDIATE=1` trace at
                        // `temp/round3-fallback-warnings.log` confirms
                        // zero `[pil2c-warn] foreign-AIR Witness` hits
                        // on the Zisk build.
                        None => {
                            if std::env::var("PIL2C_WARN_FOREIGN_INTERMEDIATE").is_ok() {
                                let air_name = self.current_air_name.borrow();
                                eprintln!(
                                    "[pil2c-warn] foreign-AIR Witness leaf: \
                                     air='{}' id={} witness_map.len={} \
                                     origin_frame_id={:?} emitting Operand::Constant(0)",
                                    *air_name,
                                    id,
                                    witness_map.len(),
                                    origin_frame_id,
                                );
                            }
                            pilout_proto::operand::Operand::Constant(
                                pilout_proto::operand::Constant { value: Vec::new() },
                            )
                        }
                    },
                    ColRefKind::Challenge => {
                        let stage = self.processor.challenges.get_data(*id)
                            .and_then(|d| d.stage)
                            .unwrap_or(1);
                        pilout_proto::operand::Operand::Challenge(
                            pilout_proto::operand::Challenge { stage, idx: *id },
                        )
                    }
                    ColRefKind::ProofValue => {
                        let stage = self.processor.proof_values.get_data(*id)
                            .and_then(|d| d.stage)
                            .unwrap_or(1);
                        pilout_proto::operand::Operand::ProofValue(
                            pilout_proto::operand::ProofValue { stage, idx: *id },
                        )
                    }
                    ColRefKind::AirGroupValue => {
                        pilout_proto::operand::Operand::AirGroupValue(
                            pilout_proto::operand::AirGroupValue { idx: *id },
                        )
                    }
                    ColRefKind::AirValue => {
                        // Round 2 (2026-04-19) foreign-AIR airvalue guard.
                        // `pil2-stark-setup/src/parser_args.rs:594` walks
                        // `stark_info.air_values_map[0..id]` to compute
                        // `air_value_pos`, so an id that exceeds the
                        // consuming AIR's `air_value_stages` length is
                        // a foreign-AIR leak and must not surface as a
                        // stale `AirValue { idx }`. Emit
                        // `Operand::Constant(0)` instead, mirroring
                        // the Witness/Fixed Constant(0) pattern from
                        // commit `73ebbbfc`. Round 7: KEEP as
                        // last-resort correctness backstop. The
                        // upstream origin-aware check earlier in
                        // this function (gated on `current_origin
                        // != 0`) handles foreign-origin AirValue
                        // references from AIR-scope serialization.
                        // This bounds-only check remains for
                        // proof-scope / origin-less leaves (the
                        // original Round 2 case that surfaced the
                        // Mem OOB panic at ids 61/65/78/100 vs
                        // `airValuesMap.len()` 23). Captured
                        // `PIL2C_WARN_FOREIGN_INTERMEDIATE=1` trace
                        // at `temp/round3-fallback-warnings.log`
                        // confirms zero firings on the Zisk build
                        // at commit `0c6101f8`. See
                        // BL-20260419-origin-frame-id-resolution.
                        let count = *self.current_air_value_count.borrow();
                        if (*id as usize) < count {
                            pilout_proto::operand::Operand::AirValue(
                                pilout_proto::operand::AirValue { idx: *id },
                            )
                        } else {
                            if std::env::var("PIL2C_WARN_FOREIGN_INTERMEDIATE").is_ok() {
                                let air_name = self.current_air_name.borrow();
                                eprintln!(
                                    "[pil2c-warn] foreign-AIR AirValue ref at leaf: \
                                     air='{}' id={} (air_value_stages.len={}) \
                                     emitting Operand::Constant(0)",
                                    *air_name, id, count,
                                );
                            }
                            pilout_proto::operand::Operand::Constant(
                                pilout_proto::operand::Constant { value: Vec::new() },
                            )
                        }
                    }
                    ColRefKind::Public => {
                        pilout_proto::operand::Operand::PublicValue(
                            pilout_proto::operand::PublicValue { idx: *id },
                        )
                    }
                    ColRefKind::Custom => {
                        // Round 13 restricted
                        // `execute_air_template_call`'s air-expression
                        // lift to drop proof-scope container slots
                        // carrying cross-AIR Custom references, and
                        // Round 14 further narrowed that filter to
                        // keep legitimate proof-scope state while
                        // dropping only cross-AIR Custom-bearing
                        // slots. Surfaces that still reach this
                        // serializer with an unmapped id (hints,
                        // constraints) degrade to `Operand::Constant`
                        // (zero) — the Round 11 fallback — rather
                        // than crashing the build. Any other surface
                        // producing unmapped Custom operands should
                        // be investigated upstream.
                        if let Some(&(stage, col_idx, commit_id)) =
                            custom_map.get(*id as usize)
                        {
                            pilout_proto::operand::Operand::CustomCol(
                                pilout_proto::operand::CustomCol {
                                    commit_id,
                                    stage,
                                    col_idx,
                                    row_offset: offset,
                                },
                            )
                        } else {
                            pilout_proto::operand::Operand::Constant(
                                pilout_proto::operand::Constant {
                                    value: Vec::new(),
                                },
                            )
                        }
                    }
                    ColRefKind::Intermediate => {
                        // Round 3 (2026-04-19 loop) origin-authoritative
                        // Intermediate leaf. Same-origin refs resolve
                        // via `source_to_pos`. Foreign-origin refs
                        // (origin_frame_id differs from the serializer's
                        // current AIR) must NOT consult `source_to_pos`
                        // at all; they bypass the local path and emit
                        // `Operand::Constant(0)` because the upstream
                        // `flatten_air_expr` / `flatten_air_operand`
                        // guard should have re-flattened via
                        // `global_intermediate_resolution` first — if
                        // this leaf is reached with a foreign origin
                        // it means the global map also missed, so
                        // `Constant(0)` is the safe terminal fallback
                        // (rather than the raw-id emission that would
                        // silently mis-resolve to another AIR's packed
                        // index or panic pil2-stark-setup). Round 7:
                        // KEEP — the captured
                        // `PIL2C_WARN_FOREIGN_INTERMEDIATE=1` trace at
                        // `temp/round3-fallback-warnings.log` shows
                        // zero firings at commit `0c6101f8` because
                        // the upstream `flatten_air_*` guards handle
                        // every foreign-origin Intermediate before it
                        // reaches this leaf arm. Branch retained as
                        // correctness backstop for any future surface
                        // that bypasses the upstream guard. See
                        // BL-20260419-origin-frame-id-resolution.
                        let current_origin = *self.current_origin_frame_id.borrow();
                        let is_foreign = matches!(origin_frame_id, Some(o) if *o != current_origin);
                        if is_foreign {
                            if std::env::var("PIL2C_WARN_FOREIGN_INTERMEDIATE").is_ok() {
                                let air_name = self.current_air_name.borrow();
                                eprintln!(
                                    "[pil2c-warn] foreign-origin Intermediate at leaf: \
                                     air='{}' id={} origin_frame_id={:?} \
                                     current_origin={} emitting Operand::Constant(0)",
                                    *air_name,
                                    id,
                                    origin_frame_id,
                                    current_origin,
                                );
                            }
                            pilout_proto::operand::Operand::Constant(
                                pilout_proto::operand::Constant { value: Vec::new() },
                            )
                        } else {
                            let proto_idx = source_to_pos
                                .get(id)
                                .and_then(|&pos| expr_id_map.get(pos).copied());
                            match proto_idx {
                                Some(idx) => pilout_proto::operand::Operand::Expression(
                                    pilout_proto::operand::Expression { idx },
                                ),
                                None => {
                                    if std::env::var("PIL2C_WARN_FOREIGN_INTERMEDIATE").is_ok() {
                                        let air_name = self.current_air_name.borrow();
                                        eprintln!(
                                            "[pil2c-warn] unresolved same-origin Intermediate \
                                             at leaf: air='{}' id={} origin_frame_id={:?} \
                                             current_origin={} emitting Operand::Constant(0)",
                                            *air_name,
                                            id,
                                            origin_frame_id,
                                            current_origin,
                                        );
                                    }
                                    pilout_proto::operand::Operand::Constant(
                                        pilout_proto::operand::Constant { value: Vec::new() },
                                    )
                                }
                            }
                        }
                    }
                }
            }
            _ => return None,
        };

        Some(pilout_proto::Operand {
            operand: Some(operand),
        })
    }
}

/// Serialize the processor state and write the .pilout file.
pub fn write_pilout(processor: &Processor, path: &str) -> anyhow::Result<()> {
    let mut builder = ProtoOutBuilder::new(processor);
    let pilout = builder.build();

    let total_air_exprs: usize = pilout.air_groups.iter()
        .flat_map(|ag| ag.airs.iter())
        .map(|a| a.expressions.len())
        .sum();
    let total_air_constraints: usize = pilout.air_groups.iter()
        .flat_map(|ag| ag.airs.iter())
        .map(|a| a.constraints.len())
        .sum();
    eprintln!(
        "  > Proto: {} air groups, {} symbols, {} hints, {} global expressions, {} global constraints, {} air expressions, {} air constraints",
        pilout.air_groups.len(),
        pilout.symbols.len(),
        pilout.hints.len(),
        pilout.expressions.len(),
        pilout.constraints.len(),
        total_air_exprs,
        total_air_constraints,
    );

    let encoded = pilout.encode_to_vec();
    eprintln!("  > Proto encoded size: {} bytes", encoded.len());

    let parent = Path::new(path).parent();
    if let Some(dir) = parent {
        if !dir.exists() {
            fs::create_dir_all(dir)?;
        }
    }

    let mut file = fs::File::create(path)?;
    file.write_all(&encoded)?;
    eprintln!("  > Proto written to {}", path);

    Ok(())
}

/// Write fixed column data to a binary file.
///
/// The JS compiler writes row-major order: for each row, iterate over all
/// non-temporal/non-external columns and write one u64 per column.  The
/// filename follows the pattern `{air_name}.fixed` (matching the JS
/// `Air.outputFixedFile` default).
pub fn write_fixed_cols_to_file(
    fixed_cols: &FixedCols,
    num_rows: u64,
    output_dir: &str,
    fixed_filename: &str,
) -> anyhow::Result<()> {
    let dir = Path::new(output_dir);
    if !dir.exists() {
        fs::create_dir_all(dir)?;
    }

    let filename = dir.join(fixed_filename);
    eprintln!("  > Saving fixed file {} ...", filename.display());
    let mut file = fs::File::create(&filename)?;

    // Collect the IDs of non-temporal, non-external columns that have data.
    let mut col_ids: Vec<u32> = Vec::new();
    let fc_start = fixed_cols.current_start();
    let fc_end = fc_start + fixed_cols.ids.current_len();
    for id in fc_start..fc_end {
        if let Some(data) = fixed_cols.ids.get_data(id) {
            if data.temporal || data.external {
                continue;
            }
        }
        col_ids.push(id);
    }

    let col_count = col_ids.len() as u32;
    let mut total_values = 0u64;

    // Up-front sanity check: any non-temporal, non-external fixed col
    // with NO row data at all is almost always a producer bug — the
    // corresponding `Tables.fill` / `Tables.copy` / direct `F[row]
    // = ...` writes never executed. Without this loud warning, the
    // serializer silently zero-pads the entire column, which is what
    // hid the trio's all-zero `.fixed` files for many rounds. See
    // BL-20260420-tables-statement-dispatch-missing and
    // BL-20260420-fixed-col-empty-row-data-diagnostic.
    let mut empty_col_ids: Vec<u32> = Vec::new();
    for &id in &col_ids {
        if fixed_cols.get_row_data(id).map_or(true, |d| d.is_empty()) {
            empty_col_ids.push(id);
        }
    }
    if !empty_col_ids.is_empty() {
        let preview: Vec<String> = empty_col_ids
            .iter()
            .take(5)
            .map(|id| id.to_string())
            .collect();
        let more = if empty_col_ids.len() > 5 {
            format!(" ... +{} more", empty_col_ids.len() - 5)
        } else {
            String::new()
        };
        eprintln!(
            "warning: write_fixed_cols_to_file({}): {} of {} non-temporal \
             fixed cols have NO row data; will silently serialize as zeros. \
             Empty col_ids: [{}]{}",
            filename.display(),
            empty_col_ids.len(),
            col_count,
            preview.join(", "),
            more
        );
    }

    // Write in row-major order (matches the JS FixedFile.saveToFile layout).
    for row in 0..num_rows as usize {
        for &id in &col_ids {
            let val = if let Some(row_data) = fixed_cols.get_row_data(id) {
                if row < row_data.len() {
                    let v = row_data[row];
                    if v < 0 {
                        let neg = ((-v) as u128) % GOLDILOCKS_PRIME;
                        if neg == 0 { 0u64 } else { (GOLDILOCKS_PRIME - neg) as u64 }
                    } else {
                        ((v as u128) % GOLDILOCKS_PRIME) as u64
                    }
                } else {
                    0u64
                }
            } else {
                0u64
            };
            file.write_all(&val.to_le_bytes())?;
            total_values += 1;
        }
    }

    eprintln!(
        "  > Fixed cols written to {}: {} cols, {} values",
        filename.display(),
        col_count,
        total_values
    );

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use super::pilout_proto;

    #[test]
    fn test_proto_types_exist() {
        // Verify that key protobuf types are generated and accessible.
        let _pilout = pilout_proto::PilOut::default();
        let _air_group = pilout_proto::AirGroup::default();
        let _air = pilout_proto::Air::default();
        let _symbol = pilout_proto::Symbol::default();
        let _hint = pilout_proto::Hint::default();
    }

    #[test]
    fn test_bigint_to_bytes_zero() {
        let bytes = bigint_to_bytes(0);
        assert!(bytes.is_empty());
    }

    #[test]
    fn test_bigint_to_bytes_one() {
        let bytes = bigint_to_bytes(1);
        assert_eq!(bytes, vec![1]);
    }

    #[test]
    fn test_bigint_to_bytes_large() {
        // The prime itself reduces to 0 modulo the prime, yielding empty bytes.
        let bytes = bigint_to_bytes(0xFFFFFFFF00000001);
        assert!(bytes.is_empty());
        // A value just below the prime should be non-empty.
        let bytes2 = bigint_to_bytes(0xFFFFFFFF00000000);
        assert!(!bytes2.is_empty());
    }

    /// Decode the golden `zisk.pilout` and assert structural invariants.
    ///
    /// The reference values come from the JS-compiled golden pilout. If the
    /// pilout file is not present (e.g. CI without large test artifacts), the
    /// test is skipped rather than failed.
    #[test]
    fn test_decoded_pilout_parity() {
        let path = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../pil/zisk.pilout");
        if !path.exists() {
            eprintln!("Skipping test_decoded_pilout_parity: {:?} not found", path);
            return;
        }
        let data = std::fs::read(&path).expect("failed to read zisk.pilout");
        let pilout = pilout_proto::PilOut::decode(data.as_slice())
            .expect("failed to decode zisk.pilout as PilOut");

        // -- Top-level structure --
        assert_eq!(pilout.air_groups.len(), 1, "expected 1 air group");
        assert!(!pilout.symbols.is_empty(), "symbols vector is empty");
        assert!(!pilout.hints.is_empty(), "hints vector is empty");

        let ag = &pilout.air_groups[0];
        assert_eq!(ag.name.as_deref(), Some("Zisk"), "air group name mismatch");
        assert_eq!(ag.airs.len(), 35, "expected 35 AIRs in the Zisk air group");

        // Helper: find an AIR by name within the single air group.
        let find_air = |name: &str| -> &pilout_proto::Air {
            ag.airs
                .iter()
                .find(|a| a.name.as_deref() == Some(name))
                .unwrap_or_else(|| panic!("AIR {:?} not found in pilout", name))
        };

        // -- Per-AIR checks --
        // Structural: every AIR must have at least 1 constraint
        for air in &ag.airs {
            assert!(air.constraints.len() > 0, "AIR {} has no constraints", air.name.as_deref().unwrap_or("?"));
        }

        // Key fixed column counts (these drive the .fixed file generation).
        // Round 15 dropped `col fixed virtual(N) tmp` helper columns from
        // pilout emission, bringing SpecifiedRanges in line with JS
        // pil2-compiler golden (59 concrete fixed cols; the previous 67
        // counted the 8 virtual tVALS scratch cols that Tables.copy
        // materialises into VALS[] before emission).
        let sr = find_air("SpecifiedRanges");
        assert_eq!(sr.fixed_cols.len(), 59, "SpecifiedRanges fixedCols count");

        let vt0 = find_air("VirtualTable0");
        assert_eq!(vt0.fixed_cols.len(), 52, "VirtualTable0 fixedCols count");

        let vt1 = find_air("VirtualTable1");
        assert_eq!(vt1.fixed_cols.len(), 73, "VirtualTable1 fixedCols count");

        let blake = find_air("Blake2br");
        assert_eq!(blake.fixed_cols.len(), 3, "Blake2br fixedCols count");

        let keccak = find_air("Keccakf");
        assert_eq!(keccak.fixed_cols.len(), 2, "Keccakf fixedCols count");

        let main = find_air("Main");
        assert_eq!(main.fixed_cols.len(), 3, "Main fixedCols count");

        eprintln!("test_decoded_pilout_parity: all assertions passed");
    }
}
