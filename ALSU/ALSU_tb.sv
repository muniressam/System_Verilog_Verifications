import ALSU_pkt::*;
module ALSU_tb;
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    ALSU_class ALU_obj = new();

    logic clk,cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    opcode_e opcode;
    logic signed [2:0] A, B;
    logic [15:0] leds;
    logic signed [5:0] out;
    logic [15:0] g_leds;
    logic signed [5:0] g_out;

    int error_count=0;
    int correct_count=0;

    ALSU DUT(.*);
    ALSU_golden UUT(.*);

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end
    
   initial begin
        ALU_obj.unique_opcode.constraint_mode(0);
        assert_reset();
        repeat(1000) begin
            assert(ALU_obj.randomize());
            rst=ALU_obj.rst;
            A=ALU_obj.A;
            B=ALU_obj.B;
            red_op_A=ALU_obj.red_op_A;
            red_op_B=ALU_obj.red_op_B;
            bypass_A=ALU_obj.bypass_A;
            bypass_B=ALU_obj.bypass_B;
            cin=ALU_obj.cin;
            direction=ALU_obj.direction;
            serial_in=ALU_obj.serial_in;
            opcode=ALU_obj.opcode;
            check_result();
            sample_cvr(rst,bypass_A,bypass_B);
        end

        ALU_obj.constraint_mode(0);
        rst=0;
        red_op_A=0;
        red_op_B=0;
        bypass_A=0;
        bypass_B=0;
        ALU_obj.unique_opcode.constraint_mode(1);

        repeat(1000) begin            
            assert(ALU_obj.randomize());
                A=ALU_obj.A;
                B=ALU_obj.B;
                cin=ALU_obj.cin;
                direction=ALU_obj.direction;
                serial_in=ALU_obj.serial_in;
            for (int i=0;i<6;i++) begin
                opcode=ALU_obj.arr_opcode[i];
                check_result();
                sample_cvr(rst,bypass_A,bypass_B);
            end
        end 
        //To achive transition coverage
        for (int i=0;i<6;i++) begin
            assert(ALU_obj.randomize());
            A=ALU_obj.A;
            B=ALU_obj.B;
            cin=ALU_obj.cin;
            direction=ALU_obj.direction;
            serial_in=ALU_obj.serial_in;
            ALU_obj.opcode=opcode_e'(i);
            opcode=ALU_obj.opcode;
            check_result();
            sample_cvr(rst,bypass_A,bypass_B);     
        end

        assert_reset();
        $display("%t:Num of Correct = %0d Num of Error= %0d",$time,correct_count,error_count);
        $stop;
    end

    task check_result();
        @(negedge clk);
        if (rst!=1) begin
            if(g_out == out && g_leds == leds ) begin
                $display("corect golden g_out =%0d , out=%0d ---golden leds=%0d , leds = %0d ",g_out,out,g_leds,leds);
                correct_count=correct_count+1;
            end else begin
                $display("Error golden g_out =%0d , out=%0d ---golden leds=%0d , leds = %0d ",g_out,out,g_leds,leds);
                error_count=error_count+1;
            end
        end else begin
            check_reset();
        end
        
    endtask 

    task assert_reset;
        rst = 1;
        check_reset();
        rst = 0;
    endtask 

    task check_reset();
        @(negedge clk) 
       if(out!=0 && leds!=0) begin
            $display("check reset is false");
            error_count ++;
            $stop;
        end else begin
            $display("check reset is true");
            correct_count ++;
        end
    endtask 

    task sample_cvr(input rst ,bypass_A ,bypass_B);
        if(!rst && !bypass_A && !bypass_B) begin
          ALU_obj.cvr_gp.sample();
        end 
    endtask 
    
endmodule
