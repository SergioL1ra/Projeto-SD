module tb_mips;

  reg clk;
  reg reset;

  MIPS mp(
    .clk(clk),
    .reset(reset)
  );

  initial begin
    $dumpfile("sim/mips_tb.vcd");
    $dumpvars(0, tb_mips);

    clk = 0;
    reset = 1;
    #10 reset = 0;

    #100;
    $finish;
  end

  // Geração de clock
  always #5 clk = ~clk;

  // Monitoramento dos registradores em tempo real
  always @(posedge clk) begin
    $display("[%0t] t0 = %0d, t1 = %0d, t2 = %0d", $time,
             mp.rf.rf[8],  // $t0
             mp.rf.rf[9],  // $t1
             mp.rf.rf[10]  // $t2
    );
  end

endmodule
