`timescale 1ns/1ps
module tb_cpu;
    reg clk = 0;
    reg reset;

    cpu uut (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/dump_cpu.vcd");
        $dumpvars(0, tb_cpu);

        reset = 1; #10;
        reset = 0;

        #100; // Roda alguns ciclos
        $finish;
    end
endmodule
