`timescale 1ns / 1ps

module data_mem_tb;

    // Inputs
    reg clk;
    reg mem_write;
    reg [31:0] alu_result;
    reg [31:0] write_data;

    // Outputs
    wire [31:0] read_data;

    // Instantiate the Unit Under Test (UUT)
    data_mem uut (
        .clk(clk),
        .mem_write(mem_write),
        .alu_result(alu_result),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        mem_write = 0;
        alu_result = 0;
        write_data = 0;

        // Wait for global reset
        #10;

        // Test case 1: Write to memory
        mem_write = 1;
        alu_result = 32'h00000004; // Address 4
        write_data = 32'hDEADBEEF; // Data to write
        #10;

        // Test case 2: Read from memory
        mem_write = 0;
        alu_result = 32'h00000004; // Address 4
        #10;
        $display("Read Data: %h (expected DEADBEEF)", read_data);

        // Test case 3: Write to another address
        mem_write = 1;
        alu_result = 32'h00000008; // Address 8
        write_data = 32'hCAFEBABE; // Data to write
        #10;

        // Test case 4: Read from the new address
        mem_write = 0;
        alu_result = 32'h00000008; // Address 8
        #10;
        $display("Read Data: %h (expected CAFEBABE)", read_data);

        // Test case 5: Read from an unwritten address
        alu_result = 32'h0000000C; // Address 12
        #10;
        $display("Read Data: %h (expected 00000000)", read_data);

        // Finish simulation
        #10 $finish;
    end

endmodule