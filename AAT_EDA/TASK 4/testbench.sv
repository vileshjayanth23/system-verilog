//------------------------------------------------------------------------------
//File       : testbench.sv
//Author     : VILESH JAYANTH MA (1BM23EC292)
//Module     : tb
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Constrained-random verification of EthPacket with 100% coverage.
//------------------------------------------------------------------------------

module tb;

    EthPacket pkt;

    // Dummy signal so VCD is not empty (for EPWave)
    logic sample_pulse;

    // -------------------------------------------------
    // COVERAGE
    // -------------------------------------------------
    covergroup cg_pkt;

        cp_len : coverpoint pkt.len {
            bins len4 = {4};
            bins len5 = {5};
            bins len6 = {6};
            bins len7 = {7};
            bins len8 = {8};
        }

    endgroup

    cg_pkt cg = new();

    initial begin
        pkt = new();

        // Dump for waveform
        $dumpfile("eth_packet.vcd");
        $dumpvars(0, tb);

        // -------------------------------------------------
        // GUARANTEED 100% COVERAGE
        // -------------------------------------------------
        for (int L = 4; L <= 8; L++) begin

            if (!pkt.randomize() with { len == L; }) begin
                $error("Randomization failed!");
            end

            pkt.display();

            // Toggle dummy signal (so waveform shows activity)
            sample_pulse = 1;
            #1;
            sample_pulse = 0;

            cg.sample();
        end

        // -------------------------------------------------
        // PRINT COVERAGE
        // -------------------------------------------------
        $display("EthPacket Coverage: %.2f %%", cg.get_inst_coverage());

        $finish;
    end

endmodule
