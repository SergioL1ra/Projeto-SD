module reg_file (
    input clk,
    input reg_write,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);
  reg [31:0] rf[31:0];
  
  always @(posedge clk)
    if (reg_write) rf[write_reg] <= write_data;
  
  assign read_data1 = (read_data1 != 0) ? rf[read_data1] : 0;
  assign read_data2 = (read_data2 != 0) ? rf[read_data2] : 0;
endmodule
