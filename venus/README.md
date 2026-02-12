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

`make prove-venus` sets `ZISK_PROVER_BACKEND=venus` and routes proving through
the venus-compatible backend path while keeping cryptographic behavior equivalent
to the reference prover.

## Cryptographic Equivalence

The FPGA implementation produces proofs that pass the existing ZisK verifier.
Field arithmetic is bit-exact with the CPU/GPU reference. Hash outputs, Merkle
roots, and FRI responses are identical for the same inputs.
