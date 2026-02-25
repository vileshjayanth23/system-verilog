// -----------------------------------------------------------------------------
// File        : dff_tb.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : tb
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
//
// Description : Testbench to validate D flip-flop operation using clocked input
//               stimuli.

// ----------------------------------------------------------------------------- 
class packet;
  rand bit d, rst;

  // Weighted distribution
  constraint c1 {
    rst dist {0 := 90, 1 := 10};
  }
endclass


module tb;
  logic clk = 0;
  logic rst, d, q;

  dff dut (.*);

  // Clock generation
  always #5 clk = ~clk;

  // Coverage
  covergroup cg @(posedge clk);
    cross_rst_d: cross rst , d;
  endgroup

  cg      c_inst = new();
  packet pkt    = new();

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    repeat (100) begin
      pkt.randomize();

      // Drive before clock edge
      rst<= pkt.rst;
      d  <= pkt.d;

      @(posedge clk);
    end

    $display("Coverage: %0.2f %%", c_inst.get_inst_coverage());
    $finish;
  end

endmodule
