# Vector ALU and Logic Unit Verification (Cocotb-Based)
---

This repository contains the **Cocotb-based functional verification** of hardware modules including a **Vector ALU** and a **256-bit Logic Unit**. The project ensures correctness, ISA-level coverage, and robust validation of operations across multiple configurations.

---

Open source Repo we refered : https://github.com/martinriis/RISC-V-Vector-Processor.git

## Repository Structure

| File/Folder | Description |
| --- | --- |
| `hw/` | Contains Verilog hardware modules (Design Under Test - DUT) for both **Vector ALU** and **Logic Unit**. |
| `test_plan_alu.md` `& test_plan_logic.md` | Detailed **verification test plan** outlining features tested, coverage metrics, and test methodology. |
| `test_alu.py` | Cocotb testbench for **Vector ALU**, with directed/random tests and functional coverage collection. |
| `test_logic_256bit.py` | Cocotb testbench for **256-bit Logic Unit** with bitwise operation validation and coverage. |
| `vector_alu_coverage.yaml/xml` | Functional coverage reports for **Vector ALU** (exported in YAML and XML formats). |
| `logic_256bit_coverage.yaml/xml` | Functional coverage reports for **Logic Unit** (YAML and XML formats). |
| `Makefile` | Simulation Makefile for running Cocotb tests using Icarus Verilog. |

---

## Project Goals

- Verify **functional correctness** of Vector ALU and Logic Unit implementations.
- Achieve **100% functional coverage** across operations, SEW (Standard Element Widths), and input types.
- Validate **boundary conditions**: zero inputs, max/min values, signed/unsigned behavior.
- Generate **detailed coverage reports** for quality assessment.

---

## Features Tested

| DUT | Features |
| --- | --- |
| **Vector ALU** | Operations: ADD, SUB; SEW: 8, 16, 32, 64-bit; Signed/Unsigned modes; Input relation tests; Directed edge cases. |
| **Logic 256-bit Unit** | Operations: AND, NAND, OR, NOR, XOR, XNOR, NOT, ANDNOT; Shifts: Logical Left/Right, Arithmetic Right; SEW: 8, 16, 32, 64-bit; Coverage of opcode-SEW pairs. |

---

## Coverage Reports

Coverage is collected using **cocotb-coverage** and exported to:

- `vector_alu_coverage.yaml/xml`
- `logic_256bit_coverage.yaml/xml`

Use these reports to assess verification **completeness**.

---

## Running the Tests

> make
>
