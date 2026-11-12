# Venus

Venus is a **compute backend acceleration and specialization** built on top of [ZisK](https://github.com/0xPolygonHermez/zisk), developed by the [Cysic Labs](https://cysic.xyz) team.

The majority of the codebase originates from the ZisK project. We are deeply grateful to the ZisK team ([0xPolygonHermez](https://github.com/0xPolygonHermez)) for their extraordinary contributions to the community in developing a high-performance zero-knowledge proof zkVM.

Venus follows the same dual-license model as ZisK (Apache 2.0 / MIT). Cysic aims to contribute our expertise in compute backend acceleration to Ethereum and the broader open-source community, with a particular focus on GPU, FPGA and ASIC acceleration.

Venus v0.4.0 is built on ZisK v1.4.0-alpha and pil2-proofman v1.4.0-alpha. It keeps their circuits, proving key and security parameters unchanged and accelerates the GPU prover and its pipeline.

## Monorepo Structure

This repository is a monorepo consolidating projects originally from [0xPolygonHermez](https://github.com/0xPolygonHermez):

| Component | Origin | Description |
|---|---|---|
| `zisk` (repository root) | [0xPolygonHermez/zisk](https://github.com/0xPolygonHermez/zisk) v1.4.0-alpha | zkVM core: state machines, emulator, executor, PIL definitions, distributed prover, CLI tools |
| `pil2-proofman/` | [0xPolygonHermez/pil2-proofman](https://github.com/0xPolygonHermez/pil2-proofman) v1.4.0-alpha | Rust proving backend with GPU (CUDA) acceleration, with its sppark and blst dependencies vendored |
| `pil2-compiler/` | [0xPolygonHermez/pil2-compiler](https://github.com/0xPolygonHermez/pil2-compiler) develop-0.14.0 | PIL (Polynomial Identity Language) compiler |

We chose this monorepo consolidation because we believe a clean repository with minimal external dependencies facilitates rapid development iteration.

**Attribution**: The code in this repository originates from the [0xPolygonHermez](https://github.com/0xPolygonHermez) team and the ZisK project. Cysic has contributed the GPU prover and pipeline optimizations described below, mainly under `pil2-proofman/` and in the executor.

## What Cysic Contributes

Cysic specializes in hardware acceleration for zero-knowledge proof systems, with expertise spanning GPU, FPGA, and ASIC backends. On top of ZisK v1.4.0-alpha, Venus v0.4.0 contributes:

1. **Multi-GPU proof pipelining** -- A worker that drives several GPUs prepares the next basic proof, and uploads its witness, while the current proof runs on each GPU. Upstream only pipelines single-GPU workers.

2. **Phase-1 witness concurrency** -- Secondary state-machine instances are shared through `Arc`, so a long witness computation no longer holds the instance map and blocks the registration of the memory instances behind it.

3. **GPU kernel improvements** -- Quotient (Q) expression kernels tuned to their largest spill-free chunk; opening evaluations computed two (polynomial, opening) slots per block; the recursion BLAKE3 witness rows staged in shared memory and stored coalesced; narrow 2^18 and 2^19 NTT batches split into three passes that fill the GPU.

None of these changes alters the circuits, the proving key or the security parameters: the modified kernels compute the same field values as the ZisK ones, and the scheduling changes only reorder work.

## Performance

Ten Ethereum mainnet blocks (26186000-26186009) proved with the [ziskethone](https://github.com/0xPolygonHermez/ziskethone) guest on RTX 5090 GPUs: same machine, same guest and same BLAKE3 proving key for both systems, one block at a time. Times are the coordinator's job duration (execution, contributions, inner proofs and final proof), averaged over the ten blocks. Every proof was verified.

| GPUs | ZisK v1.4.0-alpha | Venus v0.4.0 | Change |
|---|---:|---:|---:|
| 1 | 8.098 s | 7.927 s | -2.1% |
| 2 | 4.542 s | 4.389 s | -3.4% |
| 4 | 2.955 s | 2.888 s | -2.3% |

The Venus figures are the mean of two runs. Run-to-run variation is about 1% at 4 GPUs.

## Getting Started

Venus is used like ZisK v1.4.0-alpha: follow the ZisK [Quickstart](https://0xpolygonhermez.github.io/zisk-docs/developer/getting-started/quickstart) guide and [documentation](https://0xpolygonhermez.github.io/zisk-docs/), with the binaries built from this repository (`cargo build --release`).

Venus uses the ZisK v1.4.0-alpha proving key. To use the tuned GPU quotient kernels, regenerate the key's expression libraries with this repository's tool:

```bash
cargo-zisk-dev proofman-setup gen-exps --proving-key <proving key directory> --arch <CUDA architecture, e.g. 120> \
    --stark-src pil2-proofman/pil2-stark
```

For Ethereum blocks, use the [ziskethone](https://github.com/0xPolygonHermez/ziskethone) guest.

## License

All crates in this monorepo are licensed under one of the following options:

- The Apache License, Version 2.0 (see LICENSE-APACHE or http://www.apache.org/licenses/LICENSE-2.0)

- The MIT License (see LICENSE-MIT or http://opensource.org/licenses/MIT)

You may choose either license at your discretion.

## Acknowledgements and Declaration

Venus should be understood as Cysic's optimization, extension, and specialization of compute backends (GPU, FPGA, ASIC) built on top of the ZisK system.

We extend our deepest gratitude to the [ZisK](https://github.com/0xPolygonHermez/zisk) team and [0xPolygonHermez](https://github.com/0xPolygonHermez) for building and open-sourcing a high-performance zero-knowledge proving virtual machine. Their foundational work makes projects like Venus possible.

We also thank the [Plonky3](https://github.com/Plonky3/Plonky3) team for their contributions to zero-knowledge proving systems, the [RISC-V](https://github.com/riscv) community for providing a robust ISA that enables the zkVM model, and the broader open-source cryptography and ZK research communities whose work continues to advance scalable zero-knowledge technologies.

## Disclaimer: Software Under Development

This software is currently under **active development** and has not been audited for security or correctness.

Please be aware of the following:
* The software is **not fully tested**.
* **Do not use it in production environments** until a stable production release is available.
* Additional functionalities and optimizations **are planned for future releases**.
* Future updates may introduce breaking **backwards compatible changes** as development progresses.
* GPU proving requires Linux with an NVIDIA GPU and CUDA; macOS is not supported for GPU proving.

If you encounter any errors or unexpected behavior, please report them. Your feedback is highly appreciated in improving the software.
