package Wrapper_reset_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Wrapper_seq_item_pkg::*;
    import Wrapper_sequencer_pkg::*;
    import Wrapper_shared_pkg::*;

    class Wrapper_reset_seq extends uvm_sequence #(Wrapper_seq_item);
        `uvm_object_utils(Wrapper_reset_seq)
        Wrapper_seq_item item;

        function new(string name = "Wrapper_reset_seq");
            super.new(name);
        endfunction : new

        task body();
            item = Wrapper_seq_item::type_id::create("item");
            start_item(item);
            item.SS_n = 1;
            item.rst_n = 0;
            item.MOSI = 0;
            finish_item(item);
        endtask : body  
    endclass : Wrapper_reset_seq
    
endpackage