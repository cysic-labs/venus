//! Scope and context management: variable bindings, function definitions,
//! namespace hierarchy.
//!
//! Mirrors the JS `Context` singleton and `Scope` classes. The Rust version
//! keeps a non-global struct that the `Processor` owns.

use std::collections::HashMap;

use super::expression::Value;
use super::references::Reference;

/// Configuration for a compilation run.
#[derive(Debug, Clone, Default)]
pub struct CompilerConfig {
    pub name: String,
    pub output_file: Option<String>,
    pub output_dir: Option<String>,
    pub fixed_to_file: bool,
    pub defines: std::collections::BTreeMap<String, i128>,
    pub verbose: bool,
    pub log_hints: bool,
    pub log_deferred_calls: bool,
    pub output_constraints: bool,
    pub debug_witness_cols: bool,
    pub debug_fixed_cols: bool,
    pub proto_out: bool,
}

/// Manages the lexical scope stack, including variable shadowing and
/// scope labels (proof, airgroup, air).
///
/// Mirrors JS `Scope`.
#[derive(Debug, Clone)]
pub struct Scope {
    pub deep: u32,
    /// Per-level shadow records: when a variable is redeclared in an inner
    /// scope, the old binding is saved here so it can be restored on pop.
    shadows: Vec<HashMap<String, ShadowEntry>>,
    /// Named labels that mark specific scope depths.
    labels: HashMap<String, u32>,
    /// Stack of instance types (proof, airgroup, air).
    instance_type_stack: Vec<String>,
    pub instance_type: String,
    /// Per-level key-value store (analogous to JS `Scope.values`).
    values: Vec<HashMap<String, Value>>,
}

#[derive(Debug, Clone)]
enum ShadowEntry {
    /// Variable was freshly declared; on pop, remove it.
    New,
    /// Variable shadowed an existing binding; on pop, restore the
    /// full Reference so that the references table is properly unwound.
    Shadowed(Reference),
}

impl Scope {
    pub fn new() -> Self {
        Self {
            deep: 0,
            shadows: vec![HashMap::new()],
            labels: HashMap::new(),
            instance_type_stack: Vec::new(),
            instance_type: "air".to_string(),
            values: vec![HashMap::new()],
        }
    }

    /// Mark the current depth with a label (e.g. "proof", "airgroup").
    pub fn mark(&mut self, label: &str) {
        self.labels.insert(label.to_string(), self.deep);
    }

    /// Get the scope depth for a label, or the current depth if no label.
    pub fn get_scope_id(&self, label: Option<&str>) -> Option<u32> {
        match label {
            None => Some(self.deep),
            Some(lbl) => self.labels.get(lbl).copied(),
        }
    }

    /// Push a new scope level.
    pub fn push(&mut self) {
        self.deep += 1;
        while self.shadows.len() <= self.deep as usize {
            self.shadows.push(HashMap::new());
        }
        self.shadows[self.deep as usize].clear();
        while self.values.len() <= self.deep as usize {
            self.values.push(HashMap::new());
        }
        self.values[self.deep as usize].clear();
    }

    /// Pop the current scope level, returning names that should be unset
    /// and names with their saved References to restore.
    pub fn pop(&mut self) -> (Vec<String>, Vec<(String, Reference)>) {
        let mut to_unset = Vec::new();
        let mut to_restore = Vec::new();

        if let Some(shadow_map) = self.shadows.get(self.deep as usize) {
            for (name, entry) in shadow_map.iter() {
                match entry {
                    ShadowEntry::New => to_unset.push(name.clone()),
                    ShadowEntry::Shadowed(reference) => {
                        to_restore.push((name.clone(), reference.clone()));
                    }
                }
            }
        }

        // Purge labels deeper than the new depth.
        if self.deep > 0 {
            self.deep -= 1;
        }
        self.labels.retain(|_, d| *d <= self.deep);
        (to_unset, to_restore)
    }

    /// Record that `name` was declared at the current scope depth.
    /// If `previous` is Some, it means there was an existing Reference
    /// binding that needs restoring on scope exit.
    pub fn declare(&mut self, name: &str, previous: Option<Reference>) {
        let entry = match previous {
            Some(reference) => ShadowEntry::Shadowed(reference),
            None => ShadowEntry::New,
        };
        if let Some(shadow_map) = self.shadows.get_mut(self.deep as usize) {
            shadow_map.insert(name.to_string(), entry);
        }
    }

    /// Push a new instance type (proof -> airgroup -> air).
    pub fn push_instance_type(&mut self, itype: &str) {
        self.instance_type_stack.push(self.instance_type.clone());
        self.instance_type = itype.to_string();
        self.push();
        self.mark(itype);
    }

    /// Pop the current instance type, restoring the previous one.
    pub fn pop_instance_type(&mut self) -> (Vec<String>, Vec<(String, Reference)>) {
        let result = self.pop();
        if let Some(prev) = self.instance_type_stack.pop() {
            self.instance_type = prev;
        }
        result
    }

    /// Get the current instance type.
    pub fn get_instance_type(&self) -> &str {
        &self.instance_type
    }

    /// Set a value at the current scope level.
    pub fn set_value(&mut self, name: &str, value: Value) {
        if let Some(map) = self.values.get_mut(self.deep as usize) {
            map.insert(name.to_string(), value);
        }
    }

    /// Get a value, searching from current depth upward.
    pub fn get_value(&self, name: &str) -> Option<&Value> {
        for depth in (0..=self.deep as usize).rev() {
            if let Some(map) = self.values.get(depth) {
                if let Some(val) = map.get(name) {
                    return Some(val);
                }
            }
        }
        None
    }
}

/// Namespace and name-resolution context.
///
/// Mirrors the JS `Context` class's namespace management (push/pop,
/// `getFullName`, `getNames`).
#[derive(Debug, Clone)]
pub struct NamespaceContext {
    pub namespace: String,
    pub namespace_stack: Vec<String>,
    pub air_group_name: String,
}

impl NamespaceContext {
    pub fn new() -> Self {
        Self {
            namespace: String::new(),
            namespace_stack: Vec::new(),
            air_group_name: String::new(),
        }
    }

    /// Push a namespace onto the stack (entering an airgroup, air, etc.).
    pub fn push(&mut self, namespace: &str) {
        self.namespace_stack.push(namespace.to_string());
        self.namespace = namespace.to_string();
    }

    /// Pop the current namespace.
    pub fn pop(&mut self) {
        self.namespace_stack.pop();
        self.namespace = self
            .namespace_stack
            .last()
            .cloned()
            .unwrap_or_default();
    }

    /// Get the full name by prepending the current namespace if not already
    /// qualified.
    pub fn get_full_name(&self, name: &str) -> String {
        if name.contains('.') || self.namespace.is_empty() {
            name.to_string()
        } else {
            format!("{}.{}", self.namespace, name)
        }
    }

    /// Get all possible name resolutions: the bare name, and the name
    /// prefixed with each level in the namespace stack.
    pub fn get_names(&self, name: &str) -> Vec<String> {
        let mut names = vec![name.to_string()];
        if !name.contains('.') {
            for ns in &self.namespace_stack {
                let full = format!("{}.{}", ns, name);
                if !names.contains(&full) {
                    names.push(full);
                }
            }
        }
        names
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_scope_push_pop() {
        let mut scope = Scope::new();
        assert_eq!(scope.deep, 0);
        scope.push();
        assert_eq!(scope.deep, 1);
        scope.declare("x", None);
        let (unset, restore) = scope.pop();
        assert_eq!(scope.deep, 0);
        assert!(unset.contains(&"x".to_string()));
        assert!(restore.is_empty());
    }

    #[test]
    fn test_scope_shadow_restore() {
        use super::super::references::RefType;
        let mut scope = Scope::new();
        scope.push();
        let old_ref = Reference {
            name: "x".to_string(),
            ref_type: RefType::Int,
            is_const: false,
            id: 42,
            scope_id: 0,
            array_dims: Vec::new(),
            source_ref: String::new(),
            is_reference: false,
            label: "x".to_string(),
            is_static: false,
        };
        scope.declare("x", Some(old_ref));
        let (unset, restore) = scope.pop();
        assert!(unset.is_empty());
        assert_eq!(restore.len(), 1);
        assert_eq!(restore[0].0, "x");
        assert_eq!(restore[0].1.id, 42);
    }

    #[test]
    fn test_scope_labels() {
        let mut scope = Scope::new();
        scope.mark("proof");
        assert_eq!(scope.get_scope_id(Some("proof")), Some(0));
        scope.push();
        scope.mark("airgroup");
        assert_eq!(scope.get_scope_id(Some("airgroup")), Some(1));
    }

    #[test]
    fn test_scope_instance_type() {
        let mut scope = Scope::new();
        scope.push_instance_type("proof");
        assert_eq!(scope.get_instance_type(), "proof");
        scope.push_instance_type("airgroup");
        assert_eq!(scope.get_instance_type(), "airgroup");
        scope.pop_instance_type();
        assert_eq!(scope.get_instance_type(), "proof");
    }

    #[test]
    fn test_namespace_full_name() {
        let mut ctx = NamespaceContext::new();
        assert_eq!(ctx.get_full_name("x"), "x");
        ctx.push("MyAir");
        assert_eq!(ctx.get_full_name("x"), "MyAir.x");
        assert_eq!(ctx.get_full_name("A.x"), "A.x"); // already qualified
        ctx.pop();
        assert_eq!(ctx.get_full_name("x"), "x");
    }

    #[test]
    fn test_namespace_get_names() {
        let mut ctx = NamespaceContext::new();
        ctx.push("Group1");
        ctx.push("Air1");
        let names = ctx.get_names("col_a");
        assert!(names.contains(&"col_a".to_string()));
        assert!(names.contains(&"Group1.col_a".to_string()));
        assert!(names.contains(&"Air1.col_a".to_string()));
    }

    #[test]
    fn test_scope_values() {
        let mut scope = Scope::new();
        scope.set_value("pkg", Value::Str("mypackage".into()));
        assert_eq!(
            scope.get_value("pkg"),
            Some(&Value::Str("mypackage".into()))
        );
        scope.push();
        // Visible from inner scope via upward search.
        assert_eq!(
            scope.get_value("pkg"),
            Some(&Value::Str("mypackage".into()))
        );
    }
}
