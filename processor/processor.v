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

    

  // ----- instruction fetch (if) stage -----
  
  // states
  reg [31:0] if_pc, if_ir;
  reg if_halted, if_branch_taken, if_branched_pc;
  reg if_next_pc, if_next_branch_taken;
  
  always @ (posedge clock1) 
  begin
    // if and ex stages are activated by the same clock 
    // so waiting some time to let the branch and halted signals from ex
    // stage come in
    #2;
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
  end



  // ----- instruction decode (id) stage -----

  // states
  reg [3:0] id_opcode, id_rdest, id_ra, id_rb;
  reg [15:0] id_immediate; 
  reg [31:0] id_pc, id_rdest_val, id_ra_val, id_rb_val;
  reg id_invalid; // due to branch jump or program being halted, the instruction in this stage of pipeline can be invalid

  always @ (posedge clock2)
  begin 
    // instruction decoding
    id_opcode <= if_ir[31:28];
    id_immediate <= if_ir[15:0];
    id_rdest <= if_ir[27:24];
    id_ra <= if_ir[23:20];
    id_rb <= if_ir[19:16];
    id_rdest_val <= register_bank[if_ir[27:24]]; // register prefetching
    id_ra_val <= register_bank[if_ir[23:20]];
    id_rb_val <= register_bank[if_ir[19:16]];

    id_pc <= if_pc;
    id_invalid <= (if_branch_taken | if_halted) ? 1: 0;
  end




  // ----- execute (ex) stage: ALU and branch instruction execution -----

  // states
  reg [3:0] ex_opcode, ex_rdest, ex_ra, ex_rb;
  reg [31:0] ex_alu_result, ex_pc, ex_rdest_val, ex_ra_val, ex_rb_val;
  reg [15:0] ex_immediate;
  reg ex_invalid, ex_has_result;


  always @ (posedge clock1) 
  begin
    if (id_invalid == 0) 
    begin
      ex_invalid <= 0;
      ex_pc <= id_pc;
      ex_rdest <= id_rdest;
      ex_ra <= id_ra;
      ex_rb <= id_rb;
      ex_rdest_val <= id_rdest_val;
      ex_ra_val <= id_ra_val;
      ex_rb_val <= id_rb_val;
      ex_immediate <= id_immediate;
      case (id_opcode)
        ADD: begin ex_has_result <= 1; ex_alu_result <= id_ra_val + id_rb_val; end
        SUB: begin ex_has_result <= 1; ex_alu_result <= id_ra_val - id_rb_val; end
        MUL: begin ex_has_result <= 1; ex_alu_result <= id_ra_val * id_rb_val; end
        AND: begin ex_has_result <= 1; ex_alu_result <= id_ra_val & id_rb_val; end
        ORR: begin ex_has_result <= 1; ex_alu_result <= id_ra_val | id_rb_val; end
        NOT: begin ex_has_result <= 1; ex_alu_result <= ~id_ra_val; end
        LES: begin ex_has_result <= 1; ex_alu_result <= (id_ra_val < id_rb_val) ? 1 : 0; end
        GTR: begin ex_has_result <= 1; ex_alu_result <= (id_ra_val > id_rb_val) ? 1 : 0; end
        JEZ: begin
          ex_has_result <= 0;
          if (id_ra_val == 0) begin
            if_next_branch_taken <= 1;
            if_next_pc <= id_pc + id_immediate; // pc = pc + offset
          end
        end
        JNZ: begin
          ex_has_result <= 0;
          if (id_ra_val != 0) begin
            if_next_branch_taken <= 1;
            if_next_pc <= id_pc + id_immediate; // pc = pc + offset
          end
        end
        JMP: begin
          ex_has_result <= 0;
          begin
            if_next_branch_taken <= 1;
            if_next_pc <= id_pc + id_immediate; // pc = pc + offset
          end
        end
        HLT: begin ex_has_result <= 0; if_halted <= 1; end
      endcase
    end
    else ex_invalid <= 1;
  end



  // ----- memory access (ma) stage: memory store and load instruction execution -----

  // states
  reg [3:0] ma_opcode, ma_rdest, ma_ra, ma_rb;
  reg [31:0] ma_alu_result, ma_ra_val;
  reg [15:0] ma_immediate;
  reg ma_invalid, ma_has_result;
  
  always @ (posedge clock2)
  begin
    if (ex_invalid == 0)
    begin
      ma_invalid <= 0;
      ma_opcode <= ex_opcode;
      ma_rdest <= ex_rdest;
      ma_ra <= ex_ra;
      ma_rb <= ex_rb;
      ma_ra_val <= ex_ra_val;
      ma_immediate <= ex_immediate;
      ma_alu_result <= ex_alu_result;
      ma_has_result <= ex_has_result;
      case (ex_opcode)
        LOD: register_bank[ex_rdest] <= data_memory[ex_ra_val + ex_immediate];
        STR: data_memory[ex_ra_val + ex_immediate] <= register_bank[ex_rdest];
      endcase
    end
    else ma_invalid <= 1;
  end



  // ----- write-back (wb) stage: register move instr. + ALU result writeback

  always @ (posedge clock1)
  begin
    if (ma_invalid == 0)
    begin
      if (ma_has_result == 1) begin 
        register_bank[ma_rdest] <= ma_alu_result;
      end
      case (ma_opcode)
        MOV: register_bank[ma_rdest] <= ma_ra_val;
        MVI: register_bank[ma_rdest] <= ma_immediate;
      endcase
    end
  end


endmodule

