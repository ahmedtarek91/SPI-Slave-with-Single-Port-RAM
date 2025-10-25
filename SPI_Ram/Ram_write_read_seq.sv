package Ram_write_read_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;
    import Ram_sequencer_pkg::*;
    import Ram_shared_pkg::*;

    class Ram_write_read_seq extends uvm_sequence #(Ram_seq_item);
        `uvm_object_utils(Ram_write_read_seq)
        Ram_seq_item item;

        function new(string name = "Ram_write_read_seq");
            super.new(name);
        endfunction : new

        task body();
            item = Ram_seq_item::type_id::create("item");
            
            repeat (1000) begin
                start_item(item);
                item.constraint_mode(1);
                item.c_din_write_only.constraint_mode(0);
                item.c_din_read_only.constraint_mode(0);
                assert(item.randomize());
                finish_item(item);
            end
        endtask : body  
    endclass : Ram_write_read_seq
    
endpackage