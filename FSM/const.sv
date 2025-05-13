package FSM_pkg;
    typedef enum bit [2] {IDLE = 2'b00 , ZERO = 2'b01 , ONE = 2'b10 , STORE = 2'b11} state_e;

    class fsm_transaction ;
        rand bit rst;
        rand bit x;
        //Reset
        constraint c_reset { rst dist{0:=90 , 1:=10};}
        //FSM_1
        constraint c_x { x dist{0:=67 , 1:=33};}
    endclass 
endpackage
