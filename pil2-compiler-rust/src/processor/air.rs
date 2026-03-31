//! AIR template/instance handling: airgroup and air declarations,
//! parameterized rows.
//!
//! Mirrors the JS `Air`, `AirGroup`, `AirTemplate`, `AirGroups`, and
//! `AirTemplates` classes.

use std::collections::HashMap;

use crate::parser::ast::{FunctionArg, Statement};
use super::constraints::ConstraintEntry;
use super::expression::RuntimeExpr;

/// Hint data value that can appear inside a hint field.
/// Mirrors the JS hint data model: expressions become expression-store IDs,
/// integers/strings are kept as-is, arrays and objects are recursive.
#[derive(Debug, Clone)]
pub enum HintValue {
    /// An integer constant.
    Int(i128),
    /// A string literal.
    Str(String),
    /// An expression stored in the AIR expression store, referenced by index.
    ExprId(u32),
    /// An array of hint values.
    Array(Vec<HintValue>),
    /// An object (ordered key-value pairs) of hint values.
    Object(Vec<(String, HintValue)>),
}

/// A collected hint entry, corresponding to a `@name { ... }` statement.
#[derive(Debug, Clone)]
pub struct HintEntry {
    pub name: String,
    pub data: HintValue,
}

/// A symbol entry collected per-AIR from label ranges and translation maps.
/// These are stored in the Air struct so they survive AIR scope clearing.
#[derive(Debug, Clone)]
pub struct SymbolEntry {
    pub name: String,
    pub ref_type_str: String,
    /// The base internal ID from the label range.
    pub internal_id: u32,
    /// Array dimension count.
    pub dim: u32,
    /// Array dimension sizes.
    pub lengths: Vec<u32>,
    /// Source reference for debug.
    pub source_ref: String,
}

/// An Air instance (one concrete instantiation of an air template).
///
/// Mirrors JS `Air`.
#[derive(Debug, Clone)]
pub struct Air {
    pub id: u32,
    pub air_group_id: u32,
    pub name: String,
    pub template_name: String,
    pub rows: u64,
    pub bits: u32,
    pub is_virtual: bool,
    /// Informational counters set after air execution completes.
    pub info: AirInfo,
    /// Per-AIR constraint entries, captured before clearing.
    pub stored_constraints: Vec<ConstraintEntry>,
    /// Per-AIR expressions referenced by constraints.
    /// Empty when air_expression_store is populated (use
    /// stored_expressions_count instead).
    pub stored_expressions: Vec<RuntimeExpr>,
    /// Number of constraint expressions (used for offset calculation in
    /// proto_out when stored_expressions itself is empty to save memory).
    pub stored_expressions_count: usize,
    /// Full AIR expression store: ALL expressions created during AIR
    /// execution (intermediate column definitions, constraint
    /// sub-expressions, etc.).  Mirrors the JS `this.expressions` store.
    pub air_expression_store: Vec<RuntimeExpr>,
    /// Fixed column ID mappings: dense per-AIR, indexed relative to
    /// `fixed_col_start`.  Entry i corresponds to absolute col ID
    /// `fixed_col_start + i` -> (type char 'F'/'P', proto_index).
    pub fixed_id_map: Vec<(char, u32)>,
    /// First absolute fixed-column ID belonging to this AIR.
    pub fixed_col_start: u32,
    /// Witness column ID mappings: internal id -> (stage, proto_index).
    pub witness_id_map: Vec<(u32, u32)>,
    /// Number of witness columns per stage (1-based stage index).
    pub stage_widths: Vec<u32>,
    /// Custom commit info: (commit_name, stage_widths_vec, public_ids).
    pub custom_commits: Vec<(String, Vec<u32>, Vec<u32>)>,
    /// Custom column ID mappings: internal id -> (stage, proto_index, commit_id).
    pub custom_id_map: Vec<(u32, u32, u32)>,
    /// Air value metadata: per-value stage.
    pub air_value_stages: Vec<u32>,
    /// Whether this AIR has external fixed files (skip .fixed output).
    pub has_extern_fixed: bool,
    /// Loaded extern fixed columns (column name -> (indexes, values)).
    /// Populated by the `extern_fixed_file` pragma.
    pub extern_fixed_cols: Vec<super::fixed_cols::ExternFixedCol>,
    /// Per-AIR symbol entries collected from label ranges before scope clear.
    pub symbols: Vec<SymbolEntry>,
    /// Output fixed file name override (from output_fixed_file pragma).
    pub output_fixed_file: Option<String>,
    /// Per-AIR hint entries collected during execution.
    pub hints: Vec<HintEntry>,
}

/// Summary statistics collected after an air instance completes.
#[derive(Debug, Clone, Default)]
pub struct AirInfo {
    pub witness_cols: Vec<u32>,
    pub fixed_cols: u32,
    pub custom_cols: u32,
    pub constraints: u32,
    pub max_degree: u32,
}

impl Air {
    pub fn new(
        id: u32,
        air_group_id: u32,
        template_name: &str,
        name: &str,
        rows: u64,
        is_virtual: bool,
    ) -> Self {
        let bits = if rows == 0 {
            0
        } else {
            let log = (rows as f64).log2().ceil() as u32;
            if (1u64 << log) == rows { log } else { log }
        };
        Self {
            id,
            air_group_id,
            name: name.to_string(),
            template_name: template_name.to_string(),
            rows,
            bits,
            is_virtual,
            info: AirInfo::default(),
            stored_constraints: Vec::new(),
            stored_expressions: Vec::new(),
            stored_expressions_count: 0,
            air_expression_store: Vec::new(),
            fixed_id_map: Vec::new(),
            fixed_col_start: 0,
            witness_id_map: Vec::new(),
            stage_widths: Vec::new(),
            custom_commits: Vec::new(),
            custom_id_map: Vec::new(),
            air_value_stages: Vec::new(),
            has_extern_fixed: false,
            extern_fixed_cols: Vec::new(),
            symbols: Vec::new(),
            output_fixed_file: None,
            hints: Vec::new(),
        }
    }

    pub fn set_info(&mut self, info: AirInfo) {
        self.info = info;
    }

    /// Capture constraint/expression data from the processor before it
    /// is cleared between AIR template calls. Takes ownership to avoid
    /// cloning large expression trees.
    pub fn store_constraints_owned(
        &mut self,
        entries: Vec<ConstraintEntry>,
        expr_count: usize,
    ) {
        self.stored_constraints = entries;
        self.stored_expressions_count = expr_count;
        // stored_expressions left empty to save memory; proto_out uses
        // air_expression_store when available and only needs the count.
    }

    /// Capture the full AIR expression store (all expressions created
    /// during AIR execution, not just those referenced by constraints).
    /// Takes ownership to avoid cloning large expression trees.
    pub fn store_air_expressions_owned(&mut self, expressions: Vec<RuntimeExpr>) {
        self.air_expression_store = expressions;
    }
}

/// An airgroup: groups one or more airs together.
///
/// Mirrors JS `AirGroup`.
#[derive(Debug, Clone)]
pub struct AirGroup {
    pub name: String,
    id: Option<u32>,
    pub airs: Vec<Air>,
    pub ended: bool,
    /// Air group value metadata: (stage, aggregate_type).
    /// aggregate_type: 0 = SUM, 1 = PROD.
    pub air_group_values: Vec<(u32, i32)>,
}

impl AirGroup {
    pub fn new(name: &str) -> Self {
        Self {
            name: name.to_string(),
            id: None,
            airs: Vec::new(),
            ended: false,
            air_group_values: Vec::new(),
        }
    }

    pub fn get_id(&self) -> Option<u32> {
        self.id
    }

    pub fn set_id(&mut self, id: u32) {
        self.id = Some(id);
    }

    /// Create a new air instance in this airgroup.
    pub fn create_air(
        &mut self,
        air_id: u32,
        template_name: &str,
        name: &str,
        rows: u64,
        is_virtual: bool,
    ) -> &Air {
        let air = Air::new(
            air_id,
            self.id.unwrap_or(0),
            template_name,
            name,
            rows,
            is_virtual,
        );
        self.airs.push(air);
        self.airs.last().unwrap()
    }

    pub fn end(&mut self) {
        self.ended = true;
    }
}

/// Registry of airgroups by name.
///
/// Mirrors JS `AirGroups`.
#[derive(Debug, Clone, Default)]
pub struct AirGroups {
    groups: Vec<AirGroup>,
    name_map: HashMap<String, usize>,
}

impl AirGroups {
    pub fn new() -> Self {
        Self::default()
    }

    /// Define (or retrieve) an airgroup by name.
    pub fn get_or_create(&mut self, name: &str) -> &mut AirGroup {
        if let Some(&idx) = self.name_map.get(name) {
            &mut self.groups[idx]
        } else {
            let idx = self.groups.len();
            self.groups.push(AirGroup::new(name));
            self.name_map.insert(name.to_string(), idx);
            &mut self.groups[idx]
        }
    }

    pub fn get(&self, name: &str) -> Option<&AirGroup> {
        self.name_map.get(name).map(|&idx| &self.groups[idx])
    }

    pub fn get_mut(&mut self, name: &str) -> Option<&mut AirGroup> {
        if let Some(&idx) = self.name_map.get(name) {
            Some(&mut self.groups[idx])
        } else {
            None
        }
    }

    pub fn iter(&self) -> impl Iterator<Item = &AirGroup> {
        self.groups.iter()
    }

    pub fn iter_mut(&mut self) -> impl Iterator<Item = &mut AirGroup> {
        self.groups.iter_mut()
    }
}

/// An air template definition (the blueprint for creating air instances).
///
/// Mirrors JS `AirTemplate`. Stores the AST body and parameter declarations.
#[derive(Debug, Clone)]
pub struct AirTemplateInfo {
    pub name: String,
    pub args: Vec<FunctionArg>,
    pub body: Vec<Statement>,
    /// Methods extracted from the template body.
    pub methods: Vec<String>,
    /// Additional blocks appended via `airtemplate Name { ... }`.
    pub extra_blocks: Vec<Vec<Statement>>,
    /// Base directory for relative includes within this template.
    pub base_dir: Option<String>,
}

impl AirTemplateInfo {
    pub fn new(name: &str, args: Vec<FunctionArg>, body: Vec<Statement>) -> Self {
        Self {
            name: name.to_string(),
            args,
            body,
            methods: Vec::new(),
            extra_blocks: Vec::new(),
            base_dir: None,
        }
    }

    /// Append an extra block of statements.
    pub fn add_block(&mut self, statements: Vec<Statement>) {
        self.extra_blocks.push(statements);
    }

    /// Get the combined body: main body + all extra blocks.
    pub fn all_statements(&self) -> Vec<&Statement> {
        let mut stmts: Vec<&Statement> = self.body.iter().collect();
        for block in &self.extra_blocks {
            stmts.extend(block.iter());
        }
        stmts
    }
}

/// Registry of air templates by name.
///
/// Mirrors JS `AirTemplates`.
#[derive(Debug, Clone, Default)]
pub struct AirTemplates {
    templates: HashMap<String, AirTemplateInfo>,
}

impl AirTemplates {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn define(&mut self, name: &str, info: AirTemplateInfo) -> Result<(), String> {
        if self.templates.contains_key(name) {
            return Err(format!(
                "airtemplate '{}' has been defined previously",
                name
            ));
        }
        self.templates.insert(name.to_string(), info);
        Ok(())
    }

    pub fn get(&self, name: &str) -> Option<&AirTemplateInfo> {
        self.templates.get(name)
    }

    pub fn get_mut(&mut self, name: &str) -> Option<&mut AirTemplateInfo> {
        self.templates.get_mut(name)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_air_bits() {
        let air = Air::new(0, 0, "tpl", "myair", 1024, false);
        assert_eq!(air.bits, 10); // 2^10 = 1024
    }

    #[test]
    fn test_air_bits_non_power_of_2() {
        let air = Air::new(0, 0, "tpl", "myair", 1000, false);
        assert_eq!(air.bits, 10); // ceil(log2(1000)) = 10
    }

    #[test]
    fn test_airgroup_create_air() {
        let mut ag = AirGroup::new("TestGroup");
        ag.set_id(0);
        ag.create_air(0, "tpl", "air1", 256, false);
        ag.create_air(1, "tpl", "air2", 512, false);
        assert_eq!(ag.airs.len(), 2);
        assert_eq!(ag.airs[0].name, "air1");
        assert_eq!(ag.airs[1].bits, 9);
    }

    #[test]
    fn test_airgroups_registry() {
        let mut groups = AirGroups::new();
        groups.get_or_create("Group1");
        groups.get_or_create("Group2");
        assert!(groups.get("Group1").is_some());
        assert!(groups.get("Group2").is_some());
        assert!(groups.get("Group3").is_none());
    }

    #[test]
    fn test_air_template_define() {
        let mut templates = AirTemplates::new();
        let info = AirTemplateInfo::new("Main", vec![], vec![]);
        assert!(templates.define("Main", info).is_ok());
        assert!(templates.get("Main").is_some());

        let info2 = AirTemplateInfo::new("Main", vec![], vec![]);
        assert!(templates.define("Main", info2).is_err());
    }
}
