//------------------------------------------------------------------------------
// File       : atm_controller_tb.sv
// Author     : VILESH JAYANTH MA (1BM23EC292)
// Module     : tb
// Project    : SystemVerilog and Verification (23EC6PE2SV)
//              Faculty    : Prof. Ajaykumar Devarapalli
// Description: ATM Controller verification with coverage and 					
//              assertions
//------------------------------------------------------------------------------
module tb;

  logic clk = 0;
  logic rst;
  logic card_inserted;
  logic pin_correct;
  logic balance_ok;
  logic dispense_cash;

  atm_controller dut (.*);

  always #5 clk = ~clk;

  covergroup cg_atm @(posedge clk);

    cp_state : coverpoint dut.state {
      bins idle = {0};
      bins pin  = {1};
      bins bal  = {2};
      bins disp = {3};
    }

    cp_disp : coverpoint dispense_cash {
      bins no  = {0};
      bins yes = {1};
    }

  endgroup

  cg_atm cg = new();

  initial begin
    $dumpfile("atm_dump.vcd");
    $dumpvars(0, tb);

    rst = 1;
    card_inserted = 0;
    pin_correct = 0;
    balance_ok = 0;

    repeat(2) @(posedge clk);
    rst = 0;

    // ===== SUCCESS TRANSACTION =====

    card_inserted = 1;
    @(posedge clk);      // IDLE -> CHECK_PIN

    pin_correct = 1;
    @(posedge clk);      // CHECK_PIN -> CHECK_BAL

    balance_ok = 1;
    @(posedge clk);      // CHECK_BAL -> DISPENSE

    @(posedge clk);      // DISPENSE -> IDLE

    card_inserted = 0;
    pin_correct = 0;
    balance_ok = 0;

    // ===== WRONG PIN =====

    @(posedge clk);
    card_inserted = 1;

    @(posedge clk);      // go to CHECK_PIN
    pin_correct = 0;

    @(posedge clk);      // back to IDLE

    card_inserted = 0;

    // ===== LOW BALANCE =====

    @(posedge clk);
    card_inserted = 1;

    @(posedge clk);
    pin_correct = 1;

    @(posedge clk);      // CHECK_BAL
    balance_ok = 0;

    @(posedge clk);      // back to IDLE

    // extra clocks for sampling
    repeat(4) @(posedge clk);

    $display("Coverage = %0.2f %%", cg.get_inst_coverage());

    $finish;
  end

endmodule
