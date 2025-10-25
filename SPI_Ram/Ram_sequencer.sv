package Ram_sequencer_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;

    class Ram_sequencer extends uvm_sequencer #(Ram_seq_item);
        `uvm_component_utils(Ram_sequencer)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

    endclass : Ram_sequencer
    
endpackage