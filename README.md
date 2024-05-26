# VeriRISCy

The processor was designed for fun with a focus on simplicity.
- 32-bit word size
- 16 registers (R0 to R15)
- Harvard architecture (separate memory for instruction & data)
- Instruction pipelining
- Register prefetching while decoding
- No branch prediction

Furthermore, an [assembler](https://github.com/Bipinoli/VeriRISCy/blob/main/assembler/assembler.py) has been provided to generate the machine code from the assembly.


<hr>

# Table of contents
1. [Instruction set architecture](#isa)
2. [Instruction encoding](#encoding)
3. [Examples](#example)
4. [Processor pipeline architecture](#pipeline)
   1. [Pipeline stages](#pipeline_stages)
   2. [Two-phase clock](#two_phase)
   3. [Pipeline hazard](#hazard)
6. [Possible future directions](#future)


## Instruction set architecture (ISA) <a name="isa"></a>

```
# Move, load, and store instructions
MOV R1, R2            // R1 := R2
MVI R1, 123           // R1 := 123. 123 in 16-bit immediate value
LOD R1, R2, 123       // R1 := Memory(R2 + 123). 123 in 16-bits
STR R1, R2, -2        // Memory(R2 - 2) := R1. -2 in 16-bits

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
<hr/>

## Instruction encoding <a name="encoding"></a>

```
  __________________________________________________________________
 | opcode | r_dest |  r_a  |  r_b  |        immediate val           |
  ------------------------------------------------------------------
    4-bit    4-bit    4-bit   4-bit            16-bit
    <------------------    32-bit  --------------------------------->


examples:
  AND R1, R2, R3
  --------------
  opcode:    AND (4-bit)
  r_dest:    R1  (4-bit)
  r_a:       R2  (4-bit)
  r_b:       R3  (4-bit)
  immediate: 0 (not used)


  MVI R1, 123
  --------------
  opcode:     MVI (4-bit)
  r_dest:     R1  (4-bit)
  immediate:  123 (16-bit)
  r_a, r_b:   0 (not used)
```

<hr/>

## Examples <a name="example"></a>

There are test runs of various [programs](https://github.com/Bipinoli/VeriRISCy/tree/main/processor/tests) in VeriRISCy processor.
Execution of [one of the tests](https://github.com/Bipinoli/VeriRISCy/blob/main/processor/tests/gcd/test_gcd.v) from there is as shown below.
```
Execution of greater common divisor program in VeriRISCy processor.

Note:
  Since our processor runs instructions in a pipeline fashion, the result from
  one instruction might not have been fully committed before the successive instruction.
  This is called a data hazard.

  To deal with this, we put a no-op operation between instructions with data dependency.
  'ORR R5, R5, R5' semantically does nothing. So it is one of those no-op operations.


--------------- Assembly code -------------------  Machine code  ---------------
   #0             MVI R1, 78          0010 0001 0000 0000 0000000001001110
   #1             MVI R2, 143         0010 0010 0000 0000 0000000010001111
   #2      :loop  ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
   #3             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
   #4             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
   #5             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
   #6             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
   #7             SUB R3, R1, R2      0110 0011 0001 0010 0000000000000000
   #8             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
   #9             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
  #10             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
  #11             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
  #12             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
  #13             JEZ R3, end         1101 0011 0000 0000 0000000000001100
  #14             GTR R3, R1, R2      1100 0011 0001 0010 0000000000000000
  #15             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
  #16             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
  #17             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
  #18             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
  #19             ORR R5, R5, R5      1001 0101 0101 0101 0000000000000000
  #20             JNZ R3, greater     1110 0011 0000 0000 0000000000000011
  #21             SUB R2, R2, R1      0110 0010 0010 0001 0000000000000000
  #22             JMP loop            1111 0000 0000 0000 1111111111101100
  #23   :greater  SUB R1, R1, R2      0110 0001 0001 0010 0000000000000000
  #24             JMP loop            1111 0000 0000 0000 1111111111101010
  #25       :end  HLT                 0000 0000 0000 0000 0000000000000000


Running the machine code in the iverilog simulator we get the following:
------------------------------------------------------------------------
completed: 0     X:   x, Y:   x     GCD(X,Y):   x
completed: 0     X:  78, Y:   x     GCD(X,Y):  78
completed: 0     X:  78, Y: 143     GCD(X,Y):  78
completed: 0     X:  78, Y:  65     GCD(X,Y):  78
completed: 0     X:  13, Y:  65     GCD(X,Y):  13
completed: 0     X:  13, Y:  52     GCD(X,Y):  13
completed: 0     X:  13, Y:  39     GCD(X,Y):  13
completed: 0     X:  13, Y:  26     GCD(X,Y):  13
completed: 0     X:  13, Y:  13     GCD(X,Y):  13
completed: 1     X:  13, Y:  13     GCD(X,Y):  13

```

<hr/>

## Processor pipeline architecture <a name="pipeline"></a>

### Pipeline stages <a name="pipeline_stages"></a>
VeriRISCy follows the traditional RISC instruction pipeline, which is as follows:
1. #### Instruction Fetch
2. #### Instruction Decode
    1. pre-fetching of operand register contents
4. #### Execute
    1. ALU operations
    2. Branch identification & signaling
5. #### Memory Access
    1. Load/Store operations with data memory
6. #### Register write-back
    1. Writing results from ALU to the destination register
    2. Handling instructions

<hr>

### Two-phase clock <a name="two_phase"></a>
The results from each stage are persisted in a flip-flop which becomes the input to the next stage in the next clock cycle.

With a single clock activating all stages at once, the successive pipeline stages can work incorrectly if the input for one stage doesn't arrive in time from the previous stage.
To make sure such things don't happen we are using [two-phase clocking](https://en.wikipedia.org/wiki/Clock_signal).

With 2-phase clocking, the adjacent stages will be activated alternately thus providing us with a controlled mechanism of pipeline transfer.

<hr>

### Pipeline hazard <a name="hazard"></a>
Since our processor runs instructions in a pipeline fashion, while writing a program, one needs to be careful of [pipeline hazards](https://en.wikipedia.org/wiki/Hazard_(computer_architecture)).
One such example is a case of data dependency. When two successive instructions have a dependency where a result of one is used in another, then they can't be run concurrently in the pipeline. 
To avoid that we can introduce a buffer with no-op operations.



<hr/>

### Possible future directions <a name="future"></a>
- Running the processor in an [FPGA](https://en.wikipedia.org/wiki/Field-programmable_gate_array) or building a custom [ASIC](https://en.wikipedia.org/wiki/Application-specific_integrated_circuit)
- Introducing a simple [branch prediction](https://en.wikipedia.org/wiki/Branch_predictor) algorithm
- Writing a compiler for a higher-level language






