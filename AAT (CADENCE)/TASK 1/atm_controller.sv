// -----------------------------------------------------------------------------
// File        : atm_controller.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : atm_controller
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
// Description : ATM Controller FSM for validating transaction flow and cash
//               dispensing operation.
// ----------------------------------------------------------------------------- 
module atm_controller (
    input  logic clk, rst,
    input  logic card_inserted,
    input  logic pin_correct,
    input  logic balance_ok,
    output logic dispense_cash
);

  typedef enum logic [1:0] {IDLE, CHECK_PIN, CHECK_BAL, DISPENSE} state_t;
  state_t state, next_state;

  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      state <= IDLE;
    else
      state <= next_state;
  end

  always_comb begin
    dispense_cash = 0;
    next_state = state;

    case(state)
      IDLE      :  if(card_inserted) next_state = CHECK_PIN;
      CHECK_PIN :  if(pin_correct)   next_state = CHECK_BAL;
                   else              next_state = IDLE;
      CHECK_BAL :  if(balance_ok)    next_state = DISPENSE;
                   else              next_state = IDLE;
      DISPENSE  : begin
        dispense_cash = 1;
        next_state = IDLE;
      end
    endcase
  end

endmodule
