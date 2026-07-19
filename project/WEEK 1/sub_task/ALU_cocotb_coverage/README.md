# ALU Functional Verification using Cocotb & SystemVerilog

## Sub task description

The ALU supports 8-bit signed inputs and a 9-bit signed output to handle overflow. The operations are selected using a 2-bit control input (`ALU_Sel`).

## ALU Specifications

**Inputs:**
- `A`  : 8-bit signed operand
- `B`  : 8-bit signed operand
- `ALU_Sel` : 2-bit control signal  
  - `00` → Add  
  - `01` → Subtract  
  - `10` → Bitwise AND  
  - `11` → Bitwise OR

**Output:**
- `ALU_Out`: 9-bit signed result (to handle overflow from addition/subtraction)

**Clock & Reset:**
- `clk`: Clock input
- `rst_n`: Active-low reset

## Verification Goals

This task aims to:
- Validate **functional correctness** of the ALU operations.
- Track **input and output conditions** using functional coverage:
  - Negative inputs/outputs
  - Zero detection
  - Equality between operands
  - Overflow conditions

## Functional Coverage Metrics

We use `@CoverPoint` and `@CoverCross` decorators from `cocotb_coverage` to capture key functional aspects:

### CoverPoints

| CoverPoint             | Description                                    |
|------------------------|------------------------------------------------|
| `top.ALU_Sel`          | All 4 ALU operations (ADD, SUB, AND, OR)      |
| `top.A_zero`           | A is zero                                      |
| `top.B_zero`           | B is zero                                      |
| `top.A_negative`       | A is negative                                  |
| `top.B_negative`       | B is negative                                  |
| `top.Output_negative`  | Result is negative                             |
| `top.Output_zero`      | Result is zero                                 |
| `top.A_equal_B`        | A equals B                                     |
| `top.Overflow_add`     | ADD overflow detected                          |
| `top.Overflow_Sub`     | SUB overflow detected                          |

### CoverCross

| CoverCross                  | Description                                     |
|-----------------------------|-------------------------------------------------|
| `top.selXA0`                | ALU operation × A is zero                       |
| `top.selXB0`                | ALU operation × B is zero                       |
| `top.selXAn`                | ALU operation × A is negative                   |
| `top.selXBn`                | ALU operation × B is negative                   |
| `top.A_signX_B_sign`        | A sign × B sign                         |

## Testbench Highlights

- Runs 1000 **random input combinations** of A, B, and ALU_Sel.
- Checks for **mismatches** between ALU output and expected software model.
- Logs pass/fail cases with detailed trace.

