module DSP_TB;
parameter OPERATION = "ADD";
logic  [17:0] A ;
logic  [17:0] B ;
logic  [47:0] C ;
logic  [17:0] D ;
logic         rst_n;
logic         clk;
logic  [47:0] P ;
 
int error_count=0;
int correct_count=0;

DSP DUT(.*);
initial begin
    clk = 0;
    forever begin
        #1
        clk = ~clk;
    end
end
initial begin
    A = 0;
    B = 0;
    C = 0;
    D = 0;

    reset;
    for(int i =0 ; i<100 ; i++) begin
     A = $random;
     B = $random;
     C = $random;
     D = $random;
     check_result(DSP_ADD(A,B,C,D));
    end
    reset;
    $display("%t:Num of Correct = %0d Num of Error= %0d",$time,correct_count,error_count);
    $stop;
end
task check_result;
    input [47:0] out_P;
    repeat(4) @(negedge clk);
    if(out_P == P ) begin
       $display("corect with D=%d , B=%d , A=%d , C=%d and out_P = %d = P =%d ",D,B,A,C,out_P,P);
        correct_count=correct_count+1;
    end else begin
       $display("Error with D=%d , B=%d , A=%d , C=%d, and out_P = %d = P =%d ",D,B,A,C,out_P,P);
        error_count=error_count+1;
    end
endtask 
task reset ;
rst_n = 0;
check_result(0);
rst_n = 1;
endtask


function logic [47:0] DSP_ADD;
input [17:0] A;
input [17:0] B;
input [47:0] C;
input [17:0] D;
logic[17:0] add_1;
logic [47:0] mul_1;
begin
    add_1 = D+B;
    mul_1 =add_1*A;
    DSP_ADD = mul_1+C;
end
endfunction


endmodule