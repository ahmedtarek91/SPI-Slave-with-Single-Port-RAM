package SPI_slave_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_slave_shared_pkg::*;

    class SPI_slave_seq_item extends uvm_sequence_item;
        `uvm_object_utils(SPI_slave_seq_item)

        rand bit            rst_n, SS_n, tx_valid;
        rand bit            MOSI;
        rand bit [7:0]      tx_data;
        bit [9:0]           rx_data, rx_data_ref;
        bit                 rx_valid,rx_valid_ref, MISO, MISO_ref;
        int                 counter = 0;
        SPI_slave_state_e   cs;
        rand bit [10:0]     array_for_MOSI;

        function new(string name = "SPI_slave_seq_item");
            super.new(name);
        endfunction : new

        function string convert2string();
            return $sformatf("%s rst_n=%b, SS_n=%b, MOSI=%b, tx_valid=%b, tx_data=0x%0b, MISO=%b, rx_valid=%b, rx_data=0x%0h",
                             super.convert2string(), rst_n, SS_n, MOSI, tx_valid, tx_data, MISO, rx_valid, rx_data);
        endfunction : convert2string

        function string convert2string_stimulus();
            return $sformatf("rst_n=%b, SS_n=%b, MOSI=%b, tx_valid=%b, tx_data=0x%0b",
                             rst_n, SS_n, MOSI, tx_valid, tx_data);
        endfunction : convert2string_stimulus

        constraint c_rst_n { rst_n dist {0 := 1, 1 := 40}; }

        constraint c_SS_n { 
            if (cs == SPI_slave_state_e'(READ_DATA)) SS_n == (counter % 24 == 0);
            else SS_n == (counter % 14 == 0); 
            }
        constraint c_tx_valid { 
            if (cs == SPI_slave_state_e'(READ_DATA) && counter >= 14) tx_valid == 1; 
            else tx_valid == 0; 
            }
        constraint c_array_for_MOSI { 
            array_for_MOSI[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111}; 
            }

        function void post_randomize();
        if (rst_n == 0) counter = 0;
        else if (SS_n == 1) counter = 1;
        else counter++;
        endfunction : post_randomize

    endclass : SPI_slave_seq_item
endpackage