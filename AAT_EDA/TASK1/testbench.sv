//------------------------------------------------------------------------------
//File       : testbench.sv
//Author     : VILESH JAYANTH MA (1BM23EC292)
//Module     : tb
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Constrained-random verification of ALU with opcode coverage.
//------------------------------------------------------------------------------

class transaction;
    rand logic [7:0] a, b;
    rand opcode_e   op;

    // Ensure MUL occurs at least 20% of the time
    constraint c_mul_dist {
        op dist { ADD:=25, SUB:=25, MUL:=20, XOR:=30 };
    }
endclass

module tb;

    logic [7:0]  a, b;
    logic [15:0] y;
    opcode_e     op;

    alu dut (.*);

    transaction tr = new();

    // Coverage: verify all opcodes exercised
    covergroup cg_alu;
        cp_op : coverpoint op;
    endgroup

    cg_alu cg = new();

    initial begin
        // Dump setup
        $dumpfile("alu_calc.vcd");
        $dumpvars(0, tb);

        repeat (100) begin
            tr.randomize();
            a  = tr.a;
            b  = tr.b;
            op = tr.op;
            #5;
            cg.sample();
        end

        $display("Opcode Coverage: %.2f %%", cg.get_inst_coverage());
        $finish;
    end

endmodule
