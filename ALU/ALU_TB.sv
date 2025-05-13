import ALU_pkg::*;
module ALU_TB;
    logic              reset;
    logic              clk;
    opcode_e           Opcode;
    logic signed [3:0] A ;
    logic signed [3:0] B ;
    logic signed [4:0] C ;

    ALU_class ALU_obj = new();
    ALU_4_bit DUT(.*);
    integer correct_count=0;
    integer error_count=0;

    initial begin
        clk = 0;
        forever begin
            #1
            clk = ~clk;
        end
    end

    initial begin
        asser_reset();
        repeat(100) begin
            assert(ALU_obj.randomize());
            reset = ALU_obj.reset;
            A = ALU_obj.A;
            B = ALU_obj.B;
            Opcode = ALU_obj.Opcode;
            check_result(check_operation(reset,Opcode,A,B));
        end
        asser_reset();
        $display("%0t : At end of simulation correct_count = %0d , error_count = %0d",$time,correct_count,error_count);
        $stop;
    end
    task asser_reset();
        reset = 1;
        @(negedge clk) 
        if(C!=0) begin
            $display("check reset is false");
            error_count ++;
            $stop;
        end else begin
            $display("check reset is true");
            correct_count ++;
        end
        reset = 0;
    endtask


    task check_result;
        input signed [4:0] out_C;
        @(negedge clk);
        if(out_C == C ) begin
        $display("corect with A=%d , B=%d , op=%s and out_C = %d = C =%d ",A,B,Opcode,out_C,C);
            correct_count ++;
        end else begin
        $display("Error with A=%d , B=%d , op=%s and out_C = %d = C =%d ",A,B,Opcode,out_C,C);
        error_count ++;
        end  
    endtask
    function signed [4:0] check_operation;
        input reset;
        input opcode_e op;
        input signed [3:0] in_A;
        input signed [3:0] in_B;
        if(reset) begin
            check_operation = 0;
        end else begin
            case (op)
            Add : check_operation = in_A + in_B ;
            Sub : check_operation = in_A - in_B ;
            Not_A : check_operation = ~in_A ;
            ReductionOR_B : check_operation = |in_B ;
            endcase
        end
    endfunction
endmodule
