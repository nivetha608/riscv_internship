# 8 bit ALU verification using cocotb

We have implemented an 8-bit Arithmetic Logic Unit (ALU) in System Verilog and verified it using **Cocotb.**

The open source git repo we referred https://github.com/mohos455/ALU-Cocotb.git

## Enhancements Over Reference Project

- **Waveform Generation Added**
    
    The original project did not include waveform dump logic. We added support for waveform via **GTKWave**.
    
- **Randomized Testing Added**

  Testbench has been enhanced to include **random input generation**, increasing test coverage and robustness compared to fixed test vectors.
    
    ## Task Summary
    
    This project implements a **2-bit select 8-bit ALU** in System Verilog and tests it using **Cocotb**. The ALU performs four basic operations (ADD, SUB, AND, OR) based on the value of the 2-bit control signal ALU_Sel.
    
    ### Verilog Design
    
    - The design uses **SystemVerilog** with synchronous reset (`rst_n`) and positive-edge clocking.
    - The output `ALU_Out` is 9 bits wide to accommodate overflow from the addition.
    - Inside the `initial` block, waveform generation is enabled.
    
    ### ALU Operation Select Lines
    
    ALU_Sel   -   operation
    
    00             -    ADD
    
    01             -     SUB
    
    10             -     Bitwise AND
    
    11              -     Bitwise OR
    
    ### Cocotb Testbench
    
    - Starts the clock with 10 ns period.
    - Applies a reset and drives inputs.
    - Logs the ALU output for verification.
    - Stimulus can be extended to include more operations and randomized input.
    
    ### Waveform Generation
    
    - Waveform is dumped to `dump.vcd` for use with GTKWave.
    
    ### Commands used:
    
    - make
    - gtkwave dump.vcd (to view the waveform)
