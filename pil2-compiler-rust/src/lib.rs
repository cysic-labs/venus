pub mod field;
pub mod parser;
pub mod processor;
pub mod proto_out;

use std::collections::{HashMap, HashSet};
use std::fs;
use std::path::{Path, PathBuf};

use parser::ast::{IncludeKind, Program, Statement};
use processor::context::CompilerConfig;
use processor::Processor;

/// Configuration for a compilation run passed from the CLI.
#[derive(Debug, Clone, Default)]
pub struct CompileOptions {
    /// PIL source file path.
    pub source: String,
    /// Include paths for resolving `require` / `include` directives.
    pub include_paths: Vec<String>,
    /// Output .pilout file path.
    pub output: Option<String>,
    /// Output directory for fixed column binary files.
    pub output_dir: Option<String>,
    /// Compile-time defines (name -> value).
    pub defines: HashMap<String, i128>,
    /// PIL name (optional).
    pub name: Option<String>,
    /// Whether to write fixed columns to separate binary files.
    pub fixed_to_file: bool,
    /// Verbose output.
    pub verbose: bool,
}

// ---------------------------------------------------------------------------
// Include / require resolver
// ---------------------------------------------------------------------------

/// Resolves and expands `require` / `include` directives before execution.
///
/// Resolution order for each include path string:
///   1. Relative to the directory of the file that contains the directive.
///   2. Relative to each entry in `include_paths` (in order).
///
/// `require` uses once-semantics: a canonical path that has already been
/// included is silently skipped. `include` always re-includes.

/// Maximum include nesting depth (prevents infinite recursion from cyclic includes).
const MAX_INCLUDE_DEPTH: usize = 64;

struct IncludeResolver {
    /// `-I` search paths provided on the command line.
    include_paths: Vec<PathBuf>,
    /// Raw require strings already loaded (used to deduplicate `require`).
    /// The JS compiler deduplicates by the raw filename string BEFORE
    /// resolving, so we must do the same.
    loaded_require_strings: HashSet<String>,
    /// Canonical paths already loaded (used only to prevent infinite
    /// recursion, NOT for require deduplication).
    loaded_canonical: HashSet<PathBuf>,
    /// Current include nesting depth.
    depth: usize,
    /// Verbose logging.
    verbose: bool,
}

impl IncludeResolver {
    fn new(include_paths: &[String], verbose: bool) -> Self {
        Self {
            include_paths: include_paths.iter().map(PathBuf::from).collect(),
            loaded_require_strings: HashSet::new(),
            loaded_canonical: HashSet::new(),
            depth: 0,
            verbose,
        }
    }

    /// Resolve an include path relative to `current_dir`, then the global
    /// include paths. Returns the canonical, absolute path on success.
    fn resolve(&self, current_dir: &Path, include_path: &str) -> Option<PathBuf> {
        // 1. Try relative to the including file's directory.
        let candidate = current_dir.join(include_path);
        if candidate.exists() {
            return Some(Self::canonicalize(&candidate));
        }

        // 2. Try each `-I` include path.
        for search_dir in &self.include_paths {
            let candidate = search_dir.join(include_path);
            if candidate.exists() {
                return Some(Self::canonicalize(&candidate));
            }
        }

        None
    }

    /// Best-effort canonicalization (falls back to the input path).
    fn canonicalize(p: &Path) -> PathBuf {
        fs::canonicalize(p).unwrap_or_else(|_| p.to_path_buf())
    }

    /// Parse a single file and recursively expand all includes in its AST.
    fn parse_and_expand(
        &mut self,
        file_path: &Path,
    ) -> anyhow::Result<Vec<Statement>> {
        if self.depth >= MAX_INCLUDE_DEPTH {
            anyhow::bail!(
                "Include depth exceeds {} (possible cyclic include from {})",
                MAX_INCLUDE_DEPTH,
                file_path.display()
            );
        }
        self.depth += 1;

        let source_code = fs::read_to_string(file_path)
            .map_err(|e| anyhow::anyhow!("Failed to read {}: {}", file_path.display(), e))?;

        let program = parser::parse(&source_code)
            .map_err(|e| anyhow::anyhow!("Parse error in {}: {}", file_path.display(), e))?;

        let file_dir = file_path.parent().unwrap_or_else(|| Path::new("."));
        let result = self.expand_statements(program.statements, file_dir);

        self.depth -= 1;
        result
    }

    /// Walk a list of statements and replace every `Include` node with the
    /// parsed (and recursively expanded) contents of the referenced file.
    fn expand_statements(
        &mut self,
        statements: Vec<Statement>,
        current_dir: &Path,
    ) -> anyhow::Result<Vec<Statement>> {
        let mut result: Vec<Statement> = Vec::with_capacity(statements.len());

        for stmt in statements {
            match stmt {
                Statement::Include(ref inc) => {
                    let raw_path = &inc.path.value;

                    // `require` deduplication: the JS compiler deduplicates by
                    // raw require string BEFORE resolving. This means if
                    // `require "foo.pil"` appears in two different directories,
                    // the second is silently skipped even if the resolved path
                    // would differ (or not exist from the second location).
                    if inc.kind == IncludeKind::Require {
                        if self.loaded_require_strings.contains(raw_path.as_str()) {
                            if self.verbose {
                                eprintln!(
                                    "  > require '{}' already loaded (by raw string), skipping",
                                    raw_path
                                );
                            }
                            continue;
                        }
                        self.loaded_require_strings.insert(raw_path.clone());
                    }

                    // Resolve the file path.
                    let resolved = self
                        .resolve(current_dir, raw_path)
                        .ok_or_else(|| {
                            let searched: Vec<String> = std::iter::once(current_dir.display().to_string())
                                .chain(self.include_paths.iter().map(|p| p.display().to_string()))
                                .collect();
                            anyhow::anyhow!(
                                "Cannot resolve {} '{}' (searched: {})",
                                match inc.kind {
                                    IncludeKind::Require => "require",
                                    IncludeKind::Include => "include",
                                },
                                raw_path,
                                searched.join(", ")
                            )
                        })?;

                    eprintln!(
                        "  > {} {}",
                        match inc.kind {
                            IncludeKind::Require => "require",
                            IncludeKind::Include => "include",
                        },
                        resolved.display()
                    );

                    // Track canonical paths for recursion prevention.
                    self.loaded_canonical.insert(resolved.clone());

                    // Recursively parse and expand the included file.
                    let expanded = self.parse_and_expand(&resolved)?;
                    result.extend(expanded);
                }

                // For statements that contain nested statement lists, recurse
                // into them so that includes inside airgroups, functions, etc.
                // are also expanded.
                Statement::AirGroupDef(mut ag) => {
                    ag.statements = self.expand_statements(ag.statements, current_dir)?;
                    result.push(Statement::AirGroupDef(ag));
                }
                Statement::AirTemplateDef(mut at) => {
                    at.statements = self.expand_statements(at.statements, current_dir)?;
                    result.push(Statement::AirTemplateDef(at));
                }
                Statement::FunctionDef(mut fd) => {
                    fd.body = self.expand_statements(fd.body, current_dir)?;
                    result.push(Statement::FunctionDef(fd));
                }
                Statement::If(mut if_stmt) => {
                    if_stmt.then_body =
                        self.expand_statements(if_stmt.then_body, current_dir)?;
                    for clause in &mut if_stmt.elseif_clauses {
                        clause.body =
                            self.expand_statements(std::mem::take(&mut clause.body), current_dir)?;
                    }
                    if let Some(else_body) = if_stmt.else_body.take() {
                        if_stmt.else_body =
                            Some(self.expand_statements(else_body, current_dir)?);
                    }
                    result.push(Statement::If(if_stmt));
                }
                Statement::For(mut for_stmt) => {
                    for_stmt.body =
                        self.expand_statements(for_stmt.body, current_dir)?;
                    result.push(Statement::For(for_stmt));
                }
                Statement::While(mut w) => {
                    w.body = self.expand_statements(w.body, current_dir)?;
                    result.push(Statement::While(w));
                }
                Statement::Switch(mut sw) => {
                    for case in &mut sw.cases {
                        case.body =
                            self.expand_statements(std::mem::take(&mut case.body), current_dir)?;
                    }
                    if let Some(default) = sw.default.take() {
                        sw.default =
                            Some(self.expand_statements(default, current_dir)?);
                    }
                    result.push(Statement::Switch(sw));
                }
                Statement::Container(mut cd) => {
                    if let Some(body) = cd.body.take() {
                        cd.body = Some(self.expand_statements(body, current_dir)?);
                    }
                    result.push(Statement::Container(cd));
                }
                Statement::Package(mut pd) => {
                    pd.body = self.expand_statements(pd.body, current_dir)?;
                    result.push(Statement::Package(pd));
                }
                Statement::When(mut w) => {
                    w.body = self.expand_statements(w.body, current_dir)?;
                    result.push(Statement::When(w));
                }
                Statement::Block(stmts) => {
                    let expanded = self.expand_statements(stmts, current_dir)?;
                    result.push(Statement::Block(expanded));
                }

                // All other statements pass through unchanged.
                other => result.push(other),
            }
        }

        Ok(result)
    }
}

// ---------------------------------------------------------------------------
// Main compilation entry point
// ---------------------------------------------------------------------------

/// Compile a PIL2 source file and produce a .pilout protobuf output.
///
/// This is the main entry point that orchestrates:
/// 1. Reading the PIL source file
/// 2. Parsing it into an AST
/// 3. Expanding all `require` / `include` directives recursively
/// 4. Running the processor/evaluator
/// 5. Serializing to protobuf via proto_out
/// 6. Writing the .pilout file
/// 7. Optionally writing fixed column data to binary files
pub fn compile(options: &CompileOptions) -> anyhow::Result<()> {
    let source_path = fs::canonicalize(Path::new(&options.source))
        .map_err(|e| anyhow::anyhow!("Source file not found: {} ({})", options.source, e))?;

    eprintln!("  > Parsing {}", source_path.display());

    // Parse the top-level source and recursively expand all includes.
    let mut resolver = IncludeResolver::new(&options.include_paths, options.verbose);
    // Register the main file so a circular require back to it is a no-op.
    resolver.loaded_canonical.insert(source_path.clone());
    let expanded_stmts = resolver.parse_and_expand(&source_path)?;

    let program = Program {
        statements: expanded_stmts,
    };

    eprintln!(
        "  > Expanded to {} top-level statements (loaded {} files)",
        program.statements.len(),
        resolver.loaded_canonical.len(),
    );

    // Build the compiler config from options.
    let config = CompilerConfig {
        name: options.name.clone().unwrap_or_else(|| {
            source_path
                .file_stem()
                .map(|s| s.to_string_lossy().to_string())
                .unwrap_or_default()
        }),
        output_file: options.output.clone(),
        output_dir: options.output_dir.clone(),
        fixed_to_file: options.fixed_to_file,
        defines: options.defines.clone(),
        verbose: options.verbose,
        ..Default::default()
    };

    // Create processor and execute.
    let mut processor = Processor::new(config);
    eprintln!("  > Executing program...");
    let success = processor.execute_program(&program);

    if !success {
        anyhow::bail!("Compilation failed (tests reported failures)");
    }

    // Determine output file path.
    let output_path = options.output.clone().unwrap_or_else(|| {
        let stem = source_path
            .file_stem()
            .map(|s| s.to_string_lossy().to_string())
            .unwrap_or_else(|| "output".to_string());
        let dir = source_path
            .parent()
            .unwrap_or_else(|| Path::new("."));
        dir.join(format!("{}.pilout", stem))
            .to_string_lossy()
            .to_string()
    });

    // Write protobuf output.
    proto_out::write_pilout(&processor, &output_path)?;

    // Fixed column binary files are written per-AIR during execution
    // (inside the processor) when fixed_to_file is enabled, using each
    // AIR's real row count. No post-execution write is needed here.
    if options.fixed_to_file && options.output_dir.is_none() {
        eprintln!("  > Warning: fixed-to-file requested but no output directory specified (-u)");
    }

    eprintln!("  > Compilation complete: {}", output_path);
    Ok(())
}
