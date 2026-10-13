// extern crate env_logger;
use anyhow::Result;
use clap::Parser;
use colored::Colorize;
use fields::Goldilocks;
use std::path::PathBuf;

use crate::ux::{print_banner, print_banner_command, print_banner_field};
use proofman::{SnarkProtocol, SnarkWrapper};
use zisk_sdk::{ZiskProof, ZiskProofWithPublicValues};

#[derive(Parser)]
#[command(version, about, long_about = None)]
#[command(propagate_version = true)]
pub struct ZiskProveSnark {
    #[clap(short = 'p', long)]
    pub proof: String,

    /// ELF file path
    /// This is the path to the ROM file that the witness computation dynamic library will use
    /// to generate the witness.
    #[clap(short = 'e', long)]
    pub elf: PathBuf,

    /// Setup folder path
    #[clap(short = 'k', long)]
    pub proving_key_snark: PathBuf,

    /// Output dir path
    #[clap(short = 'o', long, default_value = "tmp")]
    pub output_dir: PathBuf,

    /// Verbosity (-v, -vv)
    #[arg(short, long, action = clap::ArgAction::Count, help = "Increase verbosity level")]
    pub verbose: u8, // Using u8 to hold the number of `-v`
}

impl ZiskProveSnark {
    pub fn run(&self) -> Result<()> {
        print_banner();

        print_banner_command("Prove SNARK");

        print_banner_field("Elf", self.elf.display());

        let zisk_proof = ZiskProofWithPublicValues::load(&self.proof).map_err(|e| {
            anyhow::anyhow!(
                "Failed to load ZiskProofWithPublicValues from file {}: {}",
                self.proof,
                e
            )
        })?;

        let snark_wrapper: SnarkWrapper<Goldilocks> =
            SnarkWrapper::new(&self.proving_key_snark, self.verbose.into())?;

        let proof = zisk_proof.get_vadcop_final_proof()?;

        let snark_proof =
            snark_wrapper.generate_final_snark_proof(&proof, Some(self.output_dir.clone()))?;

        // Saved like `prove --snark` saves it, with the statement it proves, for `verify-snark`.
        let snark_zisk_proof = match SnarkProtocol::from_protocol_id(snark_proof.protocol_id)? {
            SnarkProtocol::Plonk => ZiskProof::Plonk(snark_proof.proof_bytes),
            SnarkProtocol::Fflonk => ZiskProof::Fflonk(snark_proof.proof_bytes),
        };
        let proof_with_publics = ZiskProofWithPublicValues::new(
            snark_zisk_proof,
            zisk_proof.get_publics().clone(),
            zisk_proof.get_program_vk().clone(),
        );
        let output_path = self.output_dir.join("final_snark_proof.bin");
        proof_with_publics.save(&output_path).map_err(|e| {
            anyhow::anyhow!("Failed to save final SNARK proof to {}: {}", output_path.display(), e)
        })?;
        println!(
            "{} Final SNARK proof saved to {}. Program VK: {}, outputs: {}",
            "Info:".bright_blue().bold(),
            output_path.display(),
            proof_with_publics.get_program_vk(),
            proof_with_publics.get_publics()
        );
        Ok(())
    }
}
