// -----------------------------------------------------------------------------
// File        : alu.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : alu
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
//
// Description : ALU that executes arithmetic and logical operations based on
//               the selected opcode.
// ----------------------------------------------------------------------------- 
typedef enum bit [1:0] {ADD, SUB, AND, OR} opcode_e;
module alu(input logic [7:0] a, b, input opcode_e op, output
           logic[7:0] y);
  always_comb 
    begin
      case(op)
        ADD: y=a+b;
        SUB: y=a-b;
    	AND: y=a&b;
    	OR: y=a | b;
      endcase
    end
endmodule
