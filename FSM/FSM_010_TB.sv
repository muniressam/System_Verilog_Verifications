import FSM_pkg ::*;
module FSM_010_TB ();
    logic clk, rst, x;
	logic y;
	logic [9:0] users_count;

    fsm_transaction fsm_obj = new();
    FSM_010 DUT(.*);
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
        x = 0;
        assert_reset();
        repeat(1000) begin
            assert(fsm_obj.randomize());
            rst = fsm_obj.rst;
            x = fsm_obj.x;
            check_result(fsm_obj);
        end
        // to cover all bits of users_count we disable the reset
        repeat(20000) begin
            assert(fsm_obj.randomize());
            rst = 0;
            fsm_obj.rst=0;
            x = fsm_obj.x;
            check_result(fsm_obj);
        end
        assert_reset();
        $display("%0t : At end of simulation correct_count = %0d , error_count = %0d",$time,correct_count,error_count);
        $stop;
    end

    task golden_model(input fsm_transaction fsm , output bit y_exp, output bit [9:0] users_count_exp);
        state_e CS , NS ;
        case(CS)
            IDLE : begin
                if(fsm.x) begin
                    NS = IDLE;
                end else begin
                    NS = ZERO;
                end
            end
            ZERO : begin
                if(fsm.x) begin
                    NS = ONE;
                end else begin
                    NS = ZERO;
                end
            end
            ONE : begin
                if(fsm.x) begin
                    NS = IDLE;
                end else begin
                    NS = STORE;
                end
            end
            STORE : begin
                if(fsm.x) begin
                    NS = IDLE;
                end else begin
                    NS = ZERO;
                end
            end
        endcase
        if(fsm.rst) begin
            CS = IDLE;
            users_count_exp <= 0;
        end else begin
            if(CS == STORE) begin
                users_count_exp = users_count_exp + 1;
            end else begin
                users_count_exp = users_count_exp;
            end
            CS = NS;
        end
        y_exp = (CS == STORE) ? 1 : 0;
    endtask 

    task check_result (input fsm_transaction fsm_ob);
        bit y_exp;
        bit [9:0] users_count_exp;
        golden_model(fsm_ob,y_exp,users_count_exp);
        if (fsm_ob.rst==1) begin
            check_reset();
        end else begin
            @(negedge clk);
            if (y_exp==y && users_count_exp == users_count) begin
                $display("corect with x=%d , rst=%d and y = %d = y_exp =%d and count = %0d = exp_count = %0d ",x,rst,y,y_exp,users_count,users_count_exp);
                correct_count ++;
            end else begin
                $display("Error with x=%d , rst=%d and y = %d = y_exp =%d and count = %0d = exp_count = %0d ",x,rst,y,y_exp,users_count,users_count_exp);
                error_count ++;
            end
        end  
    endtask 

    task assert_reset();
        rst = 1;
        check_reset();
        rst = 0;
    endtask

    task check_reset();
        @(negedge clk) 
        if(y==0 && users_count == 0) begin
            $display("check reset is true");
            correct_count ++;   
        end else begin
            $display("check reset is false");
            error_count ++;
            $stop;
        end
    endtask 
endmodule