`timescale 1ns/1ps
module tb_cpu;
    reg clk = 0;
    reg reset;

    // Instância da CPU
    cpu uut (.clk(clk), .reset(reset));

    // Clock com período de 10ns
    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/dump_cpu.vcd");
        $dumpvars(0, tb_cpu);

        // Reset inicial
        reset = 1;
        #10;
        reset = 0;

        // Espera a execução de todas as instruções (~8 instruções × 10ns/ciclo)
        #100;

        $display("\n====== VERIFICAÇÃO DOS REGISTRADORES E MEMÓRIA ======");

        $display("$t0 = %d (esperado 5)",  uut.regs.registers[8]);
        $display("$t1 = %d (esperado 10)", uut.regs.registers[9]);
        $display("$t2 = %d (esperado 5)",  uut.regs.registers[10]);
        $display("$t3 = %d (esperado 1)",  uut.regs.registers[11]);
        $display("$t4 = %d (esperado 20)", uut.regs.registers[12]);
        $display("$t5 = %d (esperado 5)",  uut.regs.registers[13]);
        $display("Mem[0] = %d (esperado 5)", uut.dmem.memory[0]);

        $finish;
    end
endmodule
