package Ram_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_shared_pkg::*;

    class Ram_seq_item extends uvm_sequence_item;
        `uvm_object_utils(Ram_seq_item)

        rand bit            rst_n, rx_valid;
        rand bit [9:0]      din;
        bit                 tx_valid, tx_valid_ref;
        bit      [7:0]      dout, dout_ref;
        bit      [1:0]      old_operation;

        function new(string name = "Ram_seq_item");
            super.new(name);
        endfunction : new

        function string convert2string();
            return $sformatf("%s rst_n=%b, din=0x%0h, tx_valid=%b, dout=0x%0h, rx_valid=%b, dout_ref=0x%0h, tx_valid_ref=%b",
                     super.convert2string(), rst_n, din, tx_valid, dout, rx_valid, dout_ref, tx_valid_ref);
        endfunction : convert2string

        function string convert2string_stimulus();
            return $sformatf("rst_n=%b, din=0x%0h, tx_valid=%b",
                     rst_n, din, tx_valid);
        endfunction : convert2string_stimulus

        constraint c_rst_n { rst_n dist {0 := 1, 1 := 9}; }

        constraint c_rx_valid { rx_valid dist {0 := 1, 1 := 9};}

        constraint c_din_write_only {
                din[9:8] inside {WRITE_DATA, WRITE_ADDR};
            }

        constraint c_din_read_only {
                din[9:8] inside {READ_DATA, READ_ADDR};
                if (old_operation == READ_ADDR)
                    din[9:8] == READ_DATA;
                else
                    din[9:8] == READ_ADDR;
            }

        constraint c_din_read_write { 
            if      (old_operation == WRITE_ADDR)
                din[9:8] inside {WRITE_DATA, WRITE_ADDR};

            else if (old_operation == WRITE_DATA)
                din[9:8] dist {READ_ADDR := 60, WRITE_ADDR := 40};

            else if (old_operation == READ_ADDR)
                din[9:8] == READ_DATA;

            else
                din[9:8] dist {WRITE_ADDR := 60, READ_ADDR := 40};
            }

        function void post_randomize();
            old_operation = din[9:8];
        endfunction : post_randomize

    endclass : Ram_seq_item
endpackage