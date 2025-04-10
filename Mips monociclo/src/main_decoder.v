module main_decoder(

    input reg [5:0] op,

    output reg memtoreg,
    output reg memwrite,
    output reg branch,
    output reg aluscr,
    output reg regdst,
    output reg regwrite,
    output reg jump,
    output reg [1:0] alu_op

);

    always @(*) 
    begin
        case(op)

            6'b000000: // R-type
            begin 

                regwrite = 1;
                regdst = 1;
                aluscr = 0;
                branch = 0;
                memwrite = 0;
                memtoreg = 0;
                jump = 0;
                alu_op = 2'b10;

            end
            6'b001000: // addi
            begin 

                regwrite = 1;
                regdst = 0;
                aluscr = 1;
                branch = 0;
                memwrite = 0;
                memtoreg = 0;
                jump = 0;
                alu_op = 2'b00;

            end
            6'b000100: // beq
            begin 

                regwrite = 0;
                regdst = 0;
                aluscr = 0;
                branch = 1;
                memwrite = 0;
                memtoreg = 0;
                jump = 0;
                alu_op = 2'b01;

            end
            6'b000010: // jump
            begin 

                regwrite = 0;
                regdst = 0;
                aluscr = 0;
                branch = 0;
                memwrite = 0;
                memtoreg = 0;
                jump = 1;
                alu_op = 2'b00;

            end
            6'b100011: // lw
            begin 

                regwrite = 1;
                regdst = 0;
                aluscr = 1;
                branch = 0;
                memwrite = 0;
                memtoreg = 1;
                jump = 0;
                alu_op = 2'b00;

            end
            6'b101011: // sw
            begin 

                regwrite = 0;
                regdst = 0;
                aluscr = 1;
                branch = 0;
                memwrite = 1;
                memtoreg = 0;
                jump = 0;
                alu_op = 2'b00;

            end
            default: 
            begin

                regwrite = 1'bx;
                regdst = 1'bx;
                aluscr = 1'bx;
                branch = 1'bx;
                memwrite = 1'bx;
                memtoreg = 1'bx;
                jump = 1'bx;
                alu_op = 2'bxx;

            end

        endcase
    end

endmodule