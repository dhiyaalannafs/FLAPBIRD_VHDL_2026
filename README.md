# Flappy Bird FPGA - VHDL 2026

A Flappy Bird-inspired game implemented using **VHDL (VHSIC Hardware Description Language)** and designed to run on an FPGA development board.

This project is developed as part of a digital system design project, focusing on the implementation of game logic and hardware-based graphics using VHDL.

## Overview

The project recreates the basic gameplay of Flappy Bird using FPGA hardware. The game is designed around digital logic and VHDL modules to control the game mechanics and visual output.

The main objective is to demonstrate the application of digital design concepts through an interactive FPGA-based game.

## Technologies Used

- **Hardware Description Language:** VHDL
- **Development Environment:** AMD Xilinx Vivado
- **FPGA Board:** Digilent Basys 3
- **Constraint File:** XDC (Xilinx Design Constraints)

## Repository Structure

```text
FLAPBIRD_VHDL_2026/
│
├── SCR_VHDL/       # VHDL source files
├── ip/             # IP-related project files
├── cons.xdc        # FPGA pin constraint file
└── README.md       # Project documentation
```

## Getting Started

To run this project, follow these steps:

1. Install and open **AMD Xilinx Vivado**.
2. Create or open a Vivado project.
3. Add the VHDL source files from the `SCR_VHDL` directory.
4. Add the `cons.xdc` constraint file.
5. Ensure that the required IP files are properly configured.
6. Run **Simulation** to verify the design.
7. Run **Synthesis** and **Implementation**.
8. Generate the bitstream.
9. Connect the Basys 3 FPGA board and program the device.

## Hardware Requirements

- Digilent Basys 3 FPGA Development Board
- USB cable for programming and power

## Project Goals

- Implement game logic using VHDL.
- Apply Finite State Machine (FSM) concepts in digital system design.
- Develop visual output for an FPGA-based game.
- Understand the process of FPGA synthesis, implementation, and programming.

## Author

**Dhiya Alannafs**

GitHub: [@dhiyaalannafs](https://github.com/dhiyaalannafs)

## License

This project is intended for educational and learning purposes.
