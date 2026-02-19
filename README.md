# FPGA-Based PQC Accelerator (Kyber KeyGen)
Hardware Implementation of Post-Quantum Cryptography Algorithms Accelerator(ML-KEM/Kyber) focusing on NTT Operation

---

### About Author & Project
I am a senior Electrical Engineering student with a strong interest in **VLSI, Hardware Accelerator, FPGA, and Digital IC Design**.  
This project focuses on the hardware implementation of **Post-Quantum Cryptography (PQC)**, specifically the **Kyber (ML-KEM)** algorithm, which has been selected by NIST for standardization.

The goal of this project is to explore and learn about both cryptographic algorithm and hardware implementation by designing a **Accelerator for Kyber Key Generation** focusing on NTT transformation which is the main operation used in this algorithm.

**Note**
```
This project documents my journey in PQC hardware design.
It focuses on optimizing arithmetic operations (NTT/INTT) for FPGA resources.
The repository is organized to separate RTL design, Verification, and Software reference models.

For suggestions, feedback, or technical discussions 
📧 Email: thitipong.pav@gmail.com
```
## Overview

This project implements a hardware accelerator for **Module-Lattice-Based Key-Encapsulation Mechanism (ML-KEM/Kyber)**. The current focus is on the **Number Theoretic Transform (NTT)**, which is the most computationally intensive part of polynomial multiplication in Kyber.

**Goal**
- Develop a Python Proof-of-Concept (PoC) to verify NIST parameters and arithmetic logic.
- Implement efficient modular arithmetic units in **SystemVerilog**.
- Design a fully pipelined **Butterfly Unit** for high-throughput NTT.
- Verify the design using a co-simulation environment (Python-generated vectors vs. RTL).


## Tools Used

### RTL & Verification
- **RTL Design:** SystemVerilog
- **Functional Verification:** ModelSim 

### Algorithm & Golden Model
- **Language:** Python 3
- **Libraries:** NumPy (for matrix benchmarks), standard math libraries
- **Scripts:** Custom scripts for generating test vectors (`.csv`) for the testbench.

### FPGA Implementation
- **Synthesis and PnR** Vivado
- **Target Board** Alinx AX7010 (Zynq7000)

## Design Flow

1. **Algorithmic Verification (Python):**
   - Implemented NTT, INTT, and Montgomery Reduction in Python.
   - Benchmarked standard NumPy matrix multiplication against custom NTT approaches.

2. **RTL Component Design:**
   - Designed modular arithmetic units (`butterfly_unit`, `mont_inv_transform`).

3. **Functional Simulation:**
   - Verified RTL behavior using SystemVerilog testbenches (`tb_bntt.sv`).
   - Compared the output to the result from Python.

4. **Accelerator Integration (In Progress):**
   - Developing the full NTT control logic and memory access patterns.

## Performance Benchmarks (Proof of Concept)

Before moving to hardware, I profiled different polynomial multiplication methods in Python to justify the need for hardware acceleration and efficient algorithms.

**Python Execution Time Comparison for PolyMult(N=256):**
| Method | Time (seconds) | Note |
| :--- | :--- | :--- |
| **Numpy** | 0.004318 | Standard library |
| **Classic Poly Mult** | 0.001779 | Naive implementation |
| **My Matrix Mult NTT** | **0.000309** | Optimized algorithmic approach |
| **My Full Butterfly NTT**| 0.002292 | Slower in Python due to loops, but highly parallelizable in Hardware |
|**Hardware Perf Approx.**|**0.000080**| 1 butterfly unit = 9 cycles latency with 100MHz and Butterfly do parallelly and R/W overhead|

*Hardware approximation treats Butterfly loop as parallel operation which result in the loop of butterfly operation times are counted as parallel.*

*Observation: The Full Butterfly approach struggles in Python due to sequential execution of loops, but it is the optimal architecture for FPGA implementation due to its parallel nature.*

## Source Files Description

### Main RTL (`/rtl/ntt`)
- All main RTL source codes for implementing NTT Acceleraot.

### Memory Module (`/rtl/ram_rom`)
- **`bram_dp_word.sv`**: dual port ram for containing polynamial coefficients value (a)
- **`rom_**`**: Rom for twiddle factor

### Verification Environment (`/rtl/tb`)
- **`sim_**`**: testbench folders includes testbench file, run scripts and wave files for each test methods.
- **Data Driven**: Compares RTL output against output from Python Computation result

#### For the Design Details See 📁 /rtl

### Software (`/software/`)
- **`mont.py`,`ntt.py`**: Proof of Concept and Golden Model used in Hardware output verification
- **`factor_table_rom_gen.py`,**: RTL ROM generation scripts for twiddle factor 
- **`exceed_addr_dec_gen`** : RTL ROM generation scripts for exceed stage address decoder

### Supplementary (`/Supplementary/`)
- Supplementary files
- Timing Diagram design paper



## FPGA Implementaion
- Target Board : Alinx AX7010 (Xilinx Zynq7000)
- Current Maximum Frequency : **100MHz**
#### For the Implementation Details See 📁 /vivado

## Current Successful Work
- Butterfly Unit has 2 mode : NTT Butterfly and Direct MultMod which allow user to access MultMod logic inside directly
- Correctly Mux selecting for each stages in Butterfly operation
- Computed NTT and INTT operation for N=64,128,256 and q=7681
- Accessed NTT accelerator using Data Bus and Register-Mapped
- Timing Closure successful at 100MHz

## Current Performance (19/2/2025)
- **Suported Coefficient length** : N = 64,128,256 

*Note : Currently do not support N<64 due to the operation pipelining in each stage*
- **1 Butterfly Unit latency** : 10 cycles
- **Latency** : $$Latency = T_{clk}[2N + log_2(N)*Cycles_{BFU}*\frac{N}{2*BF\_UNITS}]$$
$$Time\ complexity = O(N\ log_2N)$$
*Note 2N comes from Data Read/Write Overhead*
- **Full NTT/iNTT computation latency (N=256)** : 1795(NTT), 2306(iNTT) cycles,


## Future Work
- Full NTT Accelerator: Complete the control logic for the `ntt_butterfly.sv` module to handle full 256-coefficient polynomials.

- Kyber KeyGen : Extend the hardware to cover Polynomial Multiplication and Matrix Multiplication for Kyber Key generation algorithm

- System Integration: Develop an AXI4-Lite Slave Interface for SoC memory-mapped configuration to connect with Zynq7000 ARM Processor or a RISC-V soft-core (from my previous project).

- On-Board Verification: Synthesize the design on the AX7010 (Zynq-7000) platform.