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

    always @(posedge clk) begin
        if (reg_write)
            rf[write_reg] <= write_data;
    end

    assign read_data1 = rf[read_reg1];
    assign read_data2 = rf[read_reg2];
endmodule
