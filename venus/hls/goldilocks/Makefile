# Makefile for Goldilocks HLS Field Arithmetic
#
# Targets:
#   csim     - Compile and run C simulation testbench (g++ with Vitis ap_int.h)
#   clean    - Remove build artifacts
#
# Prerequisites:
#   module load amd/2025.2  (sets XILINX_VITIS for ap_int.h include)
#   Or set VITIS_INCLUDE manually

VITIS_INCLUDE ?= /mnt/nas0/software/Xilinx/2025.2/Vitis/include

CXX       = g++
CXXFLAGS  = -O2 -std=c++14 -Wall -I$(VITIS_INCLUDE)
TB_SRC    = test/tb_gl64.cpp
TB_BIN    = test/tb_gl64

.PHONY: csim clean

csim: $(TB_BIN)
	./$(TB_BIN)

$(TB_BIN): $(TB_SRC) gl64_t.hpp gl64_cubic.hpp gl64_constants.hpp
	$(CXX) $(CXXFLAGS) -I. -o $@ $<

clean:
	rm -f $(TB_BIN) test/*.o
