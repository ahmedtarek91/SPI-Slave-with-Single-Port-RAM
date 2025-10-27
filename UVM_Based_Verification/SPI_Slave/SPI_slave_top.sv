import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_test_pkg::*;

module top ();
    bit clk;

    always #5 clk = ~clk;

    SPI_slave_if sif(clk);

    SLAVE DUT (sif);

    Golden_slave golden_model (sif);

    assign sif.cs = DUT.cs;
    assign sif.cs_ref = golden_model.state;

    bind SLAVE SPI_slave_sva sva (sif);

    initial begin
        uvm_config_db#(virtual SPI_slave_if)::set(null, "uvm_test_top", "vif", sif);
        run_test("SPI_slave_test");
    end
endmodule