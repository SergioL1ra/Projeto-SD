module MIPS(
  input clk,
  input reset
);

  // Program Counter
  wire [31:0] pc_in, pc_out;
  
  // Instruction Memory
  wire [31:0] instruction;
  
  // Control Unit
  wire branch, mem_to_reg, mem_write, pc_src, alu_src, reg_dst, reg_write, jump;
  wire [3:0] alu_control;
  
  // Register File
  wire [31:0] input1, write_data;
  
  // ALU
  wire zero;
  wire [31:0] alu_result;
  
  // Data Memory
  wire [31:0] read_data;
  
  // Sign Extend
  wire [31:0] sign_immediate;
  
  // Shift Left
  wire [31:0] branch_address;
  
  // Adder PC
  wire [31:0] pc_plus4;
  
  // Adder Branch
  wire [31:0] pc_branch;
  
  // Multiplexer PC Next
  wire [31:0] pc_next;
  
  // Multiplexer Write Reg
  wire [4:0] write_reg;
  
  // Multiplexer input2
  wire [31:0] input2;
  
  // Multiplexer Result
  wire [31:0] result;
  
  ProgramCounter pc(
    .clk(clk),
    .reset(reset),
    .pc_in(pc_next),
    .pc_out(pc_out)
  );

  InstructionMemory im(
    .PC(pc_out),
    .instruction(instruction)
  );

  ControlUnit cou(
    .op(instruction[31:26]),
    .funct(instruction[5:0]),
    .zero(zero),
    .branch(branch),
    .mem_to_reg(mem_to_reg),
    .mem_write(mem_write),
    .pc_src(pc_src),
    .alu_src(alu_src),
    .reg_dst(reg_dst),
    .reg_write(reg_write),
    .jump(jump),
    .alu_control(alu_control)
  );
  
  RegisterFile rf(
    .clk(clk),
    .we3(reg_write),
    .ra1(instruction[25:21]),
    .ra2(instruction[20:16]),
    .wa3(write_reg),
    .wd3(result),
    .rd1(input1),
    .rd2(write_data)
  );
  
  ALU alu(
    .input1(input1),
    .input2(input2),
    .alu_control(alu_control),
    .alu_result(alu_result),
    .zero(zero)
  );
  
  DataMemory dm(
    .clk(clk),
    .we(mem_write),
    .address(alu_result),
    .write_data(write_data),
    .read_data(read_data)
  );
  
  SignExtend se(
    .a(instruction[15:0]),
    .y(sign_immediate)
  );

  ShiftLeft sl(
    .a(sign_immediate),
    .y(branch_address)
  );
  
  Adder pa(
    .a(pc_out),
    .b(32'd4),
    .y(pc_plus4)
  );
  
  Adder ba(
    .a(branch_address),
    .b(pc_plus4),
    .y(pc_branch)
  );
  
  Multiplexer32 mc(
    .in0(pc_plus4), 
    .in1(pc_branch), 
    .sel(pc_src), 
    .out(pc_next)
  );

  Multiplexer5 mw(
    .in0(instruction[20:16]), 
    .in1(instruction[15:11]), 
    .sel(reg_dst), 
    .out(write_reg)
  );

  Multiplexer32 ms(
    .in0(write_data), 
    .in1(sign_immediate), 
    .sel(alu_src), 
    .out(input2)
  );  

  Multiplexer32 mr(
    .in0(alu_result), 
    .in1(read_data), 
    .sel(mem_to_reg), 
    .out(result)
  );

endmodule