ROOT := $(CURDIR)

CARGO_ZISK_BIN := $(ROOT)/target/release/cargo-zisk
BUILD_DIR := $(ROOT)/build
PROVING_KEY := $(BUILD_DIR)/provingKey
FIXED_DIR := $(ROOT)/tmp/fixed
PROOF_DIR := $(ROOT)/tmp
PROOF_FILE := $(PROOF_DIR)/vadcop_final_proof.bin

GUEST_DIR := $(ROOT)/guest/zisk-eth-client/bin/guests/stateless-validator-reth
GUEST_NAME := zec-reth
ELF := $(GUEST_DIR)/target/riscv64ima-zisk-zkvm-elf/release/$(GUEST_NAME)
NATIVE_GUEST := $(GUEST_DIR)/target/release/$(GUEST_NAME)
INPUT ?= $(GUEST_DIR)/inputs/mainnet_24628607_66_7_zec_reth.bin

USE_HINTS ?= false
INPUT_STEM := $(basename $(notdir $(INPUT)))
INPUT_BLOCK := $(word 2,$(subst _, ,$(INPUT_STEM)))
HINTS_DIR := $(GUEST_DIR)/hints
HINTS_FILE ?= $(HINTS_DIR)/$(INPUT_BLOCK)_hints.bin

ifeq ($(USE_HINTS),true)
ROM_SETUP_HINTS := -n
PROVE_ARGS := -H $(HINTS_FILE)
PROVE_PREPARE := generate-hints
else
ROM_SETUP_HINTS :=
PROVE_ARGS := -i $(INPUT)
PROVE_PREPARE :=
endif

.PHONY: all setup build install-toolchain check-key generate-key build-guest build-guest-native \
        generate-hints rom-setup compile-key prove verify clean purge help

all: setup prove verify

setup: build install-toolchain check-key build-guest rom-setup compile-key

build:
	cargo build --release --features gpu -p cargo-zisk --bin cargo-zisk

install-toolchain: build
	@if rustup toolchain list | grep -q '^zisk'; then \
		echo "zisk toolchain already installed"; \
	else \
		"$(CARGO_ZISK_BIN)" sdk install-toolchain; \
	fi

check-key:
	@if [ ! -d "$(PROVING_KEY)" ]; then \
		echo "proving key not found at $(PROVING_KEY), generating..."; \
		$(MAKE) generate-key; \
	fi

generate-key:
	mkdir -p "$(BUILD_DIR)" "$(FIXED_DIR)" "$(PROOF_DIR)"
	rm -rf "$(PROVING_KEY)"
	cargo run --release --bin arith_frops_fixed_gen
	cargo run --release --bin binary_basic_frops_fixed_gen
	cargo run --release --bin binary_extension_frops_fixed_gen
	cargo run --release --bin pil2c -- "$(ROOT)/pil/zisk.pil" \
		-I "$(ROOT)/pil,$(ROOT)/pil2-proofman/pil2-components/lib/std/pil,$(ROOT)/state-machines,$(ROOT)/precompiles" \
		-o "$(ROOT)/pil/zisk.pilout" -u "$(FIXED_DIR)" -O fixed-to-file
	cargo run --release --bin pil2-stark-setup -- \
		-a "$(ROOT)/pil/zisk.pilout" -b "$(BUILD_DIR)" \
		-t "$(ROOT)/pil2-proofman/pil2-components/lib/std/pil" \
		-u "$(FIXED_DIR)" -r -s "$(ROOT)/state-machines/starkstructs.json"

build-guest: install-toolchain
	cd "$(GUEST_DIR)" && "$(CARGO_ZISK_BIN)" build --release

build-guest-native:
	mkdir -p "$(GUEST_DIR)/build"
	cd "$(GUEST_DIR)" && RUSTFLAGS='--cfg zisk_hints' cargo build --release

generate-hints: build-guest-native
	mkdir -p "$(GUEST_DIR)/build" "$(HINTS_DIR)"
	rm -f "$(HINTS_FILE)"
	cp "$(INPUT)" "$(GUEST_DIR)/build/input.bin"
	cd "$(GUEST_DIR)" && "./target/release/$(GUEST_NAME)"
	test -f "$(HINTS_FILE)"

rom-setup: build-guest check-key
	"$(CARGO_ZISK_BIN)" rom-setup -e "$(ELF)" -k "$(PROVING_KEY)" $(ROM_SETUP_HINTS)

compile-key: rom-setup
	"$(CARGO_ZISK_BIN)" check-setup -k "$(PROVING_KEY)"
	"$(CARGO_ZISK_BIN)" check-setup -k "$(PROVING_KEY)" -a

prove: check-key $(PROVE_PREPARE)
	@if [ ! -f "$(ELF)" ]; then \
		echo "guest ELF not found at $(ELF), run make setup first"; \
		exit 1; \
	fi
	"$(CARGO_ZISK_BIN)" prove -e "$(ELF)" $(PROVE_ARGS) -k "$(PROVING_KEY)" -o "$(PROOF_DIR)" -a -y

verify: check-key
	@if [ ! -f "$(PROOF_FILE)" ]; then \
		echo "proof file not found at $(PROOF_FILE), run make prove first"; \
		exit 1; \
	fi
	"$(CARGO_ZISK_BIN)" verify -p "$(PROOF_FILE)" -k "$(PROVING_KEY)"

clean:
	rm -rf "$(ROOT)/target" "$(ROOT)/tmp" "$(GUEST_DIR)/target" "$(GUEST_DIR)/build" "$(GUEST_DIR)/hints"

purge: clean
	rm -rf "$(BUILD_DIR)" "$(ROOT)/pil/zisk.pilout"

help:
	@echo "Targets:"
	@echo "  make setup"
	@echo "  make generate-key"
	@echo "  make prove"
	@echo "  make verify"
	@echo ""
	@echo "Variables:"
	@echo "  INPUT=/abs/path/to/input.bin"
	@echo "  USE_HINTS=true"
