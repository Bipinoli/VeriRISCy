// function factorial(n):
//    count := n
//    ans := 1
//    while (count > 1) 
//      ans := ans * count
//      count := count - 1
//    return ans
//
// factorial(5) = 120


// TODO: update code to avoid data hazard in pipeline execution
MVI R1, 1 // ans 
MVI R2, 5 // count 

MVI R3, 1
:loop
  GTR R4, R2, R3
  JEZ R4, end
  
  MUL R1, R1, R2
  SUB R2, R2, R3

  JMP loop

:end
  HLT
  // answer in R1
