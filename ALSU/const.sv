package ALSU_pkt;
    typedef enum bit [2:0] { OR=0,XOR=1,ADD=2,MULT=3,SHIFT=4,ROTATE=5, INVALID_6=6,INVALID_7=7 } opcode_e ;
    typedef enum {MAXPOS=3, ZERO =0, MAXNEG=-4} corner_case_e;
    typedef enum bit [2:0] { first = 3'b001 , second = 3'b010 , third = 3'b100  } one_bit_high_e;
    class ALSU_class;
        rand logic rst;
        rand logic signed [0:2] A;
        rand logic signed [0:2] B;
        rand logic red_op_A;
        rand logic red_op_B;
        rand logic bypass_A;
        rand logic bypass_B;
        rand logic cin;
        rand logic direction;
        rand logic serial_in;
        rand opcode_e opcode;
        rand corner_case_e corner_case;
        rand logic signed [0:2] other;
        rand one_bit_high_e one_bit_high;

        rand opcode_e arr_opcode [6];

        //Reset
        constraint c_reset {rst dist {1:/5 ,0:/95 };}
        //ALSU_1
        constraint C_arth {
            if(opcode == ADD || opcode == MULT) {
                other != MAXPOS || ZERO || MAXNEG ;
                A dist{corner_case:=80 , other:=20};
                B dist{corner_case:=80 , other:=20};
                }
        } 
        //ALSU_2
        //ALSU_3
        constraint C_read_A_B {
            if((opcode == OR || opcode == XOR)){
                if (red_op_A) {
                    A dist{0:=20, one_bit_high:=80};
                    B ==0;
                } else if (red_op_B) {
                    B dist{0:=20, one_bit_high:=80};
                    A ==0;
                } 
            }
        }
        //ALSU_4
        constraint c_opcode{
            opcode dist{OR:=15, XOR:=15, ADD:=20, MULT:=20, SHIFT:=10, ROTATE:=10, INVALID_6:=5, INVALID_7:=5};
        } 
        //ALSU_5
        constraint c_bypass{
            bypass_A dist{1:=10, 0:=90};
            bypass_B dist{1:=10, 0:=90};
        }
        constraint c_invalid_red_op_A_B{
            if(opcode != OR || opcode != XOR){
                red_op_A dist{0:=80, 1:=20};
                red_op_B dist{0:=80, 1:=20};
                }
        } 
        //ALSU_8
        constraint unique_opcode{
            foreach(arr_opcode[i]) {
                foreach(arr_opcode[j]) {
                    if(i != j) {
                        arr_opcode[i] != arr_opcode[j];
                        arr_opcode[i] inside {[OR:ROTATE]};
                    }
                }
            }
        }    

        covergroup cvr_gp ;
            A_cp : coverpoint A { 
                bins A_data_0 = {0};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_data_default = default;
                }
            B_cp : coverpoint B { 
                bins B_data_0 = {0};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_default = default;
                }
            A_one_bit_cp : coverpoint A iff(red_op_A) {bins A_data_walkingones[] = {3'b001, 3'b010, 3'b100};}
            B_one_bit_cp : coverpoint B iff(red_op_B && !red_op_A) {bins B_data_walkingones[] = {3'b001, 3'b010, 3'b100};}
            ALU_cp : coverpoint opcode { 
                bins Bins_bitwise [] = {OR, XOR};
                bins Bins_arith [] = {ADD, MULT};
                bins Bins_shift [] = {SHIFT, ROTATE};
                illegal_bins Bins_invalid = {INVALID_6,INVALID_7};
                bins Bins_trans = (0 => 1 => 2 => 3 => 4 => 5);
                }

            //ALSU_1
            A_arith_cross : cross A_cp, ALU_cp{
                option.cross_auto_bin_max = 0;
                bins cross_zero_A = binsof(A_cp) intersect{0} && binsof(ALU_cp) intersect {ADD, MULT};
                bins cross_max_A = binsof(A_cp) intersect{MAXPOS} && binsof(ALU_cp) intersect {ADD, MULT};
                bins cross_min_A = binsof(A_cp) intersect{MAXNEG} && binsof(ALU_cp) intersect {ADD, MULT};
            }
            B_arith_cross : cross B_cp, ALU_cp{
                option.cross_auto_bin_max = 0;
                bins cross_zero_B = binsof(B_cp.B_data_0) && binsof(ALU_cp.Bins_arith);
                bins cross_max_B = binsof(B_cp.B_data_max) && binsof(ALU_cp.Bins_arith);
                bins cross_min_B = binsof(B_cp.B_data_min) && binsof(ALU_cp.Bins_arith);
            }
            //ALSU_1
            carry_cp : coverpoint cin {option.weight = 0;}
            cin_add_cross : cross carry_cp , ALU_cp{
                option.weight = 5;
                option.cross_auto_bin_max = 0;
                bins cross_zero_cin = binsof(carry_cp) intersect{0} &&
                                      binsof(ALU_cp) intersect{ADD};
                bins cross_one_cin = binsof(carry_cp) intersect{1} &&
                                      binsof(ALU_cp) intersect{ADD};
            }
            //ALSU_6
            //ALSU_7
            direction_cp : coverpoint direction {option.weight = 0;}
            direction_cross : cross direction_cp , ALU_cp{
                option.weight = 5;
                option.cross_auto_bin_max = 0;
                bins cross_zero_cin = binsof(direction_cp) intersect{0} &&
                                      binsof(ALU_cp) intersect{SHIFT, ROTATE};
                bins cross_one_cin = binsof(direction_cp) intersect{1} &&
                                      binsof(ALU_cp) intersect{SHIFT, ROTATE};
            }
            //ALSU_6
            serial_in_cp : coverpoint serial_in {option.weight = 0;}
            serial_in_cross : cross serial_in_cp , ALU_cp{
                option.weight = 5;
                option.cross_auto_bin_max = 0;
                bins cross_zero_cin = binsof(serial_in_cp) intersect{0} &&
                                      binsof(ALU_cp) intersect{SHIFT, ROTATE};
                bins cross_one_cin = binsof(serial_in_cp) intersect{1} &&
                                      binsof(ALU_cp) intersect{SHIFT, ROTATE};
            }
            //ALSU_2
            //ALSU_3
            A_cross_bitwise : cross A_one_bit_cp , ALU_cp{
                option.cross_auto_bin_max = 0;
                bins cross_A = binsof(A_one_bit_cp.A_data_walkingones) && binsof(ALU_cp.Bins_bitwise);
            }
            B_cross_bitwise : cross B_one_bit_cp , ALU_cp{
                option.cross_auto_bin_max = 0;
                bins cross_B = binsof(B_one_bit_cp.B_data_walkingones) && binsof(ALU_cp.Bins_bitwise);
            }
            //ALSU_4
            red_op_A_cp : coverpoint red_op_A {option.weight = 0;}
            red_op_B_cp : coverpoint red_op_B {option.weight = 0;}  
            invalid_cross_bitwise : cross red_op_A_cp , red_op_B_cp , ALU_cp{
                option.weight=5;
                option.cross_auto_bin_max = 0;
                bins cross_red_op_A = binsof(red_op_A_cp) intersect{1} && binsof(ALU_cp) intersect{OR, XOR};
                bins cross_red_op_B = binsof(red_op_B_cp) intersect{1} && binsof(ALU_cp) intersect{OR, XOR};
            }

        endgroup
        function new();
            cvr_gp = new(); 
        endfunction
    endclass
endpackage
