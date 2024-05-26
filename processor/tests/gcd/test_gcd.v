/*
Assembling gcd/gcd.s ---

---------------------------  debug info  ---------------------------
   #0             MVI R1, 78          0010 0001 0000 0000 0000000001001110
   #1             MVI R2, 143         0010 0010 0000 0000 0000000010001111
   #2      :loop  ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #3             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #4             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #5             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #6             SUB R3, R1, R2      0110 0011 0001 0010 0000000000000000
   #7             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #8             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #9             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #10             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #11             JEZ R3, end         1101 0011 0000 0000 0000000000001011
  #12             GTR R3, R1, R2      1100 0011 0001 0010 0000000000000000
  #13             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #14             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #15             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #16             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #17             JNZ R3, greater     1110 0011 0000 0000 0000000000000011
  #18             SUB R2, R2, R1      0110 0010 0010 0001 0000000000000000
  #19             JMP loop            1111 0000 0000 0000 1111111111101111
  #20   :greater  SUB R1, R1, R2      0110 0001 0001 0010 0000000000000000
  #21             JMP loop            1111 0000 0000 0000 1111111111101101
  #22       :end  HLT                 0000 0000 0000 0000 0000000000000000

----- assembled instructions -------
553648206
570425487
2433810432
2433810432
2433810432
2433810432
1662124032
2433810432
2433810432
2433810432
2433810432
3539992587
3272736768
2433810432
2433810432
2433810432
2433810432
3808428035
1646329856
4026597359
1628569600
4026597357
0

----- generated code -------
computer.instruction_memory[0]=553648206;
computer.instruction_memory[1]=570425487;
computer.instruction_memory[2]=2433810432;
computer.instruction_memory[3]=2433810432;
computer.instruction_memory[4]=2433810432;
computer.instruction_memory[5]=2433810432;
computer.instruction_memory[6]=1662124032;
computer.instruction_memory[7]=2433810432;
computer.instruction_memory[8]=2433810432;
computer.instruction_memory[9]=2433810432;
computer.instruction_memory[10]=2433810432;
computer.instruction_memory[11]=3539992587;
computer.instruction_memory[12]=3272736768;
computer.instruction_memory[13]=2433810432;
computer.instruction_memory[14]=2433810432;
computer.instruction_memory[15]=2433810432;
computer.instruction_memory[16]=2433810432;
computer.instruction_memory[17]=3808428035;
computer.instruction_memory[18]=1646329856;
computer.instruction_memory[19]=4026597359;
computer.instruction_memory[20]=1628569600;
computer.instruction_memory[21]=4026597357;
computer.instruction_memory[22]=0;
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
  computer.instruction_memory[2]=2433810432;
  computer.instruction_memory[3]=2433810432;
  computer.instruction_memory[4]=2433810432;
  computer.instruction_memory[5]=2433810432;
  computer.instruction_memory[6]=1662124032;
  computer.instruction_memory[7]=2433810432;
  computer.instruction_memory[8]=2433810432;
  computer.instruction_memory[9]=2433810432;
  computer.instruction_memory[10]=2433810432;
  computer.instruction_memory[11]=3539992587;
  computer.instruction_memory[12]=3272736768;
  computer.instruction_memory[13]=2433810432;
  computer.instruction_memory[14]=2433810432;
  computer.instruction_memory[15]=2433810432;
  computer.instruction_memory[16]=2433810432;
  computer.instruction_memory[17]=3808428035;
  computer.instruction_memory[18]=1646329856;
  computer.instruction_memory[19]=4026597359;
  computer.instruction_memory[20]=1628569600;
  computer.instruction_memory[21]=4026597357;
  computer.instruction_memory[22]=0;
end

initial
begin
  $dumpfile("test_gcd.vcd");
  $dumpvars(0, test_gcd);
end

initial
begin
  $monitor("time: %3t  R1: %d R2: %d GCD: %d", $time, computer.register_bank[1], computer.register_bank[2], computer.register_bank[1]);
  #1000 $finish;
end

endmodule
