////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_test_pkg::*;

module top(); 
  bit clk;
  // Example 1
  // Clock generation
  initial begin
    forever begin
      #1 clk = ~clk;
    end
  end
  

  // Instantiate the interface and DUT
  shift_reg_if shiftif (clk);
  shift_reg DUT (shiftif.clk, shiftif.reset, shiftif.serial_in, shiftif.direction, shiftif.mode, shiftif.datain, shiftif.dataout);
  // run test using run_test task
  initial begin
    uvm_config_db #(virtual shift_reg_if)::set(null ,"uvm_test_top" , "CFG" ,shiftif);
    run_test("shift_reg_test");
  end
  // Example 2
  // Set the virtual interface for the uvm test
endmodule