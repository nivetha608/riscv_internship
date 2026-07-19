import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly, Timer
from cocotb.result import TestFailure
import random

VADD_VV = 0
VSUB_VV = 1
VLOAD   = 2
VSTORE  = 3

VLEN = 8
ELEMENT_WIDTH = 32

def pack_vector(data):
    value = 0
    for i in reversed(range(VLEN)):
        value = (value << ELEMENT_WIDTH) | (data[i] & 0xFFFFFFFF)
    return value

def unpack_vector(value):
    result = []
    for i in range(VLEN):
        element = (value >> (i * ELEMENT_WIDTH)) & 0xFFFFFFFF
        result.append(element)
    return result

def make_instr(op, vs1, vs2, vd, base=0):
    instr = (op & 0x3)
    instr |= (vs1 & 0x1F) << 2
    instr |= (vs2 & 0x1F) << 7
    instr |= (vd  & 0x1F) << 12
    instr |= (base & ((1 << 64) - 1)) << 17
    return instr
async def init_dut(dut):
    """Clock + Reset"""
    cocotb.start_soon(Clock(dut.CLK, 10, units="ns").start())
    dut._log.info("[INIT] Clock started")

    if hasattr(dut, "RST_N"):
        dut.RST_N.value = 0
        await RisingEdge(dut.CLK)
        await RisingEdge(dut.CLK)
        dut.RST_N.value = 1
        dut._log.info("[INIT] Reset applied")
    else:
        dut._log.warning("[INIT] No reset signal found")

    await RisingEdge(dut.CLK)
    dut._log.info("[INIT] DUT initialization complete")

@cocotb.test()
async def reset_sanity_test(dut):
    await init_dut(dut)
    await ReadOnly()
    dut._log.info(f"[RESET TEST] DUT is alive, done={dut.done.value}")

@cocotb.test()
async def write_only_test(dut):
    await init_dut(dut)

    packed = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    dut.writeReg_vi.value = 5
    dut.writeReg_data.value = packed
    dut.EN_writeReg.value = 1
    await RisingEdge(dut.CLK)
    dut.EN_writeReg.value = 0

    for i in range(3):
        await RisingEdge(dut.CLK)
        dut._log.info(f"[WRITE ONLY] Cycle {i+1} post-write")

    dut._log.info("[PASS] write_only_test ran without crash")

@cocotb.test()
async def read_only_test(dut):
    await init_dut(dut)

    known_vec = [0x11111111] * VLEN
    packed_vec = pack_vector(known_vec)

    dut.writeReg_vi.value = 0
    dut.writeReg_data.value = packed_vec
    dut.EN_writeReg.value = 1
    await RisingEdge(dut.CLK)
    dut.EN_writeReg.value = 0
    dut._log.info("[READ ONLY] Wrote known vector to vreg 0")

    await RisingEdge(dut.CLK)

    dut.readReg_vi.value = 0
    dut.EN_readReg.value = 1
    await RisingEdge(dut.CLK)
    dut.EN_readReg.value = 0
    await RisingEdge(dut.CLK)

    await ReadOnly()
    if not dut.readReg.value.is_resolvable:
        raise TestFailure("[READ ERROR] readReg not resolvable (x or z)")

    read_packed = dut.readReg.value.integer
    read_vec = unpack_vector(read_packed)
    dut._log.info(f"[READ ONLY] Read vector: {read_vec}")

    if read_vec != known_vec:
        raise TestFailure(f"[FAIL] Expected {known_vec}, got {read_vec}")
    dut._log.info("[PASS] read_only_test passed")

@cocotb.test()
async def write_read_test(dut):
    await init_dut(dut)

    vec_data = [random.randint(0, 100) for _ in range(VLEN)]
    packed = pack_vector(vec_data)

    dut.writeReg_vi.value = 5
    dut.writeReg_data.value = packed
    dut.EN_writeReg.value = 1
    await RisingEdge(dut.CLK)
    dut.EN_writeReg.value = 0

    await RisingEdge(dut.CLK)
    await RisingEdge(dut.CLK)

    dut.readReg_vi.value = 5
    dut.EN_readReg.value = 1
    await RisingEdge(dut.CLK)
    dut.EN_readReg.value = 0
    await RisingEdge(dut.CLK)

    await ReadOnly()
    if not dut.readReg.value.is_resolvable:
        raise TestFailure("[READ ERROR] readReg not resolvable")

    read_packed = dut.readReg.value.integer
    read_vec = unpack_vector(read_packed)

    if read_vec != vec_data:
        raise TestFailure(f"[FAIL] Expected {vec_data}, got {read_vec}")

    dut._log.info("[PASS] write_read_test passed")
@cocotb.test()
async def test_vadd_vv(dut):
    dut._log.info("[TEST] Starting test_vadd_vv")

    cocotb.start_soon(Clock(dut.CLK, 10, units="ns").start())
    await RisingEdge(dut.CLK)

    if hasattr(dut, "RST_N"):
        dut.RST_N.value = 0
        for _ in range(2):
            await RisingEdge(dut.CLK)
        dut.RST_N.value = 1
        await RisingEdge(dut.CLK)

    dut._log.info("[INIT] Reset applied")
    dut._log.info("[INIT] DUT initialization complete")

    v1 = [random.randint(0, 100) for _ in range(VLEN)]
    v2 = [random.randint(0, 100) for _ in range(VLEN)]
    expected = [(v1[i] + v2[i]) & 0xFFFFFFFF for i in range(VLEN)]

    dut._log.info(f"[VADD_VV] vreg1 <- {v1}")
    dut._log.info(f"[VADD_VV] vreg2 <- {v2}")

    dut.writeReg_vi.value = 1
    dut.writeReg_data.value = pack_vector(v1)
    dut.EN_writeReg.value = 1
    await RisingEdge(dut.CLK)
    dut.EN_writeReg.value = 0

    dut.writeReg_vi.value = 2
    dut.writeReg_data.value = pack_vector(v2)
    dut.EN_writeReg.value = 1
    await RisingEdge(dut.CLK)
    dut.EN_writeReg.value = 0

    instr_val = make_instr(VADD_VV, 1, 2, 3)
    dut.execute_instr.value = instr_val
    dut.EN_execute.value = 1
    await RisingEdge(dut.CLK)
    dut.EN_execute.value = 0
    dut._log.info(f"[VADD_VV] Instruction 0x{instr_val:X} issued")

    for cycle in range(50):
        await RisingEdge(dut.CLK)
        if dut.done.value == 1:
            dut._log.info(f"[VADD_VV] Done asserted at cycle {cycle+1}")
            break
    else:
        raise TestFailure("[TIMEOUT] VADD_VV: Timeout waiting for done")

    await RisingEdge(dut.CLK)

    dut.readReg_vi.value = 3
    dut.EN_readReg.value = 1
    await RisingEdge(dut.CLK)
    dut.EN_readReg.value = 0

    result_vec = None
    result_raw = None
    for attempt in range(5):
        await RisingEdge(dut.CLK)
        await ReadOnly()
        result_raw = dut.readReg.value.integer
        result_vec = unpack_vector(result_raw)
        dut._log.info(f"[VADD_VV] Attempt {attempt+1}: result vector = {result_vec}")
        if any(result_vec): 
            break
    dut._log.info(f"[VADD_VV] v1={v1}")
    dut._log.info(f"[VADD_VV] v2={v2}")
    dut._log.info(f"[VADD_VV] expected={expected}")
    dut._log.info(f"[VADD_VV] read raw=0x{result_raw:0{VLEN*8}X}")
    dut._log.info(f"[VADD_VV] result vector from vreg3: {result_vec}")
    
    assert result_vec == expected, f"[VADD_VV FAIL] Expected {expected}, got {result_vec}"
    dut._log.info("[PASS] VADD_VV test passed")
    
