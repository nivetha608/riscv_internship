# **Test Plan for mkrestoring_div(SHAKTI C-Class MBox Divider SubModule)**

---

## **1. Overview**

This document outlines the verification strategy for the mkrestoring_div module in the SHAKTI C-Class MBox. The design performs division and remainder operations as defined in the **RISC-V M-extension** (`DIVU`, `REMU`, `DIVUW`, `REMUW`). Verification is performed using **Cocotb**, with both **directed** and **random** testing and full functional coverage collection.

---

## **2. Design Under Test (DUT)**

**Module Name:** `mkrestoring_div`

### **Interface Signals**

### Inputs:

| Signal Name | Width | Description |
| --- | --- | --- |
| `ma_inputs_in1` | 64 | Dividend operand |
| `ma_inputs_in2` | 64 | Divisor operand |
| `ma_inputs_funct3` | 3 | Operation selector (5: DIVU, 7: REMU) |
| `ma_inputs_wordop` | 1 | Word operation (1 = 32-bit operation) |
| `EN_ma_inputs` | 1 | Input valid strobe |
| `EN_mv_output` | 1 | Output ready handshake |
| `CLK` | 1 | Clock |
| `RST_N` | 1 | Active-low reset |

### Outputs:

| Signal Name | Width | Description |
| --- | --- | --- |
| `mv_output` | 64 | Division or remainder result |
| `mv_output_valid` | 1 | Output valid strobe |
| `mv_ready` | 1 | Divider is ready to accept input |

---

## **3. Features Being Verified**

| Feature | Description |
| --- | --- |
| **DIVU** | Unsigned 64-bit division (funct3 = 5, wordop = 0) |
| **REMU** | Unsigned 64-bit remainder (funct3 = 7, wordop = 0) |
| **DIVUW** | Unsigned 32-bit division with sign-extension (funct3 = 5, wordop = 1) |
| **REMUW** | Unsigned 32-bit remainder with sign-extension (funct3 = 7, wordop = 1) |
| **Division by Zero** | Division by 0 should return all 1s (DIVU) or dividend (REMU) |
| **Word Operation Sign Extension** | Lower 32-bit results extended to 64-bit correctly |
| **Handshake Protocol** | Input accepted only when `mv_ready` is high; output accepted only when `EN_mv_output` is asserted |
| **Timing & Latency** | Result returned within acceptable latency (~<100 cycles in functional tests) |
| **Equality & Edge Conditions** | Covers `in1 = 0`, `in2 = 0`, `in1 = in2`, `in2 = 1`, `in2 > in1`, max 64-bit values |

---

## **4. Testing Methodology**

### **Test Types**

- **Directed Testing**:
    - Fixed scenarios to test edge conditions:
        - Divide by 0
        - `in1 = 0`, `in2 = 1`
        - Equal operands
        - Wordop sign extension behavior
- **Random Testing**:
    - Randomized values for `in1`, `in2`, `funct3`, `wordop`
    - 100+ randomized tests to cover full operand space

### **Test Strategy**

- All transactions triggered only when `mv_ready == 1`
- Output sampled only when `mv_output_valid == 1` and `EN_mv_output == 1`
- Result compared to software reference model (`ref_div` function)

---

## **5. Functional Coverage Metrics**

Collected via `cocotb_coverage`:

| Coverage Point | Bins | Description |
| --- | --- | --- |
| `funct3` | [5, 7] | DIVU, REMU |
| `wordop` | [0, 1] | 64-bit vs 32-bit |
| `in1 == 0` | [True, False] | Zero dividend |
| `in2 == 0` | [True, False] | Divide by zero |
| `in1 == in2` | [True, False] | Equal operands |
| `in2 == 1` | [True, False] | Divider is 1 |
| `in2 > in1` | [True, False] | Divider > dividend |
| `max_unsigned_operand` | [True, False] | Max unsigned 32/64-bit values |

### **Cross Coverage**

| Cross Coverage Point | Description |
| --- | --- |
| `funct3 × wordop` | All instruction type × width |
| `funct3 × in2 == 0` | DIVU/REMU with divide-by-zero |
| `wordop × max_unsigned` | Max inputs under wordop modes |
| funct3 x in2 == 1 | DIVU/REMU with divide by one |

---

## **6. Pass/Fail Criteria**

- For every transaction:
    - Output must match reference model
    - `mv_output_valid` must be asserted before reading `mv_output`
- All directed tests must pass without assertion
- Functional coverage report (div_only_coverage.yml , div_only_coverage.xml) must show **100% bin and cross coverage**
- No dropped transactions due to improper handshake

---

## **7. Tools & Environment**

| Tool | Version |
| --- | --- |
| Simulator | Icarus Verilog (iverilog) |
| Verification Tool | Cocotb 1.9.2 |
| Coverage Tool | cocotb-coverage 1.2.0 |
| Python | Python 3.10 |
| RTL Source | `mkrestoring_div.v` from SHAKTI MBox |

---

## **8. References**

- **RISC-V Unprivileged ISA v2.2** — Section: M-extension (Integer Multiply/Divide)
- **`mkrestoring_div.v` Verilog Source** — Interface and functionality
