module WRAPPER (Wrapper_if.DUT wif);
wire [9:0] rx_data_din;
wire       rx_valid, tx_valid;
wire [7:0] tx_data_dout;

    SLAVE SLAVE_instance (
        .MOSI(wif.MOSI), 
        .MISO(wif.MISO), 
        .SS_n(wif.SS_n), 
        .clk(wif.clk), 
        .rst_n(wif.rst_n), 
        .rx_data(rx_data_din), 
        .rx_valid(rx_valid), 
        .tx_data(tx_data_dout), 
        .tx_valid(tx_valid)
    );

    RAM   RAM_instance (
        .din(rx_data_din),
        .clk(wif.clk), 
        .rst_n(wif.rst_n), 
        .rx_valid(rx_valid), 
        .dout(tx_data_dout), 
        .tx_valid(tx_valid)
    );

endmodule