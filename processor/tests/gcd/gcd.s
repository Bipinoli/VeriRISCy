// function gcd(a, b)
//    while a != b
//      if a > b
//        a := a - b
//      else 
//        b := b - a
//    return a
//
// gcd(78, 143) = 13 

// NOTE:
// ORR R1, R1, R1 is a NOP code to introduce a buffer in pipeline
// to avoid data hazard

MVI R1, 78
MVI R2, 143

:loop

  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1


  SUB R3, R1, R2

  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1

  JEZ R3, end
  
  GTR R3, R1, R2

  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1
  ORR R1, R1, R1

  JNZ R3, greater
  
  SUB R2, R2, R1
  JMP loop

  :greater
    SUB R1, R1, R2
    JMP loop

:end 
  HLT
  // result in R1

