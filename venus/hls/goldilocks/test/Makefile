# Goldilocks Field Arithmetic HLS - Build Targets
#
# Prerequisites: module load amd/2025.2  (sets up Vitis HLS tools)
#
# Targets:
#   csim      - C-simulation (functional correctness)
#   csynth    - C-synthesis (generate RTL, check II/latency/resources)
#   cosim     - Co-simulation (RTL vs C model bit-exact check)
#   hw_emu    - Hardware emulation (full AXI data flow)
#   clean     - Remove build artifacts

VITIS_HLS ?= vitis_hls
VPP       ?= v++

# HLS project settings
PROJECT   := gl64_hls
SOLUTION  := sol1
TOP_FN    := gl64_test_kernel
TB_SRC    := tb_gl64.cpp
KERN_SRC  := gl64_test_kernel.cpp
HDR_DIR   := ..

# Target platform (UltraScale+ VU47P)
PART      ?= xcvu47p-fsvh2892-3-e
CLK_NS    ?= 3.33

# Vitis target platform for v++ (adjust to actual .xpfm path)
PLATFORM  ?= xilinx_u55c_gen3x16_xdma_3_202210_1

.PHONY: csim csynth cosim hw_emu clean

# C-Simulation: validate functional correctness
csim: $(TB_SRC) $(KERN_SRC) $(HDR_DIR)/gl64_t.hpp $(HDR_DIR)/gl64_cubic.hpp
	@echo "=== Running C-Simulation ==="
	$(VITIS_HLS) -f - <<'EOF'
	open_project -reset $(PROJECT)
	set_top $(TOP_FN)
	add_files $(KERN_SRC) -cflags "-I$(HDR_DIR)"
	add_files -tb $(TB_SRC) -cflags "-I$(HDR_DIR)"
	open_solution -reset $(SOLUTION) -flow_target vitis
	set_part $(PART)
	create_clock -period $(CLK_NS)
	csim_design
	exit
	EOF

# C-Synthesis: generate RTL and resource/timing reports
csynth: $(KERN_SRC) $(HDR_DIR)/gl64_t.hpp $(HDR_DIR)/gl64_cubic.hpp
	@echo "=== Running C-Synthesis ==="
	$(VITIS_HLS) -f - <<'EOF'
	open_project -reset $(PROJECT)
	set_top $(TOP_FN)
	add_files $(KERN_SRC) -cflags "-I$(HDR_DIR)"
	open_solution -reset $(SOLUTION) -flow_target vitis
	set_part $(PART)
	create_clock -period $(CLK_NS)
	csynth_design
	exit
	EOF
	@echo "=== Synthesis report: $(PROJECT)/$(SOLUTION)/syn/report/$(TOP_FN)_csynth.rpt ==="

# Co-Simulation: verify RTL matches C model
cosim: $(TB_SRC) $(KERN_SRC) $(HDR_DIR)/gl64_t.hpp $(HDR_DIR)/gl64_cubic.hpp
	@echo "=== Running Co-Simulation ==="
	$(VITIS_HLS) -f - <<'EOF'
	open_project -reset $(PROJECT)
	set_top $(TOP_FN)
	add_files $(KERN_SRC) -cflags "-I$(HDR_DIR)"
	add_files -tb $(TB_SRC) -cflags "-I$(HDR_DIR)"
	open_solution -reset $(SOLUTION) -flow_target vitis
	set_part $(PART)
	create_clock -period $(CLK_NS)
	csynth_design
	cosim_design
	exit
	EOF

# Hardware Emulation: test with Vitis v++ flow
hw_emu:
	@echo "=== Building for HW Emulation ==="
	mkdir -p build_hw_emu
	$(VPP) -c -t hw_emu --platform $(PLATFORM) \
		--kernel $(TOP_FN) \
		-I$(HDR_DIR) \
		-o build_hw_emu/$(TOP_FN).xo \
		$(KERN_SRC)
	$(VPP) -l -t hw_emu --platform $(PLATFORM) \
		-o build_hw_emu/$(TOP_FN).xclbin \
		build_hw_emu/$(TOP_FN).xo

clean:
	rm -rf $(PROJECT) build_hw_emu *.log *.jou
