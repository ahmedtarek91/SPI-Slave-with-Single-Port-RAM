package Wrapper_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Wrapper_shared_pkg::*;

    class Wrapper_seq_item extends uvm_sequence_item;
        `uvm_object_utils(Wrapper_seq_item)

        rand bit            SS_n, rst_n, MOSI;
        bit                 MISO, MISO_ref;
        rand bit [10:0]     array_for_MOSI;
        int                 counter;
        SPI_slave_state_e   cs;

        bit [2:0] old_operation;

        function new(string name = "Wrapper_seq_item");
            super.new(name);
        endfunction : new

        function string convert2string();
            return $sformatf("%s SS_n=%b, rst_n=%b, MOSI=%b, array_for_MOSI=0x%0h, MISO=%b, MISO_ref=%b",
                 super.convert2string(), SS_n, rst_n, MOSI, array_for_MOSI, MISO, MISO_ref);
        endfunction : convert2string

        function string convert2string_stimulus();
            return $sformatf("SS_n=%b, rst_n=%b, MOSI=%b, array_for_MOSI=0x%0h",
                 SS_n, rst_n, MOSI, array_for_MOSI);
        endfunction : convert2string_stimulus

        constraint c_rst_n { rst_n dist {0 := 1, 1 := 40}; }

        constraint c_SS_n { 
            if (cs == SPI_slave_state_e'(READ_DATA)) SS_n == (counter % 24 == 0);
            else SS_n == (counter % 14 == 0); 
            }

        constraint c_array_for_MOSI { 
            array_for_MOSI[10:8] inside {WRITE_DATA, WRITE_ADDR, READ_DATAA, READ_ADDR}; 
            }

        constraint c_array_for_MOSI_write_only {
                array_for_MOSI[10:8] inside {WRITE_DATA, WRITE_ADDR};
            }

        constraint c_array_for_MOSI_read_only {
            if (old_operation == READ_ADDR)
                array_for_MOSI[10:8] == READ_DATAA;
            else
                array_for_MOSI[10:8] == READ_ADDR;
            }

        constraint c_array_for_MOSI_read_write { 
            if (old_operation == WRITE_ADDR)
                array_for_MOSI[10:8] inside {WRITE_DATA, WRITE_ADDR};

            else if (old_operation == WRITE_DATA)
                array_for_MOSI[10:8] dist {READ_ADDR := 60, WRITE_ADDR := 40};

            else if (old_operation == READ_ADDR)
                array_for_MOSI[10:8] == READ_DATAA;

            else
                array_for_MOSI[10:8] dist {WRITE_ADDR := 60, READ_ADDR := 40};
            }
            

        function void post_randomize();
            old_operation = array_for_MOSI[10:8];

            if (rst_n == 0) begin
                counter = 0;
            end
            else if (SS_n == 1) counter = 1;
            else counter++;
        endfunction : post_randomize

    endclass : Wrapper_seq_item
endpackage