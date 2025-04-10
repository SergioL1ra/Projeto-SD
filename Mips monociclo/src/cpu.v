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

module ProgramCounter(
    input clk,
    input reset,
  	input [31:0] pc_in,
    output wire [31:0] pc_out
);
  	reg [31:0] data;
  
    always @(posedge clk or posedge reset) begin
        if (reset)
            data <= 0;
        else
            data <= pc_in; 
    end
  
  	assign pc_out = data;
  
endmodule

module InstructionMemory(
	input [31:0] PC, 
  	output reg[31:0] instruction
);

  reg[31:0] memory[0:63];

  initial begin
    $readmemb("instructions.txt", memory, 0, 5);
  end

  always @(*) begin
      instruction = memory[PC >> 2];
  end
  
endmodule

module ControlUnit(
  	input [5:0] op, funct,
    input zero,
    output mem_to_reg, mem_write, branch, pc_src, alu_src, reg_dst, reg_write, jump,
  	output [3:0] alu_control
);

  	wire [1:0] alu_op;
  
    MainDecoder md(
        .op(op),
      	.mem_to_reg(mem_to_reg),
      	.mem_write(mem_write),
        .branch(branch),
      	.alu_src(alu_src),
      	.reg_dst(reg_dst),
      	.reg_write(reg_write),
        .jump(jump),
      	.alu_op(alu_op)
    );

    AluDecoder ad(
        .funct(funct),
      	.alu_op(alu_op),
      	.alu_control(alu_control)
    );

    assign pc_src = branch & zero;

endmodule

module MainDecoder(
    input [5:0] op,
  	output reg mem_to_reg, mem_write, alu_src, reg_dst, reg_write, jump, branch,
    output reg[1:0] alu_op
);

    always @(*) begin    
        case(op)       
            6'b000000: begin // R-type
                reg_write = 1;
                reg_dst = 1;
                alu_src = 0;
                branch = 0;
                mem_write = 0;
                mem_to_reg = 0;
                jump = 0;
                alu_op = 2'b10;
            end
            6'b001000: begin // addi 
                reg_write = 1;
                reg_dst = 0;
                alu_src = 1;
                branch = 0;
                mem_write = 0;
                mem_to_reg = 0;
                jump = 0;
                alu_op = 2'b00;
            end
            6'b000100: begin // beq 
                reg_write = 0;
                reg_dst = 0;
                alu_src = 0;
                branch = 1;
                mem_write = 0;
                mem_to_reg = 0;
                jump = 0;
                alu_op = 2'b01;
            end
            6'b000010: begin // jump 
                reg_write = 0;
                reg_dst = 0;
                alu_src = 0;
                branch = 0;
                mem_write = 0;
                mem_to_reg = 0;
                jump = 1;
                alu_op = 2'b00;
            end
            6'b100011: begin // lw 
                reg_write = 1;
                reg_dst = 0;
                alu_src = 1;
                branch = 0;
                mem_write = 0;
                mem_to_reg = 1;
                jump = 0;
                alu_op = 2'b00;
            end
            6'b101011: begin // sw 
                reg_write = 0;
                reg_dst = 0;
                alu_src = 1;
                branch = 0;
                mem_write = 1;
                mem_to_reg = 0;
                jump = 0;
                alu_op = 2'b00;
            end
            default: begin
                reg_write = 1'bx;
                reg_dst = 1'bx;
                alu_src = 1'bx;
                branch = 1'bx;
                mem_write = 1'bx;
                mem_to_reg = 1'bx;
                jump = 1'bx;
                alu_op = 2'bxx;
            end   
        endcase      
    end
endmodule

module AluDecoder(
    input [5:0] funct,
  	input [1:0] alu_op,
  	output reg [3:0] alu_control
);

    always @(*) begin
      	case (alu_op)
            2'b00: alu_control = 3'b010; // add
            2'b01: alu_control = 3'b110; // sub
            2'b10: begin // R-type
                case (funct) 
                    6'b100000: alu_control = 3'b010; // ADD
                    6'b100010: alu_control = 3'b110; // SUB
                    6'b101010: alu_control = 3'b111; // SLT
                    6'b011010: alu_control = 3'b101; // DIV
                    6'b100100: alu_control = 3'b000; // AND
                    6'b100101: alu_control = 3'b001; // OR
                    default: alu_control = 3'bxxx;
                endcase
            end
            default: alu_control = 3'b000;
        endcase
    end
endmodule

module RegisterFile(
  	input clk,
    input we3,
  	input [4:0] ra1, ra2, wa3,
  	input [31:0] wd3,
  	output reg [31:0] rd1, rd2
);

    reg [31:0] rf[31:0];
	
    initial begin
        integer i;
        for (i = 0; i < 32; i = i + 1) begin
           rf[i] = 32'b0;
        end
    end
  
    always @(posedge clk) begin
      if (we3) begin
        rf[wa3] <= wd3;
      end
    end
	
  	always @(*) begin
        rd1 = rf[ra1];
        rd2 = rf[ra2];
    end
  
endmodule

module ALU(
  	input [31:0] input1, input2,
  	input [3:0] alu_control,
  	output reg [31:0] alu_result,
    output zero
);
    always @(*) begin
      	case (alu_control)
            4'b0010: alu_result = input1 + input2; // add
            4'b0110: alu_result = input1 - input2; // sub
            4'b0000: alu_result = input1 & input2; // and
            4'b0001: alu_result = input1 | input2; // or
            4'b0111: alu_result = (input1 > input2) ? 1 : 0; // slt
            4'b0101: alu_result = input1 / input2; // div
            default: alu_result = 0;
        endcase
    end

  	assign zero = (alu_result == 0);
  
endmodule

module DataMemory(
    input clk,
    input we,
  	input [31:0] address,
  	input [31:0] write_data,
  	output reg [31:0] read_data
);

  	reg [31:0] memory[63:0];

    initial begin
        integer i;
        for (i = 0; i < 64; i = i + 1) begin
            memory[i] = 32'b0;
        end
    end

    always @(*) begin
      	read_data = memory[address[5:0]];
    end

    always @(posedge clk) begin
      	if (we) begin
            $display("ADDRESS: %h, VALUE: %d", address[5:0], write_data);
        	memory[address[5:0]] <= write_data;
      	end
    end

endmodule

module SignExtend(
    input [15:0] a,
    output reg [31:0] y
);
  
    assign y = {{16{a[15]}}, a};
  
endmodule

module ShiftLeft(
    input [31:0] a,
  	output reg [31:0] y
);
  
  	always @(*) begin
		y = a << 2;
	end

endmodule

module Adder(
  	input [31:0] a, b,
    output [31:0] y
);
  
    assign y = a + b;
  
endmodule

module Multiplexer5(
  	input [4:0] in0, in1,
    input sel,
    output [4:0] out
);
  
    assign out = sel ? in1 : in0;
  
endmodule

module Multiplexer32(
  	input [31:0] in0, in1,
    input sel,
    output [31:0] out
);
  
    assign out = sel ? in1 : in0;
  
endmodule