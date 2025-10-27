module SPI_slave_sva(SPI_slave_if.DUT sif);
    //Sequences
    sequence write_add_seq;
        (sif.SS_n == 1) ##1 (sif.SS_n == 0) ##1 (sif.MOSI == 0) ##1 (sif.MOSI == 0) ##1 (sif.MOSI == 0);
    endsequence
    sequence read_add_seq;
        (sif.SS_n == 1) ##1 (sif.SS_n == 0) ##1 (sif.MOSI == 1) ##1 (sif.MOSI == 1) ##1 (sif.MOSI == 0);
    endsequence
    sequence read_data_seq;
        (sif.SS_n == 1) ##1 (sif.SS_n == 0) ##1 (sif.MOSI == 1) ##1 (sif.MOSI == 1) ##1 (sif.MOSI == 1);
    endsequence
    sequence write_data_seq;
        (sif.SS_n == 1) ##1 (sif.SS_n == 0) ##1 (sif.MOSI == 0) ##1 (sif.MOSI == 0) ##1 (sif.MOSI == 1);
    endsequence

    //Properties
    property reset_check;
        @(posedge sif.clk) !sif.rst_n |=> (!sif.rx_valid && !sif.rx_data && !sif.MISO);
    endproperty

    property rx_valid_after_10_cycles;
        @(posedge sif.clk) disable iff (!sif.rst_n)
            (write_add_seq or read_add_seq or read_data_seq or write_data_seq) |-> ##10 $rose(sif.rx_valid);
    endproperty

    property SS_n_eventually_after_10_cycles;
        @(posedge sif.clk) disable iff (!sif.rst_n)
            (write_add_seq or read_add_seq or read_data_seq or write_data_seq) |-> ##[10:$] $rose(sif.SS_n);
    endproperty

    //Assertions
    assert property (reset_check)                       else $error("Reset check failed: rx_valid, rx_data, and MISO expected low during reset.");
    assert property (rx_valid_after_10_cycles)          else $error("rx_valid not asserted within 10 cycles.");
    assert property (SS_n_eventually_after_10_cycles)   else $error("SS_n not asserted eventually within 10 cycles.");

    //Coverage
    cover property (reset_check);
    cover property (rx_valid_after_10_cycles);
    cover property (SS_n_eventually_after_10_cycles);
endmodule : SPI_slave_sva