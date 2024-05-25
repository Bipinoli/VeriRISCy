# VeriRISCy

## Instruction set architecture (ISA)

Total registers: 16 (R0 to R15)
Special register: R0 (Always zero. Can't be overwritten)

```
# Load and store instructions
LOD R1, R2, 123       // R1 := Memory(R2 + 123)
STR R1, R2, -2        // Memory(R2 - 2) := R1

Note: R0 can be used to store a value to/from a specific address.
STR R1, R0, 10        // Memory(0 + 10) := R1

# ALU instructions
ADD R1, R2, R3        // R1 := R2 + R3
SUB R1, R2, R3        // R1 := R2 - R3
MUL R1, R2, R3        // R1 := R2 * R3

AND R1, R2, R3        // R1 := R2 & R3
ORR R1, R2, R3        // R1 := R2 | R3
NOT R1, R2            // R1 := ~R2 

LES R1, R2, R3        // R1 := (R2 < R3) ? R2 : R3
GTR R1, R2, R3		  // R1 := (R2 > R3) ? R2: R3o

# Branch and jump instructions
JEZ R1, label         // Jump to label if R1 == 0
JNZ R1, label         // Jump to label if R1 != 0
JMP label             // Jump to label

# End program instruction
HLT
```




