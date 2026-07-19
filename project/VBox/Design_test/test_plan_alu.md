# Vector ALU Verification - Cocotb Testbench

## Overview

This project verifies a **256-bit Vector ALU** supporting `ADD` and `SUB` operations with variable Standard Element Width (SEW) settings and signed/unsigned modes. Verification is conducted using **Cocotb** with both **random** and **directed** tests. Full **functional coverage** is collected and exported.

---

## Design Under Test (DUT)

| Signal Name | Width | Description |
| --- | --- | --- |
| `clk_i` | 1 | Clock input |
| `rst_i` | 1 | Active-high reset |
| `vs1_i` | 256 | Vector source operand 1 |
| `vs2_i` | 256 | Vector source operand 2 |
| `sew_i` | 3 | Standard Element Width selector (000=8b, 001=16b, etc.) |
| `valu_op_i` | 4 | Operation code: `1` for ADD, `2` for SUB |
| `signed_i` | 1 | Operation mode: `1` for signed, `0` for unsigned |
| `vd_o` | 256 | Vector result output |

---

## Features Verified

| Feature | Description |
| --- | --- |
| Arithmetic Operations | Functional correctness for `ADD` and `SUB` |
| SEW Variations | 8, 16, 32, 64-bit element widths |
| Signed/Unsigned Modes | Proper handling of signed and unsigned arithmetic |
| Zero Input Handling | Inputs where one or both operands are zero |
| Edge Case Outputs | Outputs resulting in all zeros, maximum values, or mixed |
| Input Relations | Cases with equal inputs, src1 > src2, src2 > src1 |
| Directed Test Scenarios | Predefined edge cases for thorough validation |

---

## Testing Methodology

- **Clocking & Reset**: Driven by Cocotb with 10 ns period.
- **Random Testing**:
    - Random selection of SEW, operation, signed mode, and input values.
    - Target: 100% functional coverage across all combinations.
- **Directed Testing**:
    - Special edge cases including zero inputs, maximum values, sign extension behavior, etc.
- **Validation**:
    - Expected outputs computed in Python and compared bit-by-bit with DUT output.
    - Result mismatches are logged and cause assertion failures.

---

## Functional Coverage Metrics

| Coverage Point | Bins |
| --- | --- |
| Operation Type | ADD, SUB |
| SEW | 8, 16, 32, 64 bits |
| Signed Mode | Signed, Unsigned |
| Input Zero Case | Src1Zero, Src2Zero, BothZero, NonZero |
| Output Edge Case | AllZero, MaxVal, Normal |
| Input Relation | Equal, Src1GT, Src2GT |

### Cross Coverage

| Cross Coverage Point | Description |
| --- | --- |
| operation × SEW × sign | All combinations of operations, widths, and sign modes |
| operation × zero case | Operation type vs. input zero patterns |
| SEW × output edge | SEW vs. result edge cases |
| sign × input relation | Sign mode vs. operand relationships |

---

## Pass/Fail Criteria

| Criteria | Condition |
| --- | --- |
| Correct Output | All results must match expected values |
| Assertion Free | No test assertions or runtime errors |
| Coverage Target | 100% bin and cross coverage |
| Logging | First hit of each (op, SEW, sign) combo is logged |

---

## Tools & Environment

| Tool | Version |
| --- | --- |
| Simulator | Icarus Verilog |
| Verification Tool | Cocotb 1.9.2 |
| Coverage Tool | cocotb-coverage 1.2.0 |
| Python | Python 3.10+ |

## Output Artifacts

| File Name | Description |
| --- | --- |
| `vector_alu_coverage.yaml` | YAML format functional coverage report |
| `vector_alu_coverage.xml` | XML format functional coverage report |
| Simulation Logs | Detailed info on mismatches and coverage status |

---
