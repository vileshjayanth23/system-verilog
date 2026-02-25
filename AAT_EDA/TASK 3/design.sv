//------------------------------------------------------------------------------
//File       : design.sv
//Author     : VILESH JAYANTH MA (1BM23EC292)
//Module     : atm_controller
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: FSM-based ATM controller with security checks.
//------------------------------------------------------------------------------

module atm_controller (
    input  logic clk,
    input  logic rst,
    input  logic card_inserted,
    input  logic pin_correct,
    input  logic balance_ok,
    output logic dispense_cash
);

    typedef enum logic [1:0] {
        IDLE,
        CHECK_PIN,
        CHECK_BAL,
        DISPENSE
    } state_t;

    state_t state, next;

    // State register
    always_ff @(posedge clk)
        if (rst)
            state <= IDLE;
        else
            state <= next;

    // Next-state logic
    always_comb begin
        next = state;
        dispense_cash = 1'b0;

        case (state)
            IDLE: begin
                if (card_inserted)
                    next = CHECK_PIN;
            end

            CHECK_PIN: begin
                if (pin_correct)
                    next = CHECK_BAL;
                else
                    next = IDLE;
            end

            CHECK_BAL: begin
                if (balance_ok)
                    next = DISPENSE;
                else
                    next = IDLE;
            end

            DISPENSE: begin
                dispense_cash = 1'b1;
                next = IDLE;
            end
        endcase
    end

endmodule
