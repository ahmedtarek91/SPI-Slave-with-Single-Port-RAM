package Wrapper_write_only_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Wrapper_seq_item_pkg::*;
    import Wrapper_sequencer_pkg::*;
    import Wrapper_shared_pkg::*;

    class Wrapper_write_only_seq extends uvm_sequence #(Wrapper_seq_item);
        `uvm_object_utils(Wrapper_write_only_seq)
        `uvm_declare_p_sequencer (Wrapper_sequencer) 
        Wrapper_seq_item item;

        function new(string name = "Wrapper_write_only_seq");
            super.new(name);
        endfunction : new

        task body();
            item = Wrapper_seq_item::type_id::create("item");

            repeat (1000) begin
                for (int i=10; i>=0; i--) begin
                    start_item(item);
                    item.cs = p_sequencer.sequencer_vif.cs; //get current SPI_slave state

                    if (item.rst_n == 0) begin
                        item.constraint_mode(0);
                        item.c_SS_n.constraint_mode(1);
                        item.c_rst_n.constraint_mode(1);
                        // enable randomization to set all array bits to 1 during reset
                        item.array_for_MOSI.rand_mode(1); 
                        assert(item.randomize() with { item.array_for_MOSI == 11'h7FF; });
                        i = 11;
                    end
                    else if (item.SS_n == 1) begin 
                        item.constraint_mode(1);
                        item.c_array_for_MOSI_write_only.constraint_mode(1);
                        item.c_array_for_MOSI_read_only.constraint_mode(0);
                        item.c_array_for_MOSI_read_write.constraint_mode(0);
                        // enable randomization for new array when SS_n is high
                        item.array_for_MOSI.rand_mode(1); 
                        assert(item.randomize());
                        i = 11;
                    end
                    else begin
                        item.constraint_mode(1);
                        item.c_array_for_MOSI_write_only.constraint_mode(0);
                        item.c_array_for_MOSI_read_only.constraint_mode(0);
                        item.c_array_for_MOSI_read_write.constraint_mode(0);
                        // disable randomization to keep array values stable
                        item.array_for_MOSI.rand_mode(0); 
                        // send array bits [10:0] sequentially to MOSI
                        assert(item.randomize() with {item.MOSI == item.array_for_MOSI[i];}); 
                    end

                    finish_item(item);
                end
            end
        endtask : body  
    endclass : Wrapper_write_only_seq
    
endpackage