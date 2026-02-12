# ZisK End-to-End Build & Prove Makefile
#
# Prerequisites:
#   - Rust toolchain installed
#   - GPU support (CUDA) for proving
#
# Usage:
#   make setup      # First time setup (build + toolchain + guest + rom-setup)
#   make prove      # Prove the sample block
#   make verify     # Verify the generated proof
#   make clean      # Clean all build artifacts
#
# Full smoke pipeline:
#   module load intel/compiler cuda openmpi && \
#   make clean && rm -rf ~/.zisk && make all

# Paths
CARGO_ZISK := cargo run --release --features gpu --bin cargo-zisk --
WITNESS_LIB := ./target/release/libzisk_witness.so
BUILD_DIR := ./build
PROVING_KEY := $(BUILD_DIR)/provingKey
GUEST_DIR := ./guest/zisk-eth-client/bin/client/rsp
ELF := $(GUEST_DIR)/target/riscv64ima-zisk-zkvm-elf/release/zec-rsp
INPUT ?= $(GUEST_DIR)/inputs/20852412_38_3_rsp.bin
PROOF_DIR := ./tmp
PROOF_TMP := $(PROOF_DIR)/vadcop_final_proof.bin
PROOF_FILE := $(PROOF_DIR)/$(notdir $(basename $(INPUT))).proof
VERKEY := $(PROVING_KEY)/zisk/vadcop_final/vadcop_final.verkey.bin
VENUS_DIR := ./venus

.PHONY: all setup build install-toolchain download-key build-guest rom-setup compile-key prove prove-venus verify \
        venus-csim venus-synth venus-cosim venus-package venus-build \
        clean purge generate-key help

all: setup
	@$(MAKE) prove
	@$(MAKE) verify

# Full setup: build everything needed for proving
setup: build install-toolchain check-key build-guest rom-setup compile-key
	@echo ""
	@echo "Setup complete! You can now run: make prove"

# Step 1: Build cargo-zisk and other tools
build:
	@echo "==> Building ZisK tools..."
	cargo build --release --features gpu

# Step 2: Install the ZisK RISC-V toolchain
install-toolchain: build
	@echo "==> Installing ZisK toolchain..."
	$(CARGO_ZISK) sdk install-toolchain

# Step 3: Check if proving key folder exists; offer to generate if missing
check-key:
	@if [ ! -d "$(PROVING_KEY)" ]; then \
		echo ""; \
		echo "WARNING: proving key directory not found at $(PROVING_KEY)"; \
		echo ""; \
		echo "Would you like to generate it? This may take ~30 minutes."; \
		printf "Type CONFIRM to generate, or anything else to abort: "; \
		read answer; \
		if [ "$$answer" = "CONFIRM" ]; then \
			$(MAKE) generate-key; \
		else \
			echo "Aborted. Cannot proceed without proving key."; \
			exit 1; \
		fi; \
	fi
	@echo "==> Proving key found at $(PROVING_KEY)"

# Generate proving key from source
generate-key:
	@echo "==> Installing npm dependencies..."
	npm i --prefix pil2-compiler
	npm i --prefix pil2-proofman-js
	@echo "==> Generating fixed columns..."
	cargo run --release --bin arith_frops_fixed_gen
	cargo run --release --bin binary_basic_frops_fixed_gen
	cargo run --release --bin binary_extension_frops_fixed_gen
	@echo "==> Compiling PIL..."
	node --max-old-space-size=16384 ./pil2-compiler/src/pil.js pil/zisk.pil \
		-I pil,./pil2-proofman/pil2-components/lib/std/pil,state-machines,precompiles \
		-o pil/zisk.pilout -u tmp/fixed -O fixed-to-file
	@echo "==> Running setup to generate proving key..."
	node --max-old-space-size=16384 --stack-size=8192 ./pil2-proofman-js/src/main_setup.js \
		-a ./pil/zisk.pilout -b $(BUILD_DIR) -t ./pil2-proofman/pil2-components/lib/std/pil \
		-u tmp/fixed -r -s ./state-machines/starkstructs.json
	@echo "==> Proving key generated at $(PROVING_KEY)"

# Step 4: Build the guest application (ETH client)
build-guest: install-toolchain
	@echo "==> Building guest application..."
	cd $(GUEST_DIR) && $(CURDIR)/target/release/cargo-zisk build --release

# Step 5: ROM setup for the compiled ELF
rom-setup: build-guest check-key
	@echo "==> Running ROM setup..."
	$(CARGO_ZISK) rom-setup -e $(ELF) -k $(PROVING_KEY) -z $(CURDIR)

# Step 6: Compile proving key (check-setup)
compile-key: rom-setup
	@echo "==> Compiling proving key (check-setup)..."
	cargo run --bin proofman-cli --features gpu check-setup --proving-key $(PROVING_KEY)
	cargo run --bin proofman-cli --features gpu check-setup --proving-key $(PROVING_KEY) -a

# Step 7: Prove the block
prove: check-key
	@echo "==> Running prove..."
	$(CARGO_ZISK) prove \
		-w $(WITNESS_LIB) \
		-k $(PROVING_KEY) \
		-e $(ELF) \
		-i $(INPUT) \
		-o $(PROOF_DIR) \
		-a -y -r
	@cp -f $(PROOF_TMP) $(PROOF_FILE)

prove-venus: check-key
	@echo "==> Running prove with Venus backend..."
	ZISK_PROVER_BACKEND=venus $(CARGO_ZISK) prove \
		-w $(WITNESS_LIB) \
		-k $(PROVING_KEY) \
		-e $(ELF) \
		-i $(INPUT) \
		-o $(PROOF_DIR) \
		-a -y -r
	@cp -f $(PROOF_TMP) $(PROOF_FILE)

# Step 8: Verify the generated proof
verify: check-key
	@if [ ! -f "$(PROOF_FILE)" ]; then \
		echo ""; \
		echo "ERROR: Proof file not found at $(PROOF_FILE)"; \
		echo "Run: make prove"; \
		echo ""; \
		exit 1; \
	fi
	@echo "==> Verifying proof..."
	$(CARGO_ZISK) verify -p $(PROOF_FILE) -k $(VERKEY)

# Venus FPGA backend targets (non-invasive: does not change default GPU flow)
venus-csim:
	@$(MAKE) -C $(VENUS_DIR) csim

venus-synth:
	@$(MAKE) -C $(VENUS_DIR) synth $(if $(TARGET),TARGET=$(TARGET),)

venus-cosim:
	@$(MAKE) -C $(VENUS_DIR) cosim $(if $(TARGET),TARGET=$(TARGET),)

venus-package:
	@$(MAKE) -C $(VENUS_DIR) package $(if $(TARGET),TARGET=$(TARGET),)

venus-build:
	@$(MAKE) -C $(VENUS_DIR) build $(if $(TARGET),TARGET=$(TARGET),)

# Clean all build artifacts (preserves proving key)
clean:
	@echo "==> Cleaning..."
	rm -rf target lib-c/target lib-float/target $(GUEST_DIR)/target ~/.zisk tmp
	@echo "Note: proving key in build/ is preserved. Use 'make purge' to remove everything."

# Full clean including proving key (~30 min to regenerate)
purge: clean
	@echo ""
	@echo "WARNING: This will delete $(BUILD_DIR)/ which contains the proving key."
	@echo "Regenerating the proving key takes ~30 minutes."
	@printf "Type CONFIRM to proceed, or anything else to abort: "
	@read answer; \
	if [ "$$answer" = "CONFIRM" ]; then \
		rm -rf $(BUILD_DIR); \
		echo "==> $(BUILD_DIR)/ removed."; \
	else \
		echo "Aborted. $(BUILD_DIR)/ was preserved."; \
	fi

# Help
help:
	@echo "ZisK Build System"
	@echo ""
	@echo "Targets:"
	@echo "  setup           - Full setup (build + toolchain + guest + rom-setup)"
	@echo "  build           - Build ZisK tools only"
	@echo "  install-toolchain - Install the ZisK RISC-V toolchain"
	@echo "  build-guest     - Build the guest ETH client"
	@echo "  rom-setup       - Run ROM setup for the guest ELF"
	@echo "  compile-key     - Compile proving key (check-setup)"
	@echo "  prove           - Prove the sample block"
	@echo "  prove-venus     - Prove with Venus runtime backend (ZISK_PROVER_BACKEND=venus)"
	@echo "  verify          - Verify the generated proof"
	@echo "  venus-csim      - Run Venus FPGA HLS C-simulation"
	@echo "  venus-synth     - Run Venus FPGA HLS synthesis (TARGET=vu47p|vh1782)"
	@echo "  venus-cosim     - Run Venus FPGA HLS co-simulation"
	@echo "  venus-package   - Package Venus kernels as XO files"
	@echo "  venus-build     - Link Venus XOs into xclbin (TARGET=vu47p|vh1782)"
	@echo "  clean           - Clean build artifacts (preserves proving key)"
	@echo "  purge           - Clean everything including proving key"
	@echo "  generate-key    - Generate proving key from source (~30 min)"
	@echo ""
	@echo "First time setup:"
	@echo "  1. Run: make setup (will offer to generate proving key if missing)"
	@echo "  2. Run: make prove"
	@echo ""
	@echo "Full smoke pipeline:"
	@echo "  module load intel/compiler cuda openmpi && \\"
	@echo "  make clean && rm -rf ~/.zisk && make all"
