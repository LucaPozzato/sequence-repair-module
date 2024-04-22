# Makefile

# defaults
SIM ?= ghdl
TOPLEVEL_LANG ?= vhdl

SIM_ARGS+=--vcd=wave.vcd

VHDL_SOURCES += $(PWD)/src/design.vhd
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = project_reti_logiche

# MODULE is the basename of the Python test file
MODULE = test_bench

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim