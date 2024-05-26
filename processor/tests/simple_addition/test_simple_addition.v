/*
Assembled result of simple_addition.s

---------------------------  debug info  ---------------------------
   #0             MVI R1, 10          0010 0001 0000 0000 0000000000001010
   #1             MVI R2, 20          0010 0010 0000 0000 0000000000010100
   #2             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #3             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #4             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #5             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #6             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #7             ADD R1, R1, R2      0101 0001 0001 0010 0000000000000000
   #8             HLT                 0000 0000 0000 0000 0000000000000000

----- assembled instructions -------
553648138
570425364
2433810432
2433810432
2433810432
2433810432
2433810432
1360134144
0

----- generated code -------
computer.if_next_pc = 0;
computer.instruction_memory[0]=553648138;
computer.instruction_memory[1]=570425364;
computer.instruction_memory[2]=2433810432;
computer.instruction_memory[3]=2433810432;
computer.instruction_memory[4]=2433810432;
computer.instruction_memory[5]=2433810432;
computer.instruction_memory[6]=2433810432;
computer.instruction_memory[7]=1360134144;
computer.instruction_memory[8]=0;
*/

module test_simple_addition;
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
  computer.instruction_memory[0]=553648138;
  computer.instruction_memory[1]=570425364;
  computer.instruction_memory[2]=2433810432;
  computer.instruction_memory[3]=2433810432;
  computer.instruction_memory[4]=2433810432;
  computer.instruction_memory[5]=2433810432;
  computer.instruction_memory[6]=2433810432;
  computer.instruction_memory[7]=1360134144;
  computer.instruction_memory[8]=0;
end

initial
begin
  $dumpfile("test_simple_addition.vcd");
  $dumpvars(0, test_simple_addition);
end

initial
begin
  $monitor("time: %3t  R1: %d", $time, computer.register_bank[1]);
  #1000 $finish;
end

endmodule
