## MBox - mkRestoring_div.v verification
---
This folder contains the functional verification of the mkRestoring_div module from the SHAKTI C-Class MBox using Cocotb.
---
Contents
- test_mkmbox_div.py: The Cocotb testbench
- Makefile: Makefile to run simulation with Icarus Verilog
- div_only_coverage.yml: Functional coverage results
- div_only_coverage.xml
- sim_build
- test_plan.md: verification test plan
- results.xml: Cocotb regression report
- screenshot of test pass

---
## Running the Simulation
Activate your Python environment and install dependencies:

pip install cocotb cocotb-coverage==1.2.0

Then, run the testbench using:

make

Ensure you have Icarus Verilog installed and available in your system's PATH.
