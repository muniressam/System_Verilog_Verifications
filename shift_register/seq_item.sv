package seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    

    class shift_reg_seq_item extends uvm_sequence_item ;
        `uvm_object_utils(shift_reg_seq_item)
        rand bit reset;
        rand bit serial_in, direction, mode;
        rand logic [5:0] datain;
        logic [5:0] dataout;

        function new(string name = "shift_reg_seq_item");
            super.new(name);
        endfunction //new()

        function string convert2string();
            return $sformatf("%s reset=%0d, serial_in=%0d, direction=%0d, mode=%0d, datain=%0h, data_out=%0h", super.convert2string(),
             reset, serial_in, direction, mode, datain, dataout);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("reset=%0d, serial_in=%0d, direction=%0d, mode=%0d, datain=%0h, data_out=%0h",
             reset, serial_in, direction, mode, datain, dataout);
        endfunction

    endclass //shift_reg_seq_item extends uvm_seqence_item 
    
endpackage