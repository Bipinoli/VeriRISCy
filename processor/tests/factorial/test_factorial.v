/*
Assembling factorial/factorial.s ---

---------------------------  debug info  ---------------------------
   #0             MVI R1, 1           0010 0001 0000 0000 0000000000000001
   #1             MVI R2, 5           0010 0010 0000 0000 0000000000000101
   #2             MVI R3, 1           0010 0011 0000 0000 0000000000000001
   #3      :loop  ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #4             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #5             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #6             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #7             GTR R4, R2, R3      1100 0100 0010 0011 0000000000000000
   #8             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #9             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #10             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #11             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #12             JEZ R4, end         1101 0100 0000 0000 0000000000000100
  #13             MUL R1, R1, R2      0111 0001 0001 0010 0000000000000000
  #14             SUB R2, R2, R3      0110 0010 0010 0011 0000000000000000
  #15             JMP loop            1111 0000 0000 0000 1111111111110100
  #16       :end  HLT                 0000 0000 0000 0000 0000000000000000

----- assembled instructions -------
553648129
570425349
587202561
2433810432
2433810432
2433810432
2433810432
3290628096
2433810432
2433810432
2433810432
2433810432
3556769796
1897005056
1646460928
4026597364
0

----- generated code -------
computer.instruction_memory[0]=553648129;
computer.instruction_memory[1]=570425349;
computer.instruction_memory[2]=587202561;
computer.instruction_memory[3]=2433810432;
computer.instruction_memory[4]=2433810432;
computer.instruction_memory[5]=2433810432;
computer.instruction_memory[6]=2433810432;
computer.instruction_memory[7]=3290628096;
computer.instruction_memory[8]=2433810432;
computer.instruction_memory[9]=2433810432;
computer.instruction_memory[10]=2433810432;
computer.instruction_memory[11]=2433810432;
computer.instruction_memory[12]=3556769796;
computer.instruction_memory[13]=1897005056;
computer.instruction_memory[14]=1646460928;
computer.instruction_memory[15]=4026597364;
computer.instruction_memory[16]=0;

*/

module test_factorial;
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
  computer.instruction_memory[0]=553648129;
  computer.instruction_memory[1]=570425349;
  computer.instruction_memory[2]=587202561;
  computer.instruction_memory[3]=2433810432;
  computer.instruction_memory[4]=2433810432;
  computer.instruction_memory[5]=2433810432;
  computer.instruction_memory[6]=2433810432;
  computer.instruction_memory[7]=3290628096;
  computer.instruction_memory[8]=2433810432;
  computer.instruction_memory[9]=2433810432;
  computer.instruction_memory[10]=2433810432;
  computer.instruction_memory[11]=2433810432;
  computer.instruction_memory[12]=3556769796;
  computer.instruction_memory[13]=1897005056;
  computer.instruction_memory[14]=1646460928;
  computer.instruction_memory[15]=4026597364;
  computer.instruction_memory[16]=0;
 
end

initial
begin
  $dumpfile("test_factorial.vcd");
  $dumpvars(0, test_factorial);
end

initial
begin
  $monitor("calculating factorial(5). 5! converging to %3d", computer.register_bank[1]);
  #1200 $finish;
end

endmodule
