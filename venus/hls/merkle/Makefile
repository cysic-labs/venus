# Merkle Tree HLS - Top-Level Makefile
#
# Prerequisites: module load amd/2025.2
#
# Targets:
#   csim     - Run C-simulation testbench via vitis-run
#   csynth   - Run C-synthesis via v++
#   cosim    - Run Co-simulation via vitis-run
#   package  - Package as XO for Vitis linking
#   clean    - Remove build artifacts

PART ?= xcvu47p-fsvh2892-3-e

.PHONY: csim csynth cosim package clean

csim:
	$(MAKE) -C test PART="$(PART)" csim

csynth:
	$(MAKE) -C test PART="$(PART)" csynth

cosim:
	$(MAKE) -C test PART="$(PART)" cosim

package:
	$(MAKE) -C test PART="$(PART)" package

clean:
	$(MAKE) -C test PART="$(PART)" clean
