# Goldilocks Field Arithmetic HLS - Build Targets
#
# Prerequisites: module load amd/2025.2
#
# Targets:
#   csim      - C-simulation (functional correctness)
#   csynth    - C-synthesis via v++ (generate RTL, check II/latency/resources)
#   cosim     - Co-simulation (RTL vs C model bit-exact check)
#   package   - Package as XO for Vitis linking
#   clean     - Remove build artifacts

VPP       ?= v++
VITIS_RUN ?= vitis-run

CFG_BASE  := hls_config.cfg
CFG       := _hls_config.cfg
WORK_DIR  := _x_gl64
HDR_DIR   := ..

# Target part (UltraScale+ VU47P)
PART      ?= xcvu47p-fsvh2892-3-e

SRCS      := gl64_test_kernel.cpp $(HDR_DIR)/gl64_t.hpp $(HDR_DIR)/gl64_cubic.hpp $(HDR_DIR)/gl64_constants.hpp
TB_SRC    := tb_gl64.cpp

.PHONY: csim csynth cosim package clean

$(CFG): $(CFG_BASE)
	@sed 's/^part=.*/part=$(PART)/' $(CFG_BASE) > $(CFG)


# C-Simulation: validate functional correctness
csim: $(SRCS) $(TB_SRC) $(CFG)
	@echo "=== Running C-Simulation via vitis-run ==="
	$(VITIS_RUN) --mode hls --csim --config $(CFG) --work_dir $(WORK_DIR)

# C-Synthesis: generate RTL and resource/timing reports
csynth: $(SRCS) $(CFG)
	@echo "=== Running C-Synthesis via v++ ==="
	$(VPP) --compile --mode hls --config $(CFG) --work_dir $(WORK_DIR)

# Co-Simulation: verify RTL matches C model
cosim: $(SRCS) $(TB_SRC) $(CFG)
	@echo "=== Running Co-Simulation via vitis-run ==="
	$(VITIS_RUN) --mode hls --cosim --config $(CFG) --work_dir $(WORK_DIR)

# Package: generate XO for Vitis linking
package: csynth
	@echo "=== Packaging XO ==="
	$(VITIS_RUN) --mode hls --package --config $(CFG) --work_dir $(WORK_DIR)

clean:
	rm -rf $(WORK_DIR) *.log *.jou tb_gl64 $(CFG)
