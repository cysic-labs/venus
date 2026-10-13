ROOT := $(CURDIR)

CARGO_ZISK_BIN := $(ROOT)/target/release/cargo-zisk
BUILD_DIR := $(ROOT)/build
PROVING_KEY := $(BUILD_DIR)/provingKey
KEY_GLOBAL_INFO := $(PROVING_KEY)/pilout.globalInfo.json
KEY_STAMP := $(PROVING_KEY)/.setup-complete
FIXED_DIR := $(ROOT)/tmp/fixed
PROOF_DIR := $(ROOT)/tmp
PROOF_FILE := $(PROOF_DIR)/vadcop_final_proof.bin
VERIFIER_SRC_DIR := $(ROOT)/pil2-proofman/verifier/src
# Native verifiers derived by the setup, as <proving-key file>:<checked-in source> pairs
RUST_VERIFIERS := $(PROVING_KEY)/zisk/Zisk/recursive2/recursive2.verifier.rs:$(VERIFIER_SRC_DIR)/recursive2_verifier.rs \
                  $(PROVING_KEY)/zisk/vadcop_final/vadcop_final.verifier.rs:$(VERIFIER_SRC_DIR)/vadcop_final_verifier.rs \
                  $(PROVING_KEY)/zisk/vadcop_final_compressed/vadcop_final_compressed.verifier.rs:$(VERIFIER_SRC_DIR)/vadcop_final_verifier_compressed.rs
PILOUT := $(ROOT)/pil/zisk.pilout
PIL_SOURCE_DIRS := $(ROOT)/pil $(ROOT)/state-machines $(ROOT)/precompiles $(ROOT)/pil2-proofman/pil2-components/lib/std/pil
KEY_GENERATOR_INPUTS := $(ROOT)/pk-setup-rs/src $(ROOT)/pk-setup-rs/assets $(ROOT)/pk-setup-rs/Cargo.toml \
                        $(ROOT)/state-machines/arith/src/arith_frops.rs \
                        $(ROOT)/state-machines/binary/src/binary_basic_frops.rs \
                        $(ROOT)/state-machines/binary/src/binary_extension_frops.rs \
                        $(ROOT)/Cargo.toml $(ROOT)/Cargo.lock

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

PIL_NODE_MAX_OLD_SPACE_SIZE ?= 49152
NODE := node --max-old-space-size=$(PIL_NODE_MAX_OLD_SPACE_SIZE)

ifeq ($(USE_HINTS),true)
ROM_SETUP_HINTS := -n
PROVE_ARGS := -H $(HINTS_FILE)
PROVE_PREPARE := generate-hints
else
ROM_SETUP_HINTS :=
PROVE_ARGS := -i $(INPUT)
PROVE_PREPARE :=
endif
PROVE_GPU_ARGS ?= -t 2 -h 4
CARGO_BUILD_RUSTFLAGS ?= -C target-cpu=native
PROVE_ENV ?= CUDA_MODULE_LOADING=EAGER CUDA_DEVICE_MAX_CONNECTIONS=32 RAYON_NUM_THREADS=16 VENUS_ROWMAJOR_REG=1 VENUS_ROWMAJOR_TPB=256 VENUS_WEIGHTED_PROOF_ORDER=1 VENUS_MAIN_FRI_STATIC=1 VENUS_COMPRESSOR_FIRST_ORDER=1 VENUS_BASIC_PRELOAD_AIR_IDS=12,22 VENUS_EXPR_MAX_BLOCKS=288 VENUS_FRI_MAX_BLOCKS=512 VENUS_WEIGHT_Q_OPS=14 VENUS_REGISTER_WITNESS_H2D=1 VENUS_DIRECT_REGISTERED_H2D=1 VENUS_PINNED_CHUNK_MB=128 VENUS_REUSE_CUSTOM_FIXED=1 VENUS_RECURSIVE_WITNESS_WORKERS=20 VENUS_CONTRIBUTION_WORKERS=12 VENUS_SKIP_NATIVE_RECURSIVE_VERIFY=1 VENUS_RECURSIVE_TRACE_PINNED_POOL=1 VENUS_RECURSIVE_TRACE_PINNED_POOL_LIMIT=32 VENUS_COMPRESSOR_PRELOAD_AIR_IDS=28,26 VENUS_CONST_TREE_HOST_CACHE_MB=12288 VENUS_CONST_TREE_HOST_CACHE_FILTER=recursive1/,/air/ VENUS_CONST_TREE_HOST_CACHE_MIN_USES=2 VENUS_CONST_TREE_HOST_CACHE_ASYNC_H2D=1 VENUS_CONST_TREE_HOST_CACHE_SETUP_PREWARM=1 VENUS_CONST_TREE_HOST_CACHE_SETUP_PREWARM_LIST=tools/consttree-prewarm-zisk-large.txt VENUS_CONST_TREE_HOST_CACHE_SETUP_PREWARM_MODE=sync

.PHONY: all setup build install-toolchain check-key compile-pil generate-rust-verifiers check-rust-verifiers generate-key generate-key-rs \
        generate-snark-key build-guest build-guest-native generate-hints rom-setup compile-key prove verify clean purge help

all: setup prove verify

setup: build install-toolchain check-key check-rust-verifiers build-guest rom-setup compile-key

build:
	RUSTFLAGS="$(CARGO_BUILD_RUSTFLAGS)" cargo build --release --features gpu -p cargo-zisk --bin cargo-zisk

install-toolchain: build
	@if rustup toolchain list | grep -q '^zisk'; then \
		echo "zisk toolchain already installed"; \
	else \
		"$(CARGO_ZISK_BIN)" sdk install-toolchain; \
	fi

check-key:
	@key_stamp="$(KEY_STAMP)"; \
	if [ ! -d "$(PROVING_KEY)" ]; then \
		echo "proving key not found at $(PROVING_KEY), generating..."; \
		$(MAKE) generate-key-rs; \
	elif [ ! -f "$(KEY_GLOBAL_INFO)" ]; then \
		echo "proving key global info not found at $(KEY_GLOBAL_INFO), regenerating..."; \
		$(MAKE) generate-key-rs; \
	elif [ ! -f "$$key_stamp" ]; then \
		echo "proving key completion stamp not found at $$key_stamp, regenerating..."; \
		$(MAKE) generate-key-rs; \
	elif [ ! -f "$(PILOUT)" ]; then \
		echo "PILOUT not found at $(PILOUT), regenerating proving key..."; \
		$(MAKE) generate-key-rs; \
	elif [ "$(PILOUT)" -nt "$$key_stamp" ]; then \
		echo "PILOUT is newer than proving key, regenerating..."; \
		$(MAKE) generate-key-rs; \
	elif [ -n "$$(find $(PIL_SOURCE_DIRS) -type f \( -name '*.pil' -o -name '*.json' -o -name '*.bin' \) -newer "$$key_stamp" -print -quit)" ]; then \
		echo "PIL sources are newer than proving key, regenerating..."; \
		$(MAKE) generate-key-rs; \
	elif [ -n "$$(find $(KEY_GENERATOR_INPUTS) -type f -newer "$$key_stamp" -print -quit)" ]; then \
		echo "proving-key generator inputs are newer than proving key, regenerating..."; \
		$(MAKE) generate-key-rs; \
	fi

generate-key:
	$(MAKE) generate-key-rs

compile-pil:
	mkdir -p "$(BUILD_DIR)" "$(FIXED_DIR)" "$(PROOF_DIR)"
	npm install --prefix "$(ROOT)/pil2-compiler"
	cargo run --release --bin arith_frops_fixed_gen
	cargo run --release --bin binary_basic_frops_fixed_gen
	cargo run --release --bin binary_extension_frops_fixed_gen
	$(NODE) "$(ROOT)/pil2-compiler/src/pil.js" "$(ROOT)/pil/zisk.pil" \
		-I "$(ROOT)/pil,$(ROOT)/pil2-proofman/pil2-components/lib/std/pil,$(ROOT)/state-machines,$(ROOT)/precompiles" \
		-o "$(PILOUT)" -u "$(FIXED_DIR)" -O fixed-to-file

generate-key-rs: compile-pil
	rm -rf "$(PROVING_KEY)"
	cargo run --release -p pk-setup-rs --bin generate-key-rs -- \
		--root "$(ROOT)" --build-dir "$(BUILD_DIR)" \
		--fixed-dir "$(FIXED_DIR)" --proof-dir "$(PROOF_DIR)" \
		--airout "$(PILOUT)" \
		--starkstructs "$(ROOT)/state-machines/starkstructs.json" -r
	touch "$(KEY_STAMP)"

# The native verifiers in pil2-proofman/verifier/src hardcode the recursion AIRs. The setup derives
# them into the proving key; copy them over (and rebuild) whenever the recursion setup changes.
generate-rust-verifiers: check-key
	@for pair in $(RUST_VERIFIERS); do cp "$${pair%%:*}" "$${pair##*:}"; done

check-rust-verifiers: check-key
	@for pair in $(RUST_VERIFIERS); do \
		if ! cmp -s "$${pair%%:*}" "$${pair##*:}"; then \
			echo "$${pair##*:} does not match the proving key; run 'make generate-rust-verifiers' and rebuild"; \
			exit 1; \
		fi; \
	done

# The SNARK wrapper for on-chain verification, in $(BUILD_DIR)/provingKeySnark: the recursivef STARK
# from the native setup and the final PLONK or fflonk SNARK over it from pil2-proofman-js. PTAU must
# be a powers-of-tau file large enough for the final circuit.
SNARK ?= plonk
generate-snark-key: check-key
	@if [ -z "$(PTAU)" ]; then echo "set PTAU=<powers of tau file>"; exit 1; fi
	cargo run --release -p pk-setup-rs --bin generate-key-rs -- \
		--root "$(ROOT)" --build-dir "$(BUILD_DIR)" --snark
	npm install --prefix "$(ROOT)/pil2-proofman-js"
	$(NODE) "$(ROOT)/pil2-proofman-js/src/main_setup_snark.js" -b "$(BUILD_DIR)" \
		-p "$(ROOT)/state-machines/publics.json" -w "$(PTAU)" -n "$(SNARK)"

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
	$(PROVE_ENV) "$(CARGO_ZISK_BIN)" prove -e "$(ELF)" $(PROVE_ARGS) -k "$(PROVING_KEY)" -o "$(PROOF_DIR)" -a -y $(PROVE_GPU_ARGS)

verify: check-key check-rust-verifiers
	@if [ ! -f "$(PROOF_FILE)" ]; then \
		echo "proof file not found at $(PROOF_FILE), run make prove first"; \
		exit 1; \
	fi
	"$(CARGO_ZISK_BIN)" verify -p "$(PROOF_FILE)" -k "$(PROVING_KEY)"

clean:
	rm -rf "$(ROOT)/target" "$(ROOT)/tmp" "$(GUEST_DIR)/target" "$(GUEST_DIR)/build" "$(GUEST_DIR)/hints"

purge: clean
	rm -rf "$(BUILD_DIR)" "$(ROOT)/pil/zisk.pilout" "$(ROOT)/pil2-compiler/node_modules" "$(ROOT)/pil2-proofman-js/node_modules"

help:
	@echo "Targets:"
	@echo "  make setup"
	@echo "  make generate-key"
	@echo "  make generate-key-rs"
	@echo "  make compile-pil"
	@echo "  make generate-rust-verifiers"
	@echo "  make generate-snark-key PTAU=/path/to/powersOfTau.ptau [SNARK=plonk|fflonk]"
	@echo "  make prove"
	@echo "  make verify"
	@echo ""
	@echo "Variables:"
	@echo "  INPUT=/abs/path/to/input.bin"
	@echo "  USE_HINTS=true"
	@echo "  PIL_NODE_MAX_OLD_SPACE_SIZE=49152"
