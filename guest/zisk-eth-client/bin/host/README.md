# ZisK Ethereum Client Host

Benchmark runner for ZisK Ethereum Client guest programs.

## Building

```bash
cargo build --release -p host
```

## Usage

```bash
zec-host [OPTIONS] --elf <ELF> <COMMAND>
```

### Global Options

| Option | Description | Default |
|--------|-------------|---------|
| `-a, --action <ACTION>` | Action to perform: `execute`, `verify-constraints`, `prove` | `execute` |
| `--elf <ELF>` | Path to the compiled ZisK ELF binary | Required |
| `--ziskemu <PATH>` | Path to ziskemu binary | Required for `execute` |
| `-p, --proving-key <PATH>` | Path to the proving key file | Required for `verify-constraints`/`prove` |
| `-o, --output-folder <PATH>` | Output folder for benchmark results | None |
| `--force-rerun` | Force rerun even if results exist | `false` |

### Commands

#### `stateless-validator`

Run stateless validator benchmarks.

```bash
zec-host --elf <ELF> stateless-validator [OPTIONS]
```

| Option | Description | Default |
|--------|-------------|---------|
| `-i, --input-folder <PATH>` | Input folder | Required |
| `-c, --client <CLIENT>` | Execution client: `reth` | `reth` |
| `-g, --gas-millions <N>` | Filter tests by gas value (e.g., 1, 5, 10, 20, 30, 60) | None (all tests) |

## Examples

```bash
# Run stateless validator benchmarks (execute action)
zec-host --ziskemu /path/to/ziskemu \
    --elf target/riscv64ima-zisk-zkvm-elf/release/zec-reth \
    stateless-validator -i zkevm-fixtures-input

# Filter by gas value (only run 10M gas tests)
zec-host --ziskemu /path/to/ziskemu \
    --elf target/riscv64ima-zisk-zkvm-elf/release/zec-reth \
    stateless-validator -i zkevm-fixtures-input -g 10

# Verify constraints
zec-host -a verify-constraints \
    -p /path/to/proving-key.bin \
    --elf target/riscv64ima-zisk-zkvm-elf/release/zec-reth \
    stateless-validator -i zkevm-fixtures-input

# Generate proofs
zec-host -a prove \
    -p /path/to/proving-key.bin \
    --elf target/riscv64ima-zisk-zkvm-elf/release/zec-reth \
    stateless-validator -i zkevm-fixtures-input

# Force rerun all benchmarks with custom output folder
zec-host --force-rerun -o my-results \
    --ziskemu /path/to/ziskemu \
    --elf target/riscv64ima-zisk-zkvm-elf/release/zec-reth \
    stateless-validator -i zkevm-fixtures-input
```

## Output

Results are saved as JSON files preserving the input folder structure:

```
<output-folder>/
  stateless-validator/
    1M/
      test_foo.json
      test_bar.json
    10M/
      ...
```

Each result file contains:

```json
{
  "test_name": "test_foo",
  "time": 1.234,
  "metrics": {
    "steps": 1000000,
    "cost": 5000000,
    "tx_count": 42,
    "gas_used": 850000
  }
}
```

A `metadata.log` file is also written with run configuration.