## Execute the Recursive Example


## Platform Compatibility

Detect your platform and set the appropriate library extension:

```bash
export PIL2_PROOFMAN_EXT=$(if [[ "$(uname -s)" == "Darwin" ]]; then echo ".dylib"; else echo ".so"; fi)
```
### Generate Setup

After compiling the PIL files, generate the setup:

```bash
# TODO: recursive setup with circom is not yet fully supported in venus-setup.
# The legacy JS tooling used flags (-c, -n, -p) that are not available in venus-setup.
cargo run --release --bin venus-setup -- -r \
     -b ./examples/test-recursive/build -t pil2-components/lib/std/pil
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

```bash
export PIL2_PROOFMAN_EXT=$(if [[ "$(uname -s)" == "Darwin" ]]; then echo ".dylib"; else echo ".so"; fi) \
# TODO: recursive setup with circom is not yet fully supported in venus-setup.
# The legacy JS tooling used flags (-c, -n, -p) that are not available in venus-setup.
&& cargo run --release --bin venus-setup -- -r \
     -b ./examples/test-recursive/build -t pil2-components/lib/std/pil \
&& cargo build --workspace \
&& cargo run --bin proofman-cli verify-constraints \
     --witness-lib ./target/debug/libtest_recursive${PIL2_PROOFMAN_EXT} \
     --proving-key examples/test-recursive/build/provingKey/ \
&& cargo run --bin proofman-cli prove \
     --witness-lib ./target/debug/libtest_recursive${PIL2_PROOFMAN_EXT}\
     --proving-key examples/test-recursive/build/provingKey/ \
     --output-dir examples/test-recursive/build/proofs -y -vv
```