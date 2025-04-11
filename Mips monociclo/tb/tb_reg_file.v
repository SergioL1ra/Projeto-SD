`timescale 1ns / 1ps

module reg_file_tb;

    reg clk, we;
    reg [4:0] ra1, ra2, wa;
    reg [31:0] wd;
    wire [31:0] rd1, rd2;

    reg_file uut (
        .clk(clk),
        .we(we),
        .ra1(ra1),
        .ra2(ra2),
        .wa(wa),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    initial begin
        clk = 0; we = 0; ra1 = 0; ra2 = 0; wa = 0; wd = 0;

        // Write to register
        we = 1; wa = 5'b00001; wd = 32'hDEAD_BEEF;
        #10 we = 0;

        // Read from register
        ra1 = 5'b00001;
        #10 $display("rd1=%h", rd1);

        #10 $finish;
    end

    always #5 clk = ~clk;

endmodule