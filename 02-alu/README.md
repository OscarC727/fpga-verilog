# ALU

A combinational ALU in Verilog, first made as a fixed 8-bit version and then parameterized to any width N.

## Operations

| op  | Operation   | Notes                                   |
|-----|-------------|-----------------------------------------|
| 000 | ADD         | a + b                                   |
| 001 | SUB         | a + ~b + 1 (two's complement)           |
| 010 | AND         | bitwise                                 |
| 011 | OR          | bitwise                                 |
| 100 | XOR         | bitwise                                 |
| 101 | SHL         | shift left by 1, shifted-out bit → cout |
| 110 | SHR         | shift right by 1, shifted-out bit → cout|
| 111 | NOT         | ~a                                      |

## Flags

- **cout**: carry out of the adder. For SUB, 1 means no borrow (a ≥ b). For shifts, it's the bit that got shifted out.
- **overflow**: signed overflow on ADD/SUB. Set when both adder inputs have the same sign but the result's sign is different.
- **zero**: result is all zeros
- **negative**: signed bit of the result

Subtraction reuses the adder: b gets inverted and the sub signal goes in as the carry-in, so a − b = a + ~b + 1.

## Files

- `8b_alu.v` / `alu_tb.v`: original 8-bit ALU and its testbench
- `Nb_alu.v` / `Nb_alu_tb.v`: parameterized N-bit ALU and its testbench

## Verification

**8-bit:** exhaustive. Every combination of a, b, and op (256 × 256 × 8 = 524,288 cases) checked against a reference model that computes the result and all four flags a different way than the ALU does (e.g. overflow from signed integer math instead of sign bits).

**N-bit:** exhaustive testing stops being possible past small widths (64-bit would be 2^131 cases), so the testbench uses:
- **Directed corner cases**: 0, 1, max positive, −1 (all ones), most negative, and alternating 0101/1010 patterns. Every pair of them through every op (7 × 7 × 8 = 392 cases). These cover the edges random inputs basically never hit, like all-ones + 1 where the carry goes through every bit.
- **1,000,000 seeded random cases**, so any failure can be reproduced.

Passes at N = 8 and N = 64. I also broke the ALU on purpose a few times to make sure the testbench actually catches bugs.

**Note** the random inputs in the N-bit testbench are built from two 32-bit $random calls, so above N = 64 the upper bits of a and b would always be 0 in the random tests (the corner cases still cover the full width). Not a bug, and easy to extend by concatenating more $random calls, just not needed for the widths I tested.

## Running it

Needs Icarus Verilog (I used the one in OSS CAD Suite).

```
# 8-bit, exhaustive
iverilog -o alu_sim alu_tb.v 8b_alu.v && vvp alu_sim

# N-bit, default N = 8
iverilog -o nb_sim Nb_alu_tb.v Nb_alu.v && vvp nb_sim

# N-bit at 64 bits
iverilog -P Nb_alu_tb.N=64 -o nb_sim Nb_alu_tb.v Nb_alu.v && vvp nb_sim
```
