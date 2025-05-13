package shift_reg_drv_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import seq_item_pkg::*;
    import config_obj_pkg::*;

    class shift_reg_drv extends uvm_driver #(shift_reg_seq_item);
        `uvm_component_utils(shift_reg_drv)

        virtual shift_reg_if shift_reg_vif;
        shift_reg_config shift_reg_cfg;
        shift_reg_seq_item stim_seq_item;

        function new(string name = "shift_reg_drv" ,uvm_component parent = null);
            super.new(name,parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(shift_reg_config)::get(this,"" , "shift_reg_config" , shift_reg_cfg)) begin
                `uvm_fatal("build phase" , "unable to get cofigration object")

            end
            
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            shift_reg_vif = shift_reg_cfg.shift_reg_vif;
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                stim_seq_item = shift_reg_seq_item :: type_id :: create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);
                shift_reg_vif.reset = stim_seq_item.reset;
                shift_reg_vif.serial_in=stim_seq_item.serial_in ; 
                shift_reg_vif.direction=stim_seq_item.direction ; 
                shift_reg_vif.mode=stim_seq_item.mode ; 
                shift_reg_vif.datain=stim_seq_item.datain ;
                stim_seq_item.dataout = shift_reg_vif.dataout ;
                @(negedge shift_reg_vif.clk ); 
                seq_item_port.item_done();
                `uvm_info("run_phase" , stim_seq_item.convert2string_stimulus(),UVM_MEDIUM)
            end
            
        endtask 
    endclass //shift_reg_drv extends uvm_driver

endpackage