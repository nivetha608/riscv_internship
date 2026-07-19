## Adder Example Verification

We executed the **adder example** from the official Cocotb examples as a preliminary test:

-  **Test Passed**: The simulation executed successfully, and all test assertions passed.
-  **Waveform Viewed**: The waveform (`.vcd`) was generated and visualized using **GTKWave**, confirming correct signal behavior.

This confirmed:
- Cocotb testbench integration is working.
- Icarus Verilog simulation setup is correct.
- Waveform dumping is functional.

Commands used
- cd examples/adder/tests
- make WAVES=1
- gtkwave dump.vcd

This baseline validation allowed us to proceed confidently with custom ALU simulations.

