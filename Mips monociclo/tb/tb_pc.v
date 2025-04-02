`timescale 1ns/1ps
module tb_pc;

    reg clk = 0;
    reg reset;
    reg [31:0] pc_in;
    wire [31:0] pc_out;

    // Instanciar o módulo pc
    pc uut (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    // Clock gerado automaticamente
    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/dump.vcd");  // Arquivo de onda
        $dumpvars(0, tb_pc);        // Sinais a observar

        reset = 1; pc_in = 32'd0;
        #10 reset = 0; pc_in = 32'd4;
        #10 pc_in = 32'd8;
        #10 pc_in = 32'd12;
        #10 $finish;
    end
endmodule
