import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ReadOnly

@cocotb.test()
async def tb_top(dut):
    cocotb.log.info("Starting ALU Simulation")

    # Start the clock
    clock = Clock(dut.clk, 10, units="ns")  # 100 MHz
    cocotb.start_soon(clock.start())

    # Apply reset
    dut.rst_n.value = 0
    dut.A.value = 0
    dut.B.value = 0
    dut.ALU_Sel.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Predefined test cases
    tests = [
        (5, 20, 0b00, "ADD"),     # 5 + 20 = 25
        (30, 10, 0b01, "SUB"),    # 30 - 10 = 20
        (15, 8,  0b10, "AND"),    # 15 & 8 = 8
        (12, 5,  0b11, "OR"),     # 12 | 5 = 13
    ]

    for A, B, sel, label in tests:
        dut.A.value = A
        dut.B.value = B
        dut.ALU_Sel.value = sel
        await RisingEdge(dut.clk)
        await ReadOnly()
        cocotb.log.info(f"[Fixed] {label}: A={A}, B={B}, ALU_Sel={bin(sel)}, Output={int(dut.ALU_Out.value)}")
        await Timer(20, units="ns")

    # Add random test cases
    for i in range(10):
        A = random.randint(0, 255)
        B = random.randint(0, 255)
        sel = random.randint(0, 3)  # Only 2-bit ALU_Sel: 00 to 11
        dut.A.value = A
        dut.B.value = B
        dut.ALU_Sel.value = sel
        await RisingEdge(dut.clk)
        await ReadOnly()
        cocotb.log.info(f"[Random {i+1}] A={A}, B={B}, ALU_Sel={bin(sel)}, Output={int(dut.ALU_Out.value)}")
        await Timer(20, units="ns")

    cocotb.log.info("Simulation completed")
    await Timer(100, units="ns")
