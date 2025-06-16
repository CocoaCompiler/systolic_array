# 4x4 Systolic Array on Basys3 FPGA Board
## Overview
This project implements a 4x4 systolic array for machine learning inference on a Basys3 FPGA Board. It performs matrix multiplication between 8-bit weights and activations, downscales results to 8-bits, and then applies ReLU activation. The output is written back to feature memory for reuse. 

Results are displayed on the Basys3 board. Each element of the 4x4 output matrix is shown using 8 LEDs, and the user can toggle a switch to cycle through and view each output element sequentially. The array uses pipelined MAC units, with a total latency of 16 clock cycles per matrix multiplication. 

## System Architecture
The system consists of the following modules:
* **systolicarray4x4**: Computes the raw matrix multiplication result (18-bit outputs).
* **quantizer_unit**: Downscales 18-bit outputs to 8-bit using thresholding.
* **activation_unit**: Applies ReLU activation on quantized outputs.
* **memory_loader**: Manages loading weights/activations, writing results back to feature memory, and displaying outputs on LEDs.
  
![image](https://github.com/user-attachments/assets/7d08fd92-ca54-48ee-85e9-24d57f02bf32)

### Dataflow
* Weights are loaded vertically over 4 clock cycles.
* Activations are streamed horizontally with zero padding from cycles 4 to 10.
* Computation results begin appearing at cycle 10 and continue until cycle 16.
* Final results are written into feature memory and displayed via LED.

### Matrix Computation
The array computes the matrix product:  C = W x A, where 
* **W**: 4x4 weight matrix (8-bit signed)
* **A**: 4x4 activation or feature matrix (8-bit signed)
* **C**: 4x4 result matrix (18-bit values)
Each element of C, C_i,j is the dot product of ith row of W with jth column of A.

![image](https://github.com/user-attachments/assets/21fa4291-22ae-40c6-9e4e-ba20803f46cc)

## Code & Modules 
### MAC Unit (`mac_unit.v`)
Each MAC (Multiply-Accumulate) unit performs local matrix multiplication and accumulation. 
**Inputs:**
* `rst`: Synchronous rest
* `clk`: System clock
* `L`: Weight load signal
* `wi`: 8-bit weight input (from above)
* `psi`: 18-bit partial sum input (from above)
* `ai`: 8-bit activation input (from the left)
**Outputs:**
* `ao`: Activation output (right)
* `wo` Weight output (downward)
* `pso`: Partial sum output (downward)

**Operation:**
On each rising clock edge:
1. `ai` is latched onto `ao`
2. If `L` is high, `wi` is latched onto `wo`; otherwise `wo` holds its value
3. The MAC computes: `pso` = (wo * ao) + psi
All outputs are reset to 0 on `rst`. 

**Pipeline Delay:**
The MAC introduces a 2-cycle delay: inputs `ai` and `wi` are latched in one cycle, and used in the computation on the next. This causes the full 4×4 matrix multiplication to complete in 16 clock cycles, rather than the ideal 14 (4 for weight loading + 10 for computation).
![image](https://github.com/user-attachments/assets/7a64f9e3-cd65-4c79-88e4-c846e4c28c6e)

#### MAC Testbench & Simulation (`mac_unit_tb.v`)
The testbench below was used to verify MAC functionality. 
![image](https://github.com/user-attachments/assets/2467e84c-b3ec-46fd-ba68-6a2a03259774)

#### MAC waveform 
![image](https://github.com/user-attachments/assets/a22f202a-5c06-4c56-9506-8f1d2d70711e)

At 5ns, `ai = 1`, `wi = 2`, `psi=3`: 
* First cycle: `pso = 0 * 0 + 3 = 3` (old latched values)
* Next cycle: `pso = 2*1 + 5 = 7`

This delay is consistent with pipelined behavior. In the systolic array:
* The top row starts with `psi = 0`, so the delay has no effect.
* In lower rows, `psi` is delayed by design, keeping all inputs synchronized.

## Systolic Array
The array receives 4 weight and 4 activation inputs. It instantiates 16 MAC units arranged in a 4x4 grid. 
* Top row MACs use psi = 0
* Weights move downward
* Activations move rightward
* Partial sums move downward
The signal routing between the MAC follows the label annotations in the diagram under System Architecture.
![image](https://github.com/user-attachments/assets/efdc34ba-8a3e-4a77-bb0a-cdfc43fc46fd)

## Quantization Unit (`quantization_unit.v`)
Clips 18-bit partial sums to fit in the 8-bit signed range:
* Values outside [-128, 127] are set to 0.
* For values within range, the lower 8 bits are retained.
![image](https://github.com/user-attachments/assets/177aef39-f4a6-47d0-b97d-88e8735730a8)

## Activation Unit (`activation_unit.v`)
Applies ReLU to each 8-bit input:
* If the value is negative, output is 0.
* Otherwise, output equals the input.
![image](https://github.com/user-attachments/assets/b420bd33-f7f7-44ca-a59a-55d4761cda2f)

## Memory Loader (`memory_loader.v`)
Controls data loading, computation, write back, and display. 
* Inputs: `clk`, `rst`, `startSignal`, `result_toggle`
* Outputs: `led[7:0]`, `process_done`
  
**Operation**
  1. Reset initializes internal state and memories (feature & activation matrices)
  2. When `startSignal` is high, weights load over cycles 0-3, activations from 4-10.
  3. Results appear from cycle 10 to 16.
  4. Outputs are stored in feature memory and displayed on LEDs.
  5. `result_toggle` with debounce logic cycles through output elements.

![image](https://github.com/user-attachments/assets/74d97407-2f88-41b1-9bf3-71da90049666)

![image](https://github.com/user-attachments/assets/499f5a6a-9407-40c9-9aa0-0c223e26de40)

## Constraints (XDC)
* Clock: 10MHz
* `startSignal`: R2
* `rst`: U1
* `result_toggle`: V17 (rightmost switch)
* `led[7:0]`: U16-V14
* `process_done`: L1 (leftmost LED)
![image](https://github.com/user-attachments/assets/99875ee4-cb7f-4498-9b2d-bde35d00d717)

## Board Output 
The matrix multiplication being tested on the board uses the following input matrices: 

![image](https://github.com/user-attachments/assets/302ca1af-18eb-48f4-bc13-d2bd1d332fd4)

These 4x4 weight and feature matrices are preloaded into internal memories within the memoryloader module on reset. The table below shows the expected outputs. Each 8-bit output is shown on the LEDs and switch V17 is used to toggle through outputs.

![image](https://github.com/user-attachments/assets/fbb819d3-de53-40ac-a088-434c10f975da)

**Photos of the board displaying outputs are shown below.**

![image](https://github.com/user-attachments/assets/8bba88f5-f626-4425-8b35-598f16ee71ac)
*rst applied*

![image](https://github.com/user-attachments/assets/53dd6900-4166-4d12-b5a7-0962e0b2c304)
*Rst deactivated, startSignal applied, process_done led is on, and 1st element of result matrix is displayed (1000)*

![image](https://github.com/user-attachments/assets/7fdd8bfd-1791-4eca-b27f-9bf8b91a3ff8)
*2nd element shown (1001) after toggle switch changed to 1*
  




