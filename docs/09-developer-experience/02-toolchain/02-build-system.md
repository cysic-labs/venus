# Build System

## Overview

A build system automates the compilation, linking, and preparation of programs for the zkVM. Managing the multi-stage toolchain manually is error-prone and tedious; a well-configured build system handles dependencies, applies correct flags, and produces ready-to-prove binaries. Most zkVM projects use Cargo (for Rust) or Make/CMake (for C/C++) with custom configurations for the RISC-V target.

The build system must handle cross-compilation, manage zkVM-specific runtime libraries, apply appropriate optimizations, and integrate with testing and proving infrastructure. This document covers build system configuration, common patterns, and integration with the proving workflow.

## Cargo Configuration

### Project Structure

Standard Rust project layout:

```
project/
├── Cargo.toml
├── .cargo/
│   └── config.toml
├── src/
│   ├── main.rs
│   └── lib.rs
├── build.rs (optional)
└── link.ld
```

### Cargo.toml

Project configuration:

```toml
[package]
name = "zkvm-program"
version = "0.1.0"
edition = "2021"

[dependencies]
zkvm-runtime = "1.0"

[profile.release]
opt-level = 3
lto = true
codegen-units = 1
panic = "abort"

[profile.dev]
opt-level = 0
debug = true
```

### .cargo/config.toml

Build settings:

```toml
[build]
target = "riscv32im-unknown-none-elf"

[target.riscv32im-unknown-none-elf]
runner = "zkvm-run"
rustflags = [
  "-C", "link-arg=-Tlink.ld",
  "-C", "target-feature=+m",
]

[env]
RUSTFLAGS = "-C target-feature=+m"
```

### Build Script

Custom build logic (build.rs):

```rust
fn main() {
  // Tell cargo to link against linker script
  println!("cargo:rustc-link-arg=-Tlink.ld");

  // Rerun if linker script changes
  println!("cargo:rerun-if-changed=link.ld");

  // Include assembly files
  cc::Build::new()
    .file("src/startup.S")
    .compile("startup");
}
```

## Make-Based Builds

### Makefile Structure

For C/C++ or multi-language:

```makefile
# Toolchain
CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
OBJCOPY = riscv32-unknown-elf-objcopy

# Flags
CFLAGS = -O2 -march=rv32im -mabi=ilp32
LDFLAGS = -T link.ld

# Sources
SRCS = main.c utils.c
OBJS = $(SRCS:.c=.o)

# Targets
all: program.elf

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

program.elf: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

clean:
	rm -f $(OBJS) program.elf
```

### Multi-Target Builds

Supporting different configurations:

```makefile
# Configurations
DEBUG_FLAGS = -O0 -g
RELEASE_FLAGS = -O3

# Targets
debug: CFLAGS += $(DEBUG_FLAGS)
debug: program-debug.elf

release: CFLAGS += $(RELEASE_FLAGS)
release: program.elf

test: program-debug.elf
	./run-tests.sh
```

## Build Patterns

### Incremental Builds

Avoiding unnecessary work:

```
Cargo:
  Automatic dependency tracking
  Only recompiles changed files
  Caches intermediate results

Make:
  Dependency rules
  Timestamp-based rebuilds
  Explicit dependencies
```

### Parallel Builds

Faster compilation:

```
Cargo:
  cargo build -j N
  Parallel by default

Make:
  make -j N
  Parallel rule execution

CI:
  Maximize parallelism
  Balance with resources
```

### Reproducible Builds

Consistent output:

```
Strategies:
  Pin toolchain version
  Lock dependencies
  Fixed timestamps
  Deterministic flags

Cargo:
  Cargo.lock commits
  rust-toolchain.toml

Verification:
  Same source → same binary
  Hash comparison
```

## Dependency Management

### Rust Dependencies

Managing crates:

```toml
[dependencies]
# Regular dependencies
serde = { version = "1.0", features = ["derive"] }

# Platform-specific
[target.'cfg(target_arch = "riscv32")'.dependencies]
zkvm-runtime = "1.0"

# Build dependencies
[build-dependencies]
cc = "1.0"
```

### C Dependencies

Managing libraries:

```makefile
# External libraries
LIBS = -lm

# Include paths
INCLUDES = -I./include -I/path/to/zkvm-runtime/include

# Library paths
LDPATHS = -L./lib -L/path/to/zkvm-runtime/lib

program.elf: $(OBJS)
	$(LD) $(LDFLAGS) $^ $(LDPATHS) $(LIBS) -o $@
```

### Submodules/Vendoring

Including source dependencies:

```
Git submodules:
  git submodule add url path
  Version controlled dependency

Vendoring:
  Copy source into project
  Full control over code
  Manual updates
```

## Testing Integration

### Test Targets

Build system test support:

```makefile
# Test targets
test: test-unit test-integration test-proof

test-unit:
	cargo test --lib

test-integration:
	cargo test --test '*'

test-proof:
	./prove-test-program.sh
```

### Test Builds

Separate test configuration:

```toml
[profile.test]
opt-level = 0
debug = true

# Different output
target-dir = "target-test"
```

## CI/CD Integration

### GitHub Actions

Example workflow:

```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Install toolchain
        run: |
          rustup target add riscv32im-unknown-none-elf

      - name: Build
        run: cargo build --release

      - name: Test
        run: cargo test

      - name: Prove
        run: ./scripts/prove.sh
```

### Artifacts

Build outputs:

```yaml
- name: Upload binary
  uses: actions/upload-artifact@v2
  with:
    name: zkvm-program
    path: target/release/program.elf
```

## Optimization

### Build Time Optimization

Faster compilation:

```
Strategies:
  Incremental compilation
  Parallel jobs
  Compiler caching (sccache)
  Minimal dependencies

sccache setup:
  export RUSTC_WRAPPER=sccache
```

### Binary Size Optimization

Smaller output:

```toml
[profile.release]
opt-level = 's'  # Size
lto = true
codegen-units = 1
strip = true
panic = 'abort'
```

### Proving Time Optimization

Better proof performance:

```
Compile-time flags:
  Target appropriate ISA subset
  Enable necessary extensions only

Example:
  -C target-feature=+m  # Only multiply
  # Not: +m,+a,+f,+d (unnecessary)
```

## Key Concepts

- **Build system**: Automation of compilation process
- **Cross-compilation**: Building for different target
- **Incremental builds**: Only rebuild what changed
- **Dependency management**: Handling external code
- **CI/CD integration**: Automated building and testing

## Design Considerations

### Build System Choice

| Cargo | Make |
|-------|------|
| Rust-native | Language-agnostic |
| Automatic | Manual rules |
| Convention | Flexibility |
| Less control | Full control |

### Optimization Strategy

| Dev Build | Release Build |
|-----------|---------------|
| Fast compile | Slow compile |
| Large binary | Small binary |
| Debug info | Stripped |
| Quick iteration | Production ready |

## Related Topics

- [Compiler Integration](01-compiler-integration.md) - Toolchain details
- [Testing and Debugging](../01-programming-model/03-testing-and-debugging.md) - Test integration
- [Program Structure](../01-programming-model/01-program-structure.md) - Source organization
- [Proof Generation Pipeline](../../07-runtime-system/03-prover-runtime/01-proof-generation-pipeline.md) - Proving integration
