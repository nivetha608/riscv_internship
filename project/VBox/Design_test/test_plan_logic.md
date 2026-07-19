# Vector Logic and Shift Unit Verification - Cocotb Testbench

## Overview

This project verifies a **256-bit Vector Logic and Shift Unit** supporting a wide range of **bitwise logic** and **shift operations** with variable Standard Element Width (SEW) settings. The testbench uses **Cocotb** and performs both **directed** and **randomized** testing with full **functional coverage** tracking and reporting.

---

## Design Under Test (DUT)

| Signal Name     | Width | Description                                                 |
|-----------------|-------|-------------------------------------------------------------|
| `clk_i`         | 1     | Clock input                                                 |
| `a_i`           | 256   | Vector operand A                                            |
| `b_i`           | 256   | Vector operand B                                            |
| `sew_i`         | 3     | Standard Element Width selector (000=8b, 001=16b, etc.)     |
| `opcode_i`      | 4     | Operation selector (0-10 for various logic/shift ops)       |
| `out_o`         | 256   | Vector result output                                        |

---

## Features Verified

| Feature                      | Description                                                  |
|-----------------------------|--------------------------------------------------------------|
| Bitwise Logic Ops           | VAND, VNAND, VANDNOT, VOR, VNOR, VXOR, VXNOR, VNOT           |
| Shift Operations            | VSLL (logical left), VSRL (logical right), VSRA (arithmetic) |
| SEW Variations              | 8, 16, 32, 64-bit elements supported                         |
| Boundary Conditions         | All-zero, all-one, and alternating input patterns            |
| Shift Behavior              | Shift by 0 and maximum allowed shift                        |
| Directed Test Scenarios     | Edge-case inputs for all operations                         |
| Random Test Scenarios       | Fully randomized values for a, b, opcode, and SEW           |

---

## Testing Methodology

| Type             | Description                                                                      |
|------------------|----------------------------------------------------------------------------------|
| Clocking         | Driven by Cocotb with a 10 ns period                                             |
| Directed Tests   | Carefully selected cases covering edge patterns for all operations              |
| Random Tests     | Randomized inputs with goal of achieving 100% functional coverage               |
| Output Check     | Computed expected result in Python; compared bit-by-bit to DUT output           |
| Logging          | Failures logged with input, expected, and obtained values for debug             |
| Coverage Export  | Results saved to YAML and XML for traceability and report generation            |

---

## Functional Coverage Metrics

| Coverage Point         | Bins                                                              |
|------------------------|-------------------------------------------------------------------|
| `logic.opcode`         | VAND, VNAND, VANDNOT, VOR, VNOR, VXOR, VXNOR, VNOT, VSLL, VSRL, VSRA |
| `logic.sew`            | 8, 16, 32, 64 bits                                                |
| `logic.cross`          | All combinations of operations and SEW settings                   |

---

## Pass/Fail Criteria

| Criteria                         | Description                                                   |
|----------------------------------|---------------------------------------------------------------|
| Correct Output                   | DUT output must match expected value for every test           |
| Assertion Free                   | No assertion errors during simulation                         |
| Coverage Target                  | 100% bin and cross coverage                                   |
| Directed Tests Pass              | All edge-case tests must pass                                 |
| Coverage Report                  | Files: `logic_256bit_coverage.yaml`, `logic_256bit_coverage.xml` |

---

## Directed Tests (Examples)

| Operation | SEW  | Input A                | Input B                 | Notes                     |
|-----------|------|------------------------|-------------------------|---------------------------|
| VOR       | 16   | All 0xFFFF            | All 0x0000              | OR with zeros             |
| VNOT      | 32   | All 0x00000000        | -                       | Bitwise NOT zero          |
| VANDNOT   | 64   | All 0xFFFFFFFFFFFFFFFF| All 0x0000000000000000  | A & ~B with edge cases    |
| VSRA      | 16   | All 0x8000 or 0x7FFF  | All 1                   | Arithmetic shift right    |
| VSLL      | 16   | 0x1111                | All 0                   | Logical left shift by 0   |
| VSRL      | 32   | 0x80000000            | 31                      | Logical right shift max   |

---

## Tools & Environment

| Tool                | Version          |
|---------------------|------------------|
| Simulator           | Icarus Verilog   |
| Verification Tool   | Cocotb 1.9.2     |
| Coverage Tool       | cocotb-coverage 1.2.0 |
| Python              | Python 3.10+     |

---

## Output Artifacts

| File Name                    | Description                                   |
|-----------------------------|-----------------------------------------------|
| `logic_256bit_coverage.yaml`| Functional coverage in YAML format           |
| `logic_256bit_coverage.xml` | Functional coverage in XML format            |
| Simulation Logs             | Pass/fail logs with mismatch information     |

