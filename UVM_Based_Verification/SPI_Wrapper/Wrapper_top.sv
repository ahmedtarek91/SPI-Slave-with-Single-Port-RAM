import uvm_pkg::*;
`include "uvm_macros.svh"
import Wrapper_test_pkg::*;
import Wrapper_shared_pkg::*;

module top ();

    bit clk;
    always #5 clk = ~clk;

    Ram_if rif(clk);
    SPI_slave_if sif(clk);
    Wrapper_if wif(clk);

    WRAPPER DUT (wif);
    Golden_wrapper golden_model (wif);

    assign sif.rst_n           = DUT.SLAVE_instance.rst_n;
    assign sif.SS_n            = DUT.SLAVE_instance.SS_n;
    assign sif.MOSI            = DUT.SLAVE_instance.MOSI;
    assign sif.tx_data         = DUT.SLAVE_instance.tx_data;
    assign sif.tx_valid        = DUT.SLAVE_instance.tx_valid;
    assign sif.cs              = DUT.SLAVE_instance.cs;
    assign sif.rx_valid        = DUT.SLAVE_instance.rx_valid;
    assign sif.rx_data         = DUT.SLAVE_instance.rx_data;
    assign sif.MISO            = DUT.SLAVE_instance.MISO;
    assign sif.cs_ref          = golden_model.Slave_instance.state;
    assign sif.rx_data_ref     = golden_model.Slave_instance.rx_data_ref;
    assign sif.rx_valid_ref    = golden_model.Slave_instance.rx_valid_ref;
    assign sif.MISO_ref        = golden_model.Slave_instance.MISO_ref;
    assign sif.array_for_MOSI  = wif.array_for_MOSI;

    assign rif.rst_n           = DUT.RAM_instance.rst_n;
    assign rif.rx_valid        = DUT.RAM_instance.rx_valid;
    assign rif.din             = DUT.RAM_instance.din;
    assign rif.dout            = DUT.RAM_instance.dout;
    assign rif.tx_valid        = DUT.RAM_instance.tx_valid;
    assign rif.dout_ref        = golden_model.Ram_instance.dout_ref;
    assign rif.tx_valid_ref    = golden_model.Ram_instance.tx_valid_ref;

    assign wif.cs = SPI_slave_state_e'(DUT.SLAVE_instance.cs);

    Wrapper_sva wrapper_sva (wif);
    SPI_slave_sva spi_slave_sva (sif);
    Ram_sva ram_sva (rif);

    initial begin
        uvm_config_db#(virtual Ram_if)::set(null, "uvm_test_top", "ram_vif", rif);
        uvm_config_db#(virtual SPI_slave_if)::set(null, "uvm_test_top", "slave_vif", sif);
        uvm_config_db#(virtual Wrapper_if)::set(null, "uvm_test_top", "wrapper_vif", wif);
        run_test("Wrapper_test");
    end
endmodule