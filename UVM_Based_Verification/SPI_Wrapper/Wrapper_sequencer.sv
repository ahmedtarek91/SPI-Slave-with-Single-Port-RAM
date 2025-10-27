package Wrapper_sequencer_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Wrapper_seq_item_pkg::*;
    import Wrapper_config_pkg::*;

    class Wrapper_sequencer extends uvm_sequencer #(Wrapper_seq_item);
        `uvm_component_utils(Wrapper_sequencer)
        Wrapper_cfg cfg;
        virtual Wrapper_if sequencer_vif;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

    endclass : Wrapper_sequencer
endpackage