# Venus - FPGA Acceleration Backend for ZisK zkVM

FPGA-accelerated proving backend for the ZisK zero-knowledge virtual machine,
targeting AMD UltraScale+ and Versal devices via Vitis HLS.

## Target Devices

| Device | Part Number | HBM | Family |
|--------|------------|-----|--------|
| VU47P | xcvu47p-fsvh2892-3-e | 16 GB | UltraScale+ |
| VH1782 | xcvh1782-lsva4737-3HP-e-S | 32 GB | Versal |

## Architecture

The proving backend is decomposed into HLS kernels that mirror the GPU
computation graph in `pil2-proofman/pil2-stark/`:

```
venus/
  hls/
    goldilocks/   # Goldilocks field arithmetic (p = 2^64 - 2^32 + 1)
    ntt/          # Number Theoretic Transform (forward/inverse)
    poseidon2/    # Poseidon2 algebraic hash function
    merkle/       # Merkle tree construction (Poseidon2-based)
    expressions/  # Polynomial constraint evaluation
    fri/          # FRI folding and query protocol
    transcript/   # Fiat-Shamir transcript
  rtl/            # Hand-written RTL for timing-critical paths
  host/           # Host-side integration code
  testbench/      # C simulation testbenches
  scripts/        # Build and synthesis scripts
  docs/           # Design documents
```

## Computation Flow

```
Witness -> Unpack -> [Stage Commits] -> Q Polynomial -> Evals -> FRI -> Proof
                         |                    |
                    NTT + Merkle        Expression Eval
                    (Poseidon2)
```

Each stage commit: NTT extend -> Poseidon2 linear hash -> Merkle tree build

## Build

```bash
module load amd/2025.2
# C simulation
make csim
# HLS synthesis
make synth TARGET=vu47p
make synth TARGET=vh1782
# Full build
make build TARGET=vu47p
```

## Runtime Integration

`venus` is integrated as an opt-in proving backend and does not change the
default GPU flow.

```bash
module load intel/compiler cuda openmpi
make prove-venus
make verify
```

`make prove-venus` sets `ZISK_PROVER_BACKEND=venus ZISK_VENUS_MODE=csim`.
The runtime executes a Venus HLS C-simulation preflight (`venus/hls/proof`)
and then runs proving through the stable GPU-compatible runtime path,
producing verifier-accepted proofs.

Optional runtime modes:

- `ZISK_VENUS_MODE=csim` (default for `make prove-venus`): run CSIM preflight + GPU-compatible proving runtime.
- `ZISK_VENUS_MODE=cpu` or `ZISK_VENUS_CPU=1`: software emulation proving path (experimental).
- `ZISK_VENUS_MODE=gpu`: skip CSIM preflight and use GPU-compatible proving runtime.

## Cryptographic Equivalence

Current verifier-valid path:

- `make prove-venus` runs Venus HLS CSIM preflight first and then executes the
  existing GPU proving runtime.
- The resulting proof passes the unmodified ZisK verifier (`make verify`).

Current limitation:

- A pure Venus software proving path (`ZISK_VENUS_MODE=cpu` /
  `ZISK_VENUS_CPU=1`) is still experimental and currently fails in recursive
  witness generation on this workload.
