# Venus - FPGA Acceleration Backend for ZisK zkVM
#
# Prerequisites: module load amd/2025.2
#
# Target devices:
#   vu47p  - xcvu47p-fsvh2892-3-e    (UltraScale+, 16 GB HBM)
#   vh1782 - xcvh1782-lsva4737-3HP-e-S (Versal, 32 GB HBM)
#
# Usage:
#   make csim                  # C-simulation (all HLS components)
#   make synth TARGET=vu47p    # HLS synthesis for VU47P
#   make synth TARGET=vh1782   # HLS synthesis for VH1782
#   make build TARGET=vu47p    # Full hardware build (link XOs -> xclbin)
#   make clean                 # Remove all build artifacts

# ---- Target device selection ----

TARGET     ?= vu47p
VPP        ?= v++
VITIS_RUN  ?= vitis-run

# Map target name to FPGA part number
ifeq ($(TARGET),vu47p)
  PART := xcvu47p-fsvh2892-3-e
else ifeq ($(TARGET),vh1782)
  PART := xcvh1782-lsva4737-3HP-e-S
else
  $(error Unknown TARGET '$(TARGET)'. Use vu47p or vh1782)
endif

# ---- Directories ----

HLS_DIR    := hls
BUILD_DIR  := _build/$(TARGET)
XO_DIR     := $(BUILD_DIR)/xo
XCLBIN_DIR := $(BUILD_DIR)

# HLS components (in dependency order)
COMPONENTS := goldilocks ntt poseidon2 merkle expressions fri transcript proof

# ---- Link configuration ----

# Clock target: 300 MHz (3.33 ns)
CLOCK_MHZ  := 300
LINK_CFG   := link_config_$(TARGET).ini

.PHONY: csim synth cosim package build clean help \
        $(addprefix csim-,$(COMPONENTS)) \
        $(addprefix synth-,$(COMPONENTS))

# ==================================================================
#  C-Simulation (architecture-independent, validates correctness)
# ==================================================================

csim:
	@echo "=== Venus: C-Simulation (all components) ==="
	$(MAKE) -C $(HLS_DIR) PART="$(PART)" csim

# Per-component csim
$(addprefix csim-,$(COMPONENTS)):
	$(MAKE) -C $(HLS_DIR) PART="$(PART)" $@

# ==================================================================
#  HLS Synthesis (generates RTL for target device)
# ==================================================================

synth:
	@echo "=== Venus: HLS Synthesis for $(TARGET) ($(PART)) ==="
	$(MAKE) -C $(HLS_DIR) PART="$(PART)" csynth

# Per-component synth
$(addprefix synth-,$(COMPONENTS)):
	$(MAKE) -C $(HLS_DIR) PART="$(PART)" $(subst synth-,csynth-,$@)

# ==================================================================
#  Co-Simulation (RTL vs C model verification)
# ==================================================================

cosim:
	@echo "=== Venus: Co-Simulation (all components) ==="
	$(MAKE) -C $(HLS_DIR) PART="$(PART)" cosim

# ==================================================================
#  Package (generate XO files for Vitis linking)
# ==================================================================

package:
	@echo "=== Venus: Package XO files ==="
	$(MAKE) -C $(HLS_DIR) PART="$(PART)" package

# ==================================================================
#  Full Build (link XO kernels into xclbin)
# ==================================================================
#
# Links all packaged HLS kernels into a single xclbin for deployment.
# Requires a link configuration file (link_config_<target>.ini) that
# specifies kernel connectivity to HBM banks.
#
# The link configuration is device-specific and maps kernel AXI-MM
# ports to HBM pseudo-channels.

build: package
	@echo "=== Venus: Linking xclbin for $(TARGET) ($(PART)) ==="
	@mkdir -p $(XCLBIN_DIR)
	@if [ ! -f "$(LINK_CFG)" ]; then \
		echo ""; \
		echo "ERROR: Link configuration not found: $(LINK_CFG)"; \
		echo ""; \
		echo "Create $(LINK_CFG) with kernel connectivity settings."; \
		echo "See venus/docs/ for examples."; \
		exit 1; \
	fi
	@XO_FILES="$$(find $(HLS_DIR) -type f -name '*.xo' | tr '\n' ' ')"; \
	if [ -z "$$XO_FILES" ]; then \
		echo ""; \
		echo "ERROR: No packaged XO files were found under $(HLS_DIR)."; \
		echo "Run 'make package TARGET=$(TARGET)' and inspect component packaging logs."; \
		echo ""; \
		exit 1; \
	fi; \
	$(VPP) -l --platform $(PART) --config $(LINK_CFG) \
		--clock.defaultFreqHz $(shell echo $$(($(CLOCK_MHZ) * 1000000))) \
		-o $(XCLBIN_DIR)/venus_$(TARGET).xclbin \
		$$XO_FILES

# ==================================================================
#  Clean
# ==================================================================

clean:
	@echo "=== Venus: Cleaning all build artifacts ==="
	$(MAKE) -C $(HLS_DIR) PART="$(PART)" clean
	rm -rf _build

# ==================================================================
#  Help
# ==================================================================

help:
	@echo "Venus FPGA Acceleration Backend"
	@echo ""
	@echo "Prerequisites: module load amd/2025.2"
	@echo ""
	@echo "Targets:"
	@echo "  csim                 - C-simulation (all HLS components)"
	@echo "  csim-<comp>          - C-simulation for one component"
	@echo "  synth TARGET=<dev>   - HLS synthesis for target device"
	@echo "  synth-<comp>         - HLS synthesis for one component"
	@echo "  cosim                - Co-simulation (all components)"
	@echo "  package              - Package all components as XO"
	@echo "  build TARGET=<dev>   - Full hardware build (xclbin)"
	@echo "  clean                - Remove all build artifacts"
	@echo "  help                 - Show this help"
	@echo ""
	@echo "Target devices:"
	@echo "  vu47p   - xcvu47p-fsvh2892-3-e    (UltraScale+, 16 GB HBM)"
	@echo "  vh1782  - xcvh1782-lsva4737-3HP-e-S (Versal, 32 GB HBM)"
	@echo ""
	@echo "Components: $(COMPONENTS)"
	@echo ""
	@echo "Examples:"
	@echo "  make csim                  # Validate all components"
	@echo "  make csim-ntt              # Validate NTT only"
	@echo "  make synth TARGET=vu47p    # Synthesize for VU47P"
	@echo "  make build TARGET=vu47p    # Full build for VU47P"
