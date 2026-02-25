//------------------------------------------------------------------------------
//File       : design.sv
//Author     : VILESH JAYANTH MA (1BM23EC292)
//Module     : alu
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Simple ALU supporting ADD, SUB, MUL, XOR using enum opcode.
//------------------------------------------------------------------------------

typedef enum logic [1:0] {ADD, SUB, MUL, XOR} opcode_e;

module alu (
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  opcode_e    op,
    output logic [15:0] y
);

    always_comb begin
        case (op)
            ADD: y = a + b;
            SUB: y = a - b;
            MUL: y = a * b;
            XOR: y = a ^ b;
            default: y = '0;
        endcase
    end

endmodule
