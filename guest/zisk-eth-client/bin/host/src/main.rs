use anyhow::Result;
use clap::Parser;
use std::{fs::File, io::Write};
use tracing::info;
use zisk_sdk::VerboseMode;

mod benchmark;
mod cli;
mod zisk;

use benchmark::BenchmarkRunner;
use cli::{Cli, GuestProgramCommand};

fn main() -> Result<()> {
    zisk_sdk::setup_logger(VerboseMode::Info);

    let cli = Cli::parse();
    cli.validate().map_err(|e| anyhow::anyhow!(e))?;

    // Write metadata to a separate file
    if cli.output_folder.is_some() {
        write_metadata(&cli)?;
    }

    info!("ZisK Host");
    info!(" Action: {:?}", cli.action);
    info!(" ELF: {}", cli.elf.display());
    info!(" Guest Program: {}", cli.guest_program.display_name());

    match &cli.guest_program {
        GuestProgramCommand::StatelessValidator {
            input_folder,
            client,
            gas_millions,
        } => {
            info!(" Client: {:?}", client);
            info!(" Input Folder: {}", input_folder.display());
            if let Some(gas) = gas_millions {
                info!(" Gas Filter: {}M", gas);
            }
            let runner = BenchmarkRunner::new(&cli);
            runner.run(input_folder, *gas_millions)?;
        }
    }

    Ok(())
}

fn write_metadata(cli: &Cli) -> Result<()> {
    let output_folder = cli.output_folder.as_ref().unwrap();
    let log_path = output_folder.join("metadata.log");

    // Create parent directory if needed
    if let Some(parent) = log_path.parent() {
        std::fs::create_dir_all(parent)?;
    }

    let mut file = File::create(&log_path)?;

    writeln!(file, "ZisK Host")?;
    writeln!(file, "=========================")?;
    writeln!(file, "Action: {:?}", cli.action)?;
    writeln!(file, "ELF: {}", cli.elf.display())?;
    writeln!(file, "Guest Program: {}", cli.guest_program.display_name())?;

    // Add per-guest metadata
    match &cli.guest_program {
        GuestProgramCommand::StatelessValidator {
            input_folder,
            client,
            gas_millions,
        } => {
            writeln!(file, "Client: {:?}", client)?;
            writeln!(file, "Input Folder: {}", input_folder.display())?;
            if let Some(gas) = gas_millions {
                writeln!(file, "Gas Filter: {}M", gas)?;
            }
        }
    }

    Ok(())
}
