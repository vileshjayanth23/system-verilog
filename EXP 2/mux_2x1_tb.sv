// -----------------------------------------------------------------------------
// File        : mux_2x1_tb.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : tb
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
//
// Description : Testbench to validate the operation of a 2x1 multiplexer by
//               testing different input and select conditions.
// -----------------------------------------------------------------------------
class Transaction;
  rand bit [7:0] a, b;
  rand bit s ;
endclass

module tb;
  logic [7:0] a, b, y;
  logic s ;
  mux_2x1 dut(.*);
  
  covergroup cg_mux;
    cp_s : coverpoint s ;
  endgroup
  
  cg_mux cg=new();
  Transaction tr =new();

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    repeat(20) begin
      assert(tr.randomize());
      a= tr.a; b= tr.b; s= tr.s ;
      #5; cg.sample();
      
      if(y !== (s ? b : a)) $error(" Mismatch!" ) ;
    end
    $display(" Coverage=%0.2f %%", cg.get_inst_coverage());
  end
endmodule
