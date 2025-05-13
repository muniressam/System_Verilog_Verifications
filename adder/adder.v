module adder (
    input clk,
    input reset,
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [4:0] C
);

    always @(posedge clk or negedge reset) begin
        if(reset) 
            C<= 5'b0;
        else
            C<= A+B ;
    end
    
endmodule