# Fibonacci Square Example Proofman Setup Guide

This guide provides step-by-step instructions for setting up the necessary repositories and executing the Fibonacci square example using the Polygon Hermez zkEVM prover.

## 0. Platform Compatibility

Detect your platform and set the appropriate library extension:

```bash
export PIL2_PROOFMAN_EXT=$(if [[ "$(uname -s)" == "Darwin" ]]; then echo ".dylib"; else echo ".so"; fi)
```

## 1. Set Up Build Environment

### 1.1 Install system packages

Update package lists and install required system packages:

```bash
sudo apt update
sudo apt install -y build-essential libbenchmark-dev libomp-dev libgmp-dev nlohmann-json3-dev nasm libsodium-dev cmake
```

### 1.2 Build Rust tools

Build the PIL2 compiler and setup tool:

```bash
cargo build --release --bin pil2c --bin venus-setup
```

### 1.3 Compile the PIL2 Stark C++ Library

Compile the PIL2 Stark C++ Library (run only once):

```bash
(cd ../pil2-proofman/pil2-stark && make clean && make -j starks_lib && make -j bctree)
```

---


## 2. Execute the Fibonacci Square Example

### 2.1 Compile PIL

To begin, compile the PIL files:

```bash
cargo run --release --bin pil2c -- ./examples/fibonacci-square/pil/build.pil \
     -I ./pil2-components/lib/std/pil \
     -o ./examples/fibonacci-square/pil/build.pilout -u ./examples/fibonacci-square/build/fixed -O fixed-to-file
```

### 2.2 Generate Setup

After compiling the PIL files, generate the setup:

```bash
cargo run --release --bin venus-setup -- \
     -a ./examples/fibonacci-square/pil/build.pilout -t ./pil2-components/lib/std/pil \
     -b ./examples/fibonacci-square/build -r -u ./examples/fibonacci-square/build/fixed
```

<!-- TODO: snark setup is not yet available in venus-setup -->

### 2.3 Generate PIL Helpers

Generate the corresponding PIL helpers by running the following command:

```bash
cargo run --bin proofman-cli pil-helpers \
     --pilout ./examples/fibonacci-square/pil/build.pilout \
     --path ./examples/fibonacci-square/src -o
```


### 2.4 Build the Project

Build the project with the following command:

```bash
cargo build --workspace
```

### 2.5 Verify Constraints

Verify the constraints by executing this command:

```bash
cargo run --bin proofman-cli verify-constraints \
     --witness-lib ./target/debug/libfibonacci_square${PIL2_PROOFMAN_EXT} \
     --proving-key examples/fibonacci-square/build/provingKey/ \
     --public-inputs examples/fibonacci-square/src/inputs.json \
     --custom-commits rom=examples/fibonacci-square/build/rom.bin
```

### 2.6 Generate Proof

Finally, generate the proof using the following command:

```bash
cargo run --bin proofman-cli prove \
     --witness-lib ./target/debug/libfibonacci_square${PIL2_PROOFMAN_EXT} \
     --proving-key examples/fibonacci-square/build/provingKey/ \
     --public-inputs examples/fibonacci-square/src/inputs.json \
     --output-dir examples/fibonacci-square/build/proofs -y 
```


### 2.7 Generate VadcopFinal Proof

This will only work if setup is generated with `-r` flag.
Generate the final proof using the following command:

```bash
cargo run --bin proofman-cli prove \
     --witness-lib ./target/debug/libfibonacci_square${PIL2_PROOFMAN_EXT} \
     --proving-key examples/fibonacci-square/build/provingKey/ \
     --public-inputs examples/fibonacci-square/src/inputs.json \
     --output-dir examples/fibonacci-square/build/proofs \
     -a
```

### 2.9 Generating GPU proof

In order to generate a proof in the GPU, the following commands needs to be executed after generating the setup and pil-helpers

```bash
cargo build --features gpu --workspace \
&& cargo run --features gpu --bin proofman-cli gen-custom-commits-fixed \
     --witness-lib ./target/debug/libfibonacci_square${PIL2_PROOFMAN_EXT} \
     --proving-key examples/fibonacci-square/build/provingKey/ \
     --custom-commits rom=examples/fibonacci-square/build/rom_gpu.bin \
&& cargo run --features gpu --bin proofman-cli prove \
     --witness-lib ./target/debug/libfibonacci_square${PIL2_PROOFMAN_EXT} \
     --proving-key examples/fibonacci-square/build/provingKey/ \
     --public-inputs examples/fibonacci-square/src/inputs.json \
     --output-dir examples/fibonacci-square/build/proofs \
     --custom-commits rom=examples/fibonacci-square/build/rom_gpu.bin -y -a -f
```
### 2.9 All at once

**Without recursion:**

```bash
export PIL2_PROOFMAN_EXT=$(if [[ "$(uname -s)" == "Darwin" ]]; then echo ".dylib"; else echo ".so"; fi) \
&& cargo run --release --bin pil2c -- ./examples/fibonacci-square/pil/build.pil \
     -I ./pil2-components/lib/std/pil \
     -o ./examples/fibonacci-square/pil/build.pilout \
&& cargo run --release --bin venus-setup -- \
     -a ./examples/fibonacci-square/pil/build.pilout \
     -b ./examples/fibonacci-square/build -t pil2-components/lib/std/pil \
&& cargo run --bin proofman-cli pil-helpers \
     --pilout ./examples/fibonacci-square/pil/build.pilout \
     --path ./examples/fibonacci-square/src -o \
&& cargo build --workspace \
&& cargo run --bin proofman-cli gen-custom-commits-fixed \
     --witness-lib ./target/debug/libfibonacci_square${PIL2_PROOFMAN_EXT} \
     --proving-key examples/fibonacci-square/build/provingKey/ \
     --custom-commits rom=examples/fibonacci-square/build/rom.bin \
&& cargo run --bin proofman-cli verify-constraints \
     --witness-lib ./target/debug/libfibonacci_square${PIL2_PROOFMAN_EXT} \
     --proving-key examples/fibonacci-square/build/provingKey/ \
     --public-inputs examples/fibonacci-square/src/inputs.json \
     --custom-commits rom=examples/fibonacci-square/build/rom.bin -d \
&& cargo run --bin proofman-cli prove \
     --witness-lib ./target/debug/libfibonacci_square${PIL2_PROOFMAN_EXT} \
     --proving-key examples/fibonacci-square/build/provingKey/ \
     --public-inputs examples/fibonacci-square/src/inputs.json \
     --output-dir examples/fibonacci-square/build/proofs_cpu \
     --custom-commits rom=examples/fibonacci-square/build/rom.bin -y
```

**With recursion:**

```bash
export PIL2_PROOFMAN_EXT=$(if [[ "$(uname -s)" == "Darwin" ]]; then echo ".dylib"; else echo ".so"; fi) \
&& cargo run --release --bin pil2c -- ./examples/fibonacci-square/pil/build.pil \
     -I ./pil2-components/lib/std/pil \
     -o ./examples/fibonacci-square/pil/build.pilout \
&& cargo run --release --bin venus-setup -- \
     -a ./examples/fibonacci-square/pil/build.pilout \
     -b ./examples/fibonacci-square/build -t pil2-components/lib/std/pil \
     -r \
&& cargo run --bin proofman-cli pil-helpers \
     --pilout ./examples/fibonacci-square/pil/build.pilout \
     --path ./examples/fibonacci-square/src -o \
&& cargo build --workspace \
cargo run --bin proofman-cli gen-custom-commits-fixed \
     --witness-lib ./target/debug/libfibonacci_square${PIL2_PROOFMAN_EXT} \
     --proving-key examples/fibonacci-square/build/provingKey/ \
     --custom-commits rom=examples/fibonacci-square/build/rom.bin \
&& cargo run --bin proofman-cli stats \
     --witness-lib ./target/debug/libfibonacci_square${PIL2_PROOFMAN_EXT} \
     --proving-key examples/fibonacci-square/build/provingKey/ \
     --public-inputs examples/fibonacci-square/src/inputs.json \
     --custom-commits rom=examples/fibonacci-square/build/rom.bin \
&& cargo run --bin proofman-cli prove \
     --witness-lib ./target/debug/libfibonacci_square${PIL2_PROOFMAN_EXT} \
     --proving-key examples/fibonacci-square/build/provingKey/ \
     --public-inputs examples/fibonacci-square/src/inputs.json \
     --custom-commits rom=examples/fibonacci-square/build/rom.bin \
     --verify-proofs \
     --aggregation \
     --compressed \
     --output-dir examples/fibonacci-square/build/proofs \
&& cargo run --bin proofman-cli verify-stark \
     --proof ./examples/fibonacci-square/build/proofs/vadcop_final_proof.bin \
     --verkey ./examples/fibonacci-square/build/provingKey/build/vadcop_final_compressed/vadcop_final_compressed.verkey.bin
```
