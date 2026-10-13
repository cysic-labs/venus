use anyhow::Result;
use clap::Parser;
use colored::Colorize;
use std::path::PathBuf;
use zisk_build::ZISK_VERSION_MESSAGE;
use zisk_sdk::{
    get_proving_key, get_proving_key_snark, setup_logger, verify_zisk_snark_proof_with_proving_key,
    ZiskProofWithPublicValues,
};

use super::verify_stark::{log_verification, ExpectedProgram};

#[derive(Parser)]
#[command(author, about, long_about = None, version = ZISK_VERSION_MESSAGE)]
#[command(propagate_version = true)]
pub struct ZiskVerifySnark {
    #[clap(short = 'p', long)]
    pub proof: String,

    /// Verbosity (-v, -vv)
    #[arg(short = 'v', long, action = clap::ArgAction::Count, help = "Increase verbosity level")]
    pub verbose: u8, // Using u8 to hold the number of `-v`

    /// Setup folder path, whose VADCoP final verification key the SNARK public input commits to
    #[clap(short = 'k', long)]
    pub proving_key: Option<PathBuf>,

    /// Setup folder path for SNARK
    #[clap(short = 'w', long)]
    pub proving_key_snark: Option<PathBuf>,

    #[command(flatten)]
    pub expected_program: ExpectedProgram,
}

impl ZiskVerifySnark {
    pub fn run(&self) -> Result<()> {
        setup_logger(self.verbose.into());

        tracing::info!(
            "{}",
            format!("{} ZiskVerifySnark", format!("{: >12}", "Command").bright_green().bold())
        );
        tracing::info!("");

        let start = std::time::Instant::now();

        let proof = ZiskProofWithPublicValues::load(&self.proof)
            .map_err(|e| anyhow::anyhow!("Error loading SNARK proof from {}: {}", self.proof, e))?;
        let proving_key = get_proving_key(self.proving_key.as_ref());

        let result = verify_zisk_snark_proof_with_proving_key(
            proof.get_proof(),
            proof.get_publics(),
            proof.get_program_vk(),
            proving_key.clone(),
            get_proving_key_snark(self.proving_key_snark.as_ref()),
        )
        .and_then(|()| self.expected_program.check(&proof, &proving_key));

        log_verification("SNARK", &proof, result.is_ok(), start.elapsed());
        result
    }
}
