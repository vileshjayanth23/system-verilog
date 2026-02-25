//------------------------------------------------------------------------------
//File       : testbench.sv
//Author     : VILESH JAYANTH MA (1BM23EC292)
//Module     : tb
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Self-checking testbench with associative reference and coverage.
//------------------------------------------------------------------------------

module tb;

    parameter ADDR_WIDTH = 4;
    parameter DATA_WIDTH = 8;

    logic clk = 0;

    logic we_a;
    logic [ADDR_WIDTH-1:0] addr_a;
    logic [DATA_WIDTH-1:0] wdata_a;

    logic [ADDR_WIDTH-1:0] addr_b;
    logic [DATA_WIDTH-1:0] rdata_b;

    dual_port_ram #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (.*);

    // Clock
    always #5 clk = ~clk;

    // -------------------------------------------------
    // Reference Model (Associative Array)
    // -------------------------------------------------
    logic [DATA_WIDTH-1:0] ref_mem [int];

    // -------------------------------------------------
    // Functional Coverage
    // -------------------------------------------------
    covergroup cg_ram @(posedge clk);

        // Cover write enable
        cp_we : coverpoint we_a;

        // Cover address space usage
        cp_addr : coverpoint addr_a {
            bins low  = {[0:3]};
            bins mid  = {[4:7]};
            bins high = {[8:15]};
        }

        // Cross write + address region
        cross_we_addr : cross cp_we, cp_addr;

    endgroup

    cg_ram cg = new();

    // -------------------------------------------------
    // Stimulus
    // -------------------------------------------------
    initial begin

        // Waveform dump
        $dumpfile("dual_port_ram.vcd");
        $dumpvars(0, tb);

        we_a   = 0;
        addr_a = 0;
        addr_b = 0;
        wdata_a = 0;

        // Multiple transactions
        repeat (30) begin

            // Random write
            addr_a  = $urandom_range(0, (1<<ADDR_WIDTH)-1);
            wdata_a = $urandom();
            we_a    = 1;

            @(posedge clk);

            // Update reference
            ref_mem[addr_a] = wdata_a;

            // Disable write
            we_a = 0;

            // Random read
            addr_b = addr_a;

            #1;

            // Compare
            if (rdata_b === ref_mem[addr_b])
                $display("PASS: Addr=%0d Data=%0h", addr_b, rdata_b);
            else
                $display("FAIL: Addr=%0d Expected=%0h Got=%0h",
                         addr_b, ref_mem[addr_b], rdata_b);

            @(posedge clk);
        end

        // Print coverage
        $display("Functional Coverage: %.2f %%", cg.get_inst_coverage());

        $finish;
    end

endmodule
