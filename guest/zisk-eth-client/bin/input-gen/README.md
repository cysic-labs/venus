# ZisK Input Generator

Generates serialized input files for the ZisK Ethereum Client stateless validator guest programs.

## Building

```bash
cargo build --release -p input-gen
```

## Usage

```bash
input-gen [OPTIONS] <COMMAND>
```

### Global Options

| Option | Description | Default |
|--------|-------------|---------|
| `-c, --client <CLIENT>` | Execution client: `reth` | `reth` |
| `-o, --output <PATH>` | Output folder | `<client>-inputs` |

### Commands

#### `rpc` — Generate from RPC endpoint

Fetch blocks directly from an Ethereum RPC endpoint.

```bash
input-gen rpc -u <RPC_URL> [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-u, --rpc-url <URL>` | RPC endpoint URL (required) |
| `-H, --rpc-headers <K:V>` | Custom headers (repeatable) |
| `-l, --last-n-blocks <N>` | Last N blocks |
| `-b, --block <N>` | Specific block number |
| `-r, --range-of-blocks <START> <END>` | Block range (inclusive) |
| `-f, --follow` | Continuously follow new blocks |

**Examples:**

```bash
# Single block
input-gen rpc -u <RPC_URL> -b 22767493

# Range of blocks
input-gen rpc -u <RPC_URL> -r 22767490 22767500

# Last 5 blocks
input-gen rpc -u <RPC_URL> -l 5

# Follow new blocks (Ctrl+C to stop)
input-gen rpc -u <RPC_URL> -f

# With custom headers
input-gen rpc -u <RPC_URL> -H "Authorization:Bearer TOKEN" -b 22767493
```

#### `eest` — Generate from EEST fixtures

Generate inputs from [Ethereum Execution Spec Tests](https://github.com/ethereum/execution-spec-tests) fixtures.

```bash
input-gen eest [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-t, --tag <TAG>` | EEST release tag |
| `-p, --eest-fixtures-path <PATH>` | Path to fixtures |
| `-i, --include <PATTERN>` | Filter tests by name (repeatable) |
| `-e, --exclude <PATTERN>` | Exclude tests by name (repeatable) |
| `-t, --threads <N>` | Number of threads for processing |

**Examples:**

```bash
# Generate from default fixtures
input-gen eest

# Use specific release tag
input-gen eest --tag v3.0.0

# Filter by test name pattern
input-gen eest --include modexp
```

## Output

Generated inputs are saved as `.bin` files with the naming convention:

```
<chain>_<block>_<txs>_<mgas>_zec_<client>.bin
```

Example: `mainnet_22767493_156_12_zec_reth.bin`

- **chain**: Network name (mainnet, sepolia, holesky, hoodi)
- **block**: Block number
- **txs**: Number of transactions
- **mgas**: Gas used in megagas (MGas)
- **client**: Target execution client