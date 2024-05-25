// function gcd(a, b)
//    while a != b
//      if a > b
//        a := a - b
//      else 
//        b := b - a
//    return a
//
// gcd(78, 143) = 13 


// TODO: The code need to be modified to avoid pipelining data hazard
MVI R1, 78
MVI R2, 143

:loop
  SUB R3, R1, R2
  JEZ R3, end
  
  GTR R3, R1, R2
  JNZ R3, greater
  
  SUB R2, R2, R1
  JMP loop

  :greater
    SUB R1, R1, R2
    JMP loop

:end 
  HLT
  // result in R1

