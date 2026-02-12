# Expression Evaluation HLS - Top-Level Makefile
#
# Prerequisites: module load amd/2025.2
#
# Targets:
#   csim     - Run C-simulation testbench via vitis-run
#   csynth   - Run C-synthesis via v++
#   cosim    - Run Co-simulation via vitis-run
#   package  - Package as XO for Vitis linking
#   clean    - Remove build artifacts

.PHONY: csim csynth cosim package clean

csim:
	$(MAKE) -C test csim

csynth:
	$(MAKE) -C test csynth

cosim:
	$(MAKE) -C test cosim

package:
	$(MAKE) -C test package

clean:
	$(MAKE) -C test clean
