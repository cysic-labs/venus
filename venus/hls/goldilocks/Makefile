# Goldilocks HLS Field Arithmetic - Top-Level Makefile
#
# Prerequisites: module load amd/2025.2
#
# Targets:
#   csim     - Run C-simulation testbench via vitis-run
#   csynth   - Run C-synthesis via v++
#   clean    - Remove build artifacts

.PHONY: csim csynth cosim clean

csim:
	$(MAKE) -C test csim

csynth:
	$(MAKE) -C test csynth

cosim:
	$(MAKE) -C test cosim

clean:
	$(MAKE) -C test clean
