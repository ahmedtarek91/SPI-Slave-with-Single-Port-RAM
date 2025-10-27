module Wrapper_sva(Wrapper_if.DUT wif);
//Sequences
    sequence write_add_seq;
        (wif.SS_n == 1) ##1 (wif.SS_n == 0) ##1 (wif.MOSI == 0) ##1 (wif.MOSI == 0) ##1 (wif.MOSI == 0);
    endsequence

    sequence read_add_seq;
        (wif.SS_n == 1) ##1 (wif.SS_n == 0) ##1 (wif.MOSI == 1) ##1 (wif.MOSI == 1) ##1 (wif.MOSI == 0);
    endsequence

    sequence write_data_seq;
        (wif.SS_n == 1) ##1 (wif.SS_n == 0) ##1 (wif.MOSI == 0) ##1 (wif.MOSI == 0) ##1 (wif.MOSI == 1);
    endsequence

//properties
    property reset_check;
        @(posedge wif.clk) !wif.rst_n |=> (!wif.MISO);
    endproperty : reset_check

    property write_add_stable_MISO;
        @(posedge wif.clk) disable iff (!wif.rst_n) 
        write_add_seq |=> (($stable(wif.MISO) throughout wif.SS_n[->1]));
    endproperty : write_add_stable_MISO

    property read_add_stable_MISO;
        @(posedge wif.clk) disable iff (!wif.rst_n) 
        read_add_seq |=> (($stable(wif.MISO) throughout wif.SS_n[->1]));
    endproperty : read_add_stable_MISO

    property write_data_stable_MISO;
        @(posedge wif.clk) disable iff (!wif.rst_n) 
        write_data_seq |=> (($stable(wif.MISO) throughout wif.SS_n[->1]));
    endproperty : write_data_stable_MISO

//Assertions
    assert property (reset_check) else $error("SVA-ERROR: Reset check failed");
    assert property (write_add_stable_MISO) else $error("SVA-ERROR: MISO changed during write address transaction");
    assert property (read_add_stable_MISO) else $error("SVA-ERROR: MISO changed during read address transaction");
    assert property (write_data_stable_MISO) else $error("SVA-ERROR: MISO changed during write data transaction");
//Coverage
    cover property (reset_check);
    cover property (write_add_stable_MISO);
    cover property (read_add_stable_MISO);
    cover property (write_data_stable_MISO);
endmodule : Wrapper_sva