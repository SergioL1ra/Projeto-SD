`timescale 1ns / 1ps

module shift_left2_tb;

    reg [31:0] in;
    wire [31:0] out;

    shift_left2 uut (
        .in(in),
        .out(out)
    );

    initial begin
        in = 32'h0000_0001;
        #10 $display("in=%h, out=%h", in, out);

        in = 32'h0000_0003;
        #10 $display("in=%h, out=%h", in, out);

        #10 $finish;
    end

endmodule