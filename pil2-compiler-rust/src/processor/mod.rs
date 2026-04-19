//! PIL2 processor/evaluator: tree-walking interpreter that processes the AST.
//!
//! This is the central compilation engine. It walks the parsed AST, manages
//! scopes and namespaces, evaluates compile-time expressions, collects
//! column declarations and constraints, and builds the internal representation
//! that feeds into protobuf output.
//!
//! Mirrors the JS `Processor` class (pil2-compiler/src/processor.js, ~2183 lines).

pub mod air;
pub mod builtins;
pub mod constraints;
pub mod context;
pub mod expression;
pub mod fixed_cols;
pub mod ids;
pub mod references;
pub mod variables;

mod mod_utils;
use mod_utils::*;

mod mod_declarations;
mod mod_air_template_call;
mod mod_eval;
mod mod_hints;
mod mod_vardecl;

#[cfg(test)]
mod mod_tests;

use std::collections::BTreeMap;
use std::rc::Rc;
use std::time::Instant;

use crate::parser::ast::*;

use air::{AirGroups, AirTemplateInfo, AirTemplates};
use builtins::{BuiltinKind, TestTracker};
use constraints::Constraints;
use context::{CompilerConfig, NamespaceContext, Scope};
use expression::{
    ColRefKind, RuntimeExpr, RuntimeOp, RuntimeUnaryOp, Value,
    eval_binop_int, eval_unaryop_int, parse_numeric_literal,
};
use fixed_cols::FixedCols;
use ids::IdData;
use references::{RefType, Reference, References};
use variables::VariableStore;

/// Flow control signals returned by statement execution.
#[derive(Debug)]
enum FlowSignal {
    /// Normal completion -- no signal.
    None,
    /// `break` encountered inside a loop.
    Break,
    /// `continue` encountered inside a loop.
    Continue,
    /// `return value` encountered inside a function.
    Return(Value),
}

impl FlowSignal {
    fn is_abort(&self) -> bool {
        !matches!(self, FlowSignal::None)
    }
}

/// The main PIL2 processor.
///
/// Owns all compilation state: scopes, references, column stores,
/// constraints, air groups, etc.
pub struct Processor {
    // -- Scope and context --
    pub scope: Scope,
    pub namespace_ctx: NamespaceContext,
    pub config: CompilerConfig,
    pub source_ref: String,

    // -- Reference management --
    pub references: References,

    // -- Variable stores (int, fe, string, expr) --
    pub ints: VariableStore,
    pub fes: VariableStore,
    pub strings: VariableStore,
    pub exprs: VariableStore,

    // -- Column stores --
    pub fixed_cols: FixedCols,
    pub witness_cols: ids::IdAllocator,
    pub custom_cols: ids::IdAllocator,
    pub publics: ids::IdAllocator,
    pub challenges: ids::IdAllocator,
    pub proof_values: ids::IdAllocator,
    pub air_group_values: ids::IdAllocator,
    pub air_values: ids::IdAllocator,

    // -- Constraints --
    pub constraints: Constraints,
    pub global_constraints: Constraints,

    // -- AIR expression store: accumulates ALL expressions created during
    // AIR execution (intermediate columns, constraint sub-exprs, etc.).
    // Mirrors the JS `this.expressions` store. --
    pub air_expression_store: Vec<air::AirExpressionEntry>,

    // -- Per-AIR set of `self.exprs` slot ids that `eval_reference`
    // returned as `Value::ColRef { col_type: Intermediate, id, .. }`
    // through `get_var_ref_value*` while this AIR was current.
    // Round 3 lift / read consistency layer: `mod_air_template_call.rs`'s
    // `air_expression_store` lift filter must keep every id in this set
    // even if its current stored value no longer passes `is_symbolic`,
    // because the proto serializer's `source_to_pos` map will need that
    // entry to resolve any `Intermediate` ref the producer minted.
    // Without this, an `expr` slot read symbolically and then overwritten
    // with a non-symbolic value (Int, Array, etc.) before AIR finalization
    // produces a stale ref that pil2-stark-setup blindly indexes
    // (panic at `pil2-stark-setup/src/helpers.rs:21:19`).
    pub intermediate_refs_emitted: std::collections::HashSet<u32>,

    // -- Per-AIR snapshot of the `RuntimeExpr` that was live at each slot
    // when the producer minted an `Intermediate` ref for it. Round 4 uses
    // this map to substitute AIR-local `Intermediate { id, .. }` leaves
    // with their underlying expression when a value is about to cross the
    // AIR boundary (written into a container-owned proof-scope slot) so
    // downstream AIRs never read a ref whose id they cannot resolve in
    // their own per-AIR `source_to_pos`. Captured at mint time rather than
    // looked up from `self.exprs` at write time because the slot may have
    // been overwritten with a non-symbolic value by then. Cleared on AIR
    // push and exit alongside `intermediate_refs_emitted`.
    // See BL-20260418-intermediate-ref-cross-air-leak.
    pub intermediate_ref_resolution:
        std::collections::HashMap<(u32, u32), std::rc::Rc<RuntimeExpr>>,

    // -- Cross-AIR safety net. Every time the producer mints an
    // `Intermediate { id, .. }` ref we also store the RuntimeExpr
    // snapshot in this persistent map, indexed by the self.exprs
    // slot id (which is globally unique across AIRs because
    // `IdAllocator::push` advances `next_id` past previous max).
    // The proto serializer consults this map when `source_to_pos`
    // for the current AIR has no entry for a leaked Intermediate
    // id, and re-flattens the underlying expression inline instead
    // of emitting the raw id (which would panic in pil2-stark-setup
    // at `helpers.rs:21:19`). Persisted for the whole pilout build.
    // See BL-20260418-intermediate-ref-cross-air-leak.
    pub global_intermediate_resolution:
        std::collections::HashMap<(u32, u32), std::rc::Rc<RuntimeExpr>>,

    // -- Monotonic counter incremented on every
    // `execute_air_template_call` entry. Used to disambiguate
    // AIR-local expr slot ids across AIRs since `IdAllocator::push`
    // resets `next_id` to 0 per AIR frame. Paired with the local id
    // as the composite key into `intermediate_ref_resolution` and
    // `global_intermediate_resolution`. Not decremented on AIR exit:
    // every call gets a unique id for the life of the pilout build.
    // Round 2 addition (BL-20260419-origin-frame-id-resolution).
    pub next_origin_frame_id: u32,
    pub current_origin_frame_id: u32,

    // -- Global (proof-level) expression store: symbolic expressions from
    // proof-level `expr` variables, mirroring JS `this.globalExpressions`. --
    pub global_expression_store: Vec<RuntimeExpr>,

    // -- Air structures --
    pub air_groups: AirGroups,
    pub air_templates: AirTemplates,
    pub air_stack: Vec<air::Air>,
    pub current_air_group: Option<String>,
    pub air_group_stack: Vec<Option<String>>,
    last_air_group_id: i32,
    last_air_id: i32,

    // -- Functions --
    /// User-defined functions: name -> (args, body). `BTreeMap` so
    /// iteration order is deterministic across process invocations.
    /// `std::collections::HashMap` uses a per-process randomized hash
    /// seed; iterating it to drive compile-time semantics or emission
    /// order produces non-reproducible pilouts.
    functions: BTreeMap<String, FunctionDef>,
    function_deep: u32,
    callstack: Vec<CallStackEntry>,

    // -- Built-in tracking --
    pub tests: TestTracker,

    // -- Deferred calls --
    /// Scope name -> (event name -> deferred calls). `BTreeMap` at
    /// both levels so deferred-function execution order is
    /// deterministic and independent of the per-process HashMap seed.
    /// JS's deferred-call table uses insertion-order Map semantics;
    /// `BTreeMap` is the closest sorted-iteration match available.
    deferred_calls: BTreeMap<String, BTreeMap<String, Vec<DeferredCallInfo>>>,

    // -- Pragmas --
    pragmas_next_statement: PragmaNextStatement,
    pragmas_next_fixed: PragmaNextFixed,

    // -- Include stack --
    include_stack: Vec<String>,

    // -- Counters --
    execute_counter: u64,

    // -- Error flag --
    /// Set when `error()` is called. Causes statement execution to
    /// short-circuit until the enclosing user function returns,
    /// matching the JS compiler's exception-unwinding behavior.
    error_raised: bool,

    // -- Error counting --
    /// Total number of runtime errors encountered during compilation.
    pub error_count: u32,

    // -- Commit tracking --
    /// Maps commit name to its commit_id (within the current AIR).
    /// `BTreeMap` so the reverse-map iteration at AIR-finalization
    /// time produces the same commit ordering across runs.
    commit_name_to_id: BTreeMap<String, u32>,
    /// Next commit_id to assign within the current AIR.
    next_commit_id: u32,
    /// Maps commit name to resolved public column IDs. `BTreeMap`
    /// for deterministic iteration order when emission lists the
    /// publics associated with each commit.
    commit_publics: BTreeMap<String, Vec<u32>>,

    // -- Cross-AIR custom column registry --
    /// Persisted metadata for every custom column ever declared in
    /// any AIR. Keyed by the allocator id assigned at declaration
    /// time in `exec_col_declaration`'s `ColType::Custom` arm.
    /// Survives `self.custom_cols.clear()` between AIRs, so any AIR
    /// that subsequently references a cross-AIR custom column can
    /// look up the (commit_name, stage, col_idx_in_stage) triple
    /// needed to synthesize its own per-AIR `custom_id_map` +
    /// `custom_commits` entry for that commit.
    pub custom_col_meta: BTreeMap<u32, (String, u32, u32)>,
    /// Persisted per-commit metadata (stage widths + associated
    /// public ids). Keyed by commit name. Populated at declaration
    /// time alongside `custom_col_meta` so cross-AIR references can
    /// rebuild the commit entry in the receiving AIR without rerunning
    /// the declaring AIR's `exec_col_declaration` path.
    pub custom_commit_meta: BTreeMap<String, (Vec<u32>, Vec<u32>)>,

    // -- Hints --
    /// Per-AIR hints collected during air scope execution.
    pub air_hints: Vec<air::HintEntry>,
    /// Global (proof-level) hints.
    pub global_hints: Vec<air::HintEntry>,
}

#[allow(dead_code)]
#[derive(Debug, Clone)]
pub(super) struct CallStackEntry {
    pub(super) name: String,
    pub(super) source: String,
}

#[allow(dead_code)]
#[derive(Debug, Clone)]
struct DeferredCallInfo {
    function_name: String,
    priority: Option<i64>,
    source_refs: Vec<String>,
}

#[derive(Debug, Clone, Default)]
struct PragmaNextStatement {
    ignore: bool,
}

#[derive(Debug, Clone, Default)]
struct PragmaNextFixed {
    #[allow(dead_code)]
    bytes: Option<u32>,
    temporal: bool,
    external: bool,
    load_from_file: Option<(String, u32)>,
}

/// Compute the pilout Symbol label for a witness / fixed / custom /
/// air-value declaration, mirroring JS `references.js:287` plus the
/// `decodeName` absolute-scope rule at `references.js:170-192`.
///
/// - `air.X` / `airgroup.X` / `proof.X` are absolute-scoped names; the
///   emitted label drops the scope prefix (JS uses
///   `parts.slice(1).join('.')`).
/// - Container-member names with a single part are prefixed with the
///   current airgroup name (JS `${Context.airGroupName}.${name}`).
/// - All other names keep the bare `item.name` the parser received.
fn js_label_for_declaration(
    raw_name: &str,
    air_group_name: &str,
    inside_container: bool,
) -> String {
    if let Some(rest) = raw_name
        .strip_prefix("air.")
        .or_else(|| raw_name.strip_prefix("airgroup."))
        .or_else(|| raw_name.strip_prefix("proof."))
    {
        return rest.to_string();
    }
    if inside_container && !raw_name.contains('.') {
        return format!("{}.{}", air_group_name, raw_name);
    }
    raw_name.to_string()
}

impl Processor {
    /// Returns `Some(current_origin_frame_id)` iff the processor is
    /// currently inside an AIR template body. Used by AIR-local
    /// column ref construction sites (Witness / Fixed / AirValue /
    /// Custom) to stamp the origin on the minted ColRef so the
    /// lift filter and serializer can detect in-range-but-foreign
    /// leaves across AIR boundaries. Proof-scope / top-level /
    /// function-body outside an AIR returns None so the refs stay
    /// origin-less and skip the cross-AIR checks. See
    /// `BL-20260419-origin-authoritative-serializer`.
    pub fn maybe_air_origin_frame_id(&self) -> Option<u32> {
        if self.air_stack.is_empty() {
            None
        } else {
            Some(self.current_origin_frame_id)
        }
    }

    /// Create a new processor with the given configuration.
    pub fn new(config: CompilerConfig) -> Self {
        let mut processor = Self {
            scope: Scope::new(),
            namespace_ctx: NamespaceContext::new(),
            config,
            source_ref: "(init)".to_string(),
            references: References::new(),
            ints: VariableStore::new("int"),
            fes: VariableStore::new("fe"),
            strings: VariableStore::new("string"),
            exprs: VariableStore::new("expr"),
            fixed_cols: FixedCols::new(),
            witness_cols: ids::IdAllocator::new("witness"),
            custom_cols: ids::IdAllocator::new("customcol"),
            publics: ids::IdAllocator::new("public"),
            challenges: ids::IdAllocator::new("challenge"),
            proof_values: ids::IdAllocator::new("proofvalue"),
            air_group_values: ids::IdAllocator::new("airgroupvalue"),
            air_values: ids::IdAllocator::new("airvalue"),
            constraints: Constraints::new(),
            global_constraints: Constraints::new(),
            air_expression_store: Vec::new(),
            intermediate_refs_emitted: std::collections::HashSet::new(),
            intermediate_ref_resolution: std::collections::HashMap::new(),
            global_intermediate_resolution: std::collections::HashMap::new(),
            next_origin_frame_id: 0,
            current_origin_frame_id: 0,
            global_expression_store: Vec::new(),
            air_groups: AirGroups::new(),
            air_templates: AirTemplates::new(),
            air_stack: Vec::new(),
            current_air_group: None,
            air_group_stack: Vec::new(),
            last_air_group_id: -1,
            last_air_id: -1,
            functions: BTreeMap::new(),
            function_deep: 0,
            callstack: Vec::new(),
            tests: TestTracker::default(),
            deferred_calls: BTreeMap::new(),
            pragmas_next_statement: PragmaNextStatement::default(),
            pragmas_next_fixed: PragmaNextFixed::default(),
            include_stack: Vec::new(),
            execute_counter: 0,
            error_raised: false,
            error_count: 0,
            commit_name_to_id: BTreeMap::new(),
            next_commit_id: 0,
            commit_publics: BTreeMap::new(),
            custom_col_meta: BTreeMap::new(),
            custom_commit_meta: BTreeMap::new(),
            air_hints: Vec::new(),
            global_hints: Vec::new(),
        };
        processor.scope.mark("proof");
        processor.load_config_defines();
        processor.register_builtins();
        processor
    }

    /// Load compile-time defines from config.
    fn load_config_defines(&mut self) {
        for (name, value) in &self.config.defines.clone() {
            let id = self.ints.reserve(1, Some(name), &[], IdData::default());
            self.ints.set(id, Value::Int(*value));
            self.references.declare(
                name,
                RefType::Int,
                id,
                &[],
                true,
                0,
                "(defines)",
            );
        }
    }

    /// Register all built-in functions as function references.
    fn register_builtins(&mut self) {
        for &name in BuiltinKind::all_names() {
            // Reserve an ID slot for the function.
            let id = self.ints.reserve(1, None, &[], IdData::default());
            self.references.declare(
                name,
                RefType::Function,
                id,
                &[],
                true,
                0,
                "(builtin)",
            );
        }
    }

    /// Declare the built-in constants (PRIME, N, BITS, etc.).
    fn declare_builtin_constants(&mut self) {
        self.declare_int_var("PRIME", 0xFFFFFFFF00000001u64 as i128, true);
        self.declare_int_var("N", 0, false);
        self.declare_int_var("BITS", 0, false);
        self.declare_string_var("AIRGROUP", "", false);
        self.declare_int_var("AIRGROUP_ID", -1, false);
        self.declare_int_var("AIR_ID", -1, false);
        self.declare_string_var("AIR_NAME", "", false);
        self.declare_string_var("AIRTEMPLATE", "", false);
        self.declare_int_var("VIRTUAL", 0, false);
    }

    fn declare_int_var(&mut self, name: &str, value: i128, is_const: bool) {
        let id = self.ints.reserve(1, Some(name), &[], IdData::default());
        self.ints.set(id, Value::Int(value));
        self.references.declare(
            name,
            RefType::Int,
            id,
            &[],
            is_const,
            self.scope.deep,
            &self.source_ref,
        );
    }

    fn declare_string_var(&mut self, name: &str, value: &str, is_const: bool) {
        let id = self
            .strings
            .reserve(1, Some(name), &[], IdData::default());
        self.strings.set(id, Value::Str(value.to_string()));
        self.references.declare(
            name,
            RefType::Str,
            id,
            &[],
            is_const,
            self.scope.deep,
            &self.source_ref,
        );
    }

    // -----------------------------------------------------------------------
    // Main execution entry point
    // -----------------------------------------------------------------------

    /// Start execution of a parsed PIL2 program.
    pub fn execute_program(&mut self, program: &Program) -> bool {
        let start = Instant::now();

        self.source_ref = "(start-execution)".to_string();
        self.declare_builtin_constants();
        self.scope.push_instance_type("proof");
        self.source_ref = "(execution)".to_string();

        self.execute_statements(&program.statements);

        self.source_ref = "(airgroup-execution)".to_string();
        self.final_closing_air_groups();
        self.final_proof_scope();

        // Collect proof-level intermediate expressions (expr-typed
        // variables with symbolic values) for global expression output.
        // This mirrors the JS `this.globalExpressions.pack(...)`.
        for eid in 0..self.exprs.len() {
            if let Some(val) = self.exprs.get(eid) {
                if is_symbolic(val) {
                    let rt = value_to_runtime_expr(val);
                    self.global_expression_store.push(rt);
                }
            }
        }

        self.scope.pop_instance_type();

        self.test_summary();

        let elapsed = start.elapsed();
        eprintln!(
            "  > Total compilation: {:.2}ms",
            elapsed.as_secs_f64() * 1000.0
        );
        if self.error_count > 0 {
            eprintln!("  > Runtime errors: {}", self.error_count);
        }

        if self.tests.active {
            self.tests.fail == 0
        } else {
            // Return false when runtime errors occurred so the caller
            // can signal failure after writing the pilout.
            self.error_count == 0
        }
    }

    fn test_summary(&self) {
        if !self.tests.active {
            return;
        }
        if self.tests.fail > 0 {
            eprintln!("> tests OK: {}", self.tests.ok);
            eprintln!("> tests FAIL: {}", self.tests.fail);
            for msg in &self.tests.messages {
                for line in msg.lines() {
                    eprintln!("  - {}", line);
                }
            }
        } else {
            eprintln!("> tests OK: {} => All tests passed", self.tests.ok);
        }
    }

    // -----------------------------------------------------------------------
    // Statement execution
    // -----------------------------------------------------------------------

    /// Execute a list of statements, returning on the first flow abort.
    ///
    /// Matches JS `executeStatements` / `execute` behavior: each statement
    /// is executed inside an implicit try/catch. If `error_raised` is set
    /// (equivalent to a JS `throw`), the error is caught at the per-statement
    /// boundary, logged, and cleared so the next statement can proceed.
    fn execute_statements(&mut self, statements: &[Statement]) -> FlowSignal {
        for st in statements {
            let signal = self.execute_statement(st);

            // After each statement, catch any error that was raised during
            // its execution. This mirrors the JS `executeStatement` try/catch
            // that wraps every individual statement call. The error has
            // already been printed when it was raised; we just clear the
            // flag so the next statement can proceed.
            if self.error_raised {
                self.error_raised = false;
                // The error swallowed the statement's result; treat it as
                // a no-op and continue with the next statement.
                continue;
            }

            if signal.is_abort() {
                return signal;
            }
        }
        FlowSignal::None
    }

    /// Execute a single statement.
    fn execute_statement(&mut self, st: &Statement) -> FlowSignal {
        self.execute_counter += 1;

        // Check pragma ignore.
        if self.pragmas_next_statement.ignore {
            self.pragmas_next_statement = PragmaNextStatement::default();
            return FlowSignal::None;
        }

        match st {
            Statement::Pragma(value) => self.exec_pragma(value),
            Statement::VariableDeclaration(vd) => self.exec_variable_declaration(vd),
            Statement::Assignment(a) => self.exec_assignment(a),
            Statement::Constraint(c) => self.exec_constraint(c),
            Statement::If(if_stmt) => self.exec_if(if_stmt),
            Statement::For(for_stmt) => self.exec_for(for_stmt),
            Statement::While(while_stmt) => self.exec_while(while_stmt),
            Statement::Switch(switch_stmt) => self.exec_switch(switch_stmt),
            Statement::Return(ret) => self.exec_return(ret),
            Statement::Break => FlowSignal::Break,
            Statement::Continue => FlowSignal::Continue,
            Statement::ExprStatement(es) => self.exec_expr_stmt(es),
            Statement::VirtualExpr(ve) => self.exec_virtual_expr(ve),
            Statement::ColDeclaration(cd) => self.exec_col_declaration(cd),
            Statement::ChallengeDeclaration(cd) => self.exec_challenge_declaration(cd),
            Statement::PublicDeclaration(pd) => self.exec_public_declaration(pd),
            Statement::ProofValueDeclaration(pvd) => self.exec_proof_value_declaration(pvd),
            Statement::AirGroupValueDeclaration(agvd) => {
                self.exec_air_group_value_declaration(agvd)
            }
            Statement::AirValueDeclaration(avd) => self.exec_air_value_declaration(avd),
            Statement::CommitDeclaration(cd) => self.exec_commit_declaration(cd),
            Statement::FunctionDef(fd) => self.exec_function_definition(fd),
            Statement::AirGroupDef(ag) => self.exec_air_group(ag),
            Statement::AirTemplateDef(at) => self.exec_air_template_definition(at),
            Statement::Include(inc) => self.exec_include(inc),
            Statement::Container(cd) => self.exec_container(cd),
            Statement::Use(ud) => self.exec_use(ud),
            Statement::Package(pd) => self.exec_package_block(pd),
            Statement::DeferredCall(dc) => self.exec_deferred_function_call(dc),
            Statement::Hint(h) => self.exec_hint(h),
            Statement::When(_w) => {
                // When conditions are handled at runtime, not compile time.
                FlowSignal::None
            }
            Statement::Block(stmts) => {
                let use_aliases_mark = self.references.snapshot_use_aliases();
                self.scope.push();
                let result = self.execute_statements(stmts);
                let (to_unset, to_restore) = self.scope.pop();
                self.apply_scope_cleanup(&to_unset, &to_restore);
                self.references.restore_use_aliases_len(use_aliases_mark);
                result
            }
            Statement::PublicTableDeclaration(_) => {
                // Handled similarly to public declarations.
                FlowSignal::None
            }
        }
    }

    /// Apply scope cleanup after a pop: unset removed vars, restore shadows.
    fn apply_scope_cleanup(
        &mut self,
        to_unset: &[String],
        to_restore: &[(String, Reference)],
    ) {
        // PIL2C_TRACE_LEAK hook (tags: cleanup-unset, cleanup-restore). Emits
        // one line per scope-cleanup action on a watched name, so rescue
        // rounds can spot bindings that are supposed to vanish on pop but
        // survive across air/function frames.
        let trace = std::env::var("PIL2C_TRACE_LEAK").is_ok();
        let wl = &["opids","exprs_num","num_reps","mins","maxs","opids_count"];
        for name in to_unset {
            if trace && wl.contains(&name.as_str()) {
                eprintln!("[pil2c-trace] [cleanup-unset] name={} depth={}", name, self.scope.deep);
            }
            self.references.unset(name);
        }
        for (name, reference) in to_restore {
            if trace && wl.contains(&name.as_str()) {
                eprintln!("[pil2c-trace] [cleanup-restore] name={} depth={} scope_id={}", name, self.scope.deep, reference.scope_id);
            }
            self.references.restore(name, reference.clone());
        }
    }

    // -----------------------------------------------------------------------
    // Pragma handling
    // -----------------------------------------------------------------------

    fn exec_pragma(&mut self, value: &str) -> FlowSignal {
        let parts: Vec<&str> = value.split_whitespace().collect();
        let instr = parts.first().copied().unwrap_or("");

        match instr {
            "message" => {
                eprintln!("{}", &value[8..].trim());
            }
            "test" => {
                self.tests.active = true;
            }
            "fixed_tmp" => {
                self.pragmas_next_fixed.temporal = true;
            }
            "fixed_external" => {
                self.pragmas_next_fixed.external = true;
            }
            "feature" => {
                if let Some(feat_name) = parts.get(1) {
                    let enabled = self.config.defines.contains_key(*feat_name);
                    self.pragmas_next_statement.ignore = !enabled;
                }
            }
            "extern_fixed_file" => {
                // Mark the current AIR as having external fixed columns.
                // The fixed data is provided by a pre-generated binary file,
                // so we should NOT write a .fixed output file for this AIR.
                if let Some(air) = self.air_stack.last_mut() {
                    air.has_extern_fixed = true;
                }
                let file_arg = parts.get(1).copied().unwrap_or("");
                // Strip backtick/quote delimiters and expand templates.
                let trimmed = file_arg.trim();
                let inner = if (trimmed.starts_with('`') && trimmed.ends_with('`'))
                    || (trimmed.starts_with('"') && trimmed.ends_with('"'))
                    || (trimmed.starts_with('\'') && trimmed.ends_with('\''))
                {
                    &trimmed[1..trimmed.len()-1]
                } else {
                    trimmed
                };
                let expanded = self.expand_templates(inner);
                eprintln!("  > Loading extern fixed file {} ...", expanded);

                // Resolve file path: try as-is, then relative to the
                // current source file's directory (mirroring JS behavior).
                let resolved = {
                    let p = std::path::Path::new(&expanded);
                    if p.exists() {
                        expanded.clone()
                    } else if let Some(src) = self.include_stack.last()
                        .or(Some(&self.source_ref))
                    {
                        // Try relative to the directory of the current source
                        // file being compiled (the .pil file that contains the
                        // pragma).
                        let src_dir = std::path::Path::new(src).parent();
                        if let Some(dir) = src_dir {
                            let candidate = dir.join(&expanded);
                            if candidate.exists() {
                                candidate.to_string_lossy().to_string()
                            } else {
                                expanded.clone()
                            }
                        } else {
                            expanded.clone()
                        }
                    } else {
                        expanded.clone()
                    }
                };

                // Load the extern fixed file and store column data in the AIR.
                match fixed_cols::load_extern_fixed_file(&resolved) {
                    Ok(cols) => {
                        if let Some(air) = self.air_stack.last_mut() {
                            air.extern_fixed_cols.extend(cols);
                        }
                    }
                    Err(e) => {
                        eprintln!("warning: failed to load extern fixed file {}: {}", resolved, e);
                    }
                }
            }
            "transpile" => {
                // Transpile pragma optimizes inner loops. No-op for
                // correctness; only affects performance.
            }
            "output_fixed_file" => {
                // Set the output fixed file name for the current AIR.
                // In JS: Context.air.setOutputFixedFile(param)
                let file_arg = parts.get(1).copied().unwrap_or("");
                let trimmed = file_arg.trim();
                let inner = if (trimmed.starts_with('`') && trimmed.ends_with('`'))
                    || (trimmed.starts_with('"') && trimmed.ends_with('"'))
                    || (trimmed.starts_with('\'') && trimmed.ends_with('\''))
                {
                    &trimmed[1..trimmed.len()-1]
                } else {
                    trimmed
                };
                let expanded = if inner.is_empty() {
                    // Default: use air name
                    let air_name = self.air_stack.last()
                        .map(|a| a.name.clone())
                        .unwrap_or_default();
                    format!("{}.fixed", air_name)
                } else {
                    self.expand_templates(inner)
                };
                if let Some(air) = self.air_stack.last_mut() {
                    air.output_fixed_file = Some(expanded);
                }
            }
            "fixed_load" => {
                // Fixed load pragma: handled during fixed column declaration.
                // Parse: fixed_load <filename> [col_index]
                let file_arg = parts.get(1).copied().unwrap_or("");
                let trimmed = file_arg.trim();
                let inner = if (trimmed.starts_with('`') && trimmed.ends_with('`'))
                    || (trimmed.starts_with('"') && trimmed.ends_with('"'))
                    || (trimmed.starts_with('\'') && trimmed.ends_with('\''))
                {
                    &trimmed[1..trimmed.len()-1]
                } else {
                    trimmed
                };
                let expanded = self.expand_templates(inner);
                let col_idx = parts.get(2)
                    .and_then(|s| s.parse::<u32>().ok())
                    .unwrap_or(0);
                self.pragmas_next_fixed.load_from_file = Some((expanded, col_idx));
            }
            "debugger" | "debug" | "profile" | "exit" | "timer" | "memory" => {
                // Debug/profiling pragmas: no-op in the Rust compiler.
            }
            _ => {
                // Unknown pragmas are warnings, not errors (matching JS behavior).
                eprintln!("warning: unknown pragma '{}'", instr);
            }
        }
        FlowSignal::None
    }


    // -----------------------------------------------------------------------
    // Constraint handling
    // -----------------------------------------------------------------------

    fn exec_constraint(&mut self, c: &Constraint) -> FlowSignal {
        let left = self.eval_expr_to_runtime(&c.left);
        let right = self.eval_expr_to_runtime(&c.right);

        let scope_type = self.scope.get_instance_type().to_string();
        let is_global = scope_type == "proof";

        // Generate witness_calc hint for `<==` constraints (matching
        // JS behavior). JS pil2-compiler validates that `<==` LHS is
        // always a bare WitnessCol or AirValue (see
        // `processor.js::2018-2020`). The `reference` field of the
        // emitted `witness_calc` hint therefore resolves to a direct
        // column operand on the consumer side, NOT a wrapping
        // expression. If we stored the LHS via the air_expression_store
        // (ExprId) for every case, the bare-col case would serialize
        // through `Operand::Expression` and land as opType::tmp in the
        // chelpers binary, which the C++ `calculateExpr` guard at
        // `pil2-proofman/pil2-stark/src/starkpil/hints.cpp:499-511`
        // rejects (it only accepts cm or airvalue). We therefore emit
        // a dedicated `HintValue::ColRef` for the bare-leaf case and
        // fall back to the ExprId path for any non-leaf LHS.
        if c.is_witness && !is_global {
            if std::env::var_os("PIL2C_WITNESS_CALC_TRACE").is_some() {
                eprintln!(
                    "PIL2C_WITNESS_CALC_TRACE: left = {:?}",
                    left
                );
            }
            // Emit a witness_calc hint only when the LHS is a bare
            // WitnessCol or AirValue, matching JS
            // `pil2-compiler/src/processor.js:2018-2020`:
            //
            //     let alone = _left.getAlone();
            //     if (alone === false || !(alone instanceof
            //         ExpressionItems.WitnessCol ||
            //         alone instanceof ExpressionItems.AirValue)) {
            //         throw new Error(`Constraint with witness generation
            //             only could be used with witness or airval on
            //             the left side ${sourceTag}`);
            //     }
            //
            // Rust's evaluator currently produces `Value::Void` for
            // some LHS resolutions inside template expansions, e.g.
            // `loop_b0 <== _loop_b0` inside a conditional branch in
            // `precompiles/dma/pil/dma.pil`. JS would throw on those;
            // we silently skip the hint. Emitting a `witness_calc`
            // hint with a non-cm/non-airvalue destination crashes
            // `make prove` at the C++ guard
            // `pil2-proofman/pil2-stark/src/starkpil/hints.cpp`
            // calculateExpr / `pil2-stark/src/starkpil/hints.cu`
            // calculateExprGPU — the Round R1 failure this plan was
            // written to resolve. Skipping unresolved LHS aligns with
            // JS semantics (the constraint itself still lands through
            // `self.constraints.define(...)` below so the proof
            // obligation is not lost; only the prover-side witness
            // calculation hint is omitted).
            //
            // TODO(follow-up): fix the LHS resolution bug upstream so
            // `<==` inside conditional / template branches no longer
            // evaluates to Void, restore the witness_calc hint for
            // all sites, and track the fix under
            // AC-parity-or-audit (branch B).
            if let RuntimeExpr::ColRef { col_type, id, row_offset, origin_frame_id } = &left {
                if matches!(
                    col_type,
                    ColRefKind::Witness | ColRefKind::AirValue
                ) {
                    let reference_value = air::HintValue::ColRef {
                        col_type: *col_type,
                        id: *id,
                        row_offset: *row_offset,
                        origin_frame_id: *origin_frame_id,
                    };
                    let right_idx = self.air_expression_store.len() as u32;
                    self.air_expression_store.push(
                        air::AirExpressionEntry::anonymous(right.clone()),
                    );
                    let hint_data = air::HintValue::Object(vec![
                        ("reference".to_string(), reference_value),
                        (
                            "expression".to_string(),
                            air::HintValue::ExprId(right_idx),
                        ),
                    ]);
                    self.air_hints.push(air::HintEntry {
                        name: "witness_calc".to_string(),
                        data: hint_data,
                    });
                }
            }
        }

        if is_global {
            self.global_constraints
                .define(left, right, None, &self.source_ref);
        } else {
            self.constraints
                .define(left, right, None, &self.source_ref);
        }
        FlowSignal::None
    }

    // -----------------------------------------------------------------------
    // Control flow
    // -----------------------------------------------------------------------

    fn exec_if(&mut self, s: &IfStmt) -> FlowSignal {
        let cond = self.eval_expr(&s.condition);
        if cond.as_bool().unwrap_or(false) {
            let use_aliases_mark = self.references.snapshot_use_aliases();
            self.scope.push();
            let result = self.execute_statements(&s.then_body);
            let (to_unset, to_restore) = self.scope.pop();
            self.apply_scope_cleanup(&to_unset, &to_restore);
            self.references.restore_use_aliases_len(use_aliases_mark);
            return result;
        }

        for elseif in &s.elseif_clauses {
            let cond = self.eval_expr(&elseif.condition);
            if cond.as_bool().unwrap_or(false) {
                let use_aliases_mark = self.references.snapshot_use_aliases();
                self.scope.push();
                let result = self.execute_statements(&elseif.body);
                let (to_unset, to_restore) = self.scope.pop();
                self.apply_scope_cleanup(&to_unset, &to_restore);
                self.references.restore_use_aliases_len(use_aliases_mark);
                return result;
            }
        }

        if let Some(else_body) = &s.else_body {
            let use_aliases_mark = self.references.snapshot_use_aliases();
            self.scope.push();
            let result = self.execute_statements(else_body);
            let (to_unset, to_restore) = self.scope.pop();
            self.apply_scope_cleanup(&to_unset, &to_restore);
            self.references.restore_use_aliases_len(use_aliases_mark);
            return result;
        }

        FlowSignal::None
    }

    fn exec_for(&mut self, s: &ForStmt) -> FlowSignal {
        let use_aliases_mark = self.references.snapshot_use_aliases();
        self.scope.push();
        self.execute_statement(&s.init);

        let mut loop_count: u64 = 0;
        let loop_start = Instant::now();
        loop {
            let cond = self.eval_expr(&s.condition);
            if !cond.as_bool().unwrap_or(false) {
                break;
            }

            // Progress indicator for long-running loops (only shown
            // after 5 seconds to avoid noise on fast loops).
            loop_count += 1;
            if loop_count & 0xFFFFF == 0 {
                let elapsed = loop_start.elapsed().as_secs_f64();
                if elapsed >= 5.0 {
                    eprintln!(
                        "  > loop progress: {} iterations ({:.1}s)",
                        loop_count, elapsed
                    );
                }
            }

            let result = self.execute_statements(&s.body);
            match result {
                FlowSignal::Break => break,
                FlowSignal::Return(v) => {
                    let (to_unset, to_restore) = self.scope.pop();
                    self.apply_scope_cleanup(&to_unset, &to_restore);
                    self.references.restore_use_aliases_len(use_aliases_mark);
                    return FlowSignal::Return(v);
                }
                FlowSignal::Continue | FlowSignal::None => {}
            }

            // Execute increment.
            for incr in &s.increment {
                self.exec_assignment(incr);
            }
        }

        let (to_unset, to_restore) = self.scope.pop();
        self.apply_scope_cleanup(&to_unset, &to_restore);
        self.references.restore_use_aliases_len(use_aliases_mark);
        FlowSignal::None
    }

    fn exec_while(&mut self, s: &WhileStmt) -> FlowSignal {
        loop {
            let use_aliases_mark = self.references.snapshot_use_aliases();
            self.scope.push();
            let cond = self.eval_expr(&s.condition);
            if !cond.as_bool().unwrap_or(false) {
                let (to_unset, to_restore) = self.scope.pop();
                self.apply_scope_cleanup(&to_unset, &to_restore);
                self.references.restore_use_aliases_len(use_aliases_mark);
                break;
            }
            let result = self.execute_statements(&s.body);
            let (to_unset, to_restore) = self.scope.pop();
            self.apply_scope_cleanup(&to_unset, &to_restore);
            self.references.restore_use_aliases_len(use_aliases_mark);
            match result {
                FlowSignal::Break => break,
                FlowSignal::Return(v) => return FlowSignal::Return(v),
                FlowSignal::Continue | FlowSignal::None => {}
            }
        }
        FlowSignal::None
    }

    fn exec_switch(&mut self, s: &SwitchStmt) -> FlowSignal {
        let switch_val = self.eval_expr(&s.value);
        let switch_int = switch_val.as_int();

        for case_clause in &s.cases {
            let mut matched = false;
            for case_val in &case_clause.values {
                match case_val {
                    CaseValue::Single(expr) => {
                        let cv = self.eval_expr(expr);
                        if cv.as_int() == switch_int {
                            matched = true;
                            break;
                        }
                    }
                    CaseValue::Range(from_expr, to_expr) => {
                        let from = self.eval_expr(from_expr).as_int().unwrap_or(0);
                        let to = self.eval_expr(to_expr).as_int().unwrap_or(0);
                        if let Some(sv) = switch_int {
                            if sv >= from && sv <= to {
                                matched = true;
                                break;
                            }
                        }
                    }
                }
            }
            if matched {
                let use_aliases_mark = self.references.snapshot_use_aliases();
                self.scope.push();
                let result = self.execute_statements(&case_clause.body);
                let (to_unset, to_restore) = self.scope.pop();
                self.apply_scope_cleanup(&to_unset, &to_restore);
                self.references.restore_use_aliases_len(use_aliases_mark);
                return result;
            }
        }

        // Default case.
        if let Some(default_body) = &s.default {
            let use_aliases_mark = self.references.snapshot_use_aliases();
            self.scope.push();
            let result = self.execute_statements(default_body);
            let (to_unset, to_restore) = self.scope.pop();
            self.apply_scope_cleanup(&to_unset, &to_restore);
            self.references.restore_use_aliases_len(use_aliases_mark);
            return result;
        }

        FlowSignal::None
    }

    fn exec_return(&mut self, s: &ReturnStmt) -> FlowSignal {
        if self.function_deep == 0 {
            eprintln!("error: return outside function scope");
            return FlowSignal::None;
        }
        let value = s
            .value
            .as_ref()
            .map(|e| self.eval_expr(e))
            .unwrap_or(Value::Void);
        FlowSignal::Return(value)
    }

    // -----------------------------------------------------------------------
    // Expression evaluation
    // -----------------------------------------------------------------------

    /// Evaluate an AST expression to a compile-time Value.
    pub fn eval_expr(&mut self, expr: &Expr) -> Value {
        match expr {
            Expr::Number(lit) => Value::Int(parse_numeric_literal(lit)),
            Expr::StringLit(sl) => Value::Str(sl.value.clone()),
            Expr::TemplateString(ts) => {
                // Template string expansion.
                Value::Str(self.expand_templates(ts))
            }
            Expr::Reference(name_id) => self.eval_reference(name_id),
            Expr::BinaryOp { op, left, right } => {
                let lval = self.eval_expr(left);
                let rval = self.eval_expr(right);
                match (lval.as_int(), rval.as_int()) {
                    (Some(l), Some(r)) => eval_binop_int(op, l, r),
                    _ => {
                        // String concatenation for Add.
                        if matches!(op, BinOp::Add) {
                            if let (Value::Str(ls), Value::Str(rs)) = (&lval, &rval) {
                                return Value::Str(format!("{}{}", ls, rs));
                            }
                        }
                        // If either operand is a column reference or a
                        // runtime expression, build a RuntimeExpr tree
                        // so that constraint expressions can be serialized
                        // to protobuf with column references intact.
                        if is_symbolic(&lval) || is_symbolic(&rval) {
                            // Identity simplifications at tree-construction
                            // time, matching JS expression-builder behavior:
                            //
                            //   Add(x, 0) -> x          Add(0, x) -> x
                            //   Sub(x, 0) -> x
                            //   Mul(x, 1) -> x          Mul(1, x) -> x
                            //
                            // JS folds these before emission; not folding
                            // them in Rust produces extra packed expression
                            // slots (a Mul node wrapping the symbolic
                            // operand with 1) that diverge from JS output.
                            // Only literal Int(0)/Int(1)/Fe(0)/Fe(1) count
                            // as the identity operand; runtime-expression
                            // constants are NOT folded here.
                            match op {
                                BinOp::Add => {
                                    if is_literal_zero(&rval) { return lval; }
                                    if is_literal_zero(&lval) { return rval; }
                                }
                                BinOp::Sub => {
                                    if is_literal_zero(&rval) { return lval; }
                                }
                                BinOp::Mul => {
                                    if is_literal_one(&rval) { return lval; }
                                    if is_literal_one(&lval) { return rval; }
                                }
                                _ => {}
                            }
                            let rt_op = match op {
                                BinOp::Add => RuntimeOp::Add,
                                BinOp::Sub => RuntimeOp::Sub,
                                BinOp::Mul => RuntimeOp::Mul,
                                _ => return Value::Void,
                            };
                            let left_rc = value_to_rc_runtime_expr(&lval);
                            let right_rc = value_to_rc_runtime_expr(&rval);
                            return Value::RuntimeExpr(Rc::new(RuntimeExpr::BinOp {
                                op: rt_op,
                                left: left_rc,
                                right: right_rc,
                            }));
                        }
                        Value::Void
                    }
                }
            }
            Expr::UnaryOp { op, operand } => {
                let val = self.eval_expr(operand);
                if let Some(v) = val.as_int() {
                    eval_unaryop_int(op, v)
                } else if is_symbolic(&val) && matches!(op, UnaryOp::Neg) {
                    let operand_rc = value_to_rc_runtime_expr(&val);
                    Value::RuntimeExpr(Rc::new(RuntimeExpr::UnaryOp {
                        op: RuntimeUnaryOp::Neg,
                        operand: operand_rc,
                    }))
                } else {
                    Value::Void
                }
            }
            Expr::Ternary {
                condition,
                then_expr,
                else_expr,
            } => {
                let cond = self.eval_expr(condition);
                if cond.as_bool().unwrap_or(false) {
                    self.eval_expr(then_expr)
                } else {
                    self.eval_expr(else_expr)
                }
            }
            Expr::FunctionCall(fc) => self.eval_function_call(fc),
            Expr::ArrayIndex { base, index } => {
                // Try to resolve Reference/MemberAccess+ArrayIndex chains as
                // a single reference lookup with array indexing.  In
                // expression context, the parser produces ArrayIndex nodes
                // wrapping a bare Reference (or MemberAccess) that has no
                // index info.  Without this, evaluating the inner node
                // returns only the scalar at the base ID, and the
                // surrounding ArrayIndex falls through to Void.
                if let Some(val) = self.try_resolve_indexed_reference(expr) {
                    return val;
                }
                let base_val = self.eval_expr(base);
                let idx_val = self.eval_expr(index);
                match (&base_val, idx_val.as_int()) {
                    (Value::Array(items), Some(i)) => {
                        let idx = i as usize;
                        items.get(idx).cloned().unwrap_or(Value::Void)
                    }
                    (Value::ColRef { col_type, id, .. }, Some(i)) => {
                        match col_type {
                            ColRefKind::Fixed => {
                                // Row-level read: FIXED_COL[row] during
                                // fixed-column generation.
                                if let Some(v) = self.fixed_cols.get_row_value(*id, i as usize) {
                                    Value::Int(v)
                                } else {
                                    Value::Int(0)
                                }
                            }
                            _ => {
                                // For witness/other column arrays, offset the
                                // base id to obtain the indexed sub-column.
                                // Round 6: carry origin_frame_id so
                                // cross-AIR refs on AIR-local column
                                // arrays (Witness / Fixed / AirValue /
                                // Custom) stay detectable at the lift
                                // filter and serializer. See
                                // BL-20260419-origin-authoritative-serializer.
                                let origin_frame_id = match col_type {
                                    ColRefKind::Witness
                                    | ColRefKind::Fixed
                                    | ColRefKind::AirValue
                                    | ColRefKind::Custom => {
                                        self.maybe_air_origin_frame_id()
                                    }
                                    _ => None,
                                };
                                Value::ColRef {
                                    col_type: *col_type,
                                    id: id + i as u32,
                                    row_offset: None,
                                    origin_frame_id,
                                }
                            }
                        }
                    }
                    (Value::ArrayRef { ref_type, base_id, dims }, Some(i)) => {
                        self.resolve_partial_array(
                            ref_type,
                            *base_id,
                            dims,
                            &[i],
                        )
                    }
                    _ => Value::Void,
                }
            }
            Expr::ArrayLiteral(items) => {
                let mut values: Vec<Value> = Vec::new();
                for item in items {
                    if let Expr::Spread(inner) = item {
                        // Evaluate the inner expression and expand it.
                        let inner_val = self.eval_expr(inner);
                        match inner_val {
                            Value::Array(arr) => {
                                values.extend(arr);
                            }
                            Value::ArrayRef { ref_type, base_id, dims } => {
                                // Expand the first dimension of the array reference.
                                if let Some(&dim0) = dims.first() {
                                    let remaining = dims[1..].to_vec();
                                    for i in 0..dim0 {
                                        let elem_id = base_id + if remaining.is_empty() {
                                            i
                                        } else {
                                            i * remaining.iter().product::<u32>()
                                        };
                                        if remaining.is_empty() {
                                            values.push(self.get_var_value_by_type_and_id(
                                                &ref_type, elem_id,
                                            ));
                                        } else {
                                            values.push(Value::ArrayRef {
                                                ref_type: ref_type.clone(),
                                                base_id: elem_id,
                                                dims: remaining.clone(),
                                            });
                                        }
                                    }
                                }
                            }
                            _ => values.push(inner_val),
                        }
                    } else {
                        values.push(self.eval_expr(item));
                    }
                }
                Value::Array(values)
            }
            Expr::Cast {
                cast_type, value, ..
            } => {
                let val = self.eval_expr(value);
                match cast_type.as_str() {
                    "int" => {
                        let v = val.as_int().unwrap_or(0);
                        Value::Int(v)
                    }
                    "fe" => {
                        let v = val.as_int().unwrap_or(0);
                        Value::Fe(v as u64)
                    }
                    "string" => Value::Str(self.value_to_label_string(&val)),
                    "expr" => val,
                    _ => val,
                }
            }
            Expr::RowOffset { base, offset, prior } => {
                // Row offset creates a column reference with offset. Prefix form
                // (`'col`, `2'col`) sets `prior = true`, which negates the offset
                // to match the JS convention where prior rows have negative offsets
                // (see pil2-compiler/src/expression_items/row_offset.js getValue).
                let base_val = self.eval_expr(base);
                let mut offset_val = self
                    .eval_expr(offset)
                    .as_int()
                    .unwrap_or(1);
                if *prior {
                    offset_val = -offset_val;
                }
                match base_val {
                    Value::ColRef {
                        col_type, id, origin_frame_id, ..
                    } => Value::ColRef {
                        col_type,
                        id,
                        row_offset: Some(offset_val as i64),
                        origin_frame_id,
                    },
                    _ => base_val,
                }
            }
            Expr::MemberAccess { base, member } => {
                // Member access: a.b -- build dotted name for reference lookup.
                // This supports container-scoped references like `air.__L1__`
                // and `air.std.connect`.
                let dotted = self.build_dotted_name(base, member);
                if let Some(dotted_name) = dotted {
                    // Try reference lookup with the dotted name.
                    let reference_opt = self.references.get_reference(&dotted_name).cloned().or_else(|| {
                        let names = self.namespace_ctx.get_names(&dotted_name);
                        self.references.get_reference_multi(&names).cloned()
                    });
                    if let Some(reference) = reference_opt {
                        // If the reference is an array, return an ArrayRef
                        // so that subsequent ArrayIndex operations can
                        // resolve individual elements.
                        if !reference.array_dims.is_empty() {
                            return Value::ArrayRef {
                                ref_type: reference.ref_type.clone(),
                                base_id: reference.id,
                                dims: reference.array_dims.clone(),
                            };
                        }
                        return self.get_var_value(&reference);
                    }
                    // If it's a container name (not a reference), return a
                    // sentinel so that `defined(container_name)` returns true.
                    if self.references.is_container_defined(&dotted_name) {
                        return Value::Int(1);
                    }
                }
                Value::Void
            }
            Expr::Sequence(_seq) => {
                // Sequence expressions are typically used in fixed column init.
                Value::Void
            }
            Expr::Spread(_) | Expr::PositionalParam(_) => Value::Void,
        }
    }


    // -----------------------------------------------------------------------
    // Sequence resolution
    // -----------------------------------------------------------------------

    /// Pre-resolve all expressions in a sequence definition by evaluating them
    /// through the processor (which can resolve named constants like `OP_MINU`,
    /// `P2_8`, etc.).  The resolved sequence uses only numeric literals so that
    /// the standalone `evaluate_sequence` can process it.
    fn resolve_sequence(&mut self, seq: &SequenceDef) -> SequenceDef {
        SequenceDef {
            elements: seq.elements.iter().map(|e| self.resolve_seq_element(e)).collect(),
            is_padded: seq.is_padded,
        }
    }

    fn resolve_seq_element(&mut self, elem: &SequenceElement) -> SequenceElement {
        match elem {
            SequenceElement::Value(expr) => {
                SequenceElement::Value(self.resolve_seq_expr(expr))
            }
            SequenceElement::Repeat { value, times } => SequenceElement::Repeat {
                value: self.resolve_seq_expr(value),
                times: self.resolve_seq_expr(times),
            },
            SequenceElement::Range { from, to, from_times, to_times } => SequenceElement::Range {
                from: self.resolve_seq_expr(from),
                to: self.resolve_seq_expr(to),
                from_times: from_times.as_ref().map(|e| self.resolve_seq_expr(e)),
                to_times: to_times.as_ref().map(|e| self.resolve_seq_expr(e)),
            },
            SequenceElement::Padding(inner) => {
                SequenceElement::Padding(Box::new(self.resolve_seq_element(inner)))
            }
            SequenceElement::SubSeq(elements) => {
                SequenceElement::SubSeq(
                    elements.iter().map(|e| self.resolve_seq_element(e)).collect(),
                )
            }
            SequenceElement::ArithSeq { t1, t2, tn } => SequenceElement::ArithSeq {
                t1: Box::new(self.resolve_seq_element(t1)),
                t2: Box::new(self.resolve_seq_element(t2)),
                tn: tn.as_ref().map(|e| Box::new(self.resolve_seq_element(e))),
            },
            SequenceElement::GeomSeq { t1, t2, tn } => SequenceElement::GeomSeq {
                t1: Box::new(self.resolve_seq_element(t1)),
                t2: Box::new(self.resolve_seq_element(t2)),
                tn: tn.as_ref().map(|e| Box::new(self.resolve_seq_element(e))),
            },
        }
    }

    /// Resolve a single expression to a numeric literal if possible, falling
    /// back to the original expression if evaluation fails.
    fn resolve_seq_expr(&mut self, expr: &Expr) -> Expr {
        if let Some(v) = self.eval_expr(expr).as_int() {
            Expr::Number(NumericLiteral {
                value: v.to_string(),
                radix: NumericRadix::Decimal,
            })
        } else {
            expr.clone()
        }
    }


    // -----------------------------------------------------------------------
    // Function definitions
    // -----------------------------------------------------------------------

    fn exec_function_definition(&mut self, fd: &FunctionDef) -> FlowSignal {
        let mut name = fd.name.clone();
        // If inside an air, prefix with air name.
        if let Some(air) = self.air_stack.last() {
            name = format!("{}.{}", air.name, name);
        }
        self.functions.insert(name.clone(), fd.clone());

        // Register the function in the reference table.
        let id = self.ints.reserve(1, None, &[], IdData::default());
        self.references.declare(
            &name,
            RefType::Function,
            id,
            &[],
            true,
            self.scope.deep,
            &self.source_ref,
        );
        FlowSignal::None
    }

    // -----------------------------------------------------------------------
    // Airgroup / airtemplate
    // -----------------------------------------------------------------------

    fn exec_air_group(&mut self, ag: &AirGroupDef) -> FlowSignal {
        let name = &ag.name;
        self.air_groups.get_or_create(name);
        self.open_air_group(name);
        let use_aliases_mark = self.references.snapshot_use_aliases();
        self.execute_statements(&ag.statements);
        self.references.restore_use_aliases_len(use_aliases_mark);
        self.suspend_current_air_group();
        FlowSignal::None
    }

    fn open_air_group(&mut self, name: &str) {
        self.air_group_stack.push(self.current_air_group.clone());
        self.current_air_group = Some(name.to_string());
        self.scope.push_instance_type("airgroup");
        self.namespace_ctx.push(name);
        self.namespace_ctx.air_group_name = name.to_string();

        // Assign airgroup ID if not yet assigned.
        let ag = self.air_groups.get_or_create(name);
        if ag.get_id().is_none() {
            self.last_air_group_id += 1;
            ag.set_id(self.last_air_group_id as u32);
        }

        // Update built-in constants.
        self.set_builtin_string("AIRGROUP", name);
        let ag_id = self
            .air_groups
            .get(name)
            .and_then(|g| g.get_id())
            .unwrap_or(0) as i128;
        self.set_builtin_int("AIRGROUP_ID", ag_id);
    }

    fn suspend_current_air_group(&mut self) {
        // Apply scope cleanup for any variables declared at the airgroup-type scope
        // depth. Previously ignored, which allowed stale bindings to persist.
        let (ag_unset, ag_restore) = self.scope.pop_instance_type();
        self.apply_scope_cleanup(&ag_unset, &ag_restore);
        self.namespace_ctx.pop();
        self.current_air_group = self.air_group_stack.pop().flatten();
        let ag_name = self
            .current_air_group
            .clone()
            .unwrap_or_default();
        self.namespace_ctx.air_group_name = ag_name.clone();
        self.set_builtin_string("AIRGROUP", &ag_name);
        let ag_id = self
            .air_groups
            .get(&ag_name)
            .and_then(|g| g.get_id())
            .map(|id| id as i128)
            .unwrap_or(-1);
        self.set_builtin_int("AIRGROUP_ID", ag_id);
    }

    fn exec_air_template_definition(&mut self, at: &AirTemplateDef) -> FlowSignal {
        let name = &at.name;
        let info = AirTemplateInfo::new(name, at.args.clone(), at.statements.clone());
        if let Err(msg) = self.air_templates.define(name, info) {
            eprintln!("error: {} at {}", msg, self.source_ref);
        }

        // Register as a callable function reference.
        let id = self.ints.reserve(1, None, &[], IdData::default());
        self.references.declare(
            name,
            RefType::Function,
            id,
            &[],
            true,
            self.scope.deep,
            &self.source_ref,
        );
        FlowSignal::None
    }


    // -----------------------------------------------------------------------
    // Include / require
    // -----------------------------------------------------------------------

    fn exec_include(&mut self, _inc: &IncludeStmt) -> FlowSignal {
        // All include/require directives are expanded by IncludeResolver
        // in lib.rs before the AST reaches the processor. This is a no-op
        // safety fallback; no Include nodes should arrive here.
        FlowSignal::None
    }

    // -----------------------------------------------------------------------
    // Container / Use / Package
    // -----------------------------------------------------------------------

    fn exec_container(&mut self, cd: &ContainerDef) -> FlowSignal {
        let name = self.expand_templates(&cd.name);
        let alias = cd.alias.as_deref();
        // JS skips the body entirely when a container already exists
        // (containers.js createContainer returns false, processor.js returns).
        // Snapshot the alias stack AFTER create_container so the
        // container's own alias (added by create_container) persists
        // in the caller's scope, but any aliases added inside the
        // body (via nested `use` or nested containers) are truncated
        // on exit. Matches JS pil2-compiler's container-body
        // lifetime for `use` statements.
        if !self.references.create_container(&name, alias) {
            return FlowSignal::None;
        }
        let use_aliases_mark = self.references.snapshot_use_aliases();
        if let Some(body) = &cd.body {
            self.execute_statements(body);
        }
        self.references.close_container();
        self.references.restore_use_aliases_len(use_aliases_mark);
        FlowSignal::None
    }

    fn exec_use(&mut self, ud: &UseDef) -> FlowSignal {
        let name = self.expand_templates(&ud.name);
        let alias = ud.alias.as_deref();
        self.references.add_use(&name, alias);
        FlowSignal::None
    }

    fn exec_package_block(&mut self, pd: &PackageDef) -> FlowSignal {
        // Snapshot alias stack so any `use` inside the package body
        // is lexical to the package. JS pil2-compiler treats
        // `package ... { ... }` as its own alias scope; without this,
        // nested `use` statements leak out to sibling packages.
        let use_aliases_mark = self.references.snapshot_use_aliases();
        self.scope.push();
        self.scope
            .set_value("package", Value::Str(pd.name.clone()));
        let result = self.execute_statements(&pd.body);
        let (to_unset, to_restore) = self.scope.pop();
        self.apply_scope_cleanup(&to_unset, &to_restore);
        self.references.restore_use_aliases_len(use_aliases_mark);
        result
    }

    // -----------------------------------------------------------------------
    // Deferred function calls
    // -----------------------------------------------------------------------

    fn exec_deferred_function_call(&mut self, dc: &DeferredCall) -> FlowSignal {
        let scope = &dc.scope;
        let fname = dc.function.path.clone();
        let event = dc.event.clone();
        let priority_val = dc
            .priority
            .as_ref()
            .and_then(|e| self.eval_expr(e).as_int().map(|v| v as i64));
        let src_ref = self.source_ref.clone();

        let qualified_scope = self.get_deferred_scope(scope);

        let scope_entry = self
            .deferred_calls
            .entry(qualified_scope)
            .or_default();
        let event_entry = scope_entry.entry(event).or_default();

        // Check if already registered.
        if !event_entry.iter().any(|d| d.function_name == fname) {
            event_entry.push(DeferredCallInfo {
                function_name: fname,
                priority: priority_val,
                source_refs: vec![src_ref],
            });
        }
        FlowSignal::None
    }

    /// Map a deferred call scope to its qualified key, mirroring the JS
    /// `getDeferredScope`.  For "airgroup" scopes, the key includes the
    /// current airgroup ID so that each airgroup has its own call list.
    fn get_deferred_scope(&self, scope: &str) -> String {
        if scope == "airgroup" {
            let ag_id = self.current_air_group.as_ref()
                .and_then(|name| self.air_groups.get(name))
                .and_then(|ag| ag.get_id());
            match ag_id {
                Some(id) => format!("airgroup#{}", id),
                None => "airgroup#".to_string(),
            }
        } else {
            scope.to_string()
        }
    }

    fn call_deferred_functions(&mut self, scope: &str, event: &str) {
        let key = self.get_deferred_scope(scope);
        self.call_deferred_functions_by_key(&key, event);
    }

    fn call_deferred_functions_by_key(&mut self, key: &str, event: &str) {
        // Support reentrant deferred calls: loop until no new calls are added.
        let mut processed = std::collections::HashSet::new();
        loop {
            let calls = match self.deferred_calls.get(key) {
                Some(scope_map) => match scope_map.get(event) {
                    Some(calls) => {
                        let mut sorted: Vec<DeferredCallInfo> = calls.clone();
                        // Sort by priority descending (higher priority first).
                        sorted.sort_by(|a, b| {
                            let pa = a.priority.unwrap_or(0);
                            let pb = b.priority.unwrap_or(0);
                            pb.cmp(&pa)
                        });
                        sorted
                    }
                    None => break,
                },
                None => break,
            };

            let mut executed_something = false;
            for call in &calls {
                if processed.contains(&call.function_name) {
                    continue;
                }
                executed_something = true;
                processed.insert(call.function_name.clone());
                if let Some(func) = self.functions.get(&call.function_name).cloned() {
                    self.execute_user_function_by_name(&func, &[], &call.function_name);
                }
                // Break after each execution for reentrant behavior.
                break;
            }
            if !executed_something {
                break;
            }
        }
        // Clear after execution.
        if let Some(scope_map) = self.deferred_calls.get_mut(key) {
            scope_map.remove(event);
        }
    }

    fn final_closing_air_groups(&mut self) {
        // First, call any deferred airgroup calls registered under the
        // current (if any) airgroup scope.
        self.call_deferred_functions("airgroup", "final");

        // Then iterate all airgroups, open each, execute their deferred
        // calls, and close (mirroring the JS finalClosingAirGroups).
        let mut closed_ids: Vec<u32> = Vec::new();
        let mut new_groups = true;
        while new_groups {
            new_groups = false;
            let ag_names: Vec<String> = self.air_groups.iter()
                .filter_map(|ag| {
                    let id = ag.get_id()?;
                    if closed_ids.contains(&id) { None } else { Some(ag.name.clone()) }
                })
                .collect();
            for ag_name in ag_names {
                let ag_id = self.air_groups.get(&ag_name)
                    .and_then(|ag| ag.get_id());
                if let Some(id) = ag_id {
                    new_groups = true;
                    closed_ids.push(id);
                    self.open_air_group(&ag_name.clone());
                    // Execute airgroup-scoped deferred calls for this group.
                    let key = format!("airgroup#{}", id);
                    self.call_deferred_functions_by_key(&key, "final");
                    self.suspend_current_air_group();
                }
            }
        }
    }

    fn final_proof_scope(&mut self) {
        self.call_deferred_functions("proof", "final");
    }


    // -----------------------------------------------------------------------
    // Extern fixed column loading
    // -----------------------------------------------------------------------

    /// Try to load fixed column data from the current AIR's extern fixed
    /// files. Returns true if data was loaded for at least one element.
    ///
    /// For scalar columns (array_dims empty), looks up `full_name` in the
    /// extern file and loads data at `base_id`.
    ///
    /// For array columns, looks up `full_name` with matching dimension
    /// indexes and loads each element at the corresponding offset from
    /// `base_id`.
    fn try_load_extern_fixed_col(
        &mut self,
        full_name: &str,
        base_id: u32,
        array_dims: &[u32],
    ) -> bool {
        // Collect extern fixed column data from the current AIR.
        // Clone to avoid borrow issues.
        let extern_cols: Vec<fixed_cols::ExternFixedCol> = self.air_stack.last()
            .map(|air| air.extern_fixed_cols.iter().map(|c| {
                fixed_cols::ExternFixedCol {
                    name: c.name.clone(),
                    indexes: c.indexes.clone(),
                    values: c.values.clone(),
                }
            }).collect())
            .unwrap_or_default();

        if extern_cols.is_empty() {
            return false;
        }

        let mut loaded = false;

        if array_dims.is_empty() {
            // Scalar column: look for exact name match with no indexes.
            for col in &extern_cols {
                if col.name == full_name && col.indexes.is_empty() {
                    self.fixed_cols.set_row_data(base_id, col.values.clone());
                    loaded = true;
                    break;
                }
            }
        } else {
            // Array column: iterate over all matching extern cols with the
            // same base name and compute the flat offset from their indexes.
            for col in &extern_cols {
                if col.name != full_name || col.indexes.is_empty() {
                    continue;
                }
                if col.indexes.len() != array_dims.len() {
                    continue;
                }
                // Compute flat index from the indexes and dims.
                let mut flat = 0u32;
                let mut valid = true;
                for (i, &idx) in col.indexes.iter().enumerate() {
                    if idx >= array_dims[i] {
                        valid = false;
                        break;
                    }
                    let stride: u32 = array_dims[i+1..].iter().product();
                    flat += idx * stride;
                }
                if !valid {
                    continue;
                }
                let target_id = base_id + flat;
                self.fixed_cols.set_row_data(target_id, col.values.clone());
                loaded = true;
            }
        }

        loaded
    }

    // -----------------------------------------------------------------------
    // Tables.* built-in functions for fixed column manipulation
    // -----------------------------------------------------------------------

    /// Extract the fixed column ID from a Value (ColRef or RuntimeExpr wrapping
    /// a ColRef). Returns None if the value is not a fixed column reference.
    fn extract_fixed_col_id(val: &Value) -> Option<u32> {
        use expression::ColRefKind;
        match val {
            Value::ColRef { col_type: ColRefKind::Fixed, id, .. } => Some(*id),
            Value::RuntimeExpr(expr) => {
                use expression::RuntimeExpr;
                match expr.as_ref() {
                    RuntimeExpr::ColRef { col_type: ColRefKind::Fixed, id, .. } => Some(*id),
                    _ => None,
                }
            }
            _ => None,
        }
    }

    /// Tables.num_rows(col): returns the number of rows written to a fixed column.
    fn tables_num_rows(&self, args: &[Value]) -> Value {
        if args.len() != 1 {
            eprintln!("error: Tables.num_rows: expected 1 argument at {}", self.source_ref);
            return Value::Void;
        }
        if let Some(col_id) = Self::extract_fixed_col_id(&args[0]) {
            let count = self.fixed_cols.get_row_data(col_id)
                .map(|d| d.len() as i128)
                .unwrap_or(0);
            Value::Int(count)
        } else {
            eprintln!("error: Tables.num_rows: argument must be a fixed column at {}", self.source_ref);
            Value::Void
        }
    }

    /// Tables.fill(value, dst, offset, count): fills a fixed column with a constant value.
    fn tables_fill(&mut self, args: &[Value]) -> Value {
        if args.len() != 4 {
            eprintln!("error: Tables.fill: expected 4 arguments at {}", self.source_ref);
            return Value::Void;
        }
        let fill_value = match args[0].as_int() {
            Some(v) => v,
            None => {
                eprintln!("error: Tables.fill: value must be integer at {}", self.source_ref);
                return Value::Void;
            }
        };
        let col_id = match Self::extract_fixed_col_id(&args[1]) {
            Some(id) => id,
            None => {
                eprintln!("error: Tables.fill: dst must be a fixed column at {}", self.source_ref);
                return Value::Void;
            }
        };
        let offset = args[2].as_int().unwrap_or(0) as usize;
        let count = args[3].as_int().unwrap_or(0) as usize;

        for i in 0..count {
            self.fixed_cols.set_row_value(col_id, offset + i, fill_value);
        }
        Value::Int(count as i128)
    }

    /// Tables.copy(src, src_offset, dst, dst_offset, count): copies rows between fixed columns.
    fn tables_copy(&mut self, args: &[Value]) -> Value {
        if args.len() < 4 || args.len() > 5 {
            eprintln!("error: Tables.copy: expected 4-5 arguments at {}", self.source_ref);
            return Value::Void;
        }
        let src_id = match Self::extract_fixed_col_id(&args[0]) {
            Some(id) => id,
            None => {
                eprintln!("error: Tables.copy: src must be a fixed column at {}", self.source_ref);
                return Value::Void;
            }
        };
        let src_offset = args[1].as_int().unwrap_or(0) as usize;
        let dst_id = match Self::extract_fixed_col_id(&args[2]) {
            Some(id) => id,
            None => {
                eprintln!("error: Tables.copy: dst must be a fixed column at {}", self.source_ref);
                return Value::Void;
            }
        };
        let dst_offset = args[3].as_int().unwrap_or(0) as usize;
        let count = if args.len() > 4 {
            args[4].as_int().unwrap_or(0) as usize
        } else {
            // Default: copy all remaining source rows
            self.fixed_cols.get_row_data(src_id)
                .map(|d| d.len().saturating_sub(src_offset))
                .unwrap_or(0)
        };

        // Read source data first to avoid borrow issues.
        let src_values: Vec<i128> = (0..count)
            .map(|i| {
                self.fixed_cols.get_row_value(src_id, src_offset + i).unwrap_or(0)
            })
            .collect();

        // Write to destination.
        for (i, val) in src_values.into_iter().enumerate() {
            self.fixed_cols.set_row_value(dst_id, dst_offset + i, val);
        }
        Value::Int(count as i128)
    }

    // -----------------------------------------------------------------------
    // Helper methods
    // -----------------------------------------------------------------------

    /// Set a built-in int constant by name.
    fn set_builtin_int(&mut self, name: &str, value: i128) {
        if let Some(reference) = self.references.get_reference(name).cloned() {
            self.ints.set(reference.id, Value::Int(value));
        }
    }

    /// Set a built-in string constant by name.
    fn set_builtin_string(&mut self, name: &str, value: &str) {
        if let Some(reference) = self.references.get_reference(name).cloned() {
            self.strings.set(reference.id, Value::Str(value.to_string()));
        }
    }

    /// Expand template strings (e.g. `${N}` inside backtick strings).
    ///
    /// Supports both simple references (`${NAME}`) and arbitrary
    /// expressions (`${log2(N)}`, `${a + b}`).  Simple references
    /// are resolved via the reference table first (fast path); if
    /// that fails, the expression inside `${}` is parsed and evaluated.
    fn expand_templates(&mut self, text: &str) -> String {
        use std::sync::OnceLock;
        static RE: OnceLock<regex::Regex> = OnceLock::new();

        if !text.contains("${") {
            return text.to_string();
        }

        let re = RE.get_or_init(|| regex::Regex::new(r"\$\{([^}]*)\}").unwrap());

        // Collect all matches first to avoid borrow issues.
        let matches: Vec<(String, String)> = re
            .captures_iter(text)
            .map(|cap| (cap[0].to_string(), cap[1].to_string()))
            .collect();

        let mut result = text.to_string();
        for (full_match, expr_str) in matches {
            // Fast path: try as a simple reference name.
            let value = self
                .references
                .get_reference(&expr_str)
                .and_then(|r| match r.ref_type {
                    RefType::Int => self.ints.get(r.id).map(|v| v.to_display_string()),
                    RefType::Str => self.strings.get(r.id).map(|v| v.to_display_string()),
                    _ => None,
                });

            let replacement = if let Some(v) = value {
                v
            } else {
                // Fall back to parsing and evaluating as an expression.
                // Wrap in a dummy program to satisfy the parser.
                let dummy_src = format!("int _tmpl_ = {};", expr_str);
                match crate::parser::parse(&dummy_src) {
                    Ok(prog) => {
                        // Extract the initializer expression from the
                        // variable declaration.
                        if let Some(Statement::VariableDeclaration(vd)) =
                            prog.statements.first()
                        {
                            if let Some(init) = vd.init.as_ref() {
                                let val = self.eval_expr(init);
                                val.to_display_string()
                            } else {
                                String::new()
                            }
                        } else {
                            String::new()
                        }
                    }
                    Err(_) => String::new(),
                }
            };
            result = result.replace(&full_match, &replacement);
        }
        result
    }
}

