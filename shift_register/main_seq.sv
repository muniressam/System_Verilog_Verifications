package main_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import seq_item_pkg::*;

    class shift_reg_main_seq extends uvm_sequence #(shift_reg_seq_item);
        `uvm_object_utils(shift_reg_main_seq)
        shift_reg_seq_item seq_item; // handel

        function new(string name = "shift_reg_main_seq");
            super.new(name);
        endfunction //new()

        task body ;
            seq_item = shift_reg_seq_item :: type_id :: create ("seq_item"); // object
            repeat(10000) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask 
    endclass //reset_seq extends superClass
endpackage