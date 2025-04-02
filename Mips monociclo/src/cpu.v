module cpu(input clk, input reset);
    // PC wires
    wire [31:0] pc_out, pc_in;

    // Instrução
    wire [31:0] instr;

    // Campos da instrução
    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd;
    wire [15:0] imm;
    wire [31:0] sign_ext_imm;

    // Registradores
    wire [31:0] read_data1, read_data2;
    wire [31:0] alu_src2;
    wire [31:0] alu_result;

    // Controle
    wire reg_write;
    wire [3:0] alu_control;
    wire alu_src;
    wire reg_dst;
    wire [1:0] alu_op;  // NOVO sinal de entrada para alu_control

    assign opcode = instr[31:26];
    assign rs     = instr[25:21];
    assign rt     = instr[20:16];
    assign rd     = instr[15:11];
    assign imm    = instr[15:0];
    assign funct  = instr[5:0];

    assign sign_ext_imm = {{16{imm[15]}}, imm};

    assign alu_src = (opcode != 6'b000000);              // I-type usa imediato
    assign reg_dst = (opcode == 6'b000000);              // R-type escreve em rd
    assign reg_write = 1'b1;                             // ainda fixo
    assign alu_op = (opcode == 6'b000000) ? 2'b10 :      // R-type
                    (opcode == 6'b000100) ? 2'b01 :      // beq
                    2'b00;                               // lw/sw/addi/etc.

    assign alu_src2 = alu_src ? sign_ext_imm : read_data2;
    wire [4:0] write_reg = reg_dst ? rd : rt;

    // PC
    pc pc0 (.clk(clk), .reset(reset), .pc_in(pc_in), .pc_out(pc_out));
    assign pc_in = pc_out + 4;

    // Memória de Instruções
    instr_mem imem (.addr(pc_out), .instr(instr));

    // Banco de Registradores
    reg_file regs (
        .clk(clk),
        .reg_write(reg_write),
        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(write_reg),
        .write_data(alu_result),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // ALU Control
    alu_control alu_ctrl (
        .alu_op(alu_op),
        .funct(funct),
        .alu_control(alu_control)
    );

    // ALU
    alu alu0 (
        .input1(read_data1),
        .input2(alu_src2),
        .alu_control(alu_control),
        .result(alu_result),
        .zero()
    );
endmodule
