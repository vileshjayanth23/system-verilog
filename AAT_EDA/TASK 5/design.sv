//------------------------------------------------------------------------------
//File       : design.sv
//Author     : VILESH JAYANTH MA (1BM23EC292)
//Module     : dual_port_ram
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Dual-port RAM (Port A: Write, Port B: Read).
//------------------------------------------------------------------------------

module dual_port_ram #(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 8
)(
    input  logic                     clk,

    // Port A (Write)
    input  logic                     we_a,
    input  logic [ADDR_WIDTH-1:0]    addr_a,
    input  logic [DATA_WIDTH-1:0]    wdata_a,

    // Port B (Read)
    input  logic [ADDR_WIDTH-1:0]    addr_b,
    output logic [DATA_WIDTH-1:0]    rdata_b
);

    logic [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    // Write logic
    always_ff @(posedge clk) begin
        if (we_a)
            mem[addr_a] <= wdata_a;
    end

    // Combinational read
    assign rdata_b = mem[addr_b];

endmodule
