package SPI_slave_sequencer_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_slave_seq_item_pkg::*;
    import SPI_slave_config_pkg::*;

    class SPI_slave_sequencer extends uvm_sequencer #(SPI_slave_seq_item);
        `uvm_component_utils(SPI_slave_sequencer)
        SPI_slave_cfg cfg;
        virtual SPI_slave_if sequencer_vif;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

    endclass : SPI_slave_sequencer
    
endpackage