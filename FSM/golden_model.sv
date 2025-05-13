module golden_model (
    input clk,rst,x,
    output reg y_exp,
    output reg [9:0] users_count_exp
    );
    parameter IDLE  = 2'b00;
	parameter ZERO  = 2'b01;
	parameter ONE   = 2'b10;
	parameter STORE = 2'b11; 

    reg [1:0] CS , NS ;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            CS <= IDLE;
            users_count_exp <= 0;
        end else begin
            CS <= NS;
            if(CS == STORE) begin
                users_count_exp <= users_count_exp + 1;
            end
        end
    end
    always @(*) begin 
        case(CS)
            2'b00 : begin
                y_exp = 0;
                if(x) begin
                    NS = IDLE;
                end else begin
                    NS = ZERO;
                end
            end
            2'b01 : begin
                y_exp = 0;
                if(x) begin
                    NS = ONE;
                end else begin
                    NS = ZERO;
                end
            end
            2'b10 : begin
                y_exp = 0;
                if(x) begin
                    NS = IDLE;
                end else begin
                    NS = STORE;
                end
            end
            2'b11 : begin
                y_exp = 1;
                if(x) begin
                    NS = IDLE;
                end else begin
                    NS = ZERO;
                end
            end
            default : NS = IDLE;
        endcase
        y_exp = (CS == STORE) ? 1 : 0;
    end

endmodule