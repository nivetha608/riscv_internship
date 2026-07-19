# FIFO Verification with Cocotb and Functional Coverage

---

We referred to this open source git repo https://github.com/mciepluc/cocotb-coverage.git

## Description
This project verifies a Verilog-based FIFO design using a Cocotb testbench with functional coverage. The FIFO includes the following signals:

- fifo_full, fifo_empty

- fifo_threshold, fifo_overflow, fifo_underflow

- Read and write interface: rd, wr, data_in, data_out

## What It Tests
- Randomized read/write transactions

- Data consistency using a reference Python deque

- FIFO behavior under:

  - Full

  - Empty

  - Threshold reached

  - Overflow and underflow

## Functional Coverage Tracked
Using cocotb_coverage, we track:

- Read (rd) and Write (wr) in all FIFO states

- Cross-coverage of operations with:

- fifo_full

- fifo_empty

- fifo_threshold

- fifo_overflow

- fifo_underflow

## Files Generated
coverage_fifo.yml: YAML format coverage report

coverage_fifo.xml: XML format coverage report
