pub mod field;
pub mod parser;
pub mod processor;
pub mod proto_out;

use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};

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

/// Compile a PIL2 source file and produce a .pilout protobuf output.
///
/// This is the main entry point that orchestrates:
/// 1. Reading the PIL source file
/// 2. Parsing it into an AST
/// 3. Running the processor/evaluator
/// 4. Serializing to protobuf via proto_out
/// 5. Writing the .pilout file
/// 6. Optionally writing fixed column data to binary files
pub fn compile(options: &CompileOptions) -> anyhow::Result<()> {
    let source_path = Path::new(&options.source);
    if !source_path.exists() {
        anyhow::bail!("Source file not found: {}", options.source);
    }

    // Read the source file.
    let source_code = fs::read_to_string(source_path)
        .map_err(|e| anyhow::anyhow!("Failed to read {}: {}", options.source, e))?;

    eprintln!("  > Parsing {}", options.source);

    // Parse into AST.
    let program = parser::parse(&source_code)
        .map_err(|e| anyhow::anyhow!("Parse error in {}: {}", options.source, e))?;

    eprintln!(
        "  > Parsed {} top-level statements",
        program.statements.len()
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

    // If fixed-to-file is enabled, write fixed column binary files.
    if options.fixed_to_file {
        if let Some(ref output_dir) = options.output_dir {
            eprintln!("  > Writing fixed columns to {}", output_dir);
            // The processor's fixed_cols are per-air, but after execution
            // the final state holds the last air's data. For a complete
            // implementation, we would iterate all airs. For now, write
            // what's available.
            let num_rows = 1u64; // placeholder; actual rows come from air context
            proto_out::write_fixed_cols_to_file(
                &processor.fixed_cols,
                num_rows,
                output_dir,
                0,
                0,
            )?;
        } else {
            eprintln!("  > Warning: fixed-to-file requested but no output directory specified (-u)");
        }
    }

    eprintln!("  > Compilation complete: {}", output_path);
    Ok(())
}
