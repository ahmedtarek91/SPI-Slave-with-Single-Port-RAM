interface SPI_slave_if (clk);
import SPI_slave_shared_pkg::*;
    input logic                     clk;
          logic                     MOSI, rst_n, SS_n, tx_valid;
          logic             [7:0]   tx_data;
          logic             [9:0]   rx_data, rx_data_ref;
          logic                     rx_valid, rx_valid_ref, MISO, MISO_ref;
          SPI_slave_state_e         cs, cs_ref;
          bit               [10:0]  array_for_MOSI;

    modport DUT (
        input clk, MOSI, rst_n, SS_n, tx_valid, tx_data,
        output rx_data, rx_valid, MISO
    );

    modport Golden (
        input clk, MOSI, rst_n, SS_n, tx_valid, tx_data,
        output rx_data_ref, rx_valid_ref, MISO_ref
    );
endinterface