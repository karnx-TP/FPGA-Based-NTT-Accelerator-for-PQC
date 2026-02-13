# FPGA Implementation
This directory contains vivado project folders of NTT Accelerator FPGA implementation.

## Specification
- **Target Board** : Alinx AX7010
- **FPGA Chip** : Xilinx Zynq7000 (xc7z010clg400-1)
- **Target Frequency** : 100 MHz

## Implementation Result

### **Resource Usage**

Resource Utilization Summary

![Resource](./pic/resum.png)

Hierarchy

![Resource](./pic/re0.png)

- **LUTs** : 6426
- **FFs** : 2151
- **BRAMs** : 1.5
- **DSPs** : 24

### **Timing Result**
---
Timing Summary (Frequency = 100MHz)

![Timing](./pic/time0.png)
- **Setup WNS** : 0.562ns
- **Hold WNS** : 0.038ns
- **WPWS** : 3.750 ns

*All timing constraits are met*

### **Power Usage**
---

Power Consumption Summary

![Power](./pic/power.png)

- **Dynamic Power** : 0.097W
- **Total Power** : 0.189W

*Dynamic = 50% of total power (~Device static)*