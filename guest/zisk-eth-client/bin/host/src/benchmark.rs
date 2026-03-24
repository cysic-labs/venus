use anyhow::Result;
use std::{
    fs,
    path::{Path, PathBuf},
    time::Instant,
};
use tracing::{error, info};

use crate::{
    cli::{Action, Cli},
    zisk::{Zisk, ZiskExecutionMetrics},
};

#[derive(Debug, serde::Serialize)]
struct BenchmarkResult {
    test_name: String,
    time: f64,
    metrics: ZiskExecutionMetrics,
}

pub struct BenchmarkRunner<'a> {
    cli: &'a Cli,
    zisk: Zisk,
}

impl<'a> BenchmarkRunner<'a> {
    pub fn new(cli: &'a Cli) -> Self {
        // Setup things
        let zisk = if matches!(cli.action, Action::Execute) {
            Zisk::new(&cli.elf).with_ziskemu(cli.ziskemu.as_ref().unwrap())
        } else {
            Zisk::new(&cli.elf)
                .with_proving_key(cli.proving_key.as_ref().unwrap())
                .expect("Failed to setup Zisk with proving key")
        };

        Self { cli, zisk }
    }

    pub fn run(&self, input_folder: &Path, gas_millions: Option<u32>) -> Result<()> {
        let mut input_files = collect_input_files(input_folder)?;

        // Filter by gas value if specified
        if let Some(gas_mb) = gas_millions {
            let gas_pattern = format!("gas-value_{}M", gas_mb);
            info!(
                "Filtering for gas value: {} (pattern: {})",
                gas_mb, gas_pattern
            );
            input_files.retain(|file| file.to_string_lossy().contains(&gas_pattern));
        }

        let total = input_files.len();
        info!("Found {} input files to run", total);

        let mut passed = 0;
        let mut failed = 0;
        let mut skipped = 0;
        for (index, file) in input_files.iter().enumerate() {
            match self.run_single(file, index + 1, total) {
                Ok(true) => passed += 1,
                Ok(false) => skipped += 1,
                Err(e) => {
                    error!("Failed to run benchmark for {}: {}", file.display(), e);
                    failed += 1;
                }
            }
        }

        // Print summary
        info!("");
        info!(
            "Summary: {} passed, {} failed, {} skipped",
            passed, failed, skipped
        );

        Ok(())
    }

    /// Returns Ok(true) if ran, Ok(false) if skipped, Err if failed
    fn run_single(&self, input_file: &Path, current: usize, total: usize) -> Result<bool> {
        let test_name = input_file
            .file_stem()
            .and_then(|s| s.to_str())
            .unwrap_or("unknown");

        if matches!(self.cli.action, Action::Execute) {
            // If output folder exists, check if output file exists and skip if it does
            if let Some(ref output_folder) = self.cli.output_folder {
                let filename = input_file.file_name().unwrap_or_default();
                let output_file = output_folder.join(filename).with_extension("json");

                if output_file.exists() && !self.cli.force_rerun {
                    info!("[{}/{}] Skipping {}", current, total, test_name);
                    return Ok(false);
                }
            }

            info!("[{}/{}] Running: {}", current, total, test_name);

            let time = Instant::now();
            let metrics = self.zisk.execute(input_file)?;
            let elapsed = time.elapsed();

            info!(
                "[{}/{}] Completed in {:.2}s",
                current,
                total,
                elapsed.as_secs_f64(),
            );

            // Write metrics to output folder if specified
            if let Some(ref output_folder) = self.cli.output_folder {
                let filename = input_file.file_name().unwrap_or_default();
                let output_file = output_folder.join(filename).with_extension("json");

                if let Some(parent) = output_file.parent() {
                    fs::create_dir_all(parent)?;
                }

                let result = BenchmarkResult {
                    test_name: test_name.to_string(),
                    time: elapsed.as_secs_f64(),
                    metrics,
                };

                let output_json = serde_json::to_string_pretty(&result)?;
                fs::write(&output_file, output_json)?;
            }
        } else {
            info!("[{}/{}] Testing: {}", current, total, test_name);

            let time = Instant::now();
            match self.cli.action {
                Action::VerifyConstraints => {
                    self.zisk.verify_constraints(input_file)?;
                }
                Action::Prove => {
                    unimplemented!("Prove action is not implemented yet");
                }
                Action::Execute => unreachable!(),
            };
            let elapsed = time.elapsed();

            info!(
                "[{}/{}] PASSED in {:.2}s",
                current,
                total,
                elapsed.as_secs_f64(),
            );
        }

        Ok(true)
    }
}

fn collect_input_files(input_folder: &Path) -> Result<Vec<PathBuf>> {
    let mut files = Vec::new();

    if input_folder.is_dir() {
        for entry in fs::read_dir(input_folder)? {
            let entry = entry?;
            let path = entry.path();
            if path.is_dir() {
                for sub_entry in fs::read_dir(&path)? {
                    let sub_entry = sub_entry?;
                    let sub_path = sub_entry.path();
                    if sub_path.is_file() {
                        files.push(sub_path);
                    }
                }
            } else if path.is_file() {
                files.push(path);
            }
        }
    } else {
        files.push(input_folder.to_path_buf());
    }

    files.sort();
    Ok(files)
}
