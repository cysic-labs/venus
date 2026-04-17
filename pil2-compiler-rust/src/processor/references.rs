//! Reference resolution and management.
//!
//! Mirrors the JS `References` class. Manages the mapping from symbolic
//! names to their type, storage location (ID), and scope information.

use std::collections::BTreeMap;


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
    /// Primary reference table: name -> Reference. `BTreeMap` so any
    /// iteration during emission is deterministic across process
    /// invocations; lookup cost is O(log n) which is negligible at
    /// compile time.
    refs: BTreeMap<String, Reference>,
    /// Container support: container_name -> { inner_name -> Reference }.
    /// Both levels are `BTreeMap` for the same reason.
    containers: BTreeMap<String, BTreeMap<String, Reference>>,
    /// Currently active container name (if inside a container block).
    current_container: Option<String>,
    /// "Use" aliases recorded in insertion order as (alias, target)
    /// pairs. JS resolves bare names in a `use`-aliased container via
    /// reverse use-stack order: the most recently added alias wins
    /// when two containers share an inner name (e.g. both
    /// `proof.std.gsum` and `proof.std.vt` declare `airgroup_ids`,
    /// and `use proof.std.vt; ... airgroup_ids ...` must resolve to
    /// the `vt` container). A `Vec<(alias, target)>` preserves
    /// insertion order; lookup iterates in reverse for LIFO
    /// semantics.
    use_aliases: Vec<(String, String)>,
    /// Visibility scope stack for function calls.
    visibility_scope: (u32, Option<u32>),
    visibility_stack: Vec<(u32, Option<u32>)>,
}

impl References {
    pub fn new() -> Self {
        Self {
            refs: BTreeMap::new(),
            containers: BTreeMap::new(),
            current_container: None,
            use_aliases: Vec::new(),
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

        // PIL2C_TRACE_LEAK hook (tag: scope-declare). Emits one line per
        // declaration of a watched name so trace-driven rescue rounds can
        // pinpoint which declare path inserts into self.refs vs containers.
        // Watch list is the symbolic-payload names from the opids/num_reps
        // producer class.
        if std::env::var("PIL2C_TRACE_LEAK").is_ok() {
            let wl = &["opids","exprs_num","num_reps","mins","maxs","opids_count"];
            if wl.contains(&name) {
                let dest = if self.current_container.is_some() { "container" } else { "refs" };
                eprintln!("[pil2c-trace] [scope-declare] name={} scope_id={} array_dims={:?} dest={}", name, scope_id, array_dims, dest);
            }
        }
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

    /// Look up a reference by name, restricted to the direct `self.refs`
    /// map only — no container walk, no use-alias resolution. Intended for
    /// shadow-on-redeclare capture sites (`scope.declare(name, previous)`)
    /// so that later `apply_scope_cleanup` does not mirror a container
    /// field into `self.refs`. Mirrors the JS `searchDefinition` semantic
    /// where only direct local bindings participate in the shadow chain;
    /// container fields resolve freshly via the use-alias walk every time.
    pub fn get_direct_ref(&self, name: &str) -> Option<&Reference> {
        self.refs.get(name)
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

        // For unqualified names, check use-aliased containers in
        // LIFO order so the most recently added `use` wins.
        if !name.contains('.') {
            for (_alias, target) in self.use_aliases.iter().rev() {
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
        // PIL2C_TRACE_LEAK hook (tag: search-def-refs). Emits one line per
        // direct-refs hit for a watched name with the visibility verdict, so
        // trace-driven rescue rounds can see which stale refs beat the
        // use-alias walk for bare symbolic-payload names.
        let trace = std::env::var("PIL2C_TRACE_LEAK").is_ok();
        let wl = &["opids","exprs_num","num_reps","mins","maxs","opids_count"];
        // Direct lookup, gated on visibility. Out-of-scope leaks
        // (e.g. stale function-parameter bindings whose call frame
        // exited but whose entry survived in `self.refs`) fall
        // through to the next lookup so the use-aliased container
        // field can still resolve.
        if let Some(r) = self.refs.get(name) {
            let vis = self.is_visible(r);
            if trace && wl.contains(&name) {
                eprintln!("[pil2c-trace] [search-def-refs] name={} scope_id={} array_dims={:?} visible={}", name, r.scope_id, r.array_dims, vis);
            }
            if vis {
                return Some(r);
            }
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
            // For unqualified names, also check all use-aliased
            // containers in LIFO order. The most recently-added `use`
            // wins when two containers share an inner name — the
            // parity rule for JS `searchDefinition` over the
            // use-stack.
            for (_alias, target) in self.use_aliases.iter().rev() {
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

            // Check if first part is a use-alias. LIFO lookup: later
            // aliases win over earlier ones.
            let alias_target = self.use_aliases.iter().rev()
                .find(|(a, _)| a == parts[0])
                .map(|(_, t)| t.clone());
            if let Some(container_name) = alias_target {
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
        self.use_aliases.retain(|(_, v)| {
            !v.starts_with("air.") && v != "air"
        });
    }

    /// Restore a previously saved reference binding.
    pub fn restore(&mut self, name: &str, reference: Reference) {
        self.refs.insert(name.to_string(), reference);
    }

    /// Start a container block. Returns false if the container already
    /// exists (matching JS `createContainer` which returns false so the
    /// caller skips the body).
    ///
    /// The alias is always installed even when the container already
    /// exists (matching JS behavior where the alias is set before the
    /// existence check).
    pub fn create_container(&mut self, name: &str, alias: Option<&str>) -> bool {
        // Always install the alias first, even on reopen. Push onto
        // the LIFO use-stack so subsequent bare-name lookups resolve
        // to the most recently aliased container.
        if let Some(a) = alias {
            self.use_aliases.push((a.to_string(), name.to_string()));
        }
        if self.containers.contains_key(name) {
            return false;
        }
        self.containers.insert(name.to_string(), BTreeMap::new());
        self.current_container = Some(name.to_string());
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

    /// Current container name, if inside a container block.
    pub fn current_container_name(&self) -> Option<&str> {
        self.current_container.as_deref()
    }

    /// Register a `use` alias. Push onto the LIFO stack; subsequent
    /// lookups iterate in reverse so the most recently-added alias
    /// wins when two aliased containers share an inner name.
    pub fn add_use(&mut self, name: &str, alias: Option<&str>) {
        let key = alias.map(|a| a.to_string()).unwrap_or_else(|| name.to_string());
        self.use_aliases.push((key, name.to_string()));
    }

    /// Snapshot the current `use_aliases` stack length. Pairs with
    /// [`restore_use_aliases_len`] to bound the lexical lifetime of
    /// aliases introduced inside a scope (function body, container
    /// body, scoped statement block). Prior behavior accumulated
    /// aliases globally across scopes, so a `use proof.std.gsum;`
    /// added by one AIR's `gsum_update_*` call leaked into every
    /// subsequent AIR and shadowed later `use air.std.gsum;`
    /// resolutions — the cross-AIR `gsum_col.reference` misresolution
    /// Codex's Round 2 review pinned.
    pub fn snapshot_use_aliases(&self) -> usize {
        self.use_aliases.len()
    }

    /// Truncate the `use_aliases` stack back to a previously
    /// snapshotted length, dropping any aliases added since.
    /// See [`snapshot_use_aliases`] for rationale.
    pub fn restore_use_aliases_len(&mut self, len: usize) {
        if self.use_aliases.len() > len {
            self.use_aliases.truncate(len);
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

    /// Push visibility scope (for function calls). `entry_depth` is
    /// the scope depth at function-body entry (set by the caller
    /// after `scope.push()`); `creation_scope` is the lexical
    /// declaration depth of the function being called (passed
    /// through from the caller; `None` means "no upper bound" / the
    /// function may have been declared at the same depth as its
    /// call site, which is the safe default for top-level
    /// declarations).
    ///
    /// The window stored is `(entry_depth, creation_scope)`. JS
    /// pil2-compiler `pushVisibilityScope` mirrors this with
    /// `[Context.scope.deep, creationScope]`. `is_visible` consults
    /// the window to filter out leaked function-parameter bindings
    /// that may still sit in `self.refs` after their owning frame
    /// exited.
    pub fn push_visibility_scope(&mut self, entry_depth: u32, creation_scope: Option<u32>) {
        self.visibility_stack.push(self.visibility_scope);
        self.visibility_scope = (entry_depth, creation_scope);
    }

    /// Pop visibility scope.
    pub fn pop_visibility_scope(&mut self) {
        if let Some(prev) = self.visibility_stack.pop() {
            self.visibility_scope = prev;
        }
    }

    /// Whether the given reference is visible from the current
    /// visibility window. Mirrors JS pil2-compiler's
    /// `References::isVisible`:
    ///
    ///     !def.scopeId || def.scopeId === 1 ||
    ///     !this.hasScope(def.type) || def.type === 'function' ||
    ///     def.scopeId >= this.visibilityScope[0] ||
    ///     (this.visibilityScope[1] !== false &&
    ///      def.scopeId <= this.visibilityScope[1])
    ///
    /// Used by `search_definition` to skip stale function-parameter
    /// bindings that survived their call frame's exit. Without this
    /// filter, a deferred handler at proof-final time can resolve
    /// bare names to leaked param refs (with `array_dims = []`),
    /// shadowing the proof-scope container fields the handler
    /// actually needs to read.
    pub fn is_visible(&self, reference: &Reference) -> bool {
        if reference.scope_id == 0 || reference.scope_id == 1 {
            return true;
        }
        if !reference.ref_type.has_scope() {
            return true;
        }
        if matches!(reference.ref_type, RefType::Function) {
            return true;
        }
        let (lo, hi) = self.visibility_scope;
        if reference.scope_id >= lo {
            return true;
        }
        if let Some(upper) = hi {
            if reference.scope_id <= upper {
                return true;
            }
        }
        false
    }

    /// Get the references inside a specific container, if it exists.
    pub fn get_container_refs(&self, container_name: &str) -> Option<&BTreeMap<String, Reference>> {
        self.containers.get(container_name)
    }

    /// Iterate over all references.
    pub fn iter(&self) -> impl Iterator<Item = (&String, &Reference)> {
        self.refs.iter()
    }

    /// Iterate over references of specific types.
    pub fn iter_of_types<'a>(
        &'a self,
        types: &'a [RefType],
    ) -> impl Iterator<Item = (&'a String, &'a Reference)> + 'a {
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

    /// Regression guard: two proof-scope containers can share a bare
    /// variable name without the last-aliased container's variable
    /// leaking into the top-level `refs` map and shadowing the other.
    ///
    /// Before the fix, a `container proof.a { int users[8]; }` variable
    /// declared while scope-tracking captured `previous = users-from-c2`
    /// (or similar) would, on scope pop, `restore("users", previous)`
    /// into `self.refs`. Subsequent bare `users` lookups hit the
    /// restored top-level entry directly and bypassed the
    /// use-aliased-container LIFO scan, returning the wrong variable.
    ///
    /// After the fix, container declarations do not participate in
    /// scope-level shadow tracking, so bare-name lookups consult the
    /// use-alias stack exactly as the PIL semantics require.
    #[test]
    fn test_container_does_not_leak_into_refs_on_scope_pop() {
        let mut refs = References::new();

        // Two proof-scope containers, both with a `users` variable.
        refs.create_container("proof.c1", None);
        refs.declare("users", RefType::Int, 100, &[8], false, 0, "test:c1");
        refs.close_container();

        refs.create_container("proof.c2", None);
        refs.declare("users", RefType::Int, 200, &[2], false, 0, "test:c2");
        refs.close_container();

        // Bare `users` without any `use ...` should not resolve.
        assert!(!refs.is_defined("users"));

        // With `use proof.c1;` the bare `users` must resolve to the
        // proof.c1 variant (base_id=100, dims=[8]).
        refs.add_use("proof.c1", None);
        let got = refs.get_reference("users").expect("bare users via use proof.c1");
        assert_eq!(got.id, 100, "bare users must resolve to proof.c1.users base_id");
        assert_eq!(got.array_dims, vec![8u32], "bare users must carry proof.c1.users dims");

        // After `use proof.c2;`, the most recent use wins.
        refs.add_use("proof.c2", None);
        let got = refs.get_reference("users").expect("bare users via use proof.c2");
        assert_eq!(got.id, 200, "LIFO: use proof.c2 must now resolve bare users to c2");
        assert_eq!(got.array_dims, vec![2u32], "bare users dims must match proof.c2.users");
    }
}
