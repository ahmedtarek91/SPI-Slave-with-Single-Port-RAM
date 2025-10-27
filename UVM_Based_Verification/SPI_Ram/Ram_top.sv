import uvm_pkg::*;
`include "uvm_macros.svh"
import Ram_test_pkg::*;

module top ();
    bit clk;

    always #5 clk = ~clk;

    Ram_if rif(clk);

    RAM DUT (rif);

    Golden_ram golden_model (rif);

    bind RAM Ram_sva sva (rif);

    initial begin
        uvm_config_db#(virtual Ram_if)::set(null, "uvm_test_top", "vif", rif);
        run_test("Ram_test");
    end
endmodule