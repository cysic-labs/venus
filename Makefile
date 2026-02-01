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

# Paths
CARGO_ZISK := cargo run --release --features gpu --bin cargo-zisk --
WITNESS_LIB := ./target/release/libzisk_witness.so
PROVING_KEY := ./provingKey
GUEST_DIR := ./guest/zisk-eth-client/bin/client/rsp
ELF := $(GUEST_DIR)/target/riscv64ima-zisk-zkvm-elf/release/zec-rsp
INPUT := $(GUEST_DIR)/inputs/20852412_38_3_rsp.bin
PROOF_DIR := ./tmp
PROOF_TMP := $(PROOF_DIR)/vadcop_final_proof.bin
PROOF_FILE := $(PROOF_DIR)/$(notdir $(basename $(INPUT))).proof
VERKEY := $(PROVING_KEY)/zisk/vadcop_final/vadcop_final.verkey.bin

# Proving key download URL (fill in your URL here)
PROVING_KEY_URL := <YOUR_PROVING_KEY_URL_HERE>

.PHONY: all setup build install-toolchain download-key build-guest rom-setup compile-key prove verify clean help

all: setup
	@$(MAKE) prove

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

# Step 3: Check if provingKey exists (user must download manually)
check-key:
	@if [ ! -d "$(PROVING_KEY)" ]; then \
		echo ""; \
		echo "ERROR: provingKey directory not found!"; \
		echo ""; \
		echo "Please download and extract the proving key:"; \
		echo "  curl -L -o ./pk.tgz $(PROVING_KEY_URL) && tar -xzf ./pk.tgz"; \
		echo ""; \
		echo "This will create the ./provingKey directory."; \
		exit 1; \
	fi
	@echo "==> Proving key found at $(PROVING_KEY)"

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
	cargo run --bin proofman-cli check-setup --proving-key $(PROVING_KEY)
	cargo run --bin proofman-cli check-setup --proving-key $(PROVING_KEY) -a

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

# Clean all build artifacts
clean:
	@echo "==> Cleaning..."
	rm -rf target
	rm -rf $(GUEST_DIR)/target
	rm -rf ~/.zisk/cache
	@echo "Note: provingKey is preserved. Remove manually if needed."

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
	@echo "  verify          - Verify the generated proof"
	@echo "  clean           - Clean build artifacts"
	@echo ""
	@echo "First time setup:"
	@echo "  1. Download proving key:"
	@echo "     curl -L -o ./pk.tgz $(PROVING_KEY_URL) && tar -xzf ./pk.tgz"
	@echo "  2. Run: make setup"
	@echo "  3. Run: make prove"
