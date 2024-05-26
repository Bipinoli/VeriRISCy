// store values 1 to 8 in memory location 1 to 8 successively
// fetch a value from a location to verify 

// Final value of 1 in R1 indicates error. 0 indicates success 
MVI R2, 8 // count
MVI R3, 1

:loop
  // NOP to avoid pipelining hazard
  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1

  JEZ R2, continue // while (count > 0)

  STR R2, R2, 0 // memory(x) = x
  SUB R2, R2, R3 // count = count - 1
  JMP loop

:continue
  // NOP to avoid pipelining hazard
  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1

  MVI R1, 3

  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1

  LOD R1, R1, 2 // R1 = memory(5) = 5

  HLT


