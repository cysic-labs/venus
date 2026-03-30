# Venus

Venus is a **compute backend extension and specialization** built on top of [ZisK](https://github.com/0xPolygonHermez/zisk), developed by the [Cysic Labs](https://cysic.xyz) team.

The majority of the codebase originates from the ZisK project. We are deeply grateful to the ZisK team ([0xPolygonHermez](https://github.com/0xPolygonHermez)) for their extraordinary contributions to the community in developing a high-performance zero-knowledge proof zkVM.

Venus follows the same dual-license model as ZisK (Apache 2.0 / MIT). Cysic aims to contribute our expertise in compute backend acceleration to Ethereum and the broader open-source community, with a particular focus on FPGA and ASIC custom acceleration.

## Monorepo Structure

This repository is a deeply integrated monorepo consolidating multiple projects originally from [0xPolygonHermez](https://github.com/0xPolygonHermez):

| Component | Origin | Description |
|---|---|---|
| **`venus-acc/`** | **Cysic Labs** | **FPGA/ASIC acceleration backend (submodule, Cysic original work)** |
| `zisk` | [0xPolygonHermez/zisk](https://github.com/0xPolygonHermez/zisk) | zkVM core: state machines, emulator, executor, PIL definitions, CLI tools |
| `pil2-proofman/` | [0xPolygonHermez/pil2-proofman](https://github.com/0xPolygonHermez/pil2-proofman) | Rust proving backend with GPU (CUDA) acceleration |
| `pil2-compiler/` | [0xPolygonHermez/pil2-compiler](https://github.com/0xPolygonHermez/pil2-compiler) | PIL (Polynomial Identity Language) compiler |
| `pil2-stark-setup/` | Cysic Labs (Rust port) | Rust-native proving key generation and setup (replaces legacy JS tooling) |

We chose this monorepo consolidation because we believe a clean repository with minimal external dependencies facilitates rapid development iteration.

**Attribution**: The code outside `venus-acc/` originates from the [0xPolygonHermez](https://github.com/0xPolygonHermez) team and the ZisK project. Cysic has contributed GPU backend optimizations under `pil2-proofman/` (cudaGraph integration, expression kernel tuning, shared-memory optimization, etc.) and the complete hardware acceleration backend under `venus-acc/`.

## What Cysic Contributes

Cysic specializes in hardware acceleration for zero-knowledge proof systems, with expertise spanning GPU, FPGA, and ASIC backends. On top of the ZisK foundation, Cysic has contributed:

1. **GPU Backend Performance Improvement** -- Optimizations to the existing CUDA proving backend under `pil2-proofman/`, including cudaGraph integration, expression evaluation kernel tuning, and shared-memory optimizations for intermediate buffers. Preliminary benchmarks on RTX 5090 show measurable improvement over the ZisK baseline.

2. **Complete FPGA Acceleration Backend** (`venus-acc/`) -- A full proving system backend implementation targeting FPGA acceleration, with HLS-based kernels (Goldilocks field arithmetic, NTT, Poseidon2, Merkle tree, FRI, expressions evaluation) targeting AMD UltraScale+ and Versal devices with HBM.

3. **Preliminary ASIC-Oriented zkVM Acceleration Chip** -- An initial implementation of a custom silicon design for zkVM proof acceleration.

4. **Ongoing Development** -- Deeper integration of FPGA and ASIC compute backends is under active, high-frequency development.

## Getting Started

To start using ZisK, follow the [Quickstart](https://0xpolygonhermez.github.io/zisk/getting_started/quickstart.html) guide.

Complete Documentation: [ZisK Docs](https://0xpolygonhermez.github.io/zisk/)

## License

All crates in this monorepo are licensed under one of the following options:

- The Apache License, Version 2.0 (see LICENSE-APACHE or http://www.apache.org/licenses/LICENSE-2.0)

- The MIT License (see LICENSE-MIT or http://opensource.org/licenses/MIT)

You may choose either license at your discretion.

## Acknowledgements and Declaration

Venus should be understood as Cysic's optimization, extension, and specialization of specialized hardware backends (GPU, FPGA, ASIC) built on top of the ZisK system.

We extend our deepest gratitude to the [ZisK](https://github.com/0xPolygonHermez/zisk) team and [0xPolygonHermez](https://github.com/0xPolygonHermez) for building and open-sourcing a high-performance zero-knowledge proving virtual machine. Their foundational work makes projects like Venus possible.

We also thank the [Plonky3](https://github.com/Plonky3/Plonky3) team for their contributions to zero-knowledge proving systems, the [RISC-V](https://github.com/riscv) community for providing a robust ISA that enables the zkVM model, and the broader open-source cryptography and ZK research communities whose work continues to advance scalable zero-knowledge technologies.

## Disclaimer: Software Under Development

This software is currently under **active development** and has not been audited for security or correctness.

Please be aware of the following:
* The software is **not fully tested**.
* **Do not use it in production environments** until a stable production release is available.
* Additional functionalities and optimizations **are planned for future releases**.
* Future updates may introduce breaking **backwards compatible changes** as development progresses.
* Mac is currently not supported. We are working to support it soon.

If you encounter any errors or unexpected behavior, please report them. Your feedback is highly appreciated in improving the software.
