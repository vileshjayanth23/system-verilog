// -----------------------------------------------------------------------------
// File        : dual_port_ram.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : dual_port_ram
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
// Description : Dual-port RAM allowing simultaneous write and 					 
//               read operations using separate addresses.
// ----------------------------------------------------------------------------- 
module dual_port_ram (
  input logic clk,
  input logic we,
  input logic [5:0] addr_a,
  input logic [7:0] data_a,
  input logic [5:0] addr_b,
  output logic [7:0] data_b
);

  logic [7:0] mem [0:63];

  always_ff @(posedge clk) begin
    if (we)
      mem[addr_a] <= data_a;
  end

  always_ff @(posedge clk)
    data_b <= mem[addr_b];

endmodule
