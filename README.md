# Into the Silicon: FPGA and Verilog

Where I'm learning Verilog on an FPGA. I'm taking Fundamentals of Digital Circuits at USF, and this is the hands-on side of that: writing the logic myself and running it on real hardware.

Long term I want to work in digital hardware, specifically chip design and GPU architecture, so this is the starting point.

**Status:** toolchain is set up, blink runs on the board, and an 8-bit ALU passes its testbench.

## Setup

- **Board:** Sipeed Tang Nano 20K (Gowin GW2AR-18, 27 MHz clock)
- **Synthesis / place and route:** open-source flow, Yosys + nextpnr, on Windows through MSYS2
- **Simulation:** Icarus Verilog

## Projects

| Folder | What it is |
|---|---|
| [`01-blink`](01-blink) | Toggles an LED once a second by counting 27 million clock cycles. Mostly here to prove the toolchain works end to end. |
| [`02-alu`](02-alu) | 8-bit ALU with 8 operations (add, subtract, AND, OR, XOR, shift left, shift right, NOT) and carry, overflow, zero, and negative flags. The testbench runs every input combination, 256 × 256 × 8 = 524,288 cases, and checks the result and all four flags. |

## Roadmap

- [x] Blink an LED and set up the toolchain
- [x] 8-bit ALU with a full testbench
- [ ] More combinational logic: multiplexers, decoders
- [ ] Sequential logic: counters, shift registers, finite state machines
- [ ] Drive a seven-segment display
- [ ] UART to talk to a computer
- [ ] First real project, combining the pieces above

Each step gets its own folder with the Verilog, a testbench, and a short note on what I learned.
