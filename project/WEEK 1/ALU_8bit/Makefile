TOPLEVEL_LANG ?= verilog
SIM ?= icarus
PWD := $(shell pwd)

# Sources
VERILOG_SOURCES = $(PWD)/design.sv

# Module names
TOPLEVEL := ALU
MODULE   := tb

# Dump waveform
ifeq ($(SIM), icarus)
WAVES ?= 1
ifeq ($(WAVES), 1)
DUMPFILE = dump.vcd
endif
endif

# Cocotb include
include $(shell cocotb-config --makefiles)/Makefile.sim
