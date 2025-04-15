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