// -----------------------------------------------------------------------------
// File        : fifo.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : siso
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
// Description : Testbench for validating FIFO functionality 					 using coverage-driven verification.
// ----------------------------------------------------------------------------- 
interface fifo_if(input clk);
  logic wr, rd, full , empty; logic [7:0] din;
endinterface

module tb;
  bit clk=0; always #5 clk=~clk;
  fifo_if vif(clk);
  fifo dut(.clk(clk), .wr(vif .wr), .rd(vif .rd),
           .din(vif .din), . full(vif . full),
           .empty(vif.empty));
  covergroup cg_fifo @(posedge clk);
    cross_wr_full : cross vif.wr, vif.full ;
  endgroup
  cg_fifo cg=new();
  initial begin
  $dumpfile("dump.vcd");
  $dumpvars;

  vif.wr = 1;
  vif.rd = 0;
  repeat(20) @(posedge clk);

  vif.wr = 0;
  repeat(5) @(posedge clk);

  vif.rd = 1;
  repeat(20) @(posedge clk);

  vif.rd = 0;

  $display("Coverage: %0.2f %% ", cg.get_inst_coverage());
  $finish;
end
endmodule
