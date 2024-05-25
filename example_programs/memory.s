// 1. store values 1 to 8 in memory location 1 to 8 successively
// 2. fetch values in multiple locatiosn to verify that

//TODO: modify code to handle data hazard due to instruction pipelining
// Final value of 1 in R1 indicates error. 0 indicates success 
MVI R2, 8 // count
MVI R3, 1

:loop
  JEZ R2, continue // while (count > 0)

  STR R2, R2, 0 // memory(x) = x
  SUB R2, R2, R3 // count = count - 1
  JMP loop

:continue
  MVI R1, 3
  LOD R1, R1, 2 // R1 = memory(5) = 5
  
  MVI R2, 4
  LOD R2, R2, 3 // R2 = memory(7) = 7

  MVI R4, 3
  LOD R4, R4, -2 // R4 = memory(1) = 1

  MVI R3, 5
  SUB R1, R1, R3
  JNZ R1, error

  MVI R3, 7
  SUB R2, R2, R3
  JNZ R2, error

  MVI R3, 1
  SUB R4, R4, R3
  JNS R4, error

  // R1 = 0 (success)
  HLT

:error
  // R1 = 1 (error)
  MVI R1, 1
  HLT
