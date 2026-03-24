# ZisK Ethereum Client

An experimental Ethereum execution client built for the [ZisK zkVM](https://github.com/0xPolygonHermez/zisk).

This project enables **stateless block validation** to run, verifying Ethereum blocks without maintaining full blockchain state by using execution witnesses. The validation runs inside the ZisK zkVM, allowing blocks to be proven in real-time.

## Project Structure

```
zisk-eth-client/
├── bin/
│   ├── guests/                  # zkVM guest programs
│   │   └── stateless-validator-reth/  # Reth-based stateless validator
│   ├── host/                    # Benchmark runner for guest programs
│   └── input-gen/               # Input file generator
└── crates/
    ├── guest-reth/              # Core validation library for reth
    └── input/                   # RPC data fetching utilities
```

## Quick Start

### Prerequisites

- [Rust](https://www.rust-lang.org/tools/install) (latest stable)
- [zisk](https://0xpolygonhermez.github.io/zisk/getting_started/installation.html)
- Ethereum RPC endpoint (Infura, Alchemy, or your own node) for input generation

### Build the Guest Program

To build the Reth stateless validator guest program:

```bash
cd bin/guests/stateless-validator-reth
cargo-zisk build --release
```

The ELF binary will be located at:
```
target/riscv64ima-zisk-zkvm-elf/release/zec-reth
```

### Execute the Program in ZisK

Some input files are available in the `bin/guests/stateless-validator-reth/inputs/` folder for testing.

Run the block validation:

```bash
cd bin/guests/stateless-validator-reth
ziskemu -e target/riscv64ima-zisk-zkvm-elf/release/zec-reth \
        -i inputs/<input_file>.bin
```
You can also generate your own inputs using the `input-gen` tool.

### Generate Input Files

Generate an input file for a specific block:

```bash
cargo run --release --bin input-gen -- rpc -u <RPC_URL>
```

This command will fetch the latest block from the specified RPC endpoint and create a serialized input file `<chain>_<block_number>_<txs>_<mgas>_zec_reth.bin` in the `reth-inputs/` folder. 

You can specify options to target specific blocks or ranges as needed. Refer to the [input-gen README](bin/input-gen/README.md) for detailed usage instructions.

## Using a Local ZisK Build

The standard `cargo-zisk` installation fetches the latest published version. If you need to test unreleased features or patches, build ZisK locally from source:

```bash
# Clone and build ZisK
git clone https://github.com/0xPolygonHermez/zisk
cd zisk && cargo build --release
```

Then use the local binaries instead of the installed ones:

```bash
# Build guest with local cargo-zisk
/path/to/zisk/target/release/cargo-zisk build --release

# Execute with local ziskemu
/path/to/zisk/target/release/ziskemu -e <elf> -i <input>
```

## Components

| Component | Description |
|-----------|-------------|
| [**stateless-validator-reth**](bin/guests/stateless-validator-reth/) | zkVM guest program that validates Ethereum blocks statelessly |
| [**host**](bin/host/) | Benchmark runner for executing/proving guest programs |
| [**input-gen**](bin/input-gen/) | Generate inputs from RPC endpoints or EEST test fixtures |
| [**guest-reth**](crates/guest-reth/) | Core library: crypto, validation logic, input types |
| [**input**](crates/input/) | RPC data fetching with `FromRpc` trait |

## Supported Chains

- Ethereum Mainnet
- Sepolia
- Holesky
- Hoodi

## License

Licensed under either of [Apache License, Version 2.0](LICENSE-APACHE) or [MIT License](LICENSE-MIT) at your option.
