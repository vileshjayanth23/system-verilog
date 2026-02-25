// -----------------------------------------------------------------------------
// File        : dual_port_ram_tb.sv
// Author      : VILESH JAYANTH MA (1BM23EC292)
// Module      : tb
// Project     : SystemVerilog and Verification (23EC6PE2SV),
//               Faculty: Prof. Ajaykumar Devarapalli
// Description : Testbench to verify dual-port RAM functionality 				  
//               using directed and random stimulus with 						 
//               coverage.
// ----------------------------------------------------------------------------- 
module tb;

  logic clk = 0;
  logic we;
  logic [5:0] addr_a, addr_b;
  logic [7:0] data_a;
  logic [7:0] data_b;

  dual_port_ram dut (.*);

  always #5 clk = ~clk;

  byte ref_mem [0:63];

  covergroup cg_ram @(posedge clk);

    cp_we : coverpoint we {
      bins write = {1};
      bins read  = {0};
    }

    cp_addr : coverpoint addr_a {
      bins all[] = {[0:63]};
    }

  endgroup

  cg_ram cg = new();

  initial begin
    $dumpfile("ram_dump.vcd");
    $dumpvars(0, tb);

    // ---------------- Directed (hit all addresses) ----------------

    for (int i=0; i<64; i++) begin

      we = 1;
      addr_a = i;
      data_a = i + 8'h10;
      addr_b = i;

      @(posedge clk);

      ref_mem[i] = data_a;

    end

    // ---------------- Random testing ----------------

    repeat(20) begin

      we = $urandom_range(0,1);
      addr_a = $urandom_range(0,63);
      addr_b = $urandom_range(0,63);
      data_a = $urandom();

      @(posedge clk);

      if (we)
        ref_mem[addr_a] = data_a;

      if (data_b == ref_mem[addr_b])
        $display("PASS Addr=%0d Data=%0h", addr_b, data_b);
      else
        $display("FAIL Addr=%0d", addr_b);

    end

    $display("Coverage: %0.2f %%", cg.get_inst_coverage());
    $finish;
  end

endmodule
