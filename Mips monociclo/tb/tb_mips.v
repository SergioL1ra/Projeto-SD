module TB_MIPS;
	
  // Signals
  reg clk;
  reg reset;
  
  MIPS mp(
    .clk(clk),
    .reset(reset)
  );
  
  // Clock
  always #5 clk = ~clk;

  initial begin
      $dumpfile("sim/mips_tb.vcd");
      $dumpvars(0, TB_MIPS);
      // Initialize signals
      clk = 0;
      reset = 1;
      #10 reset = 0;

	    #200;
      #10 $finish;
  end
endmodule