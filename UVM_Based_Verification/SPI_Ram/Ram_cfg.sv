package Ram_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh" 

    class Ram_cfg extends uvm_object;
        `uvm_object_utils(Ram_cfg)
        virtual Ram_if Ram_vif;
        uvm_active_passive_enum is_active; // UVM_ACTIVE or UVM_PASSIVE

        function new(string name = "Ram_cfg");
            super.new(name);
        endfunction : new

    endclass : Ram_cfg
endpackage