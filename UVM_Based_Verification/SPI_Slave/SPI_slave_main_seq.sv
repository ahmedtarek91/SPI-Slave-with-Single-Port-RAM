package SPI_slave_main_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_slave_seq_item_pkg::*;
    import SPI_slave_sequencer_pkg::*;
    import SPI_slave_shared_pkg::*;

    class SPI_slave_main_seq extends uvm_sequence #(SPI_slave_seq_item);
        `uvm_object_utils(SPI_slave_main_seq)
        `uvm_declare_p_sequencer (SPI_slave_sequencer) 
        /*This macro gives a handle to the sequencer it’s running on.
          Lets the sequence access custom fields/methods on the sequencer.*/
        SPI_slave_seq_item item;

        function new(string name = "SPI_slave_main_seq");
            super.new(name);
        endfunction : new

        task body();
            item = SPI_slave_seq_item::type_id::create("item");
            repeat (1000) begin
                for (int i=10; i>=0; i--) begin
                    start_item(item);
                    item.cs = p_sequencer.sequencer_vif.cs; //get current SPI_slave state

                    if (item.tx_valid) item.tx_data.rand_mode(0);
                    else item.tx_data.rand_mode(1);

                    if (item.SS_n == 1) begin 
                        // enable randomization for new array when SS_n is high
                        item.array_for_MOSI.rand_mode(1);
                        assert(item.randomize());
                        i = 11;
                    end
                    else if (item.cs == IDLE) begin
                        item.array_for_MOSI.rand_mode(0);
                        assert(item.randomize());
                        i = 11;
                    end
                    else begin
                        // disable randomization to keep array values stable
                        item.array_for_MOSI.rand_mode(0);
                        // send array bits [10:0] sequentially to MOSI
                        assert(item.randomize() with { item.MOSI == item.array_for_MOSI[i]; });
                    end

                    finish_item(item);
                end
                end
        endtask : body  
    endclass : SPI_slave_main_seq
endpackage