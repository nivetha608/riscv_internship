# **Vector ALU in Bluespec SystemVerilog (BSV)**

This repository implements and verifies a **Vector Arithmetic Logic Unit (Vector ALU)** using **Bluespec SystemVerilog (BSV)**. The design supports **vector-vector arithmetic operations** (`VADD_VV`, `VSUB_VV`) and **memory operations** (`VLOAD`, `VSTORE`) over **32 vector registers**.

---

## **Repository Structure**

| File / Package | Description |
| --- | --- |
| `VectorTypes.bsv` | Defines **vector types**, **operation codes**, and **instruction format** used across modules. |
| `VectorRegisterFile.bsv` | Implements the **vector register file** (`v0`–`v31`) with **read and write capabilities**. |
| `mkVecUnit.bsv` | Implements the **Vector ALU unit**, including **memory**, **instruction decoding**, and **execution**. |
| `mkVecUnitTB.bsv` | **Testbench** for the Vector ALU. Executes **ADD**, **SUB**, **LOAD**, and **STORE** operations. |
| `Makefile` | Tor run the bsv |
| `Reference model` | Python reference model |

---

## **Module-Level Details**

### **1. `VectorTypes.bsv`**

- **Purpose**: Centralized definition of **vector register width**, **number of registers**, **opcodes**, and **instruction format**.
- **Key Components**:
    - `VectorReg`: **Vector with 8 elements**, each **32 bits**.
    - `VRegIndex`: **5-bit index** for accessing **32 registers**.
    - `VecOp`: Enumeration for supported operations: `VADD_VV`, `VSUB_VV`, `VLOAD`, `VSTORE`.
    - `VecInstr`: Struct defining an **instruction** with **opcode**, **register indices**, and **base address**.

---

### **2. `VectorRegisterFile.bsv`**

- **Purpose**: Implements a **32-register file** where each register is a **vector** (`VectorReg`).
- **Interface**:
    - `write(idx, val)`: **Writes** `val` to register `idx`.
    - `read(idx)`: **Reads** value from register `idx`.

---

### **3. `mkVecUnit.bsv`**

- **Purpose**: Main **Vector ALU Unit** handling **arithmetic** and **memory instructions**.
- **Key Features**:
    - **Registers**:
        - `vregs`: **Vector register file interface**.
        - `vecMem`: **16-entry vector memory** for load/store.
        - `resultReg`: Holds **result for verification**.
    - **Execution Logic**:
        - `execute(instr)`: Accepts an **instruction** and initiates **processing**.
        - `process_instruction`: Decodes and processes instruction (**ADD**, **SUB**, **LOAD**, **STORE**).
    - **Rules**:
        - Uses `conflict_free` and `descending_urgency` pragmas for **safe concurrent operation**.

---

### **4. `mkVecUnitTB.bsv`**

- **Purpose**: **Testbench** that performs the following:
    - **Initializes registers** `v1` and `v2` with **test data**.
    - Executes `VADD_VV` and verifies **result in `v3`**.
    - Executes `VSUB_VV` and verifies **result in `v4`**.
    - Performs `VSTORE` of `v4` and `VLOAD` into `v10`, then verifies **data correctness**.
- **Timeout Protection**: Each operation includes **timeout checks** to prevent **infinite waits**.
- **Logging**: Uses `$display` to show **detailed per-element results**.

---

## **Features Tested in Testbench**

| Test | Description |
| --- | --- |
| `VADD_VV` | Adds `v1` and `v2`, stores **result in `v3`**. |
| `VSUB_VV` | Subtracts `v2` from `v1`, stores **result in `v4`**. |
| `VSTORE` | Stores `v4` into **vector memory at address**. |
| `VLOAD` | Loads data from **memory address** into `v10`, checks **correctness**. |

---

## **Commands**

make b_all

make v_all
