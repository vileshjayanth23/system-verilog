//------------------------------------------------------------------------------
//File       : testbench.sv
//Author     : VILESH JAYANTH MA (1BM23EC292)
//Module     : tb
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Assertion + coverage based verification of ATM controller FSM.
//------------------------------------------------------------------------------

module tb;

    logic clk = 0;
    logic rst;
    logic card_inserted, pin_correct, balance_ok;
    logic dispense_cash;

    atm_controller dut (.*);

    // Clock
    always #5 clk = ~clk;

    // -------------------------------------------------
    // ENUM MIRROR FOR COVERAGE & ASSERTIONS
    // -------------------------------------------------
    localparam logic [1:0]
        IDLE      = 2'd0,
        CHECK_PIN = 2'd1,
        CHECK_BAL = 2'd2,
        DISPENSE  = 2'd3;

    // -------------------------------------------------
    // COVERAGE
    // -------------------------------------------------
    covergroup cg_atm @(posedge clk);

        // State coverage
        cp_state : coverpoint dut.state {
            bins idle      = {IDLE};
            bins check_pin = {CHECK_PIN};
            bins check_bal = {CHECK_BAL};
            bins dispense  = {DISPENSE};
        }

        // Transition coverage (FSM path)
        cp_trans : coverpoint dut.state {
            bins idle_to_pin  = (IDLE      => CHECK_PIN);
            bins pin_to_bal   = (CHECK_PIN => CHECK_BAL);
            bins bal_to_disp  = (CHECK_BAL => DISPENSE);
            bins disp_to_idle = (DISPENSE  => IDLE);
        }

    endgroup

    cg_atm cg = new();

    // -------------------------------------------------
    // ASSERTIONS
    // -------------------------------------------------

    // Cash dispensed ONLY if pin_correct AND balance_ok
    property dispense_only_if_authorized;
        @(posedge clk)
        dispense_cash |-> (pin_correct && balance_ok);
    endproperty

    assert_dispense_auth:
        assert property (dispense_only_if_authorized)
        else $error("Cash dispensed without authorization!");

    // FSM must return to IDLE after DISPENSE
    property return_to_idle_after_dispense;
        @(posedge clk)
        (dut.state == DISPENSE) |=> (dut.state == IDLE);
    endproperty

    assert_return_idle:
        assert property (return_to_idle_after_dispense)
        else $error("FSM did not return to IDLE!");

    // -------------------------------------------------
    // STIMULUS (DIRECTED → 100% COVERAGE)
    // -------------------------------------------------
    initial begin
        // Dump
        $dumpfile("atm_controller.vcd");
        $dumpvars(0, tb);

        // Reset
        rst = 1;
        card_inserted = 0;
        pin_correct   = 0;
        balance_ok    = 0;
        @(posedge clk);
        rst = 0;

        // ---- VALID TRANSACTION (hits all states) ----
        card_inserted = 1;                // IDLE → CHECK_PIN
        @(posedge clk);

        pin_correct = 1;                  // CHECK_PIN → CHECK_BAL
        @(posedge clk);

        balance_ok = 1;                   // CHECK_BAL → DISPENSE
        @(posedge clk);

        @(posedge clk);                   // DISPENSE → IDLE

        // ---- INVALID PIN PATH ----
        card_inserted = 1;
        pin_correct   = 0;                // CHECK_PIN → IDLE
        @(posedge clk);

        // ---- INVALID BALANCE PATH ----
        card_inserted = 1;
        pin_correct   = 1;
        @(posedge clk);
        balance_ok    = 0;                // CHECK_BAL → IDLE
        @(posedge clk);

        // -------------------------------------------------
        // PRINT COVERAGE
        // -------------------------------------------------
        $display("ATM FSM Coverage: %.2f %%", cg.get_inst_coverage());

        $finish;
    end

endmodule
