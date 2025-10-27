interface Ram_if (clk);
import Ram_shared_pkg::*;
    input logic            clk;
          logic            rst_n, rx_valid, tx_valid, tx_valid_ref;
          logic            [9:0] din;
          logic            [7:0] dout, dout_ref;


    modport DUT (
        input clk, rst_n, rx_valid, din,
        output dout, tx_valid
    );

    modport Golden (
        input clk, rst_n, rx_valid, din,
        output dout_ref, tx_valid_ref
    );

endinterface