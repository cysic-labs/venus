## Execute the Recursive Example

All commands should be run from the **repository root** directory.

## Platform Compatibility

Detect your platform and set the appropriate library extension:

```bash
export PIL2_PROOFMAN_EXT=$(if [[ "$(uname -s)" == "Darwin" ]]; then echo ".dylib"; else echo ".so"; fi)
```

### Compile PIL

```bash
cargo run --release --bin pil2c -- pil2-proofman/examples/test-recursive/test.pil \
     -I pil2-proofman/pil2-components/lib/std/pil \
     -o pil2-proofman/examples/test-recursive/test.pilout
```

### Generate Setup

```bash
cargo run --release --bin venus-setup -- \
     -a pil2-proofman/examples/test-recursive/test.pilout \
     -b pil2-proofman/examples/test-recursive/build \
     -t pil2-proofman/pil2-components/lib/std/pil
```

### Build the Project

```bash
cargo build -p test-recursive
```

### Verify Constraints

```bash
cargo run --bin proofman-cli verify-constraints \
     --witness-lib ./target/debug/libtest_recursive${PIL2_PROOFMAN_EXT} \
     --proving-key pil2-proofman/examples/test-recursive/build/provingKey/
```

### Generate Proof

```bash
cargo run --bin proofman-cli prove \
     --witness-lib ./target/debug/libtest_recursive${PIL2_PROOFMAN_EXT} \
     --proving-key pil2-proofman/examples/test-recursive/build/provingKey/ \
     --output-dir pil2-proofman/examples/test-recursive/build/proofs -y -vv
```

### All at once

```bash
export PIL2_PROOFMAN_EXT=$(if [[ "$(uname -s)" == "Darwin" ]]; then echo ".dylib"; else echo ".so"; fi) \
&& cargo run --release --bin pil2c -- pil2-proofman/examples/test-recursive/test.pil \
     -I pil2-proofman/pil2-components/lib/std/pil \
     -o pil2-proofman/examples/test-recursive/test.pilout \
&& cargo run --release --bin venus-setup -- \
     -a pil2-proofman/examples/test-recursive/test.pilout \
     -b pil2-proofman/examples/test-recursive/build \
     -t pil2-proofman/pil2-components/lib/std/pil \
&& cargo build -p test-recursive \
&& cargo run --bin proofman-cli verify-constraints \
     --witness-lib ./target/debug/libtest_recursive${PIL2_PROOFMAN_EXT} \
     --proving-key pil2-proofman/examples/test-recursive/build/provingKey/ \
&& cargo run --bin proofman-cli prove \
     --witness-lib ./target/debug/libtest_recursive${PIL2_PROOFMAN_EXT} \
     --proving-key pil2-proofman/examples/test-recursive/build/provingKey/ \
     --output-dir pil2-proofman/examples/test-recursive/build/proofs -y -vv
```
