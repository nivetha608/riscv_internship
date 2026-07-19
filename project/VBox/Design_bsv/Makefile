help:
	@echo "Targets:"
	@echo "  b_all = b_compile  b_link  b_sim    (for Bluesim)"
	@echo "  v_all = v_compile  v_link  v_sim    (for Verilog & Verilator simulation)"
	@echo ""
	@echo "  clean         Delete intermediate files and dirs"
	@echo "  full_clean    Restore to pristine state"

# ****************************************************************
# Top-level BSV file and module name

TOPFILE   ?= mkVecUnitTB.bsv
TOPMODULE ?= mkTestbench

# ****************************************************************
# Target Aggregators

b_all: b_compile b_link b_sim
v_all: v_compile v_link v_sim

# ****************************************************************
# FOR BLUESIM

.PHONY: b_compile
b_compile:
	@echo "Compiling for Bluesim ..."
	bsc -u -sim -g $(TOPMODULE) $(TOPFILE)
	@echo "Compiled for Bluesim"

.PHONY: b_link
b_link:
	@echo "Linking for Bluesim ..."
	bsc -sim -e $(TOPMODULE) -o exe_HW_bsim
	@echo "Linked for Bluesim"

.PHONY: b_sim
b_sim:
	@echo "Simulating in Bluesim ..."
	./exe_HW_bsim
	@echo "Simulated in Bluesim"

# ****************************************************************
# FOR VERILATOR

.PHONY: v_compile
v_compile:
	@echo "Compiling to Verilog ..."
	bsc -u -verilog -g $(TOPMODULE) $(TOPFILE)
	@echo "Compiled to Verilog"

.PHONY: v_link
v_link:
	@echo "Linking Verilog for Verilator simulation ..."
	bsc -vsim verilator -e $(TOPMODULE) -o exe_HW_vsim
	@echo "Linked Verilog for Verilator simulation"

.PHONY: v_sim
v_sim:
	@echo "Simulating Verilog in Verilator ..."
	./exe_HW_vsim
	@echo "Simulated Verilog in Verilator"

# ****************************************************************
# CLEANUP

# ****************************************************************
.PHONY: clean
clean:
	rm -rf *~ *.bo *.ba *.c* *.h* *.o *.vcd

.PHONY: full_clean
full_clean: clean
	rm -rf exe_* *.v *.log *.xml *.verilog
# ****************************************************************


# ****************************************************************
