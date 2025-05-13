module priority_enc_tb;
logic       clk;
logic       rst;
logic [3:0] D;
logic [1:0] Y;
logic       valid;

priority_enc DUT(.*);

initial begin
 clk = 0;
 forever begin
     #1 clk = ~clk;
 end
end
initial begin
  // Test
   D =0;
   rst = 1;
   @( posedge clk );
    rst = 0;
    D = 'b0000 ;
    D = 'b0001 ;
    D = 'b0010 ;
    D = 'b0011 ;
    D = 'b0100 ;
    D = 'b0101 ;
    D = 'b0110 ;
    D = 'b0111 ;
    D = 'b1000 ;
    D = 'b1001 ;
    D = 'b1010 ;
    D = 'b1011 ;
    D = 'b1100 ;
    D = 'b1101 ;
    D = 'b1110 ;
    D = 'b1111 ;
    D = 'b0000 ;

   repeat(100) begin
     rst = $random;
     D = $random;
     @( posedge clk );
   end
   @( posedge clk );
    rst = 1;
   $stop;

end

property p_reset;
    @(posedge clk) rst |=> (Y == 2'b00 && valid == 1'b0);
endproperty

property p_valid;
    @(posedge clk) ($countones(D) == 0 )|=> !valid ;
endproperty

property output_0;
    @(posedge clk) (D == 4'b1000 && !rst) |=> (Y == 0 );
endproperty

property output_1;
    @(posedge clk) (D[2:0] == 3'b100 && !rst ) |=> (Y == 1 );
endproperty

property output_2;
    @(posedge clk) (D[1:0] == 2'b10 && !rst ) |=> (Y == 2 );
endproperty

property output_3;
    @(posedge clk) (D[0] == 1'b1 && !rst ) |=> (Y == 3 );
endproperty

assert_reset: assert property (p_reset) ;
assert_valid: assert property (p_valid) ;
assert_output_0: assert property (output_0) ;
assert_output_1: assert property (output_1) ;       
assert_output_2: assert property (output_2) ;
assert_output_3: assert property (output_3) ;

cover_reset: cover property (p_reset) ;
cover_valid: cover property (p_valid) ;
cover_output_0: cover property (output_0) ;
cover_output_1: cover property (output_1) ;
cover_output_2: cover property (output_2) ;
cover_output_3: cover property (output_3) ;

endmodule 
