interface Wrapper_if (clk);
import Wrapper_shared_pkg::*;
    input logic             clk;
          logic             SS_n, rst_n, MOSI;
          logic             MISO, MISO_ref;
          logic [10:0]      array_for_MOSI;
          SPI_slave_state_e cs;
          bit [2:0]         old_operation;

    modport DUT (
        input  clk, rst_n, SS_n, MOSI,
        output MISO
    );

    modport Golden (
        input  clk, rst_n, SS_n, MOSI,
        output MISO_ref
    );
endinterface