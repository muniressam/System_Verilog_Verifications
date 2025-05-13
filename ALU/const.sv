package ALU_pkg;
    typedef enum logic [2] { Add=2'b00 ,Sub=2'b01 ,Not_A=2'b10 ,ReductionOR_B=2'b11 } opcode_e;
    class ALU_class;
        rand logic reset;
        rand opcode_e Opcode;	
        rand logic signed [3:0] A;	
        rand logic signed [3:0] B;
        
        constraint c_reset {reset dist {1:=10 ,0:=90 };}
       
    endclass //ALU_class
 	    
endpackage