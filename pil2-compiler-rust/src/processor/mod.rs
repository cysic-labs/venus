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

use std::collections::HashMap;
use std::time::Instant;

use crate::parser::ast::*;

use air::{AirGroup, AirGroups, AirInfo, AirTemplateInfo, AirTemplates};
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
    pub air_expression_store: Vec<RuntimeExpr>,

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
    /// User-defined functions: name -> (args, body).
    functions: HashMap<String, FunctionDef>,
    function_deep: u32,
    callstack: Vec<CallStackEntry>,

    // -- Built-in tracking --
    pub tests: TestTracker,

    // -- Deferred calls --
    deferred_calls: HashMap<String, HashMap<String, Vec<DeferredCallInfo>>>,

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
    commit_name_to_id: HashMap<String, u32>,
    /// Next commit_id to assign within the current AIR.
    next_commit_id: u32,
    /// Maps commit name to resolved public column IDs.
    commit_publics: HashMap<String, Vec<u32>>,
}

#[derive(Debug, Clone)]
struct CallStackEntry {
    name: String,
    source: String,
}

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
    bytes: Option<u32>,
    temporal: bool,
    external: bool,
    load_from_file: Option<(String, u32)>,
}

/// Maximum number of values in a switch-case range expansion.
const MAX_SWITCH_CASE_RANGE: i128 = 512;

impl Processor {
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
            global_expression_store: Vec::new(),
            air_groups: AirGroups::new(),
            air_templates: AirTemplates::new(),
            air_stack: Vec::new(),
            current_air_group: None,
            air_group_stack: Vec::new(),
            last_air_group_id: -1,
            last_air_id: -1,
            functions: HashMap::new(),
            function_deep: 0,
            callstack: Vec::new(),
            tests: TestTracker::default(),
            deferred_calls: HashMap::new(),
            pragmas_next_statement: PragmaNextStatement::default(),
            pragmas_next_fixed: PragmaNextFixed::default(),
            include_stack: Vec::new(),
            execute_counter: 0,
            error_raised: false,
            error_count: 0,
            commit_name_to_id: HashMap::new(),
            next_commit_id: 0,
            commit_publics: HashMap::new(),
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
                self.scope.push();
                let result = self.execute_statements(stmts);
                let (to_unset, to_restore) = self.scope.pop();
                self.apply_scope_cleanup(&to_unset, &to_restore);
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
        for name in to_unset {
            self.references.unset(name);
        }
        for (name, reference) in to_restore {
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
    // Variable declarations
    // -----------------------------------------------------------------------

    fn exec_variable_declaration(&mut self, vd: &VariableDeclaration) -> FlowSignal {
        // Evaluate the RHS once. When `is_multiple` is true (destructuring
        // like `const int [a, b, c] = [1, 2, 3]`), the init evaluates to an
        // Array and each element is assigned to the corresponding variable.
        let full_init = vd.init.as_ref().map(|e| self.eval_expr(e));

        for (index, item) in vd.items.iter().enumerate() {
            let name = &item.name;
            let array_dims: Vec<u32> = item
                .array_dims
                .iter()
                .filter_map(|d| d.as_ref().and_then(|e| self.eval_expr(e).as_int().map(|v| v as u32)))
                .collect();
            let size: u32 = if array_dims.is_empty() {
                1
            } else {
                array_dims.iter().product()
            };

            // Per-element init: for destructuring, extract element `index`
            // from the array; otherwise use the full init value for all items.
            let init_value = if vd.is_multiple {
                full_init.as_ref().and_then(|v| {
                    if let Value::Array(items) = v {
                        items.get(index).cloned()
                    } else {
                        Some(v.clone())
                    }
                })
            } else {
                full_init.clone()
            };

            let (ref_type, store_id) = match &vd.vtype {
                TypeKind::Int => {
                    let id = self.ints.reserve(
                        size,
                        Some(name),
                        &array_dims,
                        IdData {
                            source_ref: self.source_ref.clone(),
                            ..Default::default()
                        },
                    );
                    if let Some(val) = &init_value {
                        self.ints.set(id, val.clone());
                    }
                    (RefType::Int, id)
                }
                TypeKind::Fe => {
                    let id = self.fes.reserve(
                        size,
                        Some(name),
                        &array_dims,
                        IdData {
                            source_ref: self.source_ref.clone(),
                            ..Default::default()
                        },
                    );
                    if let Some(val) = &init_value {
                        self.fes.set(id, val.clone());
                    }
                    (RefType::Fe, id)
                }
                TypeKind::StringType => {
                    let id = self.strings.reserve(
                        size,
                        Some(name),
                        &array_dims,
                        IdData {
                            source_ref: self.source_ref.clone(),
                            ..Default::default()
                        },
                    );
                    if let Some(val) = &init_value {
                        self.strings.set(id, val.clone());
                    }
                    (RefType::Str, id)
                }
                TypeKind::Expr => {
                    let id = self.exprs.reserve(
                        size,
                        Some(name),
                        &array_dims,
                        IdData {
                            source_ref: self.source_ref.clone(),
                            ..Default::default()
                        },
                    );
                    if let Some(val) = &init_value {
                        self.exprs.set(id, val.clone());
                    }
                    (RefType::Expr, id)
                }
                _ => {
                    // Other types not handled as simple variables.
                    return FlowSignal::None;
                }
            };

            // When inside a re-opened container, skip re-declaration of
            // variables that already exist. This matches the JS behavior
            // where container variable initializers only run the first
            // time the container is created.
            if self.references.inside_container() {
                if self.references.container_has_var(name) {
                    continue;
                }
            }

            // Check for an existing binding to save for scope restore.
            let previous = self.references.get_reference(name).cloned();
            self.references.declare(
                name,
                ref_type,
                store_id,
                &array_dims,
                vd.is_const,
                self.scope.deep,
                &self.source_ref,
            );
            // Record in scope so that pop() can unset or restore.
            self.scope.declare(name, previous);
        }
        FlowSignal::None
    }

    // -----------------------------------------------------------------------
    // Assignment
    // -----------------------------------------------------------------------

    fn exec_assignment(&mut self, a: &Assignment) -> FlowSignal {
        let value = match &a.value {
            AssignValue::Expr(e) => self.eval_expr(e),
            AssignValue::Sequence(_seq) => {
                // Sequence assignment for fixed columns.
                Value::Void
            }
        };

        let name = &a.target.path;
        // Try namespace-qualified resolution first, then fall back to
        // direct lookup so that columns inside airtemplates are found.
        let names = self.namespace_ctx.get_names(name);
        let reference = self
            .references
            .get_reference_multi(&names)
            .or_else(|| self.references.get_reference(name))
            .cloned();

        if let Some(reference) = reference {
            // Evaluate target indexes (e.g. C[i] has one index expression).
            let target_indexes: Vec<i128> = a
                .target
                .indexes
                .iter()
                .map(|e| self.eval_expr(e).as_int().unwrap_or(0))
                .collect();

            // For compound assignments (+=, -=, *=), we need to read the
            // current value from the correct indexed element, not from the
            // base reference.  Resolve the effective ID once so all branches
            // can reuse it.
            let indexed_id = if !target_indexes.is_empty()
                && !reference.array_dims.is_empty()
            {
                let flat = compute_flat_index(&target_indexes, &reference.array_dims);
                Some(reference.id + flat)
            } else {
                None
            };

            let final_value = match a.op {
                AssignOp::Assign => value,
                AssignOp::AddAssign => {
                    let current = if let Some(eid) = indexed_id {
                        self.get_var_value_by_type_and_id(&reference.ref_type, eid)
                    } else {
                        self.get_var_value(&reference)
                    };
                    if let (Some(l), Some(r)) = (current.as_int(), value.as_int()) {
                        Value::Int(l + r)
                    } else {
                        value
                    }
                }
                AssignOp::SubAssign => {
                    let current = if let Some(eid) = indexed_id {
                        self.get_var_value_by_type_and_id(&reference.ref_type, eid)
                    } else {
                        self.get_var_value(&reference)
                    };
                    if let (Some(l), Some(r)) = (current.as_int(), value.as_int()) {
                        Value::Int(l - r)
                    } else {
                        value
                    }
                }
                AssignOp::MulAssign => {
                    let current = if let Some(eid) = indexed_id {
                        self.get_var_value_by_type_and_id(&reference.ref_type, eid)
                    } else {
                        self.get_var_value(&reference)
                    };
                    if let (Some(l), Some(r)) = (current.as_int(), value.as_int()) {
                        Value::Int(l * r)
                    } else {
                        value
                    }
                }
            };

            // Handle column writes with row indexes (e.g. C[i] = expr).
            if !target_indexes.is_empty() && matches!(reference.ref_type, RefType::Fixed) {
                let col_id = if !reference.array_dims.is_empty() && target_indexes.len() > 1 {
                    // Multi-dimensional column array: split last index as
                    // row, earlier indexes select the sub-column.
                    let dim_indexes = &target_indexes[..target_indexes.len() - 1];
                    let flat = compute_flat_index(dim_indexes, &reference.array_dims);
                    reference.id + flat
                } else {
                    reference.id
                };
                let row = *target_indexes.last().unwrap() as usize;
                if let Some(v) = final_value.as_int() {
                    self.fixed_cols.set_row_value(col_id, row, v);
                }
            } else if !target_indexes.is_empty()
                && !reference.array_dims.is_empty()
            {
                // Array variable: compute the flat offset and write to the
                // element at that position.
                let flat = compute_flat_index(&target_indexes, &reference.array_dims);
                let id = reference.id + flat;
                self.set_var_value_by_type_and_id(&reference.ref_type, id, final_value);
            } else {
                self.set_var_value(&reference, final_value);
            }
        }
        FlowSignal::None
    }

    /// Get a variable's current value using its reference.
    fn get_var_value(&self, reference: &Reference) -> Value {
        match reference.ref_type {
            RefType::Int => self.ints.get(reference.id).cloned().unwrap_or(Value::Int(0)),
            RefType::Fe => self.fes.get(reference.id).cloned().unwrap_or(Value::Fe(0)),
            RefType::Str => self
                .strings
                .get(reference.id)
                .cloned()
                .unwrap_or(Value::Str(String::new())),
            RefType::Expr => self
                .exprs
                .get(reference.id)
                .cloned()
                .unwrap_or(Value::Void),
            RefType::Fixed => Value::ColRef {
                col_type: ColRefKind::Fixed,
                id: reference.id,
                row_offset: None,
            },
            RefType::Witness => Value::ColRef {
                col_type: ColRefKind::Witness,
                id: reference.id,
                row_offset: None,
            },
            RefType::Public => Value::ColRef {
                col_type: ColRefKind::Public,
                id: reference.id,
                row_offset: None,
            },
            RefType::Challenge => Value::ColRef {
                col_type: ColRefKind::Challenge,
                id: reference.id,
                row_offset: None,
            },
            _ => Value::Void,
        }
    }

    /// Set a variable's value using its reference.
    fn set_var_value(&mut self, reference: &Reference, value: Value) {
        match reference.ref_type {
            RefType::Int => self.ints.set(reference.id, value),
            RefType::Fe => self.fes.set(reference.id, value),
            RefType::Str => self.strings.set(reference.id, value),
            RefType::Expr => self.exprs.set(reference.id, value),
            _ => {}
        }
    }

    /// Set a variable value by type and explicit ID (for indexed array writes).
    fn set_var_value_by_type_and_id(&mut self, ref_type: &RefType, id: u32, value: Value) {
        match ref_type {
            RefType::Int => self.ints.set(id, value),
            RefType::Fe => self.fes.set(id, value),
            RefType::Str => self.strings.set(id, value),
            RefType::Expr => self.exprs.set(id, value),
            _ => {}
        }
    }

    // -----------------------------------------------------------------------
    // Constraint handling
    // -----------------------------------------------------------------------

    fn exec_constraint(&mut self, c: &Constraint) -> FlowSignal {
        let left = self.eval_expr_to_runtime(&c.left);
        let right = self.eval_expr_to_runtime(&c.right);

        let scope_type = self.scope.get_instance_type();
        let is_global = scope_type == "proof";

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
            self.scope.push();
            let result = self.execute_statements(&s.then_body);
            let (to_unset, to_restore) = self.scope.pop();
            self.apply_scope_cleanup(&to_unset, &to_restore);
            return result;
        }

        for elseif in &s.elseif_clauses {
            let cond = self.eval_expr(&elseif.condition);
            if cond.as_bool().unwrap_or(false) {
                self.scope.push();
                let result = self.execute_statements(&elseif.body);
                let (to_unset, to_restore) = self.scope.pop();
                self.apply_scope_cleanup(&to_unset, &to_restore);
                return result;
            }
        }

        if let Some(else_body) = &s.else_body {
            self.scope.push();
            let result = self.execute_statements(else_body);
            let (to_unset, to_restore) = self.scope.pop();
            self.apply_scope_cleanup(&to_unset, &to_restore);
            return result;
        }

        FlowSignal::None
    }

    fn exec_for(&mut self, s: &ForStmt) -> FlowSignal {
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
        FlowSignal::None
    }

    fn exec_while(&mut self, s: &WhileStmt) -> FlowSignal {
        loop {
            self.scope.push();
            let cond = self.eval_expr(&s.condition);
            if !cond.as_bool().unwrap_or(false) {
                let (to_unset, to_restore) = self.scope.pop();
                self.apply_scope_cleanup(&to_unset, &to_restore);
                break;
            }
            let result = self.execute_statements(&s.body);
            let (to_unset, to_restore) = self.scope.pop();
            self.apply_scope_cleanup(&to_unset, &to_restore);
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
                self.scope.push();
                let result = self.execute_statements(&case_clause.body);
                let (to_unset, to_restore) = self.scope.pop();
                self.apply_scope_cleanup(&to_unset, &to_restore);
                return result;
            }
        }

        // Default case.
        if let Some(default_body) = &s.default {
            self.scope.push();
            let result = self.execute_statements(default_body);
            let (to_unset, to_restore) = self.scope.pop();
            self.apply_scope_cleanup(&to_unset, &to_restore);
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
                            let rt_op = match op {
                                BinOp::Add => RuntimeOp::Add,
                                BinOp::Sub => RuntimeOp::Sub,
                                BinOp::Mul => RuntimeOp::Mul,
                                _ => return Value::Void,
                            };
                            let left_rt = value_to_runtime_expr(&lval);
                            let right_rt = value_to_runtime_expr(&rval);
                            return Value::RuntimeExpr(Box::new(RuntimeExpr::BinOp {
                                op: rt_op,
                                left: Box::new(left_rt),
                                right: Box::new(right_rt),
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
                    let rt = value_to_runtime_expr(&val);
                    Value::RuntimeExpr(Box::new(RuntimeExpr::UnaryOp {
                        op: RuntimeUnaryOp::Neg,
                        operand: Box::new(rt),
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
                                Value::ColRef {
                                    col_type: *col_type,
                                    id: id + i as u32,
                                    row_offset: None,
                                }
                            }
                        }
                    }
                    _ => Value::Void,
                }
            }
            Expr::ArrayLiteral(items) => {
                let values: Vec<Value> = items.iter().map(|e| self.eval_expr(e)).collect();
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
                    "string" => Value::Str(val.to_display_string()),
                    "expr" => val,
                    _ => val,
                }
            }
            Expr::RowOffset { base, offset } => {
                // Row offset creates a column reference with offset.
                let base_val = self.eval_expr(base);
                let offset_val = self
                    .eval_expr(offset)
                    .as_int()
                    .unwrap_or(1);
                match base_val {
                    Value::ColRef {
                        col_type, id, ..
                    } => Value::ColRef {
                        col_type,
                        id,
                        row_offset: Some(offset_val as i64),
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

    /// Evaluate a reference (variable or column lookup).
    fn eval_reference(&mut self, name_id: &NameId) -> Value {
        let name = &name_id.path;
        // Fast path: try direct lookup first to avoid allocating namespace
        // variants. This is a significant optimization for tight loops.
        let reference_opt = self.references.get_reference(name).cloned().or_else(|| {
            let names = self.namespace_ctx.get_names(name);
            self.references.get_reference_multi(&names).cloned()
        });
        if let Some(reference) = reference_opt {
            // Handle array indexing.
            if !name_id.indexes.is_empty() && !reference.array_dims.is_empty() {
                let indexes: Vec<i128> = name_id
                    .indexes
                    .iter()
                    .map(|e| self.eval_expr(e).as_int().unwrap_or(0))
                    .collect();
                let flat_idx = compute_flat_index(&indexes, &reference.array_dims);
                let id = reference.id + flat_idx;
                return self.get_var_value_by_type_and_id(&reference.ref_type, id);
            }
            self.get_var_value(&reference)
        } else {
            Value::Void
        }
    }

    /// Get a variable value by type and ID.
    fn get_var_value_by_type_and_id(&self, ref_type: &RefType, id: u32) -> Value {
        match ref_type {
            RefType::Int => self.ints.get(id).cloned().unwrap_or(Value::Int(0)),
            RefType::Fe => self.fes.get(id).cloned().unwrap_or(Value::Fe(0)),
            RefType::Str => self
                .strings
                .get(id)
                .cloned()
                .unwrap_or(Value::Str(String::new())),
            RefType::Expr => self.exprs.get(id).cloned().unwrap_or(Value::Void),
            RefType::Fixed => Value::ColRef {
                col_type: ColRefKind::Fixed,
                id,
                row_offset: None,
            },
            RefType::Witness => Value::ColRef {
                col_type: ColRefKind::Witness,
                id,
                row_offset: None,
            },
            RefType::Public => Value::ColRef {
                col_type: ColRefKind::Public,
                id,
                row_offset: None,
            },
            RefType::Challenge => Value::ColRef {
                col_type: ColRefKind::Challenge,
                id,
                row_offset: None,
            },
            _ => Value::Void,
        }
    }

    /// Recursively build a dotted name from a MemberAccess chain.
    /// E.g. `air.std.connect` from nested MemberAccess nodes.
    fn build_dotted_name(&self, base: &Expr, member: &str) -> Option<String> {
        let base_name = match base {
            Expr::Reference(name_id) => Some(name_id.path.clone()),
            Expr::MemberAccess {
                base: inner_base,
                member: inner_member,
            } => self.build_dotted_name(inner_base, inner_member),
            _ => None,
        };
        base_name.map(|b| format!("{}.{}", b, member))
    }

    /// Evaluate an expression into a RuntimeExpr (for constraints).
    fn eval_expr_to_runtime(&mut self, expr: &Expr) -> RuntimeExpr {
        let val = self.eval_expr(expr);
        value_to_runtime_expr(&val)
    }

    /// Evaluate a function call.
    fn eval_function_call(&mut self, fc: &FunctionCall) -> Value {
        let name = &fc.function.path;

        // Fast path for no-op builtins: skip argument evaluation entirely.
        // In the JS compiler, `log` is handled by the transpiler context and
        // is effectively a no-op during normal interpreted execution.
        if matches!(name.as_str(), "log") {
            return Value::Int(0);
        }

        // Evaluate all call arguments (values only).
        let raw_args: Vec<Value> = fc.args.iter().map(|a| self.eval_expr(&a.value)).collect();

        // Check for builtin (builtins don't use named args).
        if let Some(kind) = BuiltinKind::from_name(name) {
            match builtins::exec_builtin(kind, &raw_args, &self.source_ref, &mut self.tests) {
                Ok(val) => return val,
                Err(msg) => {
                    eprintln!("error: {} at {}", msg, self.source_ref);
                    // In the JS compiler, error()/assert()/assert_eq()
                    // throw exceptions that unwind the call stack. When
                    // inside a user function, set a flag to short-circuit
                    // statement execution in the enclosing function. At
                    // proof level there is no function to unwind so we
                    // just report and continue.
                    self.error_count += 1;
                    if self.function_deep > 0 {
                        self.error_raised = true;
                    }
                    return Value::Void;
                }
            }
        }

        // Helper: reorder args if any are named, matching the function
        // definition's parameter order.
        let has_named = fc.args.iter().any(|a| a.name.is_some());

        // Check for user-defined function.
        if let Some(func_def) = self.functions.get(name).cloned() {
            let args = if has_named {
                reorder_named_args(&fc.args, &raw_args, &func_def.args)
            } else {
                raw_args
            };
            return self.execute_user_function(&func_def, &args);
        }

        // Check namespace-qualified names.
        let names = self.namespace_ctx.get_names(name);
        for qualified_name in &names {
            if let Some(func_def) = self.functions.get(qualified_name).cloned() {
                let args = if has_named {
                    reorder_named_args(&fc.args, &raw_args, &func_def.args)
                } else {
                    raw_args.clone()
                };
                return self.execute_user_function(&func_def, &args);
            }
        }

        // Check for airtemplate call (creating an air instance).
        if let Some(tpl) = self.air_templates.get(name).cloned() {
            let args = if has_named {
                reorder_named_args(&fc.args, &raw_args, &tpl.args)
            } else {
                raw_args
            };
            return self.execute_air_template_call(&tpl, &args, name, false);
        }

        // Tables.* built-in functions for fixed column manipulation.
        match name.as_str() {
            "Tables.num_rows" => return self.tables_num_rows(&raw_args),
            "Tables.fill" => return self.tables_fill(&raw_args),
            "Tables.copy" => return self.tables_copy(&raw_args),
            _ => {}
        }

        Value::Void
    }

    /// Evaluate a function call with optional alias and virtual flag.
    /// Used by exec_expr_stmt and exec_virtual_expr for airtemplate calls.
    fn eval_function_call_with_alias(
        &mut self,
        fc: &FunctionCall,
        alias: Option<&str>,
        is_virtual: bool,
    ) -> FlowSignal {
        let name = &fc.function.path;

        // Fast path for no-op builtins (see eval_function_call).
        if matches!(name.as_str(), "log") {
            return FlowSignal::None;
        }

        let raw_args: Vec<Value> = fc.args.iter().map(|a| self.eval_expr(&a.value)).collect();
        let has_named = fc.args.iter().any(|a| a.name.is_some());

        // Check for builtin (builtins can't be aliased, but handle for safety).
        if let Some(kind) = BuiltinKind::from_name(name) {
            match builtins::exec_builtin(kind, &raw_args, &self.source_ref, &mut self.tests) {
                Ok(_val) => return FlowSignal::None,
                Err(msg) => {
                    eprintln!("error: {} at {}", msg, self.source_ref);
                    self.error_count += 1;
                    if self.function_deep > 0 {
                        self.error_raised = true;
                    }
                    return FlowSignal::None;
                }
            }
        }

        // Check for user-defined function.
        if let Some(func_def) = self.functions.get(name).cloned() {
            let args = if has_named {
                reorder_named_args(&fc.args, &raw_args, &func_def.args)
            } else {
                raw_args
            };
            self.execute_user_function(&func_def, &args);
            return FlowSignal::None;
        }

        // Check namespace-qualified names.
        let names = self.namespace_ctx.get_names(name);
        for qualified_name in &names {
            if let Some(func_def) = self.functions.get(qualified_name).cloned() {
                let args = if has_named {
                    reorder_named_args(&fc.args, &raw_args, &func_def.args)
                } else {
                    raw_args.clone()
                };
                self.execute_user_function(&func_def, &args);
                return FlowSignal::None;
            }
        }

        // Check for airtemplate call: use alias as instance name if provided.
        if let Some(tpl) = self.air_templates.get(name).cloned() {
            let args = if has_named {
                reorder_named_args(&fc.args, &raw_args, &tpl.args)
            } else {
                raw_args
            };
            let raw_instance_name = alias.unwrap_or(name);
            // Expand template strings (e.g. `VirtualTable${i}` -> `VirtualTable0`).
            let instance_name = self.expand_templates(raw_instance_name);
            self.execute_air_template_call(&tpl, &args, &instance_name, is_virtual);
            return FlowSignal::None;
        }

        FlowSignal::None
    }

    /// Execute a user-defined function.
    fn execute_user_function(&mut self, func: &FunctionDef, args: &[Value]) -> Value {
        self.function_deep += 1;
        self.callstack.push(CallStackEntry {
            name: func.name.clone(),
            source: self.source_ref.clone(),
        });
        self.scope.push();
        self.references.push_visibility_scope(Some(self.scope.deep));

        // Bind arguments.
        for (i, arg_def) in func.args.iter().enumerate() {
            let value = args
                .get(i)
                .cloned()
                .and_then(|v| if matches!(v, Value::Void) { None } else { Some(v) })
                .or_else(|| {
                    arg_def
                        .default_value
                        .as_ref()
                        .map(|e| self.eval_expr(e))
                })
                .unwrap_or(Value::Void);

            let ref_type = match &arg_def.type_info.kind {
                TypeKind::Int => RefType::Int,
                TypeKind::Fe => RefType::Fe,
                TypeKind::StringType => RefType::Str,
                TypeKind::Expr => RefType::Expr,
                _ => RefType::Int,
            };
            let store_id = match ref_type {
                RefType::Int => {
                    let id = self.ints.reserve(1, Some(&arg_def.name), &[], IdData::default());
                    self.ints.set(id, value);
                    id
                }
                RefType::Fe => {
                    let id = self.fes.reserve(1, Some(&arg_def.name), &[], IdData::default());
                    self.fes.set(id, value);
                    id
                }
                RefType::Str => {
                    let id = self.strings.reserve(1, Some(&arg_def.name), &[], IdData::default());
                    self.strings.set(id, value);
                    id
                }
                RefType::Expr => {
                    let id = self.exprs.reserve(1, Some(&arg_def.name), &[], IdData::default());
                    self.exprs.set(id, value);
                    id
                }
                _ => 0,
            };

            let previous = self.references.get_reference(&arg_def.name).cloned();
            self.references.declare(
                &arg_def.name,
                ref_type,
                store_id,
                &[],
                arg_def.type_info.is_const,
                self.scope.deep,
                &self.source_ref,
            );
            self.scope.declare(&arg_def.name, previous);
        }

        // Execute body.
        let result = self.execute_statements(&func.body);

        // Do NOT clear error_raised here. In the JS compiler, errors
        // (thrown exceptions) propagate through all function call frames
        // (executeFunctionCall uses try/finally, not try/catch) and are
        // only caught at the statement execution level or the airtemplate
        // call boundary. Clearing here would swallow errors from nested
        // callees, allowing the caller to resume incorrectly.

        self.references.pop_visibility_scope();
        let (to_unset, to_restore) = self.scope.pop();
        self.apply_scope_cleanup(&to_unset, &to_restore);
        self.callstack.pop();
        self.function_deep -= 1;

        match result {
            FlowSignal::Return(val) => val,
            _ => Value::Int(0),
        }
    }

    // -----------------------------------------------------------------------
    // Expression statement
    // -----------------------------------------------------------------------

    fn exec_expr_stmt(&mut self, es: &ExprStmt) -> FlowSignal {
        // If this is a function call with an alias, handle airtemplate
        // aliasing: `Dma(enable: E_DMA_MEMCPY) alias DmaMemCpy` creates
        // an air instance named "DmaMemCpy" instead of "Dma".
        if let Expr::FunctionCall(fc) = &es.expr {
            if es.alias.is_some() || true {
                // Always go through the alias-aware path so that airtemplate
                // calls get proper naming.
                return self.eval_function_call_with_alias(fc, es.alias.as_deref(), false);
            }
        }
        self.eval_expr(&es.expr);
        FlowSignal::None
    }

    fn exec_virtual_expr(&mut self, ve: &VirtualExprStmt) -> FlowSignal {
        // Virtual expressions create virtual air instances with is_virtual=true.
        if let Expr::FunctionCall(fc) = &ve.expr {
            return self.eval_function_call_with_alias(fc, ve.alias.as_deref(), true);
        }
        self.eval_expr(&ve.expr);
        FlowSignal::None
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
    // Column declarations
    // -----------------------------------------------------------------------

    fn exec_col_declaration(&mut self, cd: &ColDeclaration) -> FlowSignal {
        for item in &cd.items {
            let full_name = self.namespace_ctx.get_full_name(&item.name);
            let array_dims: Vec<u32> = item
                .array_dims
                .iter()
                .filter_map(|d| {
                    d.as_ref()
                        .and_then(|e| self.eval_expr(e).as_int().map(|v| v as u32))
                })
                .collect();
            let size: u32 = if array_dims.is_empty() {
                1
            } else {
                array_dims.iter().product()
            };

            let mut data = IdData {
                source_ref: self.source_ref.clone(),
                ..Default::default()
            };

            match &cd.col_type {
                ColType::Witness => {
                    // Extract stage from features.
                    let stage = cd
                        .features
                        .iter()
                        .find(|f| f.name == "stage")
                        .and_then(|f| {
                            f.args
                                .first()
                                .and_then(|a| self.eval_expr(&a.value).as_int().map(|v| v as u32))
                        });
                    data.stage = stage;
                    let id = self.witness_cols.reserve(
                        size,
                        Some(&full_name),
                        &array_dims,
                        data,
                    );
                    self.references.declare(
                        &full_name,
                        RefType::Witness,
                        id,
                        &array_dims,
                        false,
                        self.scope.deep,
                        &self.source_ref,
                    );
                }
                ColType::Fixed => {
                    if self.pragmas_next_fixed.temporal {
                        data.temporal = true;
                        self.pragmas_next_fixed.temporal = false;
                    }
                    if self.pragmas_next_fixed.external {
                        data.external = true;
                        self.pragmas_next_fixed.external = false;
                    }
                    // Consume fixed_load pragma if set.
                    let load_from_file = self.pragmas_next_fixed.load_from_file.take();

                    let id = self.fixed_cols.reserve(
                        size,
                        Some(&full_name),
                        &array_dims,
                        data,
                    );

                    if let Some((file_path, col_idx)) = load_from_file {
                        // Load fixed column data from external binary file.
                        let num_rows = self
                            .ints
                            .get(
                                self.references
                                    .get_reference("N")
                                    .map(|r| r.id)
                                    .unwrap_or(0),
                            )
                            .and_then(|v| v.as_int())
                            .unwrap_or(0) as u64;
                        if num_rows > 0 {
                            match fixed_cols::load_fixed_from_binary(
                                &file_path, col_idx, num_rows,
                            ) {
                                Ok(data) => {
                                    self.fixed_cols.set_row_data(id, data);
                                }
                                Err(e) => {
                                    eprintln!(
                                        "warning: failed to load fixed col from {}: {}",
                                        file_path, e
                                    );
                                }
                            }
                        }
                    } else {
                        // Evaluate initialization (sequence or expression).
                        if let Some(init) = &cd.init {
                            match init {
                                ColInit::Sequence(seq) => {
                                    let num_rows = self
                                        .ints
                                        .get(
                                            self.references
                                                .get_reference("N")
                                                .map(|r| r.id)
                                                .unwrap_or(0),
                                        )
                                        .and_then(|v| v.as_int())
                                        .unwrap_or(0) as u64;
                                    if num_rows > 0 {
                                        let resolved = self.resolve_sequence(seq);
                                        let data =
                                            fixed_cols::evaluate_sequence(&resolved, num_rows);
                                        self.fixed_cols.set_row_data(id, data);
                                    }
                                }
                                ColInit::Expression(expr) => {
                                    let _val = self.eval_expr(expr);
                                    // Expression init for fixed columns.
                                }
                            }
                        }
                    }

                    self.references.declare(
                        &full_name,
                        RefType::Fixed,
                        id,
                        &array_dims,
                        false,
                        self.scope.deep,
                        &self.source_ref,
                    );
                }
                ColType::Custom(commit_name) => {
                    // Look up the commit_id for this commit name.
                    let cid = self.commit_name_to_id.get(commit_name).copied();
                    data.commit_id = cid;
                    let id = self.custom_cols.reserve(
                        size,
                        Some(&full_name),
                        &array_dims,
                        data,
                    );
                    self.references.declare(
                        &full_name,
                        RefType::CustomCol,
                        id,
                        &array_dims,
                        false,
                        self.scope.deep,
                        &self.source_ref,
                    );
                }
            }
        }
        FlowSignal::None
    }

    fn exec_challenge_declaration(&mut self, cd: &ChallengeDeclaration) -> FlowSignal {
        for item in &cd.items {
            let name = &item.name;
            let id = self.challenges.reserve(
                1,
                Some(name),
                &[],
                IdData {
                    source_ref: self.source_ref.clone(),
                    stage: cd.stage.map(|s| s as u32),
                    ..Default::default()
                },
            );
            self.references.declare(
                name,
                RefType::Challenge,
                id,
                &[],
                false,
                self.scope.deep,
                &self.source_ref,
            );
        }
        FlowSignal::None
    }

    fn exec_public_declaration(&mut self, pd: &PublicDeclaration) -> FlowSignal {
        for item in &pd.items {
            let name = &item.name;
            let array_dims: Vec<u32> = item
                .array_dims
                .iter()
                .filter_map(|d| {
                    d.as_ref()
                        .and_then(|e| self.eval_expr(e).as_int().map(|v| v as u32))
                })
                .collect();
            let size: u32 = if array_dims.is_empty() {
                1
            } else {
                array_dims.iter().product()
            };
            let id = self.publics.reserve(
                size,
                Some(name),
                &array_dims,
                IdData {
                    source_ref: self.source_ref.clone(),
                    ..Default::default()
                },
            );
            self.references.declare(
                name,
                RefType::Public,
                id,
                &array_dims,
                false,
                self.scope.deep,
                &self.source_ref,
            );
        }
        FlowSignal::None
    }

    fn exec_proof_value_declaration(&mut self, pvd: &ProofValueDeclaration) -> FlowSignal {
        for item in &pvd.items {
            let name = &item.name;
            let id = self.proof_values.reserve(
                1,
                Some(name),
                &[],
                IdData {
                    source_ref: self.source_ref.clone(),
                    stage: pvd.stage.map(|s| s as u32),
                    ..Default::default()
                },
            );
            self.references.declare(
                name,
                RefType::ProofValue,
                id,
                &[],
                false,
                self.scope.deep,
                &self.source_ref,
            );
        }
        FlowSignal::None
    }

    fn exec_air_group_value_declaration(
        &mut self,
        agvd: &AirGroupValueDeclaration,
    ) -> FlowSignal {
        // Determine aggregate type: 0 = SUM, 1 = PROD.
        let agg_type = match agvd.aggregate_type.as_deref() {
            Some("prod") => 1i32,
            _ => 0i32, // default to SUM
        };
        // Default stage is 2 for air group values (matches JS compiler's
        // DEFAULT_AIR_GROUP_VALUE_STAGE = 2 in pil_parser.jison).
        let stage = agvd.stage.map(|s| s as u32).unwrap_or(2);

        for item in &agvd.items {
            let name = &item.name;

            // Deduplicate: if this AGV name already exists in the current
            // airgroup, reuse the existing reference (matching JS
            // AirGroup.declareAirGroupValue which skips re-declaration).
            if self.references.get_reference(name).is_some() {
                continue;
            }

            let id = self.air_group_values.reserve(
                1,
                Some(name),
                &[],
                IdData {
                    source_ref: self.source_ref.clone(),
                    stage: Some(stage),
                    ..Default::default()
                },
            );
            self.references.declare(
                name,
                RefType::AirGroupValue,
                id,
                &[],
                false,
                self.scope.deep,
                &self.source_ref,
            );

            // Store metadata in the current airgroup for protobuf output.
            if let Some(ref ag_name) = self.current_air_group {
                let ag_name = ag_name.clone();
                if let Some(ag) = self.air_groups.get_mut(&ag_name) {
                    ag.air_group_values.push((stage, agg_type));
                }
            }
        }
        FlowSignal::None
    }

    fn exec_air_value_declaration(&mut self, avd: &AirValueDeclaration) -> FlowSignal {
        for item in &avd.items {
            let full_name = self.namespace_ctx.get_full_name(&item.name);
            let id = self.air_values.reserve(
                1,
                Some(&full_name),
                &[],
                IdData {
                    source_ref: self.source_ref.clone(),
                    stage: avd.stage.map(|s| s as u32),
                    ..Default::default()
                },
            );
            self.references.declare(
                &full_name,
                RefType::AirValue,
                id,
                &[],
                false,
                self.scope.deep,
                &self.source_ref,
            );
        }
        FlowSignal::None
    }

    fn exec_commit_declaration(&mut self, cd: &CommitDeclaration) -> FlowSignal {
        // Allocate a commit_id for this commit name if not already assigned.
        let commit_name = cd.name.clone();
        if !self.commit_name_to_id.contains_key(&commit_name) {
            let cid = self.next_commit_id;
            self.next_commit_id += 1;
            self.commit_name_to_id.insert(commit_name.clone(), cid);
        }

        // Resolve public column references and store their IDs.
        let mut pub_ids = Vec::new();
        for pub_name in &cd.publics {
            let reference_opt = self.references.get_reference(pub_name).cloned().or_else(|| {
                let names = self.namespace_ctx.get_names(pub_name);
                self.references.get_reference_multi(&names).cloned()
            });
            if let Some(reference) = reference_opt {
                if reference.ref_type == RefType::Public {
                    let total = reference.total_size();
                    for i in 0..total {
                        pub_ids.push(reference.id + i);
                    }
                }
            }
        }
        if !pub_ids.is_empty() {
            self.commit_publics
                .entry(commit_name)
                .or_insert_with(Vec::new)
                .extend(pub_ids);
        }
        FlowSignal::None
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
        self.execute_statements(&ag.statements);
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
        self.scope.pop_instance_type();
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

    /// Execute an air template call, creating a new air instance.
    fn execute_air_template_call(
        &mut self,
        tpl: &AirTemplateInfo,
        args: &[Value],
        name: &str,
        is_virtual: bool,
    ) -> Value {
        let ag_name = match &self.current_air_group {
            Some(n) => n.clone(),
            None => {
                eprintln!("error: air template call outside airgroup at {}", self.source_ref);
                return Value::Void;
            }
        };

        eprintln!(
            "\nAIR {}instance {} in airgroup {}",
            if is_virtual { "virtual " } else { "" },
            name,
            ag_name
        );

        // Push function scope and bind arguments.
        self.function_deep += 1;
        self.callstack.push(CallStackEntry {
            name: name.to_string(),
            source: self.source_ref.clone(),
        });
        self.scope.push();

        for (i, arg_def) in tpl.args.iter().enumerate() {
            let value = args
                .get(i)
                .cloned()
                .and_then(|v| if matches!(v, Value::Void) { None } else { Some(v) })
                .or_else(|| arg_def.default_value.as_ref().map(|e| self.eval_expr(e)))
                .unwrap_or(Value::Void);

            let store_id = self
                .ints
                .reserve(1, Some(&arg_def.name), &[], IdData::default());
            self.ints.set(store_id, value);
            self.references.declare(
                &arg_def.name,
                RefType::Int,
                store_id,
                &[],
                arg_def.type_info.is_const,
                self.scope.deep,
                &self.source_ref,
            );
        }

        // Determine rows from N parameter.
        let rows = self
            .references
            .get_reference("N")
            .map(|r| r.id)
            .and_then(|id| self.ints.get(id))
            .and_then(|v| v.as_int())
            .unwrap_or(0) as u64;

        // Create the air instance.
        self.last_air_id += 1;
        let air_id = self.last_air_id as u32;
        {
            let ag = self.air_groups.get_or_create(&ag_name);
            ag.create_air(air_id, &tpl.name, name, rows, is_virtual);
        }

        let air = air::Air::new(air_id, 0, &tpl.name, name, rows, is_virtual);
        self.air_stack.push(air);

        // Push the expr store so air-level expressions don't mix with
        // proof-level ones. Matches JS pushAirScope()/popAirScope().
        self.exprs.push();

        self.namespace_ctx.push(name);
        self.scope.push_instance_type("air");

        // Update built-in constants.
        self.set_builtin_int("BITS", self.air_stack.last().map(|a| a.bits as i128).unwrap_or(0));
        self.set_builtin_int("AIR_ID", air_id as i128);
        self.set_builtin_string("AIR_NAME", name);
        self.set_builtin_int("VIRTUAL", if is_virtual { 1 } else { 0 });
        self.set_builtin_string("AIRTEMPLATE", &tpl.name);

        // Execute template body.
        let body = tpl.body.clone();
        let extra_blocks = tpl.extra_blocks.clone();
        self.execute_statements(&body);
        for block in &extra_blocks {
            self.execute_statements(block);
        }

        // Execute deferred air-scoped calls (like piop_gprod_air,
        // piop_gsum_air) before capturing constraints/columns.
        // Mirrors JS `finalAirScope()`.
        self.call_deferred_functions("air", "final");

        let witness_count = self.witness_cols.len();
        let fixed_count = self.fixed_cols.len();
        let constraint_count = self.constraints.len() as u32;

        eprintln!("  > Witness cols: {}", witness_count);
        eprintln!("  > Fixed cols: {}", fixed_count);
        eprintln!("  > Constraints: {}", constraint_count);

        // Build fixed column ID mappings for this AIR.
        let mut fixed_id_map: Vec<(char, u32)> = Vec::new();
        {
            let num_rows = self.air_stack.last().map(|a| a.rows).unwrap_or(0);
            let mut fixed_proto_idx = 0u32;
            let mut periodic_proto_idx = 0u32;
            let fc_start = self.fixed_cols.current_start();
            let fc_end = fc_start + self.fixed_cols.len();
            for col_id in fc_start..fc_end {
                if let Some(data) = self.fixed_cols.ids.get_data(col_id) {
                    if data.temporal {
                        continue;
                    }
                }
                // Detect periodic: column has fewer rows than the AIR
                let is_periodic = if let Some(row_data) = self.fixed_cols.get_row_data(col_id) {
                    row_data.len() > 0 && (row_data.len() as u64) < num_rows
                } else {
                    false
                };
                if is_periodic {
                    while fixed_id_map.len() <= col_id as usize {
                        fixed_id_map.push(('F', 0));
                    }
                    fixed_id_map[col_id as usize] = ('P', periodic_proto_idx);
                    periodic_proto_idx += 1;
                } else {
                    while fixed_id_map.len() <= col_id as usize {
                        fixed_id_map.push(('F', 0));
                    }
                    fixed_id_map[col_id as usize] = ('F', fixed_proto_idx);
                    fixed_proto_idx += 1;
                }
            }
        }

        // Build witness column ID mappings (stage -> proto_index).
        let witness_id_map: Vec<(u32, u32)> = {
            let mut map = Vec::new();
            // Group by stage, assign per-stage indices.
            let mut stages: HashMap<u32, Vec<u32>> = HashMap::new();
            for wid in 0..self.witness_cols.len() {
                let stage = self.witness_cols.datas.get(wid as usize)
                    .and_then(|d| d.stage)
                    .unwrap_or(1);
                stages.entry(stage).or_default().push(wid);
            }
            let mut sorted_stages: Vec<u32> = stages.keys().cloned().collect();
            sorted_stages.sort();
            for stage in sorted_stages {
                if let Some(ids) = stages.get(&stage) {
                    for (idx, &wid) in ids.iter().enumerate() {
                        while map.len() <= wid as usize {
                            map.push((1, 0));
                        }
                        map[wid as usize] = (stage, idx as u32);
                    }
                }
            }
            map
        };

        // Compute stage_widths: count witness columns per stage.
        let stage_widths: Vec<u32> = {
            let mut by_stage: HashMap<u32, u32> = HashMap::new();
            for wid in 0..self.witness_cols.len() {
                let stage = self.witness_cols.datas.get(wid as usize)
                    .and_then(|d| d.stage)
                    .unwrap_or(1);
                *by_stage.entry(stage).or_insert(0) += 1;
            }
            if by_stage.is_empty() {
                Vec::new()
            } else {
                let max_stage = *by_stage.keys().max().unwrap();
                let mut widths = vec![0u32; max_stage as usize];
                for (stage, count) in by_stage {
                    if stage > 0 && (stage as usize) <= widths.len() {
                        widths[(stage - 1) as usize] = count;
                    }
                }
                widths
            }
        };

        // Build the full AIR expression store from intermediate columns
        // (expr-typed variables) and constraint expressions. This mirrors
        // the JS `this.expressions` store that holds ALL expressions
        // created during AIR execution. The exprs store was pushed at
        // air start, so all entries belong to this AIR.
        let air_expr_store: Vec<RuntimeExpr> = {
            let mut store = Vec::new();
            // Collect intermediate column expressions from this AIR.
            // Only include entries that hold symbolic values (ColRef or
            // RuntimeExpr), not compile-time constants.
            for eid in 0..self.exprs.len() {
                if let Some(val) = self.exprs.get(eid) {
                    if is_symbolic(val) {
                        let rt = value_to_runtime_expr(val);
                        store.push(rt);
                    }
                }
            }
            // Also include constraint expressions (which may reference
            // intermediates by index).
            for expr in self.constraints.all_expressions() {
                store.push(expr.clone());
            }
            store
        };

        // Build custom column ID mappings and custom_commits.
        let (custom_id_map, custom_commits) = {
            let mut cid_map: Vec<(u32, u32, u32)> = Vec::new();
            let mut commits: Vec<(String, Vec<u32>, Vec<u32>)> = Vec::new();

            // Group custom columns by commit_id.
            let mut commits_by_id: HashMap<u32, Vec<(u32, u32)>> = HashMap::new();
            let mut commit_names: HashMap<u32, String> = HashMap::new();
            for col_id in 0..self.custom_cols.len() {
                if let Some(data) = self.custom_cols.get_data(col_id) {
                    let cid = data.commit_id.unwrap_or(0);
                    let stage = data.stage.unwrap_or(0);
                    commits_by_id.entry(cid).or_default().push((col_id, stage));
                }
            }
            // Map commit_id -> name from the reverse of commit_name_to_id.
            for (name, &cid) in &self.commit_name_to_id {
                commit_names.insert(cid, name.clone());
            }

            let mut sorted_cids: Vec<u32> = commits_by_id.keys().cloned().collect();
            sorted_cids.sort();

            for cid in sorted_cids {
                let cols = commits_by_id.get(&cid).unwrap();
                let commit_name = commit_names.get(&cid).cloned().unwrap_or_default();

                // Group by stage and build stage_widths (0-based stages
                // for custom commits, matching JS behavior).
                let mut stages_map: HashMap<u32, Vec<u32>> = HashMap::new();
                for &(col_id, stage) in cols {
                    stages_map.entry(stage).or_default().push(col_id);
                }
                let max_stage = stages_map.keys().max().copied().unwrap_or(0);
                let mut sw = Vec::new();
                let mut sorted_stages: Vec<u32> = stages_map.keys().cloned().collect();
                sorted_stages.sort();
                for stage in 0..=max_stage {
                    let count = stages_map.get(&stage).map(|v| v.len() as u32).unwrap_or(0);
                    sw.push(count);
                    if let Some(ids) = stages_map.get(&stage) {
                        for (idx, &col_id) in ids.iter().enumerate() {
                            while cid_map.len() <= col_id as usize {
                                cid_map.push((0, 0, 0));
                            }
                            cid_map[col_id as usize] = (stage, idx as u32, cid);
                        }
                    }
                }
                // Get public IDs for this commit.
                let pub_ids = self.commit_publics
                    .get(&commit_name)
                    .cloned()
                    .unwrap_or_default();
                commits.push((commit_name, sw, pub_ids));
            }
            (cid_map, commits)
        };

        // Build air value stages.
        let air_value_stages: Vec<u32> = {
            let mut stages = Vec::new();
            for avid in 0..self.air_values.len() {
                let stage = self.air_values.get_data(avid)
                    .and_then(|d| d.stage)
                    .unwrap_or(1);
                stages.push(stage);
            }
            stages
        };

        // Check if AIR has external fixed files (set by extern_fixed_file pragma).
        let has_extern_fixed = self.air_stack.last()
            .map(|a| a.has_extern_fixed)
            .unwrap_or(false);

        // Get output_fixed_file from the air stack (set by pragma).
        let output_fixed_file = self.air_stack.last()
            .and_then(|a| a.output_fixed_file.clone());

        // Collect per-AIR symbol entries from label ranges before scope
        // clearing destroys them. This mirrors the JS `setSymbolsFromLabels`
        // calls during `airGroupProtoOut`.
        let air_symbols: Vec<air::SymbolEntry> = {
            let mut syms = Vec::new();
            let air_name = self.air_stack.last().map(|a| a.name.clone()).unwrap_or_default();

            // Witness symbols from label ranges.
            for lr in self.witness_cols.label_ranges.to_vec() {
                let src = self.witness_cols.get_data(lr.from)
                    .map(|d| d.source_ref.clone())
                    .unwrap_or_default();
                syms.push(air::SymbolEntry {
                    name: lr.label.clone(),
                    ref_type_str: "witness".to_string(),
                    internal_id: lr.from,
                    dim: lr.array_dims.len() as u32,
                    lengths: lr.array_dims.clone(),
                    source_ref: src,
                });
            }

            // Fixed symbols from non-temporal label ranges.
            for lr in self.fixed_cols.get_non_temporal_labels() {
                let src = self.fixed_cols.ids.get_data(lr.from)
                    .map(|d| d.source_ref.clone())
                    .unwrap_or_default();
                syms.push(air::SymbolEntry {
                    name: lr.label.clone(),
                    ref_type_str: "fixed".to_string(),
                    internal_id: lr.from,
                    dim: lr.array_dims.len() as u32,
                    lengths: lr.array_dims.clone(),
                    source_ref: src,
                });
            }

            // Custom column symbols from label ranges.
            for lr in self.custom_cols.label_ranges.to_vec() {
                let src = self.custom_cols.get_data(lr.from)
                    .map(|d| d.source_ref.clone())
                    .unwrap_or_default();
                syms.push(air::SymbolEntry {
                    name: lr.label.clone(),
                    ref_type_str: "customcol".to_string(),
                    internal_id: lr.from,
                    dim: lr.array_dims.len() as u32,
                    lengths: lr.array_dims.clone(),
                    source_ref: src,
                });
            }

            // Air value symbols from label ranges.
            for lr in self.air_values.label_ranges.to_vec() {
                let src = self.air_values.get_data(lr.from)
                    .map(|d| d.source_ref.clone())
                    .unwrap_or_default();
                syms.push(air::SymbolEntry {
                    name: lr.label.clone(),
                    ref_type_str: "airvalue".to_string(),
                    internal_id: lr.from,
                    dim: lr.array_dims.len() as u32,
                    lengths: lr.array_dims.clone(),
                    source_ref: src,
                });
            }

            // Intermediate (im) symbols from expression labels. In JS,
            // expression labels are collected from the packed expressions;
            // here we use the exprs variable store's label ranges.
            for lr in self.exprs.ids.label_ranges.to_vec() {
                syms.push(air::SymbolEntry {
                    name: format!("{}_{}", air_name, lr.label),
                    ref_type_str: "im".to_string(),
                    internal_id: lr.from,
                    dim: lr.array_dims.len() as u32,
                    lengths: lr.array_dims.clone(),
                    source_ref: String::new(),
                });
            }

            syms
        };

        // Store per-AIR data (constraints, expressions, column maps) in the
        // airgroup's air entry before clearing.
        if !is_virtual {
            if let Some(air_on_stack) = self.air_stack.last() {
                let air_id = air_on_stack.id;
                if let Some(ag) = self.air_groups.get_mut(&ag_name) {
                    if let Some(stored_air) = ag.airs.iter_mut().find(|a| a.id == air_id) {
                        stored_air.store_constraints(&self.constraints);
                        stored_air.store_air_expressions(&air_expr_store);
                        stored_air.fixed_id_map = fixed_id_map;
                        stored_air.witness_id_map = witness_id_map;
                        stored_air.stage_widths = stage_widths;
                        stored_air.custom_id_map = custom_id_map;
                        stored_air.custom_commits = custom_commits;
                        stored_air.air_value_stages = air_value_stages;
                        stored_air.has_extern_fixed = has_extern_fixed;
                        stored_air.symbols = air_symbols;
                        stored_air.output_fixed_file = output_fixed_file.clone();
                    }
                }
            }
        }

        // Write fixed columns to binary file before clearing.
        // Skip if the AIR uses extern_fixed_file (data provided externally)
        // or if it's a virtual AIR (virtual AIRs don't produce fixed output).
        // Use output_fixed_file pragma filename if set, otherwise default
        // to "{air_name}.fixed".
        if self.config.fixed_to_file && !has_extern_fixed && !is_virtual {
            if let Some(ref output_dir) = self.config.output_dir.clone() {
                if let Some(air) = self.air_stack.last() {
                    // Only write if there are non-temporal, non-external fixed
                    // columns with actual data.
                    let fc_s = self.fixed_cols.current_start();
                    let fc_e = fc_s + self.fixed_cols.len();
                    let has_writable_cols = (fc_s..fc_e).any(|id| {
                        if let Some(data) = self.fixed_cols.ids.get_data(id) {
                            !data.temporal && !data.external
                        } else {
                            true
                        }
                    });
                    if has_writable_cols {
                        // Determine the output filename: use pragma-set name or default.
                        let default_name = format!("{}.fixed", air.name);
                        let fixed_filename = output_fixed_file.as_deref()
                            .unwrap_or(&default_name);
                        if let Err(e) = crate::proto_out::write_fixed_cols_to_file(
                            &self.fixed_cols,
                            air.rows,
                            output_dir,
                            fixed_filename,
                        ) {
                            eprintln!("  > Warning: failed to write fixed cols: {}", e);
                        }
                    }
                }
            }
        }

        // Clean up air scope.
        self.constraints.clear();
        self.scope.pop_instance_type();
        self.namespace_ctx.pop();
        self.air_stack.pop();

        // Update built-in constants back.
        let (bits_val, air_id_val, air_name_val) = if let Some(air) = self.air_stack.last() {
            (air.bits as i128, air.id as i128, air.name.clone())
        } else {
            (0, -1, String::new())
        };
        self.set_builtin_int("BITS", bits_val);
        self.set_builtin_int("AIR_ID", air_id_val);
        self.set_builtin_string("AIR_NAME", &air_name_val);
        if self.air_stack.is_empty() {
        }

        let (to_unset, to_restore) = self.scope.pop();
        self.apply_scope_cleanup(&to_unset, &to_restore);
        self.callstack.pop();
        self.function_deep -= 1;

        // Pop expr store to restore proof-level expressions.
        self.exprs.pop();

        // Clear air-scoped column stores and their references.
        // Mirrors JS clearAirScope() which calls clearType for each column type.
        self.fixed_cols.clear();
        self.witness_cols.clear();
        self.custom_cols.clear();
        self.air_values.clear();
        self.references.clear_type(&RefType::Fixed);
        self.references.clear_type(&RefType::Witness);
        self.references.clear_type(&RefType::CustomCol);
        self.references.clear_type(&RefType::AirValue);
        // Clear air-scoped containers (names starting with "air.").
        self.references.clear_air_containers();
        self.commit_name_to_id.clear();
        self.next_commit_id = 0;
        self.commit_publics.clear();

        Value::Int(0)
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
        if !self.references.create_container(&name, alias) {
            return FlowSignal::None;
        }
        if let Some(body) = &cd.body {
            self.execute_statements(body);
        }
        self.references.close_container();
        FlowSignal::None
    }

    fn exec_use(&mut self, ud: &UseDef) -> FlowSignal {
        let name = self.expand_templates(&ud.name);
        let alias = ud.alias.as_deref();
        self.references.add_use(&name, alias);
        FlowSignal::None
    }

    fn exec_package_block(&mut self, pd: &PackageDef) -> FlowSignal {
        self.scope.push();
        self.scope
            .set_value("package", Value::Str(pd.name.clone()));
        let result = self.execute_statements(&pd.body);
        let (to_unset, to_restore) = self.scope.pop();
        self.apply_scope_cleanup(&to_unset, &to_restore);
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
                    self.execute_user_function(&func, &[]);
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
    // Hint handling
    // -----------------------------------------------------------------------

    fn exec_hint(&mut self, _h: &HintStmt) -> FlowSignal {
        // Hints are collected for protobuf output. Simplified here.
        FlowSignal::None
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

/// Compute a flat index from multi-dimensional indexes and dimensions.
fn compute_flat_index(indexes: &[i128], dims: &[u32]) -> u32 {
    if indexes.is_empty() || dims.is_empty() {
        return 0;
    }
    let mut flat = 0u32;
    let mut stride = 1u32;
    for i in (0..indexes.len().min(dims.len())).rev() {
        flat += (indexes[i] as u32) * stride;
        stride *= dims[i];
    }
    flat
}

/// Reorder call arguments when some are named so that each value lands at the
/// position matching the function definition's parameter list.  Positional
/// arguments stay in their original slots; named arguments are placed at the
/// parameter index whose name matches.
fn reorder_named_args(
    call_args: &[CallArg],
    raw_values: &[Value],
    func_params: &[FunctionArg],
) -> Vec<Value> {
    let n = func_params.len();
    let mut result: Vec<Option<Value>> = vec![None; n];

    // First pass: place named arguments by matching parameter name.
    let mut used_positions: Vec<bool> = vec![false; n];
    for (i, call_arg) in call_args.iter().enumerate() {
        if let Some(ref arg_name) = call_arg.name {
            // Find the parameter position for this name.
            if let Some(pos) = func_params.iter().position(|p| &p.name == arg_name) {
                result[pos] = raw_values.get(i).cloned();
                used_positions[pos] = true;
            }
        }
    }

    // Second pass: fill remaining slots with positional (unnamed) arguments.
    let mut positional_iter = call_args
        .iter()
        .enumerate()
        .filter(|(_, a)| a.name.is_none());
    for pos in 0..n {
        if used_positions[pos] {
            continue;
        }
        if let Some((i, _)) = positional_iter.next() {
            result[pos] = raw_values.get(i).cloned();
        }
    }

    // Convert to final Vec, defaulting to Void for missing slots.
    result.into_iter().map(|v| v.unwrap_or(Value::Void)).collect()
}

/// Convert a Value to a RuntimeExpr.
/// Check if a Value is "symbolic" (a column reference or runtime
/// expression) rather than a simple compile-time constant.
fn is_symbolic(val: &Value) -> bool {
    matches!(val, Value::ColRef { .. } | Value::RuntimeExpr(_))
}

fn value_to_runtime_expr(val: &Value) -> RuntimeExpr {
    match val {
        Value::ColRef {
            col_type,
            id,
            row_offset,
        } => RuntimeExpr::ColRef {
            col_type: *col_type,
            id: *id,
            row_offset: *row_offset,
        },
        Value::RuntimeExpr(expr) => *expr.clone(),
        _ => RuntimeExpr::Value(val.clone()),
    }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

#[cfg(test)]
mod tests {
    use super::*;

    fn make_processor() -> Processor {
        Processor::new(CompilerConfig::default())
    }

    #[test]
    fn test_processor_creation() {
        let p = make_processor();
        assert_eq!(p.scope.deep, 0);
        assert!(p.references.is_defined("println"));
        assert!(p.references.is_defined("assert"));
        assert!(p.references.is_defined("log2"));
    }

    #[test]
    fn test_execute_empty_program() {
        let mut p = make_processor();
        let prog = Program {
            statements: vec![],
        };
        let result = p.execute_program(&prog);
        assert!(result);
    }

    #[test]
    fn test_eval_number() {
        let mut p = make_processor();
        let expr = Expr::Number(NumericLiteral {
            value: "42".to_string(),
            radix: NumericRadix::Decimal,
        });
        assert_eq!(p.eval_expr(&expr), Value::Int(42));
    }

    #[test]
    fn test_eval_binary_op() {
        let mut p = make_processor();
        let expr = Expr::BinaryOp {
            op: BinOp::Add,
            left: Box::new(Expr::Number(NumericLiteral {
                value: "3".to_string(),
                radix: NumericRadix::Decimal,
            })),
            right: Box::new(Expr::Number(NumericLiteral {
                value: "4".to_string(),
                radix: NumericRadix::Decimal,
            })),
        };
        assert_eq!(p.eval_expr(&expr), Value::Int(7));
    }

    #[test]
    fn test_eval_ternary() {
        let mut p = make_processor();
        let expr = Expr::Ternary {
            condition: Box::new(Expr::Number(NumericLiteral {
                value: "1".to_string(),
                radix: NumericRadix::Decimal,
            })),
            then_expr: Box::new(Expr::Number(NumericLiteral {
                value: "10".to_string(),
                radix: NumericRadix::Decimal,
            })),
            else_expr: Box::new(Expr::Number(NumericLiteral {
                value: "20".to_string(),
                radix: NumericRadix::Decimal,
            })),
        };
        assert_eq!(p.eval_expr(&expr), Value::Int(10));
    }

    #[test]
    fn test_variable_declaration_and_assignment() {
        let mut p = make_processor();
        // Simulate: const int X = 42;
        let vd = VariableDeclaration {
            is_const: true,
            vtype: TypeKind::Int,
            items: vec![VarDeclItem {
                name: "X".to_string(),
                array_dims: vec![],
            }],
            init: Some(Expr::Number(NumericLiteral {
                value: "42".to_string(),
                radix: NumericRadix::Decimal,
            })),
            is_multiple: false,
        };
        p.exec_variable_declaration(&vd);
        let val = p.eval_expr(&Expr::Reference(NameId {
            path: "X".to_string(),
            indexes: vec![],
            row_offset: None,
        }));
        assert_eq!(val, Value::Int(42));
    }

    #[test]
    fn test_for_loop() {
        let mut p = make_processor();
        // for (int i = 0; i < 5; i = i + 1) { }
        // After the loop, i is gone (scoped). We test the loop executes.
        let for_stmt = ForStmt {
            init: Box::new(Statement::VariableDeclaration(VariableDeclaration {
                is_const: false,
                vtype: TypeKind::Int,
                items: vec![VarDeclItem {
                    name: "i".to_string(),
                    array_dims: vec![],
                }],
                init: Some(Expr::Number(NumericLiteral {
                    value: "0".to_string(),
                    radix: NumericRadix::Decimal,
                })),
                is_multiple: false,
            })),
            condition: Expr::BinaryOp {
                op: BinOp::Lt,
                left: Box::new(Expr::Reference(NameId {
                    path: "i".to_string(),
                    indexes: vec![],
                    row_offset: None,
                })),
                right: Box::new(Expr::Number(NumericLiteral {
                    value: "5".to_string(),
                    radix: NumericRadix::Decimal,
                })),
            },
            increment: vec![Assignment {
                target: NameId {
                    path: "i".to_string(),
                    indexes: vec![],
                    row_offset: None,
                },
                op: AssignOp::Assign,
                value: AssignValue::Expr(Expr::BinaryOp {
                    op: BinOp::Add,
                    left: Box::new(Expr::Reference(NameId {
                        path: "i".to_string(),
                        indexes: vec![],
                        row_offset: None,
                    })),
                    right: Box::new(Expr::Number(NumericLiteral {
                        value: "1".to_string(),
                        radix: NumericRadix::Decimal,
                    })),
                }),
            }],
            body: vec![],
        };
        let result = p.exec_for(&for_stmt);
        assert!(matches!(result, FlowSignal::None));
    }

    #[test]
    fn test_if_then_else() {
        let mut p = make_processor();
        // Declare result first.
        let vd = VariableDeclaration {
            is_const: false,
            vtype: TypeKind::Int,
            items: vec![VarDeclItem {
                name: "result".to_string(),
                array_dims: vec![],
            }],
            init: Some(Expr::Number(NumericLiteral {
                value: "0".to_string(),
                radix: NumericRadix::Decimal,
            })),
            is_multiple: false,
        };
        p.exec_variable_declaration(&vd);

        let if_stmt = IfStmt {
            condition: Expr::Number(NumericLiteral {
                value: "0".to_string(),
                radix: NumericRadix::Decimal,
            }),
            then_body: vec![Statement::Assignment(Assignment {
                target: NameId {
                    path: "result".to_string(),
                    indexes: vec![],
                    row_offset: None,
                },
                op: AssignOp::Assign,
                value: AssignValue::Expr(Expr::Number(NumericLiteral {
                    value: "1".to_string(),
                    radix: NumericRadix::Decimal,
                })),
            })],
            elseif_clauses: vec![],
            else_body: Some(vec![Statement::Assignment(Assignment {
                target: NameId {
                    path: "result".to_string(),
                    indexes: vec![],
                    row_offset: None,
                },
                op: AssignOp::Assign,
                value: AssignValue::Expr(Expr::Number(NumericLiteral {
                    value: "2".to_string(),
                    radix: NumericRadix::Decimal,
                })),
            })]),
        };
        p.exec_if(&if_stmt);

        let val = p.eval_expr(&Expr::Reference(NameId {
            path: "result".to_string(),
            indexes: vec![],
            row_offset: None,
        }));
        assert_eq!(val, Value::Int(2)); // condition was 0 (false), so else branch
    }

    #[test]
    fn test_compute_flat_index() {
        assert_eq!(compute_flat_index(&[2, 3], &[4, 5]), 2 * 5 + 3);
        assert_eq!(compute_flat_index(&[0], &[10]), 0);
        assert_eq!(compute_flat_index(&[], &[]), 0);
    }

    #[test]
    fn test_expand_templates() {
        let mut p = make_processor();
        // Declare a variable N = 16.
        let vd = VariableDeclaration {
            is_const: false,
            vtype: TypeKind::Int,
            items: vec![VarDeclItem {
                name: "MY_VAR".to_string(),
                array_dims: vec![],
            }],
            init: Some(Expr::Number(NumericLiteral {
                value: "16".to_string(),
                radix: NumericRadix::Decimal,
            })),
            is_multiple: false,
        };
        p.exec_variable_declaration(&vd);
        let result = p.expand_templates("size_${MY_VAR}");
        assert_eq!(result, "size_16");
    }
}
