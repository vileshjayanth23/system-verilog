// -----------------------------------------------------------------------------
// File        : counter_4bit.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : counter
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
//
// Description : 4-bit counter with reset functionality that increments on each
//               clock edge and returns to zero when reset is asserted.
// ----------------------------------------------------------------------------- 
module counter(input clk, rst , output logic [3:0] count);
  always_ff @(posedge clk)
    if(rst) count<= 0; else count<=count + 1;
endmodule
