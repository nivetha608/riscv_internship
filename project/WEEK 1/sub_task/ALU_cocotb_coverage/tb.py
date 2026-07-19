import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ReadOnly
from cocotb_coverage.coverage import coverage_db, CoverPoint, CoverCross
import random

# Track covered input combinations
covered_values = set()



@CoverPoint("top.ALU_Sel", xf=lambda A, B, sel, result: sel, bins=[0, 1, 2, 3])
@CoverPoint("top.A_zero", xf=lambda A, B, sel, result: A == 0, bins=[True, False])
@CoverPoint("top.B_zero", xf=lambda A, B, sel, result: B == 0, bins=[True, False])
@CoverPoint("top.A_negative", xf=lambda A, B, sel, result: A < 0, bins=[True, False])
@CoverPoint("top.B_negative", xf=lambda A, B, sel, result: B < 0, bins=[True, False])
@CoverPoint("top.Output_negative", xf=lambda A, B, sel, result: result < 0, bins=[True, False])
@CoverPoint("top.Output_zero", xf=lambda A, B, sel, result: result == 0, bins=[True, False])
@CoverPoint("top.A_equal_B", xf=lambda A, B, sel, result: A == B, bins=[True, False])
@CoverPoint("top.Overflow_add", xf=lambda A, B, sel, result: sel == 0 and (A + B > 127 or A + B < -128), bins=[True, False])
@CoverPoint("top.Overflow_Sub", xf=lambda A, B, sel, result:sel == 1 and (A - B > 127 or A - B < -128), bins=[True, False])


@CoverCross("top.selXA0", items=["top.ALU_Sel", "top.A_zero"])
@CoverCross("top.selXB0", items=["top.ALU_Sel", "top.B_zero"])
@CoverCross("top.selXAn", items=["top.ALU_Sel", "top.A_negative"])
@CoverCross("top.selXBn", items=["top.ALU_Sel", "top.B_negative"])
@CoverCross("top.A_signX_B_sign", items=["top.A_negative", "top.B_negative"])

def record_coverage(A, B, sel, result):
    covered_values.add((A, B, sel))



@cocotb.test()
async def tb_top(dut):
    cocotb.log.info("Starting ALU Functional Coverage Test")

    # Start clock
    clock = Clock(dut.clk, 10, units="ns")  # 100 MHz
    cocotb.start_soon(clock.start())

    # Apply reset
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Test 500 random input combinations
    for i in range(1000):
        A = random.randint(-128, 127)
        B = random.randint(-128, 127)
        sel = random.randint(0, 3)

        # Apply inputs
        dut.A.value = A
        dut.B.value = B
        dut.ALU_Sel.value = sel

        await RisingEdge(dut.clk)
        await ReadOnly()

        result = dut.ALU_Out.value.signed_integer

        # Model expected output
        expected = {
            0: A + B,
            1: A - B,
            2: A & B,
            3: A | B,
        }.get(sel, 0)

        # Show info with expected always
        if result != expected:
            cocotb.log.error(f"[Mismatch] A={A}, B={B}, sel={sel}, result={result}, expected={expected}")
        else:
            cocotb.log.info(f"[Valid] A={A}, B={B}, sel={sel}, result={result}, expected={expected}")

        # Record functional coverage
        record_coverage(A, B, sel, result)

        await Timer(10, units="ns")


    # Export coverage
    coverage_db.export_to_yaml("alu_coverage.yml")
    cocotb.log.info("Simulation completed and coverage dumped.")
