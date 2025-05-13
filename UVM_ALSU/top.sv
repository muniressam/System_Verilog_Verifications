import alsu_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top ();
    bit clk;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    ALSU_IF alsu_if(clk);

    ALSU DUT(alsu_if.A, alsu_if.B, alsu_if.cin, alsu_if.serial_in,
             alsu_if.red_op_A, alsu_if.red_op_B, alsu_if.opcode, 
             alsu_if.bypass_A, alsu_if.bypass_B, alsu_if.clk, alsu_if.rst,
             alsu_if.direction, alsu_if.leds, alsu_if.out);

    initial begin
        uvm_config_db #(virtual ALSU_IF)::set(null ,"uvm_test_top" , "ALSU_IF" ,alsu_if);
        run_test("alsu_test");
    end

endmodule
