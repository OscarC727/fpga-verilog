# 02: 8-bit ALU

| `op` | Operation | Carry out |
|---|---|---|
| `000` | a + b | carry from bit 7 |
| `001` | a − b (two's complement: a + ~b + 1) | 1 if no borrow (a ≥ b) |
| `010` | a AND b | 0 |
| `011` | a OR b | 0 |
| `100` | a XOR b | 0 |
| `101` | a << 1 | bit shifted out (old bit 7) |
| `110` | a >> 1 | bit shifted out (old bit 0) |
| `111` | NOT a | 0 |

Flags: `cout`, `overflow` (signed overflow on add/subtract), `zero`, `negative` (bit 7 of the result).

Subtraction reuses the adder. When `op` is `001`, `b` gets inverted and the `sub` bit goes in as the carry in, so a − b becomes a + ~b + 1.

## Test

`alu_tb.v` loops through every `a`, every `b`, and every `op` (524,288 cases), computes the expected result and flags separately, and prints the first 10 mismatches if there are any.

```
iverilog -o alu_sim alu.v alu_tb.v
vvp alu_sim
```

Prints `All tests passed successfully.` when everything matches.

## What I learned

<!-- write a couple lines here -->
