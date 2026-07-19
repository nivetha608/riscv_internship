# mkVecUnit Verification

This repository contains the functional verification of the `mkVecUnit` module

## Features Tested
- `VADD_VV`: Vector-vector addition operation
- Basic DUT read/write access

## Repository Structure

| File / Folder           | Description                                    |
|-------------------------|------------------------------------------------|
| `test.py`               | Cocotb testbench with multiple test cases     |
| `Makefile`              | Makefile to run simulations with Icarus Verilog |
| `mkVecUnit.v`        | verilog design for the Vector ALU                 |


## Example Output (VADD_VV)

```
[INIT] DUT initialization complete
[VADD_VV] vreg1 <- [68, 40, 10, 7, 4, 48, 42, 51]
[VADD_VV] vreg2 <- [86, 76, 21, 68, 7, 84, 41, 34]
[VADD_VV] expected = [154, 116, 31, 75, 11, 132, 83, 85]
[VADD_VV] result   = [0, 0, 0, 0, 0, 0, 0, 0] 
[VADD_VV FAIL] Expected [154, 116, 31, 75, 11, 132, 83, 85], got [0, 0, 0, 0, 0, 0, 0, 0]
```

## Test Summary

| Test Name            | Status |
|----------------------|--------|
| reset_sanity_test    | PASS   |
| write_only_test      | PASS   |
| read_only_test       | PASS   |
| write_read_test      | PASS   |
| test_vadd_vv         | FAIL   |

## Notes
- `VADD_VV` failed: Result vector is not updated correctly in the DUT.
- Debugging required to verify instruction decode and result write-back in `mkVecUnit`.
