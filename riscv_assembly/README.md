## 🧠 RISC-V Assembly Programs Overview

This folder contains the RISC-V assembly programs executed as part of learning and exploring the **RISC-V Instruction Set Architecture (ISA)**.  
It includes a wide range of examples that demonstrate fundamental concepts — from basic arithmetic to control flow, memory handling, and trap mechanisms across privilege levels.

---

### 📘 Unprivileged Architecture

#### ✅ Programs Executed:

1. **Basic Arithmetic Operations**  
   - Addition, subtraction, multiplication, and division  
   *(Programs 1 to 4)*

2. **Bitwise Operations**  
   - AND, OR, XOR  
   *(Programs 5 and 6)*

3. **Conditional Logic**  
   - Implemented `if`, `if-else`, and `if-elseif-else` structures  
   *(Programs 7 to 9)*

4. **Loop Structures**  
   - Used loops to construct `while` and `switch-case` logic  
   *(Programs 10 and 11)*

5. **Odd or Even Check**  
   - Determined whether a number is odd or even  
   *(Program 12)*

6. **Factorial Calculation**  
   - Calculated factorial using a loop  
   *(Program 13)*

7. **Array Operations**  
   - Computed sum, found max/min, and searched for elements  
   *(Programs 14, 16, 17, 18)*

8. **Matrix Operations**  
   - Added two matrices using nested loops  
   *(Program 15)*

9. **String Length Finder**  
   - Determined the length of a string  
   *(Program 19)*

10. **Vowel Counter**  
    - Counted vowels in a given string  
    *(Program 20)*

---

### 🔐 Privileged Architecture (PREV SPEC)

#### ✅ Programs Executed:

1. **CSR Manipulation (mscratch)**  
   - Read, wrote, set, and cleared the `mscratch` register  
   *(Program 21)*

2. **mstatus CSR Handling**  
   - Explored machine mode behavior by accessing `mstatus`  
   *(Program 22)*

3. **Single-Precision Floating Point Operations**  
   - Executed `fadd.s`, `fsub.s`, etc.  
   *(Program 23)*

4. **Double-Precision Floating Point Operations**  
   - Executed `fadd.d`, `fdiv.d`, etc.  
   *(Program 24)*

5. **Trap Handling: Illegal Instruction**  
   - Simulated and trapped an illegal instruction  
   *(Program 25)*

6. **Trap Handling: ECALL**  
   - Triggered and handled an `ecall` trap  
   *(Program 26)*

7. **Privilege Mode Trap Handling**  
   - Managed traps across Machine, Supervisor, and User modes  
   *(Program 27)*

8. **Trap Handling: EBREAK**  
   - Executed and handled `ebreak`  
   *(Program 28)*

---

### 📌 Summary

Through these programs, I have developed a strong foundational understanding of:

- Writing low-level logic using RISC-V assembly  
- Performing arithmetic, logic, and control flow operations  
- Working with arrays, strings, and matrices  
- Managing memory and registers  
- Using Control and Status Registers (CSRs)  
- Handling traps (ecall, ebreak, illegal instructions)  
- Performing floating-point operations  
- Navigating between different privilege levels in the RISC-V ISA
