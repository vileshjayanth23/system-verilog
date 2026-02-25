// -----------------------------------------------------------------------------
// File        : and_gate_tb.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : tb
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
//
// Description : Testbench to validate the operation of a 2-input AND gate by
//               testing all input conditions and checking the output response.
// -----------------------------------------------------------------------------
module tb;
  logic a, b, y;
  and_gate dut(.*); 
  
  covergroup cg_and;
    cp_a: coverpoint a;
    cp_b: coverpoint b;
    cross_ab: cross cp_a, cp_b; 
  endgroup

  cg_and cg = new(); 

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    repeat(20) begin
      a=$urandom_range(0,1); 
      b=$urandom_range(0,1);
      #5; 
      cg.sample(); 
    end
    $display(" Final Coverage=%0.2f %%", cg.get_inst_coverage());
  end
    
endmodule
