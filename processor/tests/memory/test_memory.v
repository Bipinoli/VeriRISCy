/*

Assembling memory.s ---

---------------------------  debug info  ---------------------------
   #0             MVI R2, 8           0010 0010 0000 0000 0000000000001000
   #1             MVI R3, 1           0010 0011 0000 0000 0000000000000001
   #2      :loop  ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #3             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #4             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #5             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
   #6             JEZ R2, continue    1101 0010 0000 0000 0000000000000100
   #7             STR R2, R2, 0       0100 0010 0010 0000 0000000000000000
   #8             SUB R2, R2, R3      0110 0010 0010 0011 0000000000000000
   #9             JMP loop            1111 0000 0000 0000 1111111111111001
  #10  :continue  ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #11             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #12             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #13             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #14             MVI R1, 3           0010 0001 0000 0000 0000000000000011
  #15             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #16             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #17             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #18             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #19             ORR R1, R1, R1      1001 0001 0001 0001 0000000000000000
  #20             LOD R1, R1, 2       0011 0001 0001 0000 0000000000000010
  #21             HLT                 0000 0000 0000 0000 0000000000000000

----- assembled instructions -------
570425352
587202561
2433810432
2433810432
2433810432
2433810432
3523215364
1109393408
1646460928
4026597369
2433810432
2433810432
2433810432
2433810432
553648131
2433810432
2433810432
2433810432
2433810432
2433810432
823132162
0

----- generated code -------
computer.instruction_memory[0]=570425352;
computer.instruction_memory[1]=587202561;
computer.instruction_memory[2]=2433810432;
computer.instruction_memory[3]=2433810432;
computer.instruction_memory[4]=2433810432;
computer.instruction_memory[5]=2433810432;
computer.instruction_memory[6]=3523215364;
computer.instruction_memory[7]=1109393408;
computer.instruction_memory[8]=1646460928;
computer.instruction_memory[9]=4026597369;
computer.instruction_memory[10]=2433810432;
computer.instruction_memory[11]=2433810432;
computer.instruction_memory[12]=2433810432;
computer.instruction_memory[13]=2433810432;
computer.instruction_memory[14]=553648131;
computer.instruction_memory[15]=2433810432;
computer.instruction_memory[16]=2433810432;
computer.instruction_memory[17]=2433810432;
computer.instruction_memory[18]=2433810432;
computer.instruction_memory[19]=2433810432;
computer.instruction_memory[20]=823132162;
computer.instruction_memory[21]=0;
*/

module test_memory;
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
  computer.instruction_memory[0]=570425352;
  computer.instruction_memory[1]=587202561;
  computer.instruction_memory[2]=2433810432;
  computer.instruction_memory[3]=2433810432;
  computer.instruction_memory[4]=2433810432;
  computer.instruction_memory[5]=2433810432;
  computer.instruction_memory[6]=3523215364;
  computer.instruction_memory[7]=1109393408;
  computer.instruction_memory[8]=1646460928;
  computer.instruction_memory[9]=4026597369;
  computer.instruction_memory[10]=2433810432;
  computer.instruction_memory[11]=2433810432;
  computer.instruction_memory[12]=2433810432;
  computer.instruction_memory[13]=2433810432;
  computer.instruction_memory[14]=553648131;
  computer.instruction_memory[15]=2433810432;
  computer.instruction_memory[16]=2433810432;
  computer.instruction_memory[17]=2433810432;
  computer.instruction_memory[18]=2433810432;
  computer.instruction_memory[19]=2433810432;
  computer.instruction_memory[20]=823132162;
  computer.instruction_memory[21]=0;

end

initial
begin
  $dumpfile("test_memory.vcd");
  $dumpvars(0, test_memory);
end

initial
begin
  $monitor("PC = %2d, mem[1] = %2d, mem[2] = %2d, mem[3] = %2d, mem[4] = %2d, mem[5] = %2d, mem[6] = %2d, mem[7] = %2d, mem[8] = %2d. Fetch test: mem[5] = %2d.", 
    computer.if_pc, computer.data_memory[1], computer.data_memory[2],  computer.data_memory[3], computer.data_memory[4],
    computer.data_memory[5], computer.data_memory[6], computer.data_memory[7], computer.data_memory[8], computer.register_bank[1]);
  #2000 $finish;
end

endmodule
