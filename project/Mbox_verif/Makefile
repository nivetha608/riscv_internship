TOPLEVEL_LANG ?= verilog

COMPILE_ARGS += -g2012 -Wall \
  -DBSV_RESET_FIFO_HEAD \
  -DBSV_RESET_FIFO_ARRAY

PWD := $(shell pwd)
TOP_DIR := $(PWD)
TOP_MODULE := mkmbox

VERILOG_SOURCES = $(TOP_DIR)/mkmbox.v \
                  $(TOP_DIR)/mkRestoring_div.v \
                  $(TOP_DIR)/mkcombo_mul.v \
                  $(TOP_DIR)/FIFO2.v \
                  $(TOP_DIR)/FIFOL1.v \
                  $(TOP_DIR)/signedmul.v

TOPLEVEL := $(TOP_MODULE)
MODULE   := test_mkmbox_div

include $(shell cocotb-config --makefiles)/Makefile.sim
