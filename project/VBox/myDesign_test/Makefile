TOPLEVEL_LANG ?= verilog
SIM ?= icarus
PWD := $(shell pwd)

# Sources
VERILOG_SOURCES = $(PWD)/mkVecUnit.v

# Module names
TOPLEVEL := mkVecUnit
MODULE   := test

# Cocotb include
include $(shell cocotb-config --makefiles)/Makefile.sim
