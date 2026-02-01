use clap::ValueEnum;
use std::fmt::Display;
use url::Url;

#[derive(Debug, Clone, ValueEnum)]
pub enum Network {
    Mainnet,
    Sepolia,
}

#[derive(Debug, Clone, ValueEnum)]
pub enum GuestProgram {
    Rsp,
    Zeth,
}

pub struct InputGenerator {
    pub rpc_url: Url,
    pub network: Network,
}

impl InputGenerator {
    pub fn new(rpc_url: Url, network: Network) -> Self {
        Self { rpc_url, network }
    }
}

pub struct InputGeneratorResult {
    pub guest: GuestProgram,
    pub input: Vec<u8>,
    pub gas_used: u64,
    pub tx_count: u64,
}

impl Display for GuestProgram {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            GuestProgram::Rsp => write!(f, "rsp"),
            GuestProgram::Zeth => write!(f, "zeth"),
        }
    }
}
