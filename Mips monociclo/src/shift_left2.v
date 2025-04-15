module ShiftLeft(
    input [31:0] a,
  	output reg [31:0] y
);
  
  	always @(*) begin
		y = a << 2;
	end

endmodule