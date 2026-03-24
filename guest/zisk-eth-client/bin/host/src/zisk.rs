use anyhow::{Context, Ok, Result};
use std::{
    path::{Path, PathBuf},
    process::Command,
};

use zisk_sdk::{ElfBinaryFromFile, Emu, ProverClient, ZiskProgramPK, ZiskProver, ZiskStdin};

#[derive(Debug, serde::Serialize)]
pub struct ZiskExecutionMetrics {
    pub steps: u64,
    pub cost: u64,
    pub tx_count: Option<u64>,
    pub gas_used: Option<u64>,
}

// #[derive(Debug, Clone)]
pub struct Zisk {
    pub elf: PathBuf,
    pub ziskemu: Option<PathBuf>,
    pub client: Option<ZiskProver<Emu>>,
    pub pk: Option<ZiskProgramPK>,
}

impl Zisk {
    pub fn new(elf: impl Into<PathBuf>) -> Self {
        Self {
            elf: elf.into(),
            ziskemu: None,
            client: None,
            pk: None,
        }
    }

    pub fn with_ziskemu(mut self, ziskemu: impl Into<PathBuf>) -> Self {
        self.ziskemu = Some(ziskemu.into());
        self
    }

    pub fn with_proving_key(mut self, proving_key: impl Into<PathBuf>) -> Result<Self> {
        let elf = ElfBinaryFromFile::new(&self.elf, false).context("Failed to load ELF binary")?;

        let client = ProverClient::builder()
            .emu()
            .verify_constraints()
            .proving_key_path(proving_key.into())
            .build()
            .context("Failed to build ProverClient builder")?;

        let (pk, _) = client.setup(&elf).context("Failed to setup program")?;

        self.client = Some(client);
        self.pk = Some(pk);

        Ok(self)
    }

    /// Execute the guest program and return metrics
    pub fn execute(&self, input_file: &Path) -> Result<ZiskExecutionMetrics> {
        let ziskemu = self
            .ziskemu
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("ZisK Emulator path is required for execution"))?;
        let output = Command::new(ziskemu)
            .arg("-e")
            .arg(&self.elf)
            .arg("-i")
            .arg(input_file)
            .arg("--stats")
            .output()
            .context("Failed to run ziskemu")?;

        if !output.status.success() {
            let stderr = String::from_utf8_lossy(&output.stderr);
            anyhow::bail!("ziskemu execute failed: {}", stderr);
        }

        let stdout = String::from_utf8_lossy(&output.stdout);
        parse_metrics(&stdout)
    }

    /// Execute and verify constraints
    pub fn verify_constraints(&self, input_file: &Path) -> Result<()> {
        let stdin = ZiskStdin::from_file(input_file).context("Failed to load input file")?;

        let pk = self
            .pk
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("Proving key is not set up"))?;

        self.client
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("Client is not set up"))?
            .verify_constraints(pk, stdin)
            .context("Failed to verify constraints")?;

        Ok(())
    }
}

fn parse_metrics(output: &str) -> Result<ZiskExecutionMetrics> {
    let mut steps = 0u64;
    let mut cost = 0u64;
    let mut tx_count = None;
    let mut gas_used = None;

    for line in output.lines() {
        if line.contains("STEPS")
            && let Some(val) = line.split_whitespace().last()
        {
            steps = val.replace(",", "").parse().unwrap_or(0);
        }
        if line.contains("TOTAL")
            && line.contains("100.00%")
            && let Some(val) = line.split_whitespace().nth(1)
        {
            cost = val.replace(",", "").parse().unwrap_or(0);
        }
        if line.contains("- Transaction Count:")
            && let Some(val) = line.split(':').next_back()
        {
            tx_count = val.trim().replace(",", "").parse().ok();
        }
        if line.contains("- Gas Consumed:")
            && let Some(val) = line.split(':').next_back()
        {
            gas_used = val.trim().replace(",", "").parse().ok();
        }
    }

    Ok(ZiskExecutionMetrics {
        steps,
        cost,
        tx_count,
        gas_used,
    })
}
