//------------------------------------------------------------------------------
//File       : testbench.sv
//Author     : VILESH JAYANTH MA (1BM23EC292)
//Module     : tb
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Verification of digital clock using transition bins.
//------------------------------------------------------------------------------

module tb;

    logic clk = 0;
    logic rst;
    logic [5:0] sec, min;

    digital_clock dut (.*);

    // Clock generation
    always #5 clk = ~clk;

    // Coverage: second rollover and minute increment
    covergroup cg_clock @(posedge clk);

      // Seconds must wrap correctly
      cp_sec : coverpoint sec {
          bins sec_roll = (59 => 0);
      }

      // Minute must increment on second wrap
      cp_min : coverpoint min {
          bins min_inc = (0 => 1), (1 => 2), (2 => 3);
      }

  	  endgroup

    

    cg_clock cg = new();

    initial begin
        // Dump setup
        $dumpfile("digital_clock.vcd");
        $dumpvars(0, tb);

        // Reset
        rst = 1;
        @(posedge clk);
        rst = 0;

        // Run long enough to force multiple rollovers
        repeat (130) @(posedge clk);

        $display("Clock Coverage: %.2f %%", cg.get_inst_coverage());
        $finish;
    end

endmodule
