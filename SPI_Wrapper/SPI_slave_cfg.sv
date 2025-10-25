package SPI_slave_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh" 

    class SPI_slave_cfg extends uvm_object;
        `uvm_object_utils(SPI_slave_cfg)
        virtual SPI_slave_if Slave_vif;
        uvm_active_passive_enum is_active;

        function new(string name = "SPI_slave_cfg");
            super.new(name);
        endfunction : new

        
    endclass : SPI_slave_cfg
endpackage