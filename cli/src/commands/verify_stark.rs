use anyhow::{Context, Result};
use clap::Parser;
use colored::Colorize;
use std::path::{Path, PathBuf};
use std::time::Duration;
use zisk_build::ZISK_VERSION_MESSAGE;
use zisk_sdk::{
    get_program_vk_with_proving_key, get_proving_key, setup_logger,
    verify_zisk_proof_with_proving_key, ElfBinaryFromFile, ZiskProgramVK,
    ZiskProofWithPublicValues,
};

#[derive(Parser)]
#[command(author, about, long_about = None, version = ZISK_VERSION_MESSAGE)]
#[command(propagate_version = true)]
pub struct ZiskVerify {
    #[clap(short = 'p', long)]
    pub proof: String,

    /// Verbosity (-v, -vv)
    #[arg(short = 'v', long, action = clap::ArgAction::Count, help = "Increase verbosity level")]
    pub verbose: u8, // Using u8 to hold the number of `-v`

    #[clap(short = 'k', long)]
    pub proving_key: Option<PathBuf>,

    #[command(flatten)]
    pub expected_program: ExpectedProgram,
}

impl ZiskVerify {
    pub fn run(&self) -> Result<()> {
        setup_logger(self.verbose.into());

        tracing::info!(
            "{}",
            format!("{} ZiskVerify", format!("{: >12}", "Command").bright_green().bold())
        );
        tracing::info!("");

        let start = std::time::Instant::now();

        let proof = ZiskProofWithPublicValues::load(&self.proof).map_err(|e| {
            anyhow::anyhow!("Error loading VADCoP final proof from {}: {}", self.proof, e)
        })?;
        let proving_key = get_proving_key(self.proving_key.as_ref());

        let result = verify_zisk_proof_with_proving_key(
            proof.get_proof(),
            proof.get_publics(),
            proof.get_program_vk(),
            proving_key.clone(),
        )
        .and_then(|()| self.expected_program.check(&proof, &proving_key));

        log_verification("Stark", &proof, result.is_ok(), start.elapsed());
        result
    }
}

// The program a proof must be for. Without one, a proof is accepted for whatever program it
// claims, which the verification logs. (A doc comment here would become the commands' about text.)
#[derive(clap::Args)]
pub struct ExpectedProgram {
    /// Require a proof for this ELF, whose program VK `rom-setup` computed for the proving key
    #[clap(short = 'e', long, conflicts_with = "program_vk")]
    pub elf: Option<PathBuf>,

    /// Require a proof for the program with this VK, given as `[w0, w1, w2, w3]`
    #[clap(long)]
    pub program_vk: Option<ZiskProgramVK>,
}

impl ExpectedProgram {
    /// Fails unless `proof` is for the expected program, if there is one.
    pub fn check(&self, proof: &ZiskProofWithPublicValues, proving_key: &Path) -> Result<()> {
        let expected = match (&self.elf, &self.program_vk) {
            (Some(elf), _) => {
                let elf_binary = ElfBinaryFromFile::new(elf, false)?;
                get_program_vk_with_proving_key(&elf_binary, proving_key.to_path_buf())
                    .with_context(|| {
                        format!("no program VK for {}; run rom-setup for it first", elf.display())
                    })?
            }
            (None, Some(program_vk)) => program_vk.clone(),
            (None, None) => return Ok(()),
        };
        let program_vk = proof.get_program_vk();
        if program_vk.vk != expected.vk {
            anyhow::bail!("the proof is for program VK {program_vk}, not the expected {expected}");
        }
        Ok(())
    }
}

/// Logs the outcome of verifying `proof` and, if it was verified, the statement it proves.
pub(crate) fn log_verification(
    proof_kind: &str,
    proof: &ZiskProofWithPublicValues,
    verified: bool,
    elapsed: Duration,
) {
    if verified {
        tracing::info!(
            "{}",
            format!("\u{2713} {proof_kind} proof was verified").bright_green().bold()
        );
    } else {
        tracing::info!(
            "{}",
            format!("\u{2717} {proof_kind} proof was not verified").bright_red().bold()
        );
    }

    tracing::info!("{}", "--- VERIFICATION SUMMARY ---".bright_green().bold());
    tracing::info!("      time: {} milliseconds", elapsed.as_millis());
    if verified {
        tracing::info!("program VK: {}", proof.get_program_vk());
        tracing::info!("   outputs: {}", proof.get_publics());
    }
    tracing::info!("{}", "----------------------------".bright_green().bold());
}
