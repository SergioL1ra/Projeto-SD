`timescale 1ns / 1ps

module sign_extend_tb;

    reg [15:0] in;
    wire [31:0] out;

    sign_extend uut (
        .in(in),
        .out(out)
    );

    initial begin
        in = 16'h0001;
        #10 $display("in=%h, out=%h", in, out);

        in = 16'h8000;
        #10 $display("in=%h, out=%h", in, out);

        #10 $finish;
    end

endmodule