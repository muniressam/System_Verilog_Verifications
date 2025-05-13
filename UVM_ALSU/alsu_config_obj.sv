package alsu_config_obj_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_config_obj extends uvm_object;
    `uvm_object_utils(alsu_config_obj);
    virtual ALSU_IF alsu_config_vif;

    function new(string name = "alsu_config_obj");
        super.new(name);
    endfunction //new()
endclass //className extends uvm_object;
    
endpackage