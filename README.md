# VeriRISCy

The processor has been designed for simplicity of implementation.
- 32-bit address space
- 16 registers (R0 to R15)
- Harvard architecture (separate memory for instruction & data)
- Instruction pipelining
- Register prefetching before decoding
- No branch prediction

Furthermore, an assembler has been provided to generate the machine code from the assembly.

## Instruction set architecture (ISA)

16 registers (R0 to R15) with a special register R0 which is always zero.

```
# Load and store instructions
LOD R1, R2, 123       // R1 := Memory(R2 + 123). 123 in 16-bits
STR R1, R2, -2        // Memory(R2 - 2) := R1. -2 in 16-bits

Note: R0 can be used to store a value to/from a specific address.
STR R1, R0, 10        // Memory(0 + 10) := R1

# ALU instructions
ADD R1, R2, R3        // R1 := R2 + R3
SUB R1, R2, R3        // R1 := R2 - R3
MUL R1, R2, R3        // R1 := R2 * R3

AND R1, R2, R3        // R1 := R2 & R3
ORR R1, R2, R3        // R1 := R2 | R3
NOT R1, R2            // R1 := ~R2 

LES R1, R2, R3        // R1 := (R2 < R3) ? 1 : 0
GTR R1, R2, R3        // R1 := (R2 > R3) ? 1 : 0

# Branch and jump instructions
JEZ R1, label         // Jump to label if R1 == 0
JNZ R1, label         // Jump to label if R1 != 0
JMP label             // Jump to label

# End program instruction
HLT
```
### Instruction encoding
TODO:

### Processor pipeline architecture
TODO:

### Note on Pipelining hazards
TODO:







