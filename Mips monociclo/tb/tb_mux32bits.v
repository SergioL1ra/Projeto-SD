`timescale 1ns / 1ps

module mux32bits_tb;

    reg [31:0] a, b;
    reg sel;
    wire [31:0] y;

    mux32bits uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin
        a = 32'hAAAA_AAAA; b = 32'h5555_5555; sel = 0;
        #10 $display("sel=0: y=%h", y);

        sel = 1;
        #10 $display("sel=1: y=%h", y);

        #10 $finish;
    end

endmodule