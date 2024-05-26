/*
Assembling gcd.s ---

---------------------------  debug info  ---------------------------
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

----- assembled instructions -------
553648206
570425487
2505375744
2505375744
2505375744
2505375744
2505375744
1662124032
2505375744
2505375744
2505375744
2505375744
2505375744
3539992588
3272736768
2505375744
2505375744
2505375744
2505375744
2505375744
3808428035
1646329856
4026597356
1628569600
4026597354
0

----- generated code -------
computer.instruction_memory[0]=553648206;
computer.instruction_memory[1]=570425487;
computer.instruction_memory[2]=2505375744;
computer.instruction_memory[3]=2505375744;
computer.instruction_memory[4]=2505375744;
computer.instruction_memory[5]=2505375744;
computer.instruction_memory[6]=2505375744;
computer.instruction_memory[7]=1662124032;
computer.instruction_memory[8]=2505375744;
computer.instruction_memory[9]=2505375744;
computer.instruction_memory[10]=2505375744;
computer.instruction_memory[11]=2505375744;
computer.instruction_memory[12]=2505375744;
computer.instruction_memory[13]=3539992588;
computer.instruction_memory[14]=3272736768;
computer.instruction_memory[15]=2505375744;
computer.instruction_memory[16]=2505375744;
computer.instruction_memory[17]=2505375744;
computer.instruction_memory[18]=2505375744;
computer.instruction_memory[19]=2505375744;
computer.instruction_memory[20]=3808428035;
computer.instruction_memory[21]=1646329856;
computer.instruction_memory[22]=4026597356;
computer.instruction_memory[23]=1628569600;
computer.instruction_memory[24]=4026597354;
computer.instruction_memory[25]=0;

*/

module test_gcd;
reg clock1, clock2;

processor computer(clock1, clock2);

// generate 2-phase clock
initial
begin
  clock1 = 0; clock2 = 0;
  forever begin
      #5 clock1 = 1;
      #5 clock1 = 0;
      #5 clock2 = 1;
      #5 clock2 = 0;
  end
end

initial 
begin
  computer.instruction_memory[0]=553648206;
  computer.instruction_memory[1]=570425487;
  computer.instruction_memory[2]=2505375744;
  computer.instruction_memory[3]=2505375744;
  computer.instruction_memory[4]=2505375744;
  computer.instruction_memory[5]=2505375744;
  computer.instruction_memory[6]=2505375744;
  computer.instruction_memory[7]=1662124032;
  computer.instruction_memory[8]=2505375744;
  computer.instruction_memory[9]=2505375744;
  computer.instruction_memory[10]=2505375744;
  computer.instruction_memory[11]=2505375744;
  computer.instruction_memory[12]=2505375744;
  computer.instruction_memory[13]=3539992588;
  computer.instruction_memory[14]=3272736768;
  computer.instruction_memory[15]=2505375744;
  computer.instruction_memory[16]=2505375744;
  computer.instruction_memory[17]=2505375744;
  computer.instruction_memory[18]=2505375744;
  computer.instruction_memory[19]=2505375744;
  computer.instruction_memory[20]=3808428035;
  computer.instruction_memory[21]=1646329856;
  computer.instruction_memory[22]=4026597356;
  computer.instruction_memory[23]=1628569600;
  computer.instruction_memory[24]=4026597354;
  computer.instruction_memory[25]=0;
end

initial
begin
  $dumpfile("test_gcd.vcd");
  $dumpvars(0, test_gcd);
end

initial
begin
  $monitor("completed: %1b     X: %3d, Y: %3d     GCD(X,Y): %3d", computer.if_halted, computer.register_bank[1], computer.register_bank[2], computer.register_bank[1]);
  #5000 $finish;
end

endmodule
