interface ALSU_IF(clk);
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";

    input clk;
    logic rst;
    logic cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    logic [2:0] opcode;
    logic signed [2:0] A;
    logic signed [2:0] B;
    logic [15:0] leds;
    logic signed [5:0] out;
endinterface 