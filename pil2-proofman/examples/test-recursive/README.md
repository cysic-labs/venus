## Recursive Example

This example demonstrates the recursive proof composition flow using circom verifier circuits.

> **Note**: This example requires prerequisite setup files (pilout, proving key) to be generated before running. The circom-based recursive setup flow generates these files during the `venus-setup -r` pipeline.

### Prerequisites

The following files must exist before running:
- A compiled `.pilout` file for the recursive test
- Proving keys generated via the setup pipeline
- The `proof.bin` witness file (included in this directory)

### Build and Run

From the `pil2-proofman/` directory:

```bash
cargo build --workspace
```

### Verify Constraints

```bash
cargo run --bin proofman-cli verify-constraints \
     --witness-lib ./target/debug/libtest_recursive$(if [[ "$(uname -s)" == "Darwin" ]]; then echo ".dylib"; else echo ".so"; fi) \
     --proving-key examples/test-recursive/build/provingKey/
```

### Generate Proof

```bash
cargo run --bin proofman-cli prove \
     --witness-lib ./target/debug/libtest_recursive$(if [[ "$(uname -s)" == "Darwin" ]]; then echo ".dylib"; else echo ".so"; fi) \
     --proving-key examples/test-recursive/build/provingKey/ \
     --output-dir examples/test-recursive/build/proofs -y -vv
```
