use anyhow::{Context, Result};
use std::path::Path;

use guest_reth::{RethInput, RethInputPublic, RethInputWitness};
use witness_generator::StatelessValidationFixture;
use zisk_sdk::ZiskStdin;

use super::ExecutionClient;
use crate::source::SourceKind;

pub struct RethClient;

impl RethClient {
    pub fn new() -> Self {
        Self
    }
}

impl ExecutionClient for RethClient {
    fn name(&self) -> &'static str {
        "reth"
    }

    fn display_name(&self) -> &'static str {
        "Reth"
    }

    fn supported_sources(&self) -> &'static [SourceKind] {
        &[SourceKind::Eest, SourceKind::Rpc]
    }

    fn process_fixture(
        &self,
        fixture: &StatelessValidationFixture,
        output_dir: &Path,
    ) -> Result<(), anyhow::Error> {
        // Generate the Reth input from the fixture
        let input = RethInput::new(&fixture.stateless_input).with_context(|| {
            format!(
                "Failed to create {} input for {}",
                self.display_name(),
                fixture.name
            )
        })?;

        // Save the input to a file
        let zisk_stdin = ZiskStdin::new();

        // Write public
        let public = RethInputPublic {
            block: input.stateless_input.block.clone(),
            chain_config: input.stateless_input.chain_config.clone(),
            public_keys: input.public_keys.clone(),
        };
        let public_bytes = RethInputPublic::serialize(&public)?;
        zisk_stdin.write_slice(&public_bytes);

        // Write witness
        let witness = RethInputWitness {
            witness: input.stateless_input.witness.clone(),
        };
        let witness_bytes = RethInputWitness::serialize(&witness)?;
        zisk_stdin.write_slice(&witness_bytes);

        // Sanitize filename and save
        let filename = sanitize_filename(&fixture.name);
        let output_path = output_dir.join(format!("{}.bin", filename));
        zisk_stdin.save(&output_path)?;

        Ok(())
    }
}

fn sanitize_filename(name: &str) -> String {
    name.replace(['/', '\\', ':', '*', '?', '"', '<', '>', '|'], "_")
}
