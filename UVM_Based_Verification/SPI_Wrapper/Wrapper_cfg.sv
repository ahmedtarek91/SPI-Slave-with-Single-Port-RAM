package Wrapper_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh" 

    class Wrapper_cfg extends uvm_object;
        `uvm_object_utils(Wrapper_cfg)
        virtual Wrapper_if Wrapper_vif;
        uvm_active_passive_enum is_active;

        function new(string name = "Wrapper_cfg");
            super.new(name);
        endfunction : new

    endclass : Wrapper_cfg
endpackage