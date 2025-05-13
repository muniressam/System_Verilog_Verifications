module ALSU_golden (A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, clk, rst, direction, g_leds, g_out);
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    input clk,cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    input signed [2:0] A;
    input signed [2:0] B;
    input [2:0] opcode;
    output reg signed [5:0] g_out ;
    output reg [15:0] g_leds;

    reg g_red_op_A, g_red_op_B, g_bypass_A, g_bypass_B, g_direction, g_serial_in;
    reg signed [1:0]g_cin;
    reg [2:0] g_opcode;
    reg signed [2:0] g_A, g_B;

    wire invalid_op;
    wire invalid_red;
    wire invalid_all;

    assign invalid_red = (g_red_op_A | g_red_op_B) & (g_opcode[1] | g_opcode[2]);
    assign invalid_op = (g_opcode[1] & g_opcode[2] );
    assign invalid_all = invalid_op | invalid_red;

  always @(posedge clk or posedge rst) begin
    if(rst) begin
      g_cin<= 0;
      g_red_op_B<= 0;
      g_red_op_A<= 0;
      g_bypass_B<= 0;
      g_bypass_A<= 0;
      g_direction<= 0;
      g_serial_in<= 0;
      g_opcode<= 0;
      g_A<= 0;
      g_B<= 0;
    end else begin
      g_cin<= cin;
      g_red_op_B<= red_op_B;
      g_red_op_A<= red_op_A;
      g_bypass_B<= bypass_B;
      g_bypass_A<= bypass_A;
      g_direction<= direction;
      g_serial_in<= serial_in;
      g_opcode<= opcode;
      g_A<= A;
      g_B<= B;
    end
end

always @(posedge clk or negedge rst) begin
    if(rst) begin
        g_leds <= 0;
    end else begin
      if (invalid_all) begin
          g_leds <= ~g_leds;
      end else begin
          g_leds <= 0;
      end
    end
end

always @(posedge clk or negedge rst) begin
    if(rst) begin
        g_out <= 0;
    end else begin
        // ALSU_5
        if (g_bypass_A && g_bypass_B)
            g_out <= (INPUT_PRIORITY == "A")? g_A: g_B;
        else if (g_bypass_A) 
            g_out <= g_A;
        else if (g_bypass_B)
            g_out <= g_B;
        // invalid test
         else if (invalid_all) 
            g_out <= 0;
        else begin
            case (g_opcode)
                //ALSU_2
                3'h0: begin
                    if (g_red_op_A && g_red_op_B ) 
                      g_out <= (INPUT_PRIORITY == "A")? |g_A: |g_B;
                    else if (g_red_op_A) 
                      g_out <= |g_A;
                    else if (g_red_op_B)
                      g_out <= |g_B;
                    else 
                      g_out <= g_A | g_B;
                end
                //ALSU_3
                3'h1: begin
                    if (g_red_op_A && g_red_op_B ) 
                      g_out <= (INPUT_PRIORITY == "A")? ^g_A: ^g_B;
                    else if (g_red_op_A) 
                      g_out <= ^g_A;
                    else if (g_red_op_B)
                      g_out <= ^g_B;
                    else 
                      g_out <= g_A ^ g_B;
                end
                //ALSU_1
                3'h2: begin 
                    if (FULL_ADDER == "ON") 
                        g_out <= g_A + g_B + g_cin;
                     else
                        g_out <= g_A + g_B ;
                end
                3'h3: g_out <= g_A * g_B;
                //ALSU_6
                3'h4: begin
                    if(g_direction)
                        g_out <= {g_out[4:0], g_serial_in};//shift left
                    else
                        g_out <= {g_serial_in, g_out[5:1]};//shift right
                end
                //ALSU_7
                3'h5 : begin
                    if (g_direction)
                        g_out <= {g_out[4:0], g_out[5]};//rotate left
                    else
                        g_out <= {g_out[0], g_out[5:1]};//rotate right
                end
                default : g_out <=0;
            endcase
        end
    end
end
endmodule
