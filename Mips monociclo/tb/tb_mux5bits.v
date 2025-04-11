`timescale 1ns / 1ps

module mux5bits_tb;

    reg [4:0] a, b;
    reg sel;
    wire [4:0] y;

    mux5bits uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin
        a = 5'b00001; b = 5'b00010; sel = 0;
        #10 $display("sel=0: y=%b", y);

        sel = 1;
        #10 $display("sel=1: y=%b", y);

        #10 $finish;
    end

endmodule