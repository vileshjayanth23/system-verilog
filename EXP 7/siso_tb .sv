// -----------------------------------------------------------------------------
// File        : siso.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : siso
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
// Description :  Testbench to validate SISO shift register operation.
// ----------------------------------------------------------------------------- 
module tb;
  logic clk=0, si , so;
  siso dut(.*) ;
  always #5 clk = ~clk ;
  logic [3:0] q_ref ;
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    repeat (20) begin
      si = $urandom() ;
      q_ref = {q_ref [2:0] , si };
      @(posedge clk) ; #1;
    end
    $finish ;
  end
endmodule
