import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
from cocotb_coverage.coverage import coverage_db, CoverPoint, CoverCross
import random

ALU_OPS = {
    0: "VAND",
    1: "VNAND",
    2: "VANDNOT",
    3: "VOR",
    4: "VNOR",
    5: "VXOR",
    6: "VXNOR",
    7: "VNOT",
    8: "VSLL",
    9: "VSRL",
    10: "VSRA"
}

SEW_VALUES = [0b000, 0b001, 0b010, 0b011]

SEW_MAP = {
    0b000: 8,
    0b001: 16,
    0b010: 32,
    0b011: 64
}

MASK_MAP = {
    8:  0xFF,
    16: 0xFFFF,
    32: 0xFFFFFFFF,
    64: 0xFFFFFFFFFFFFFFFF
}

def op_validate(opcode):
    if opcode not in ALU_OPS:
        raise ValueError(
            f"Invalid opcode '{opcode}'. "
            f"Supported opcodes: {list(ALU_OPS.keys())}"
        )

coverage_db.clear()

@CoverPoint("logic.opcode", xf=lambda op, sew: op, bins=list(ALU_OPS.values()))
@CoverPoint("logic.sew", xf=lambda op, sew: sew, bins=[8, 16, 32, 64])
@CoverCross("logic.cross", items=["logic.opcode", "logic.sew"])
def sample_coverage(op_name, sew_bits):
    pass
async def run_test_case(dut, opcode_val, sew_bin, a_list, b_list):
    op_validate(opcode_val)
    elem_width = SEW_MAP[sew_bin]
    elems = 256 // elem_width
    mask = MASK_MAP[elem_width]
    # Pack lists to 256b
    a_val = sum([a_list[i] << (i * elem_width) for i in range(elems)])
    b_val = sum([b_list[i] << (i * elem_width) for i in range(elems)])
    dut.a_i.value = a_val
    dut.b_i.value = b_val
    dut.sew_i.value = sew_bin
    dut.opcode_i.value = opcode_val
    await RisingEdge(dut.clk_i)
    await RisingEdge(dut.clk_i)
    result = dut.out_o.value.integer
    # Compute expected
    expected = 0
    result_list = []
    expected_list = []
    for i in range(elems):
        a = a_list[i]
        b = b_list[i]
        b = min(b, elem_width - 1)
        if opcode_val == 0: res = a & b
        elif opcode_val == 1: res = ~(a & b) & mask
        elif opcode_val == 2: res = a & (~b & mask)
        elif opcode_val == 3: res = a | b
        elif opcode_val == 4: res = ~(a | b) & mask
        elif opcode_val == 5: res = a ^ b
        elif opcode_val == 6: res = ~(a ^ b) & mask
        elif opcode_val == 7: res = ~a & mask
        elif opcode_val == 8: res = (a << b) & mask
        elif opcode_val == 9: res = (a >> b) & mask
        elif opcode_val == 10:
            signed_a = a - (1 << elem_width) if a & (1 << (elem_width - 1)) else a
            res = (signed_a >> b) & mask
        else:
            res = 0
        expected |= (res << (i * elem_width))
        result_elem = (result >> (i * elem_width)) & mask
        expected_elem = (expected >> (i * elem_width)) & mask
        result_list.append(result_elem)
        expected_list.append(expected_elem)
    # Compare
    if result_list != expected_list:
        cocotb.log.error(
            f"[FAIL] {ALU_OPS[opcode_val]} SEW={elem_width} bits\n"
            f"a_list     = {a_list}\n"
            f"b_list     = {b_list}\n"
            f"expected   = {expected_list}\n"
            f"got        = {result_list}"
        )
        assert False, "Mismatch detected"
    sample_coverage(ALU_OPS[opcode_val], elem_width)

@cocotb.test()
async def test_logic_256bit(dut):

    cocotb.start_soon(Clock(dut.clk_i, 10, units="ns").start())
    await run_test_case(dut, 3, 0b001, [0xFFFF]*16, [0]*16)  # VOR
    await run_test_case(dut, 7, 0b010, [0x00000000]*8, [0]*8)  # VNOT 
    await run_test_case(dut, 7, 0b000, [0b10001111]*32, [0]*32)  # VNOT
    await run_test_case(dut, 2, 0b011, [0xFFFFFFFFFFFFFFFF]*4, [0]*4)    # VANDNOT
    await run_test_case(dut, 2, 0b011, [0]*4, [0xFFFFFFFFFFFFFFFF]*4)    # VANDNOT
    await run_test_case(dut, 10, 0b001, [0x8000]*16, [1]*16)   # VSRA
    await run_test_case(dut, 10, 0b001, [0x7FFF]*16, [1]*16)   # VSRA
    await run_test_case(dut, 8, 0b001, [0x1111]*16, [0]*16)    # VSLL 
    await run_test_case(dut, 9, 0b010, [0x80000000]*8, [31]*8) # VSRL
    cocotb.log.info("Directed tests passed.")


    max_trials = 1000
    trials = 0
    while coverage_db["logic.cross"].coverage < 100 and trials < max_trials:
        trials += 1
        opcode_val = random.choice(list(ALU_OPS.keys()))
        sew_bin = random.choice(SEW_VALUES)
        elem_width = SEW_MAP[sew_bin]
        elems = 256 // elem_width
        a_list = [random.getrandbits(elem_width) for _ in range(elems)]
        b_list = [random.randint(0, elem_width - 1) for _ in range(elems)]
        if trials <= 5:
            cocotb.log.info(
                f"[Trial {trials}] {ALU_OPS[opcode_val]} SEW={elem_width} bits\n"
                f"a_list     = {a_list}\n"
                f"b_list     = {b_list}"
            )
        await run_test_case(dut, opcode_val, sew_bin, a_list, b_list)

    coverage_db.export_to_yaml("logic_256bit_coverage.yaml")
    coverage_db.export_to_xml("logic_256bit_coverage.xml")
    cocotb.log.info("Logic coverage saved.")
