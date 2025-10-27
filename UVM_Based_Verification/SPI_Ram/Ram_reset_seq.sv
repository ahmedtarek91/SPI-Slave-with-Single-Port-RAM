package Ram_reset_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;
    import Ram_sequencer_pkg::*;
    import Ram_shared_pkg::*;

    class Ram_reset_seq extends uvm_sequence #(Ram_seq_item);
        `uvm_object_utils(Ram_reset_seq)
        Ram_seq_item item;

        function new(string name = "Ram_reset_seq");
            super.new(name);
        endfunction : new

        task body();
            item = Ram_seq_item::type_id::create("item");
            start_item(item);
            item.rst_n = 0;
            item.din = '0;
            item.rx_valid = 0;
            finish_item(item);
        endtask : body  
    endclass : Ram_reset_seq
    
endpackage