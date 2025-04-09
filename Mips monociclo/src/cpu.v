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
    wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, jump;
    wire [1:0] alu_op;
    wire [3:0] alu_control;

    // Memória de Dados
    wire [31:0] mem_data;
    wire [31:0] write_data;

    assign opcode = instr[31:26];
    assign rs     = instr[25:21];
    assign rt     = instr[20:16];
    assign rd     = instr[15:11];
    assign imm    = instr[15:0];
    assign funct  = instr[5:0];

    assign sign_ext_imm = {{16{imm[15]}}, imm};

    assign alu_src2 = alu_src ? sign_ext_imm : read_data2;
    wire [4:0] write_reg = reg_dst ? rd : rt;

    // PC
    pc pc0 (.clk(clk), .reset(reset), .pc_in(pc_in), .pc_out(pc_out));

    // Calculo do endereço de branch
    wire [31:0] branch_addr = pc_out + 4 + (sign_ext_imm << 2);

    // Lógica de branch
    wire branch_taken = branch & alu_result[0]; // `alu_result[0]` indica igualdade (zero)

    // Lógica de jump
    wire [31:0] jump_addr = {pc_out[31:28], instr[25:0], 2'b00};

    // Mux final para pc_in
    assign pc_in = jump ? jump_addr : (branch_taken ? branch_addr : (pc_out + 4));

    // Memória de Instruções
    instr_mem imem (.addr(pc_out), .instr(instr));

    // Banco de Registradores
    reg_file regs (
        .clk(clk),
        .reg_write(reg_write),
        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Unidade de Controle
    control control_unit (
        .opcode(opcode),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
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

    // Memória de Dados
    data_mem dmem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(alu_result),
        .write_data(read_data2),
        .read_data(mem_data)
    );

    // Mux final para selecionar entre alu_result e mem_data
    assign write_data = mem_to_reg ? mem_data : alu_result;
endmodule