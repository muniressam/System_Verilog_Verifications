package sequencer_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import seq_item_pkg::*;

    class shift_reg_sequencer extends uvm_sequencer #(shift_reg_seq_item);
        `uvm_component_utils(shift_reg_sequencer)

        function new(string name = "shift_reg_sequencer" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

    endclass //reset_seq extends superClass
endpackage