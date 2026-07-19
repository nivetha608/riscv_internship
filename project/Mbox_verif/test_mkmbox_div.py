import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.result import TestFailure
from cocotb_coverage.coverage import CoverPoint, CoverCross, coverage_db
import random
import ctypes
from cocotb_coverage.coverage import coverage_db
coverage_db.clear()  

def validate_funct3(funct3):
    """Validate funct3 value and raise error if invalid"""
    if funct3 not in [5, 7]:
        raise TestFailure(f"Invalid funct3 value: {funct3}. Only 5 (DIVU) and 7 (REMU) are supported")

@CoverPoint("div.funct3", xf=lambda x: x["funct3"], bins=[5, 7], at_least=1)
@CoverPoint("div.wordop", xf=lambda x: x["wordop"], bins=[0, 1], at_least=1)
@CoverPoint("div.in2_is_zero", xf=lambda x: x["in2"] == 0, bins=[True, False], at_least=1)
@CoverPoint("div.in1_is_zero", xf=lambda x: x["in1"] == 0, bins=[True, False], at_least=1)
@CoverPoint("div.in1_eq_in2", xf=lambda x: x["in1"] == x["in2"], bins=[True, False], at_least=1)
@CoverPoint("div.in2_is_one", xf=lambda x: x["in2"] == 1, bins=[True, False], at_least=1)
@CoverPoint("div.in2_gt_in1", xf=lambda x: x["in2"] > x["in1"], bins=[True, False], at_least=1)
@CoverPoint("div.max_unsigned_operand", xf=lambda x: x["in1"] == 0xFFFFFFFFFFFFFFFF or x["in2"] == 0xFFFFFFFFFFFFFFFF
    if x["wordop"] == 0 else x["in1"] == 0xFFFFFFFF or x["in2"] == 0xFFFFFFFF, bins=[True, False], at_least=1)
@CoverCross("div.cross_funct3_wordop", items=["div.funct3", "div.wordop"], at_least=1)
@CoverCross("div.cross_funct3_in2_zero", items=["div.funct3", "div.in2_is_zero"], at_least=1)
@CoverCross("div.cross_funct3_in2_is_one", items=["div.funct3", "div.in2_is_one"], at_least=1)
@CoverCross("div.cross_wordop_max_unsigned", items=["div.wordop", "div.max_unsigned_operand"], at_least=1)

def sample_coverage(data):
    pass

def pack_inputs(funct3, wordop, in1, in2):
    # Validate funct3 before packing
    validate_funct3(funct3)
    return (wordop << 131) | (in1 << 67) | (in2 << 3) | (funct3 & 0b111)

def ref_div(in1, in2, funct3, wordop):
    def sign32(x): return x if x < 0x80000000 else x - (1 << 32)
    def sign64(x): return x if x < 0x8000000000000000 else x - (1 << 64)

    MASK64 = 0xFFFFFFFFFFFFFFFF

    if wordop:
        a_u = in1 & 0xFFFFFFFF
        b_u = in2 & 0xFFFFFFFF

        if b_u == 0:
            if funct3 == 5:
                return MASK64
            elif funct3 == 7:
                return a_u 
            else:
                return 0

        if funct3 == 5:     # DIVUW
            res = int(a_u // b_u)
        elif funct3 == 7:     # REMUW
            res = int(a_u % b_u)
        else:
            return 0  # Defensive default

        # Sign-extend 32-bit result to 64-bit
        res &= 0xFFFFFFFF
        if res & 0x80000000:
            return res | 0xFFFFFFFF00000000
        else:
            return res

    else:
        # 64-bit division ops 
        a_u = in1 & MASK64
        b_u = in2 & MASK64

        if b_u == 0:
            if funct3 == 5:
                return MASK64
            elif funct3 == 7:
                return a_u
            else:
                return 0

        if funct3 == 5:     # DIVU
            return int(a_u // b_u) & MASK64
        elif funct3 == 7:     # REMU
            return int(a_u % b_u) & MASK64
        else:
            return 0  # Defensive default

@cocotb.test()
async def test_div_only(dut):
    cocotb.start_soon(Clock(dut.CLK, 10, units="ns").start())
    dut.RST_N.value = 0
    dut.tx_output_enq_rdy_b.value = 1
    dut.tx_output_notFull_b.value = 1
    await Timer(50, units="ns")
    dut.RST_N.value = 1
    for _ in range(3): await RisingEdge(dut.CLK)

    # Continue with normal tests
    funct3_list = [5, 7]  # DIVU, REMU

    directed_tests = [
        # in2 = 0 (divide by zero)
        {"in1": 10, "in2": 0, "wordop": 0},
        {"in1": 10, "in2": 0, "wordop": 1},
        # in1 = 0
        {"in1": 0, "in2": 10, "wordop": 0},
        {"in1": 0, "in2": 10, "wordop": 1},
        # in1 = in2
        {"in1": 12345, "in2": 12345, "wordop": 0},
        {"in1": 0xFFFFFFFF, "in2": 0xFFFFFFFF, "wordop": 1},
        # in1 = -1 (unsigned all ones)
        {"in1": 0xFFFFFFFFFFFFFFFF, "in2": 5, "wordop": 0},
        {"in1": 0xFFFFFFFF, "in2": 2, "wordop": 1},
        # in2 = -1 (unsigned all ones)
        {"in1": 0x20, "in2": 0xFFFFFFFFFFFFFFFF, "wordop": 0},
        {"in1": 0x20, "in2": 0xFFFFFFFF, "wordop": 1},
        # All sign bit patterns (using unsigned)
        {"in1": 10, "in2": 3, "wordop": 0},   
        {"in1": 0x8000000000000000, "in2": 3, "wordop": 0}, 
        {"in1": 10, "in2": 0x8000000000000000, "wordop": 0},
        {"in1": 0x8000000000000000, "in2": 0x8000000000000000, "wordop": 0},
        # Boundary values
        {"in1": 0xFFFFFFFFFFFFFFFF, "in2": 2, "wordop": 0},
        {"in1": 0x7FFFFFFF, "in2": 1, "wordop": 1},
        {"in1": 0x80000000, "in2": 2, "wordop": 1},
    ]

    for funct3 in funct3_list:
        for case in directed_tests:
            in1, in2, wordop = case["in1"], case["in2"], case["wordop"]
            ref = ref_div(in1, in2, funct3, wordop)
            packed = pack_inputs(funct3, wordop, in1, in2)
            dut.ma_inputs_inputs.value = packed
            dut.EN_ma_inputs.value = 1
            await RisingEdge(dut.CLK)
            dut.EN_ma_inputs.value = 0

            for _ in range(100):
                await RisingEdge(dut.CLK)
                if dut.tx_output_enq_ena.value == 1:
                    result = dut.tx_output_enq_data.value.integer

                    result_u64 = result & 0xFFFFFFFFFFFFFFFF
                    ref_u64 = ref & 0xFFFFFFFFFFFFFFFF

                    dut._log.info(f"[DIRECTED] funct3={funct3}, wordop={wordop}, in1={in1}, in2={in2} → REF={ref_u64}, GOT={result_u64}")

                    assert (result & 0xFFFFFFFFFFFFFFFF) == (ref & 0xFFFFFFFFFFFFFFFF), \
                        f"[DIRECTED] Mismatch: REF={ref_u64} ({hex(ref)}), GOT={result_u64} ({hex(result)})"

                    sample_coverage({"funct3": funct3, "wordop": wordop, "in1": in1, "in2": in2})
                    break

    for funct3 in funct3_list:
        for trial in range(100):
            wordop = random.randint(0, 1)
            width = 32 if wordop else 64
            in1 = random.randint(0, (1 << width) - 1)
            in2 = random.randint(0, (1 << width) - 1)

            ref = ref_div(in1, in2, funct3, wordop)
            packed = pack_inputs(funct3, wordop, in1, in2)
            dut.ma_inputs_inputs.value = packed
            dut.EN_ma_inputs.value = 1
            await RisingEdge(dut.CLK)
            dut.EN_ma_inputs.value = 0

            for _ in range(100):
                await RisingEdge(dut.CLK)
                if dut.tx_output_enq_ena.value == 1:
                    result = dut.tx_output_enq_data.value.integer

                    result_u64 = result & 0xFFFFFFFFFFFFFFFF
                    ref_u64 = ref & 0xFFFFFFFFFFFFFFFF

                    dut._log.info(f"[RANDOM] funct3={funct3}, wordop={wordop}, in1={in1}, in2={in2} → REF={ref_u64}, GOT={result_u64}")

                    assert (result & 0xFFFFFFFFFFFFFFFF) == (ref & 0xFFFFFFFFFFFFFFFF), \
                        f"[RANDOM] Mismatch: REF={ref_u64} ({hex(ref)}), GOT={result_u64} ({hex(result)})"

                    sample_coverage({"funct3": funct3, "wordop": wordop, "in1": in1, "in2": in2})
                    break

    coverage_db.report_coverage(cocotb.log.info, bins=True)
    coverage_db.export_to_yaml("div_only_coverage.yml")
    coverage_db.export_to_xml("div_only_coverage.xml")
    dut._log.info("Coverage exported")
