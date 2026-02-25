//------------------------------------------------------------------------------
//File       : design.sv
//Author     : VILESH JAYANTH MA (1BM23EC292)
//Module     : digital_clock
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Digital clock with seconds and minutes counters (0–59).
//------------------------------------------------------------------------------

module digital_clock (
    input  logic clk,
    input  logic rst,
    output logic [5:0] sec,
    output logic [5:0] min
);

    always_ff @(posedge clk) begin
        if (rst) begin
            sec <= 6'd0;
            min <= 6'd0;
        end
        else if (sec == 6'd59) begin
            sec <= 6'd0;
            if (min == 6'd59)
                min <= 6'd0;
            else
                min <= min + 1'b1;
        end
        else begin
            sec <= sec + 1'b1;
        end
    end

endmodule
