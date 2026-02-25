// -----------------------------------------------------------------------------
// File        : priority_encoder_tb.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : tb
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
//
// Description : Testbench to validate the functionality of a priority encoder
//               by checking output responses for different input conditions.
// -----------------------------------------------------------------------------
module tb;
  logic [3:0] in; logic [1:0] out; logic valid;
  priority_enc dut(.*);
  
  covergroup cg_enc;
    cp_in: coverpoint in {
      bins b0={1}; // 0001
      bins b1={2}; // 0010
      bins b2={4}; // 0100
      bins b3={8}; // 1000
      bins others =default;
    }
  endgroup
  cg_enc cg=new();
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    repeat(50) begin
      in=$urandom_range(0, 15);
      #5; cg.sample();
    end
    $display( "Coverage: %0.2f %%", cg.get_inst_coverage());
  end
endmodule
