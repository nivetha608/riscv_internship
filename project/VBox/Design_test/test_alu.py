import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
from cocotb_coverage.coverage import coverage_db, CoverCross, CoverPoint
import random
import os

coverage_db.clear()

SEW_MAP = {
    0b000: 8,
    0b001: 16,
    0b010: 32,
    0b011: 64
}

VALU_OPCODES = {
    "ADD": 1,
    "SUB": 2,
}

def validate_opcode(op_name):
    if op_name not in VALU_OPCODES:
        valid_ops = ', '.join(VALU_OPCODES.keys())
        msg = f"Invalid opcode '{op_name}' given. Valid operations are: {valid_ops}"
        cocotb.log.error(msg)
        assert False, msg 

def sign_extend(val, bits):
    if val & (1 << (bits - 1)):
        return val - (1 << bits)
    return val

@CoverPoint("alu.operation", xf=lambda op, sew, sign: op, bins=["ADD", "SUB"])
@CoverPoint("alu.sew", xf=lambda op, sew, sign: sew, bins=[8, 16, 32, 64])
@CoverPoint("alu.sign_mode", xf=lambda op, sew, sign: sign, bins=["Signed", "Unsigned"])
@CoverCross("alu.cross_main", items=["alu.operation", "alu.sew", "alu.sign_mode"])
def cover_func(op, sew, sign):
    pass
@CoverPoint("alu.zero_inputs", xf=lambda *args: args[3], bins=["Src1Zero", "Src2Zero", "BothZero", "NonZero"])
@CoverPoint("alu.result_edge", xf=lambda *args: args[4], bins=["AllZero", "MaxVal", "Normal"])
@CoverPoint("alu.input_relation", xf=lambda *args: args[5], bins=["Equal", "Src1GT", "Src2GT"])
@CoverCross("alu.op_x_zero", items=["alu.operation", "alu.zero_inputs"])
@CoverCross("alu.sew_x_result", items=["alu.sew", "alu.result_edge"])
@CoverCross("alu.sign_x_relation", items=["alu.sign_mode", "alu.input_relation"])
def cover_func_extra(op, sew, sign, zcase, edge, rel):
    pass

@cocotb.test()
async def test_vector_alu_coverage(dut):

    cocotb.start_soon(Clock(dut.clk_i, 10, units="ns").start())

    dut.rst_i.value = 1
    for _ in range(5):
        await RisingEdge(dut.clk_i)
    dut.rst_i.value = 0

    max_trials = 5000
    trial_count = 0
    seen_cases = set()

    while coverage_db["alu.cross_main"].coverage < 100 and trial_count < max_trials:
        trial_count += 1

        sew_bin = random.choice(list(SEW_MAP.keys()))
        elem_width = SEW_MAP[sew_bin]
        elems = 256 // elem_width

        op_name = random.choice(list(VALU_OPCODES.keys()))
        validate_opcode(op_name)
        opcode_val = VALU_OPCODES[op_name]

        signed_flag = random.choice([True, False])
        sign_str = "Signed" if signed_flag else "Unsigned"
        case_key = (op_name, elem_width, sign_str)

        src1_list, src2_list = [], []
        for _ in range(elems):
            if signed_flag:
                val1 = random.randint(-(2**(elem_width - 1)), 2**(elem_width - 1) - 1)
                val2 = random.randint(-(2**(elem_width - 1)), 2**(elem_width - 1) - 1)
            else:
                val1 = random.randint(0, 2**elem_width - 1)
                val2 = random.randint(0, 2**elem_width - 1)
            src1_list.append(val1)
            src2_list.append(val2)

        src1_unsigned = [val & ((1 << elem_width) - 1) for val in src1_list]
        src2_unsigned = [val & ((1 << elem_width) - 1) for val in src2_list]

        expected_list = []
        for a, b in zip(src1_list, src2_list):
            res = (a + b) if op_name == "ADD" else (a - b)
            expected_list.append(res & ((1 << elem_width) - 1))

        vs1_val = sum([src1_unsigned[i] << (i * elem_width) for i in range(elems)])
        vs2_val = sum([src2_unsigned[i] << (i * elem_width) for i in range(elems)])

        dut.vs1_i.value = vs1_val
        dut.vs2_i.value = vs2_val
        dut.rs1_i.value = 0
        dut.v0_i.value = 0
        dut.sew_i.value = sew_bin
        dut.valu_op_i.value = opcode_val
        dut.signed_i.value = 1 if signed_flag else 0
        dut.use_mask_i.value = 0
        dut.use_carry_i.value = 0
        dut.produce_carry_i.value = 0
        dut.saturate_i.value = 0

        await RisingEdge(dut.clk_i)
        await RisingEdge(dut.clk_i)

        result_val = dut.vd_o.value.integer
        result_list = [(result_val >> (i * elem_width)) & ((1 << elem_width) - 1) for i in range(elems)]

        errors = sum(got != exp for got, exp in zip(result_list, expected_list))
        assert errors == 0, f"{errors} mismatches in {case_key}"

        zcase = ("BothZero" if all(v == 0 for v in src1_list) and all(v == 0 for v in src2_list)
                 else "Src1Zero" if all(v == 0 for v in src1_list)
                 else "Src2Zero" if all(v == 0 for v in src2_list)
                 else "NonZero")

        edge = ("AllZero" if all(v == 0 for v in result_list)
                else "MaxVal" if any(v == (1 << elem_width) - 1 for v in result_list)
                else "Normal")

        rel = ("Equal" if src1_list == src2_list
               else "Src1GT" if sum(src1_list) > sum(src2_list)
               else "Src2GT")

        if case_key not in seen_cases:
            cocotb.log.info(f"First hit: {op_name}, SEW={elem_width}, {sign_str}")
            for i in range(elems):
                s1 = sign_extend(src1_unsigned[i], elem_width) if signed_flag else src1_unsigned[i]
                s2 = sign_extend(src2_unsigned[i], elem_width) if signed_flag else src2_unsigned[i]
                res = sign_extend(result_list[i], elem_width) if signed_flag else result_list[i]
                exp = sign_extend(expected_list[i], elem_width) if signed_flag else expected_list[i]
                cocotb.log.info(f"[{i}] Src1={s1} Src2={s2} Expected={exp} Got={res}")
            seen_cases.add(case_key)

        cover_func(op_name, elem_width, sign_str)
        cover_func_extra(op_name, elem_width, sign_str, zcase, edge, rel)

    cocotb.log.info("Starting Directed Tests...")
    for sew_bin, elem_width in SEW_MAP.items():
        elems = 256 // elem_width
        max_val = (1 << elem_width) - 1
        max_pos = (1 << (elem_width - 1)) - 1
        min_neg = -(1 << (elem_width - 1))

        directed_tests = [
    ("All Inputs Zero", [0]*elems, [0]*elems, False, "ADD"),  
    ("Src1 Zero, Src2 Non-Zero", [0]*elems, [1]*elems, False, "SUB"),  
    ("Equal Inputs", [5]*elems, [5]*elems, True, "SUB"), 
    ("Max Unsigned Inputs", [max_val]*elems, [max_val]*elems, False, "ADD"),  
    ("Max Positive + Min Negative", [max_pos]*elems, [min_neg]*elems, True, "ADD"), 
    ("Alternating Zero and Max",
     [0 if i%2==0 else max_val for i in range(elems)],
     [max_val if i%2==0 else 0 for i in range(elems)],
     False, "SUB"),
    ("One Element Non-Zero",
     [10 if i==3 else 0 for i in range(elems)],
     [5 if i==3 else 0 for i in range(elems)],
     True, "SUB"),  
    ("ADD Src1Zero", [0]*elems, [random.randint(1, 10)]*elems, False, "ADD"),
    ("ADD Src2Zero", [random.randint(1, 10)]*elems, [0]*elems, False, "ADD"),
    ("SUB BothZero", [0]*elems, [0]*elems, False, "SUB"),
    ("SUB Src2Zero", [random.randint(1, 10)]*elems, [0]*elems, False, "SUB"),
]

        for desc, s1_list, s2_list, signed_flag, op_name in directed_tests:
            sign_str = "Signed" if signed_flag else "Unsigned"
            cocotb.log.info(f"Directed Test: {desc}, SEW={elem_width}, {sign_str}")
            src1_unsigned = [v & ((1<<elem_width)-1) for v in s1_list]
            src2_unsigned = [v & ((1<<elem_width)-1) for v in s2_list]

            expected_list = []
            for a, b in zip(s1_list, s2_list):
                res = (a + b) if op_name == "ADD" else (a - b)
                expected_list.append(res & ((1 << elem_width) - 1))

            vs1_val = sum([src1_unsigned[i] << (i * elem_width) for i in range(elems)])
            vs2_val = sum([src2_unsigned[i] << (i * elem_width) for i in range(elems)])

            dut.vs1_i.value = vs1_val
            dut.vs2_i.value = vs2_val
            dut.rs1_i.value = 0
            dut.v0_i.value = 0
            dut.sew_i.value = sew_bin
            validate_opcode(op_name)
            dut.valu_op_i.value = VALU_OPCODES[op_name]
            validate_opcode(op_name)

            dut.signed_i.value = 1 if signed_flag else 0
            dut.use_mask_i.value = 0
            dut.use_carry_i.value = 0
            dut.produce_carry_i.value = 0
            dut.saturate_i.value = 0

            await RisingEdge(dut.clk_i)
            await RisingEdge(dut.clk_i)

            result_val = dut.vd_o.value.integer
            result_list = [(result_val >> (i * elem_width)) & ((1 << elem_width) - 1) for i in range(elems)]

            for i in range(elems):
                got = result_list[i]
                exp = expected_list[i]
                assert got == exp, f"Mismatch in '{desc}' SEW={elem_width}, index {i}: got={got}, expected={exp}"
                s1_disp = sign_extend(src1_unsigned[i], elem_width) if signed_flag else src1_unsigned[i]
                s2_disp = sign_extend(src2_unsigned[i], elem_width) if signed_flag else src2_unsigned[i]
                res_disp = sign_extend(got, elem_width) if signed_flag else got
                exp_disp = sign_extend(exp, elem_width) if signed_flag else exp
                cocotb.log.info(f"[{i}] Src1={s1_disp} Src2={s2_disp} Expected={exp_disp} Got={res_disp}")

            zcase = ("BothZero" if all(v == 0 for v in s1_list) and all(v == 0 for v in s2_list)
                     else "Src1Zero" if all(v == 0 for v in s1_list)
                     else "Src2Zero" if all(v == 0 for v in s2_list)
                     else "NonZero")

            edge = ("AllZero" if all(v == 0 for v in result_list)
                    else "MaxVal" if any(v == (1 << elem_width) - 1 for v in result_list)
                    else "Normal")

            rel = ("Equal" if s1_list == s2_list
                   else "Src1GT" if sum(s1_list) > sum(s2_list)
                   else "Src2GT")

            cover_func(op_name, elem_width, sign_str)
            cover_func_extra(op_name, elem_width, sign_str, zcase, edge, rel)

    coverage_db.export_to_yaml("vector_alu_coverage.yaml")
    coverage_db.export_to_xml("vector_alu_coverage.xml")
    cocotb.log.info("Coverage reports saved: YAML and XML.")
