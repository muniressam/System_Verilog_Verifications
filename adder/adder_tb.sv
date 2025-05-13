module adder_tb ();
    logic clk,reset;
    logic signed [3:0] A;
    logic signed [3:0] B;
    logic signed [4:0] C;
    
    localparam MAXPOS = 7 , ZERO = 0 , MAXNEG = -8 ;
    adder DUT (.*);

    integer correct_count;
    integer error_count;

    // clk generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
       //adder1
       A =0;
       B =0;
       clk = 0;
       correct_count = 0;
       error_count = 0 ;
       //ADDER_1
       RST;
       //ADDER_2
       A = MAXNEG ; B = MAXNEG;
       check_result (-16);
       //ADDER_3
       A = MAXNEG ; B = MAXPOS;
       check_result (-1);
        //ADDER_4
       A = MAXNEG ; B = ZERO;
       check_result (-8);
        //ADDER_5
       A = MAXPOS ; B = MAXNEG;
       check_result (-1);
        //ADDER_6
       A = MAXPOS ; B = MAXPOS;
       check_result (14);
        //ADDER_7
       A = MAXPOS ; B = ZERO;
       check_result (7);
        //ADDER_8
       A = ZERO ; B = MAXNEG;
       check_result (-8);
        //ADDER_9
       A = ZERO ; B = MAXPOS;
       check_result (7);
        //ADDER_10
       A = ZERO ; B = ZERO;
       check_result (0);

       RST;
       $display("%0t : At end of simulation correct_count = %0d , error_count = %0d",$time,correct_count,error_count);
       $display("");
    $stop;
    end
    task RST ;
        reset = 1;
        @(negedge clk) 
        if(C!=0) begin
            $display("check reset is false");
            error_count ++;
            $stop;
        end else begin
            correct_count ++;
        end
        //check_result(0); 
        reset = 0;  
    endtask  
    task  check_result (input signed [4:0] x );
        @(negedge clk )
        if (C == x ) begin
            $display("check_result is true");
            correct_count ++;
        end else begin
            $display("check_result is false");
            error_count ++;
        end
    endtask 
endmodule