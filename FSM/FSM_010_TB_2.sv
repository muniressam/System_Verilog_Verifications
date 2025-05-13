import FSM_pkg ::*;
module FSM_010_TB_2 ();
    logic clk, rst, x;
	logic y;
	logic [9:0] users_count;

    logic y_exp;
    logic [9:0] users_count_exp;

    fsm_transaction fsm_obj = new();
    FSM_010 DUT(.*);
    golden_model UUT(.clk(clk),.rst(rst),.x(x),.y_exp(y_exp),.users_count_exp(users_count_exp));
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
        assert_reset();
        repeat(100) begin
            assert(fsm_obj.randomize());
            rst = fsm_obj.rst;
            x = fsm_obj.x;
            check_result();
        end
        assert_reset();
        $display("%0t : At end of simulation correct_count = %0d , error_count = %0d",$time,correct_count,error_count);
        $stop;
    end

    

    task check_result ();
        @(negedge clk);
        if (y_exp==y && users_count_exp == users_count) begin
            $display("corect with x=%d , rst=%d and y = %d = y_exp =%d and count = %0d = exp_count = %0d ",x,rst,y,y_exp,users_count,users_count_exp);
            correct_count ++;
        end else begin
            $display("Error with x=%d , rst=%d and y = %d = y_exp =%d and count = %0d = exp_count = %0d ",x,rst,y,y_exp,users_count,users_count_exp);
            error_count ++;
        end
        
    endtask 

    task assert_reset();
        rst = 1;
        @(negedge clk) 
        if(y==0 && users_count == 0) begin
            $display("check reset is true");
            correct_count ++;   
        end else begin
            $display("check reset is false");
            error_count ++;
            $stop;
        end
        rst = 0;
    endtask
endmodule