## Execute the Recursive Example


## Platform Compatibility

Detect your platform and set the appropriate library extension:

```bash
export PIL2_PROOFMAN_EXT=$(if [[ "$(uname -s)" == "Darwin" ]]; then echo ".dylib"; else echo ".so"; fi)
```
### Generate Setup

All commands below should be run from the `pil2-proofman/` directory:

```bash
cd pil2-proofman

cargo run --release --bin pil2c -- ./examples/test-recursive/test.pil \
     -I pil2-components/lib/std/pil \
     -o ./examples/test-recursive/test.pilout

cargo run --release --bin venus-setup -- \
     -a ./examples/test-recursive/test.pilout \
     -b ./examples/test-recursive/build \
     -t pil2-components/lib/std/pil
```

### Build the Project

Build the project with the following command:

```bash
cargo build --workspace
```

### Verify Constraints

Verify the constraints by executing this command:

```bash
cargo run --bin proofman-cli verify-constraints \
     --witness-lib ./target/debug/libtest_recursive${PIL2_PROOFMAN_EXT} \
     --proving-key examples/test-recursive/build/provingKey/
```

### Generate Proof

Finally, generate the proof using the following command:

```bash
     cargo run --bin proofman-cli --features gpu prove \
     --witness-lib ./target/debug/libtest_recursive${PIL2_PROOFMAN_EXT}\
     --proving-key examples/test-recursive/build/provingKey/ \
     --output-dir examples/test-recursive/build/proofs -y -vv
```

### All at once

Run from the `pil2-proofman/` directory:

```bash
cd pil2-proofman
export PIL2_PROOFMAN_EXT=$(if [[ "$(uname -s)" == "Darwin" ]]; then echo ".dylib"; else echo ".so"; fi) \
&& cargo run --release --bin pil2c -- ./examples/test-recursive/test.pil \
     -I pil2-components/lib/std/pil \
     -o ./examples/test-recursive/test.pilout \
&& cargo run --release --bin venus-setup -- \
     -a ./examples/test-recursive/test.pilout \
     -b ./examples/test-recursive/build \
     -t pil2-components/lib/std/pil \
&& cargo build --workspace \
&& cargo run --bin proofman-cli verify-constraints \
     --witness-lib ./target/debug/libtest_recursive${PIL2_PROOFMAN_EXT} \
     --proving-key examples/test-recursive/build/provingKey/ \
&& cargo run --bin proofman-cli prove \
     --witness-lib ./target/debug/libtest_recursive${PIL2_PROOFMAN_EXT}\
     --proving-key examples/test-recursive/build/provingKey/ \
     --output-dir examples/test-recursive/build/proofs -y -vv
```