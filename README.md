# 4x4 Systolic Array on FPGA
## Overview
This project implements a 4x4 systolic array for machine learning inference on a Basys3 FPGA Board. It performs matrix multiplication between 8-bit weights and activations, downscales results to 8-bits, and then applies ReLU activation. The output is written back to feature memory for reuse. 

Results are displayed on the Basys3 board. Each element of the 4x4 output matrix is shown using 8 LEDs, and the user can toggle a switch to cycle through and view each output element sequentially. The array uses pipelined MAC units, with a total latency of 16 clock cycles per matrix multiplication. 

[Demo Video](https://youtu.be/q6n5RfTxQ9Q)


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

## Board Output

The matrix multiplication being tested on the board uses the following input matrices: 

![image](https://github.com/user-attachments/assets/302ca1af-18eb-48f4-bc13-d2bd1d332fd4)

These 4x4 weight and feature matrices are preloaded into internal memories within the memoryloader module on reset. The table below shows the expected outputs. Each 8-bit output is shown on the LEDs and switch V17 is used to toggle through outputs.

![image](https://github.com/user-attachments/assets/fbb819d3-de53-40ac-a088-434c10f975da)

[Demo Video](https://youtu.be/q6n5RfTxQ9Q)
> The video demonstrates output for the matrix multiplication example shown in the **Board Output** section below. Many of the values are zero due to the ReLU activation.

Photos of the board displaying select outputs are shown below. After the 16th element is displayed, toggling the switch will display the first element again. 

![image](https://github.com/user-attachments/assets/8bba88f5-f626-4425-8b35-598f16ee71ac)

*rst applied*

![image](https://github.com/user-attachments/assets/53dd6900-4166-4d12-b5a7-0962e0b2c304)

*rst deactivated, startSignal applied, process_done led is on, and first element of result matrix is displayed (0000 1000)*

![image](https://github.com/user-attachments/assets/7fdd8bfd-1791-4eca-b27f-9bf8b91a3ff8)

*Second element shown (0000 1001) after toggle switch changed to 1*
  
## Acknowledgement

This project was a course assignment and is shared with permission from the instructor.



