// -----------------------------------------------------------------------------
// File        : counter_4bit_tb.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : tb
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
// Description : Testbench to validate 4-bit counter operation using clock and
//               reset stimulus.
// ----------------------------------------------------------------------------- 
module tb;

  logic clk = 0;
  logic rst;
  logic [3:0] count;

  counter dut (.*);

  always #5 clk = ~clk;

  covergroup cg_count @(posedge clk);
    cp_val : coverpoint count {
      bins zero = {0};
      bins max  = {15};
      bins roll = (15 => 0) ;
    }
  endgroup

  cg_count cg = new();

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    rst = 1;
    #20;
    rst = 0;

    repeat (40) @(posedge clk);

    $display("Coverage: %0.2f %%", cg.get_inst_coverage());


    $finish;
  end

endmodule
