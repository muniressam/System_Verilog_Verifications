import ALSU_pkt::*;
module ALSU_tb_2;
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    ALSU_class ALU_obj = new();

    bit clk, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    bit signed [1:0] cin;
    opcode_e opcode;
    bit signed [2:0] A, B;
    bit [15:0] leds;
    bit signed [5:0] out;

    int error_count=0;
    int correct_count=0;

    ALSU DUT(.*);
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
            @(negedge clk);
            check_result(ALU_obj);
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
            ALU_obj.rst = rst;
            ALU_obj.red_op_A= red_op_A;
            ALU_obj.red_op_B= red_op_B;
            ALU_obj.bypass_A= bypass_A;
            ALU_obj.bypass_B= bypass_B;
            A=ALU_obj.A;
            B=ALU_obj.B;
            cin=ALU_obj.cin;
            direction=ALU_obj.direction;
            serial_in=ALU_obj.serial_in;
            opcode=ALU_obj.opcode;
            @(negedge clk);
            check_result(ALU_obj);
        end

        assert_reset();
        $display("%t:Num of Correct = %0d Num of Error= %0d",$time,correct_count,error_count);
        $stop;
    end
////////////Task for golden model///////////////
    task golden_model (
        input ALSU_class ALU_obj,
        output [5:0] g_out , [15:0] g_leds
    );
        if(ALU_obj.rst) begin
            g_out = 0;
            g_leds= 0;
        end else begin
            // invalid test
            if((ALU_obj.red_op_A || ALU_obj.red_op_B) && (ALU_obj.opcode== OR || ALU_obj.opcode==XOR)) begin
                g_leds = ~g_leds;
                g_out  = 0;
            end else if(ALU_obj.opcode == INVALID_6 || ALU_obj.opcode == INVALID_7 ) begin
                g_leds = ~g_leds;
                g_out  = 0;
            end else begin
                g_leds = 0;
            end
            // high periority for bypass
            if (ALU_obj.bypass_A && ALU_obj.bypass_B)
            g_out = (INPUT_PRIORITY == "A")? ALU_obj.A: ALU_obj.B;
            else if (ALU_obj.bypass_A)
            g_out = ALU_obj.A;
            else if (ALU_obj.bypass_B)
            g_out = ALU_obj.B;
            else begin
                // opcode operation
                case (ALU_obj.opcode)
                    OR: begin
                        if (ALU_obj.red_op_A && ALU_obj.red_op_B ) begin
                            g_out = (INPUT_PRIORITY == "A")? |ALU_obj.A: |ALU_obj.B;
                        end else if (ALU_obj.red_op_A) 
                            g_out = |ALU_obj.A;
                            else if (ALU_obj.red_op_B)
                            g_out = |ALU_obj.B;
                            else 
                            g_out = ALU_obj.A | ALU_obj.B;
                    end
                    XOR: begin
                        if (ALU_obj.red_op_A && ALU_obj.red_op_B ) begin
                            g_out = (INPUT_PRIORITY == "A")? ^ALU_obj.A: ^ALU_obj.B;
                        end else if (ALU_obj.red_op_A) 
                            g_out = ^ALU_obj.A;
                            else if (ALU_obj.red_op_B)
                            g_out = ^ALU_obj.B;
                            else 
                            g_out = ALU_obj.A ^ ALU_obj.B;
                    end
                    ADD: begin 
                        if (FULL_ADDER == "ON") 
                            g_out = ALU_obj.A + ALU_obj.B + ALU_obj.cin;
                         else
                            g_out = ALU_obj.A + ALU_obj.B ;
                    end
                    MULT: begin
                        g_out = ALU_obj.A * ALU_obj.B;
                    end
                    SHIFT: begin
                        if(ALU_obj.direction)
                            g_out = {g_out[4:0], ALU_obj.serial_in};//shift left
                        else
                            g_out = {ALU_obj.serial_in, g_out[5:1]};//shift right
                    end
                    ROTATE : begin
                        if (ALU_obj.direction)
                            g_out = {g_out[4:0], g_out[5]};//rotate left
                        else
                            g_out = {g_out[0], g_out[5:1]};//rotate right
                    end
                    
                endcase
            end
        end

    endtask 
       
    task check_result(input ALSU_class ALU_check );
        bit [5:0] out_check ;
        bit [15:0] leds_check;
        golden_model(ALU_check , out_check ,leds_check);
        @(negedge clk);
        if (rst!=1) begin
            if(out_check == out && leds_check == leds ) begin
                $display("corect golden out_check =%0d , out=%0d ---golden leds=%0d , leds = %0d ",out_check,out,leds_check,leds);
                correct_count=correct_count+1;
            end else begin
                $display("Error golden out_check =%0d , out=%0d ---golden leds=%0d , leds = %0d ",out_check,out,leds_check,leds);
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

    task sample();
        ALU_obj.cvr_gp
    endtask 


endmodule
