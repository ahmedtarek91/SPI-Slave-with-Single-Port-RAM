package SPI_slave_reset_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_slave_seq_item_pkg::*;
    import SPI_slave_sequencer_pkg::*;

    class SPI_slave_reset_seq extends uvm_sequence #(SPI_slave_seq_item);
        `uvm_object_utils(SPI_slave_reset_seq)
        `uvm_declare_p_sequencer (SPI_slave_sequencer) 
        /*This macro gives a handle to the sequencer it’s running on.
          Lets the sequence access custom fields/methods on the sequencer.*/
        SPI_slave_seq_item item;

        function new(string name = "SPI_slave_reset_seq");
            super.new(name);
        endfunction : new

        task body();
            item = SPI_slave_seq_item::type_id::create("item");
                start_item(item);
                item.rst_n = 0;
                item.SS_n = 1;
                item.MOSI = 0;
                item.tx_valid = 0;
                item.tx_data = 0;
                item.array_for_MOSI = 0;
                finish_item(item);
                
        endtask : body  
    endclass : SPI_slave_reset_seq
    
endpackage