# Merkle Tree HLS - Build Targets
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

CFG       := hls_config.cfg
WORK_DIR  := _x_merkle
HDR_DIR   := ..

# Target part (UltraScale+ VU47P)
PART      ?= xcvu47p-fsvh2892-3-e

MT_HDRS   := $(HDR_DIR)/merkle_config.hpp $(HDR_DIR)/merkle_tree.hpp \
             $(HDR_DIR)/merkle_proof.hpp
P2_HDRS   := $(HDR_DIR)/../poseidon2/poseidon2_config.hpp \
             $(HDR_DIR)/../poseidon2/poseidon2_constants.hpp \
             $(HDR_DIR)/../poseidon2/poseidon2_core.hpp \
             $(HDR_DIR)/../poseidon2/poseidon2_linear_hash.hpp
GL_HDRS   := $(HDR_DIR)/../goldilocks/gl64_t.hpp
SRCS      := merkle_test_kernel.cpp $(MT_HDRS) $(P2_HDRS) $(GL_HDRS)
TB_SRC    := tb_merkle.cpp

.PHONY: csim csynth cosim package clean

# C-Simulation: validate functional correctness
csim: $(SRCS) $(TB_SRC) $(CFG)
	@echo "=== Running C-Simulation via vitis-run ==="
	$(VITIS_RUN) --mode hls --csim --config $(CFG) --work_dir $(WORK_DIR)

# C-Synthesis: generate RTL and resource/timing reports
csynth: $(SRCS) $(CFG)
	@echo "=== Running C-Synthesis via v++ ==="
	$(VPP) -c -m hls --config $(CFG) --work_dir $(WORK_DIR)

# Co-Simulation: verify RTL matches C model
cosim: $(SRCS) $(TB_SRC) $(CFG)
	@echo "=== Running Co-Simulation via vitis-run ==="
	$(VITIS_RUN) --mode hls --cosim --config $(CFG) --work_dir $(WORK_DIR)

# Package: generate XO for Vitis linking
package: csynth
	@echo "=== Packaging XO ==="
	$(VITIS_RUN) --mode hls --package --config $(CFG) --work_dir $(WORK_DIR)

clean:
	rm -rf $(WORK_DIR) *.log *.jou
