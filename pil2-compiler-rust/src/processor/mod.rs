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
        self.scope.pop_instance_type();

        self.test_summary();

        let elapsed = start.elapsed();
        eprintln!(
            "  > Total compilation: {:.2}ms",
            elapsed.as_secs_f64() * 1000.0
        );

        if self.tests.active {
            self.tests.fail == 0
        } else {
            true
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
                        Value::Void
                    }
                }
            }
            Expr::UnaryOp { op, operand } => {
                let val = self.eval_expr(operand);
                if let Some(v) = val.as_int() {
                    eval_unaryop_int(op, v)
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
                // Member access: a.b  -- treated as dotted name.
                let base_val = self.eval_expr(base);
                let _ = member;
                base_val
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
            let instance_name = alias.unwrap_or(name);
            self.execute_air_template_call(&tpl, &args, instance_name, is_virtual);
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
                    let id = self.fixed_cols.reserve(
                        size,
                        Some(&full_name),
                        &array_dims,
                        data,
                    );

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
                ColType::Custom(_commit_name) => {
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
        for item in &agvd.items {
            let name = &item.name;
            let id = self.air_group_values.reserve(
                1,
                Some(name),
                &[],
                IdData {
                    source_ref: self.source_ref.clone(),
                    stage: agvd.stage.map(|s| s as u32),
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

    fn exec_commit_declaration(&mut self, _cd: &CommitDeclaration) -> FlowSignal {
        // Commit declarations register a commit stage. Simplified for now.
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

        // Clear the error flag so that the caller (airgroup) can
        // continue instantiating more AIRs after this one.
        self.error_raised = false;

        let witness_count = self.witness_cols.len();
        let fixed_count = self.fixed_cols.len();
        let constraint_count = self.constraints.len() as u32;

        eprintln!("  > Witness cols: {}", witness_count);
        eprintln!("  > Fixed cols: {}", fixed_count);
        eprintln!("  > Constraints: {}", constraint_count);

        // Write fixed columns to binary file before clearing.
        if self.config.fixed_to_file {
            if let Some(ref output_dir) = self.config.output_dir.clone() {
                if let Some(air) = self.air_stack.last() {
                    if let Err(e) = crate::proto_out::write_fixed_cols_to_file(
                        &self.fixed_cols,
                        air.rows,
                        output_dir,
                        &air.name,
                    ) {
                        eprintln!("  > Warning: failed to write fixed cols: {}", e);
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

        // Clear air-scoped column stores.
        self.fixed_cols.clear();
        self.witness_cols.clear();
        self.custom_cols.clear();
        self.air_values.clear();

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
        self.references.create_container(&name, alias);
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

        let scope_entry = self
            .deferred_calls
            .entry(scope.clone())
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

    fn call_deferred_functions(&mut self, scope: &str, event: &str) {
        let key = scope.to_string();
        if let Some(scope_map) = self.deferred_calls.get(&key) {
            if let Some(calls) = scope_map.get(event) {
                let call_names: Vec<String> = calls.iter().map(|c| c.function_name.clone()).collect();
                for fname in call_names {
                    if let Some(func) = self.functions.get(&fname).cloned() {
                        self.execute_user_function(&func, &[]);
                    }
                }
            }
        }
        // Clear after execution.
        if let Some(scope_map) = self.deferred_calls.get_mut(&key) {
            scope_map.remove(event);
        }
    }

    fn final_closing_air_groups(&mut self) {
        self.call_deferred_functions("airgroup", "final");
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
    fn expand_templates(&self, text: &str) -> String {
        use std::sync::OnceLock;
        static RE: OnceLock<regex::Regex> = OnceLock::new();

        if !text.contains("${") {
            return text.to_string();
        }
        // Simple template expansion: replace ${NAME} with the value.
        let mut result = text.to_string();
        let re = RE.get_or_init(|| regex::Regex::new(r"\$\{([^}]*)\}").unwrap());
        let captures: Vec<(String, String)> = re
            .captures_iter(text)
            .map(|cap| {
                let full = cap[0].to_string();
                let name = cap[1].to_string();
                let value = self
                    .references
                    .get_reference(&name)
                    .and_then(|r| match r.ref_type {
                        RefType::Int => self.ints.get(r.id).map(|v| v.to_display_string()),
                        RefType::Str => self.strings.get(r.id).map(|v| v.to_display_string()),
                        _ => None,
                    })
                    .unwrap_or_default();
                (full, value)
            })
            .collect();
        for (pattern, replacement) in captures {
            result = result.replace(&pattern, &replacement);
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
