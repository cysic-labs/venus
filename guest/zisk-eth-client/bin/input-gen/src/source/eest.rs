use anyhow::Context;
use clap::Args;
use rayon::ThreadPoolBuilder;
use std::path::{Path, PathBuf};
use tracing::info;

use witness_generator::{eest_generator::EESTFixtureGeneratorBuilder, FixtureGenerator};

use super::{InputSource, SourceKind};
use crate::{client::ExecutionClient, common::fixtures_from_path, processor::ProcessingTracker};

#[derive(Debug, Clone, Args)]
pub struct EestSource {
    /// EEST release tag to use (e.g., "v0.1.0"). If empty, the latest release will be used.
    #[arg(short, long, conflicts_with = "eest_fixtures_path")]
    tag: Option<String>,

    /// Input folder for EEST files. If not provided, --tag is required.
    #[arg(short = 'p', long, conflicts_with = "tag")]
    eest_fixtures_path: Option<PathBuf>,

    /// Include only test names containing the provided strings.
    #[arg(short, long)]
    include: Option<Vec<String>>,

    /// Exclude all test names containing the provided strings.
    #[arg(short, long)]
    exclude: Option<Vec<String>>,

    /// Number of threads for parallel processing
    #[arg(short, long, default_value = "10")]
    threads: Option<usize>,
}

#[async_trait::async_trait]
impl InputSource for EestSource {
    fn kind(&self) -> SourceKind {
        SourceKind::Eest
    }

    async fn generate_inputs(
        &self,
        client: &dyn ExecutionClient,
        output: &Path,
    ) -> anyhow::Result<()> {
        if !client.supports_source(self.kind()) {
            anyhow::bail!("{} doesn't support EEST source", client.display_name());
        }

        if let Some(threads) = self.threads {
            ThreadPoolBuilder::new()
                .num_threads(threads)
                .build_global()
                .expect("Failed to build global Rayon thread pool");
        }

        let mut builder = EESTFixtureGeneratorBuilder::default();

        if let Some(tag) = &self.tag {
            info!("Using EEST release tag: {}", tag);
            builder = builder.with_tag(tag.to_string());
        } else if let Some(input_folder) = &self.eest_fixtures_path {
            info!("Using local EEST from: {}", input_folder.display());
            builder = builder.with_input_folder(input_folder.clone())?;
        } else {
            info!("Using latest EEST release");
        }

        if let Some(include) = &self.include {
            info!("Include patterns: {:?}", include);
            builder = builder.with_includes(include.clone());
        }
        if let Some(exclude) = &self.exclude {
            info!("Exclude patterns: {:?}", exclude);
            builder = builder.with_excludes(exclude.clone());
        }

        let generator = builder
            .build()
            .await
            .context("Failed to build EEST generator")?;

        info!("Generating EEST fixtures...");

        // Generate fixtures to a temp directory, then convert to ZisK inputs
        let temp_dir = tempfile::tempdir().context("Failed to create temp directory")?;

        let count = generator
            .generate_to_path(temp_dir.path())
            .await
            .context("Failed to generate EEST fixtures")?;

        info!(
            "Generated {} EEST fixtures, converting to ZisK inputs...",
            count
        );

        // Initialize the tracker
        let mut tracker = ProcessingTracker::new(client.display_name());

        let fixtures = fixtures_from_path(temp_dir.path())?;
        for fixture in &fixtures {
            let name = format!("EEST \"{}\"", fixture.name);
            match client.process_fixture(fixture, output) {
                Ok(_) => tracker.record_success(&name),
                Err(e) => tracker.record_error(&name, &e),
            }
        }

        tracker.log_summary();

        Ok(())
    }
}
