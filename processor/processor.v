module processor(clock1, clock2);
  // 2-phase clocks:
  // - for controlled operations in each pipeline stage
  // With a single clock activating all stages at once, the successive
  // pipeline stages can work incorrectly if the input for one stage doesn't
  // arrive in time from the previous stage.
  // With 2-phase clocks each adjacent stages will be activated alternately
  // avoid this scenerio
  input clock1, clock2;

  reg [31:0] register_bank [0:15];
  reg [31:0] instruction_memory [0:1023];
  reg [31:0] data_memory [0:1023];

  // opcodes
  parameter 
    HLT = 4'b0000,
    MOV = 4'b0001,
    MVI = 4'b0010,
    LOD = 4'b0011,
    STR = 4'b0100,
    ADD = 4'b0101,
    SUB = 4'b0110,
    MUL = 4'b0111,
    AND = 4'b1000,
    ORR = 4'b1001,
    NOT = 4'b1010,
    LES = 4'b1011,
    GTR = 4'b1100,
    JEZ = 4'b1101,
    JNZ = 4'b1110,
    JMP = 4'b1111;

    

  // ----- instruction fetch stage (if) -----
  
  // states
  reg [31:0] if_pc, if_ir;
  reg if_halted, if_branch_taken, if_branched_pc;
  reg if_next_pc, if_next_branch_taken;
  
  always @ (posedge clock1) 
    if (if_halted != 0)
    begin
      if_pc = if_next_pc;
      if_branch_taken = if_next_branch_taken;
      if (if_branch_taken == 1)
      begin
        if_pc = if_branched_pc;
        if_ir = instruction_memory[if_pc];
        if_next_branch_taken = 0;
        if_next_pc = if_pc + 1;
      end
      else 
      begin
        if_ir = instruction_memory[if_pc];
        if_next_pc = if_pc + 1;
      end
    end



  // ----- instruction decode stage (id) -----

  // states
  reg [3:0] id_opcode;
  reg [15:0] id_immediate; 
  reg [31:0] id_pc, id_rdest, id_ra, id_rb;
  reg id_invalid; // due to branch jump or program being halted, the instruction in this stage of pipeline can be invalid

  always @ (posedge clock2)
  begin 
    // instruction decoding
    id_opcode <= if_ir[31:28];
    id_immediate <= if_ir[15:0];
    id_rdest <= register_bank[if_ir[27:24]]; // register prefetching
    id_ra <= register_bank[if_ir[23:20]];
    id_rb <= register_bank[if_ir[19:16]];

    id_pc <= if_pc;
    id_invalid <= (if_branch_taken | if_halted) ? 1: 0;
  end




  // ----- execute stage: ALU and branch instruction execution (EX) -----

  // states
  reg [31:0] ex_alu_result;
  reg ex_invalid;


  always @ (posedge clock1) 
  begin

  end

endmodule

