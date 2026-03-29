//! Reference resolution and management.
//!
//! Mirrors the JS `References` class. Manages the mapping from symbolic
//! names to their type, storage location (ID), and scope information.

use std::collections::HashMap;

use super::context::{NamespaceContext, Scope};
use super::expression::Value;

/// The type of a declared reference.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum RefType {
    Int,
    Fe,
    Str,
    Expr,
    Fixed,
    Witness,
    CustomCol,
    Public,
    Challenge,
    ProofValue,
    AirGroupValue,
    AirValue,
    Function,
    Intermediate,
}

impl RefType {
    /// Parse a type string (as used in the AST / JS processor) into a RefType.
    pub fn from_str(s: &str) -> Option<Self> {
        match s {
            "int" => Some(Self::Int),
            "fe" => Some(Self::Fe),
            "string" => Some(Self::Str),
            "expr" => Some(Self::Expr),
            "fixed" => Some(Self::Fixed),
            "witness" => Some(Self::Witness),
            "customcol" => Some(Self::CustomCol),
            "public" => Some(Self::Public),
            "challenge" => Some(Self::Challenge),
            "proofvalue" => Some(Self::ProofValue),
            "airgroupvalue" => Some(Self::AirGroupValue),
            "airvalue" => Some(Self::AirValue),
            "function" => Some(Self::Function),
            "im" => Some(Self::Intermediate),
            _ => None,
        }
    }

    pub fn as_str(&self) -> &'static str {
        match self {
            Self::Int => "int",
            Self::Fe => "fe",
            Self::Str => "string",
            Self::Expr => "expr",
            Self::Fixed => "fixed",
            Self::Witness => "witness",
            Self::CustomCol => "customcol",
            Self::Public => "public",
            Self::Challenge => "challenge",
            Self::ProofValue => "proofvalue",
            Self::AirGroupValue => "airgroupvalue",
            Self::AirValue => "airvalue",
            Self::Function => "function",
            Self::Intermediate => "im",
        }
    }

    /// Whether this type is scoped (i.e., should be removed when its scope exits).
    pub fn has_scope(&self) -> bool {
        !matches!(
            self,
            Self::Public | Self::ProofValue | Self::Challenge | Self::AirGroupValue
        )
    }
}

/// Information about a declared reference.
#[derive(Debug, Clone)]
pub struct Reference {
    pub name: String,
    pub ref_type: RefType,
    pub is_const: bool,
    /// Allocated ID in the corresponding storage (VariableStore / IdAllocator).
    pub id: u32,
    /// Scope depth at which this reference was declared.
    pub scope_id: u32,
    /// Array dimensions (empty for scalar).
    pub array_dims: Vec<u32>,
    /// Source location string.
    pub source_ref: String,
    /// Whether this is a reference to another reference (the `&type` syntax).
    pub is_reference: bool,
    /// Label used for the reference (may differ from name when inside containers).
    pub label: String,
    /// Whether this is a static (scope-qualified) reference.
    pub is_static: bool,
}

impl Reference {
    /// Compute the total number of elements this reference covers.
    pub fn total_size(&self) -> u32 {
        if self.array_dims.is_empty() {
            1
        } else {
            self.array_dims.iter().copied().product()
        }
    }
}

/// Name-to-reference mapping with visibility, scope, and container support.
///
/// Mirrors the JS `References` class.
#[derive(Debug, Clone)]
pub struct References {
    /// Primary reference table: name -> Reference.
    refs: HashMap<String, Reference>,
    /// Container support: container_name -> { inner_name -> Reference }.
    containers: HashMap<String, HashMap<String, Reference>>,
    /// Currently active container name (if inside a container block).
    current_container: Option<String>,
    /// "Use" aliases: alias -> container_name.
    use_aliases: HashMap<String, String>,
    /// Visibility scope stack for function calls.
    visibility_scope: (u32, Option<u32>),
    visibility_stack: Vec<(u32, Option<u32>)>,
}

impl References {
    pub fn new() -> Self {
        Self {
            refs: HashMap::new(),
            containers: HashMap::new(),
            current_container: None,
            use_aliases: HashMap::new(),
            visibility_scope: (0, None),
            visibility_stack: Vec::new(),
        }
    }

    /// Declare a new reference. Returns the allocated ID.
    pub fn declare(
        &mut self,
        name: &str,
        ref_type: RefType,
        id: u32,
        array_dims: &[u32],
        is_const: bool,
        scope_id: u32,
        source_ref: &str,
    ) -> u32 {
        let reference = Reference {
            name: name.to_string(),
            ref_type,
            is_const,
            id,
            scope_id,
            array_dims: array_dims.to_vec(),
            source_ref: source_ref.to_string(),
            is_reference: false,
            label: name.to_string(),
            is_static: false,
        };

        if let Some(container_name) = &self.current_container {
            let container = self
                .containers
                .entry(container_name.clone())
                .or_default();
            container.insert(name.to_string(), reference);
        } else {
            self.refs.insert(name.to_string(), reference);
        }
        id
    }

    /// Check if a name is defined.
    pub fn is_defined(&self, name: &str) -> bool {
        self.search_definition(name).is_some()
    }

    /// Look up a reference by name, searching the main table, containers,
    /// and use-aliases.
    pub fn get_reference(&self, name: &str) -> Option<&Reference> {
        self.search_definition(name)
    }

    /// Get a mutable reference to a Reference by name.
    pub fn get_reference_mut(&mut self, name: &str) -> Option<&mut Reference> {
        if self.refs.contains_key(name) {
            return self.refs.get_mut(name);
        }

        // Find which container holds this name and do the mutable lookup
        // in a single step to satisfy the borrow checker.
        let container_key = self.find_container_for_mut(name);
        if let Some(key) = container_key {
            return self.containers.get_mut(&key)
                .and_then(|c| c.get_mut(name));
        }

        // Search dotted containers.
        if name.contains('.') {
            let parts: Vec<&str> = name.split('.').collect();
            if parts.len() > 1 {
                let container_name = parts[..parts.len() - 1].join(".");
                let inner_name = parts.last().unwrap().to_string();
                return self.containers.get_mut(&container_name)
                    .and_then(|c| c.get_mut(&inner_name));
            }
        }
        None
    }

    /// Helper: find which container holds an unqualified name.
    /// Returns the container key, or None. Used by get_reference_mut.
    fn find_container_for_mut(&self, name: &str) -> Option<String> {
        // Check current container first.
        if let Some(cname) = &self.current_container {
            if let Some(container) = self.containers.get(cname) {
                if container.contains_key(name) {
                    return Some(cname.clone());
                }
            }
        }

        // For unqualified names, check use-aliased containers.
        if !name.contains('.') {
            for target in self.use_aliases.values() {
                if let Some(container) = self.containers.get(target) {
                    if container.contains_key(name) {
                        return Some(target.clone());
                    }
                }
            }
        }
        None
    }

    /// Search for a reference definition by name (mirrors JS `searchDefinition`).
    fn search_definition(&self, name: &str) -> Option<&Reference> {
        // Direct lookup.
        if let Some(r) = self.refs.get(name) {
            return Some(r);
        }

        // Check current container for unqualified names.
        if let Some(container_name) = &self.current_container {
            if let Some(container) = self.containers.get(container_name) {
                if let Some(r) = container.get(name) {
                    return Some(r);
                }
            }
        }

        if !name.contains('.') {
            // For unqualified names, also check all use-aliased containers.
            // `use proof.std.rc` makes inner names of `proof.std.rc` directly
            // accessible without qualification.
            for (_alias, target) in &self.use_aliases {
                if let Some(container) = self.containers.get(target) {
                    if let Some(r) = container.get(name) {
                        return Some(r);
                    }
                }
            }
            return None;
        }

        // Try dotted name: container.inner_name.
        let parts: Vec<&str> = name.split('.').collect();
        if parts.len() > 1 {
            let container_candidate = parts[..parts.len() - 1].join(".");
            let inner_name = parts[parts.len() - 1];

            // Check if first part is a use-alias.
            if let Some(container_name) = self.use_aliases.get(parts[0]) {
                let resolved = format!("{}.{}", container_name, parts[1..].join("."));
                if let Some(r) = self.refs.get(&resolved) {
                    return Some(r);
                }
                // Also try the resolved name as a container lookup.
                let resolved_parts: Vec<&str> = resolved.split('.').collect();
                if resolved_parts.len() > 1 {
                    let rc = resolved_parts[..resolved_parts.len() - 1].join(".");
                    let rn = resolved_parts[resolved_parts.len() - 1];
                    if let Some(container) = self.containers.get(&rc) {
                        if let Some(r) = container.get(rn) {
                            return Some(r);
                        }
                    }
                }
            }

            // Check explicit containers.
            if let Some(container) = self.containers.get(&container_candidate) {
                if let Some(r) = container.get(inner_name) {
                    return Some(r);
                }
            }
        }

        None
    }

    /// Search for a reference by trying multiple name candidates.
    pub fn get_reference_multi(&self, names: &[String]) -> Option<&Reference> {
        for name in names {
            if let Some(r) = self.search_definition(name) {
                return Some(r);
            }
        }
        None
    }

    /// Remove a reference by name.
    pub fn unset(&mut self, name: &str) {
        self.refs.remove(name);
    }

    /// Remove all references of a given type (for clearing air-scoped columns).
    /// Also clears matching entries from containers.
    pub fn clear_type(&mut self, ref_type: &RefType) {
        self.refs.retain(|_, r| &r.ref_type != ref_type);
        for container in self.containers.values_mut() {
            container.retain(|_, r| &r.ref_type != ref_type);
        }
    }

    /// Remove air-scoped containers (names starting with "air.") and
    /// use-aliases pointing to them. Mirrors JS `references.clearScope('air')`.
    pub fn clear_air_containers(&mut self) {
        let air_keys: Vec<String> = self.containers.keys()
            .filter(|k| k.starts_with("air.") || *k == "air")
            .cloned()
            .collect();
        for key in &air_keys {
            self.containers.remove(key);
        }
        // Remove use-aliases that point to removed containers.
        self.use_aliases.retain(|_, v| {
            !v.starts_with("air.") && v != "air"
        });
    }

    /// Restore a previously saved reference binding.
    pub fn restore(&mut self, name: &str, reference: Reference) {
        self.refs.insert(name.to_string(), reference);
    }

    /// Start a container block.
    pub fn create_container(&mut self, name: &str, alias: Option<&str>) -> bool {
        if self.containers.contains_key(name) {
            // Container already exists, reopen.
            self.current_container = Some(name.to_string());
            return true;
        }
        self.containers.insert(name.to_string(), HashMap::new());
        self.current_container = Some(name.to_string());
        if let Some(a) = alias {
            self.use_aliases.insert(a.to_string(), name.to_string());
        }
        true
    }

    /// Close the current container block.
    pub fn close_container(&mut self) {
        self.current_container = None;
    }

    /// Whether we are currently inside a container block.
    pub fn inside_container(&self) -> bool {
        self.current_container.is_some()
    }

    /// Register a `use` alias.
    pub fn add_use(&mut self, name: &str, alias: Option<&str>) {
        if let Some(a) = alias {
            self.use_aliases.insert(a.to_string(), name.to_string());
        } else {
            self.use_aliases.insert(name.to_string(), name.to_string());
        }
    }

    /// Check if a container is defined.
    pub fn is_container_defined(&self, name: &str) -> bool {
        self.containers.contains_key(name)
    }

    /// Check if the current container already has a variable by name.
    /// Used to avoid re-initializing container variables on re-open.
    pub fn container_has_var(&self, name: &str) -> bool {
        if let Some(container_name) = &self.current_container {
            if let Some(container) = self.containers.get(container_name) {
                return container.contains_key(name);
            }
        }
        false
    }

    /// Push visibility scope (for function calls).
    pub fn push_visibility_scope(&mut self, creation_scope: Option<u32>) {
        self.visibility_stack.push(self.visibility_scope);
        self.visibility_scope = (0, creation_scope); // simplified
    }

    /// Pop visibility scope.
    pub fn pop_visibility_scope(&mut self) {
        if let Some(prev) = self.visibility_stack.pop() {
            self.visibility_scope = prev;
        }
    }

    /// Iterate over all references.
    pub fn iter(&self) -> impl Iterator<Item = (&String, &Reference)> {
        self.refs.iter()
    }

    /// Iterate over references of specific types.
    pub fn iter_of_types<'a>(
        &'a self,
        types: &'a [RefType],
    ) -> impl Iterator<Item = (&String, &Reference)> + 'a {
        self.refs
            .iter()
            .filter(move |(_, r)| types.contains(&r.ref_type))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_declare_and_lookup() {
        let mut refs = References::new();
        refs.declare("x", RefType::Int, 0, &[], false, 0, "test:1");
        assert!(refs.is_defined("x"));
        assert!(!refs.is_defined("y"));
        let r = refs.get_reference("x").unwrap();
        assert_eq!(r.ref_type, RefType::Int);
        assert_eq!(r.id, 0);
    }

    #[test]
    fn test_container() {
        let mut refs = References::new();
        refs.create_container("MyContainer", None);
        refs.declare("a", RefType::Witness, 0, &[], false, 0, "test:1");
        refs.close_container();

        // Direct lookup should fail.
        assert!(!refs.is_defined("a"));
        // Qualified lookup should work.
        assert!(refs.is_defined("MyContainer.a"));
    }

    #[test]
    fn test_use_alias() {
        let mut refs = References::new();
        refs.create_container("LongContainerName", Some("lc"));
        refs.declare("col_x", RefType::Fixed, 0, &[], false, 0, "test:1");
        refs.close_container();
        refs.add_use("LongContainerName", Some("lc"));

        assert!(refs.is_defined("lc.col_x"));
    }

    #[test]
    fn test_unset_and_restore() {
        let mut refs = References::new();
        refs.declare("x", RefType::Int, 0, &[], false, 0, "test:1");
        let saved = refs.get_reference("x").unwrap().clone();
        refs.unset("x");
        assert!(!refs.is_defined("x"));
        refs.restore("x", saved);
        assert!(refs.is_defined("x"));
    }
}
