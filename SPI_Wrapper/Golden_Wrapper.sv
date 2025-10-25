module Golden_wrapper  (Wrapper_if.Golden wif);
    wire [9:0]  rx_data;
    wire        rx_valid, tx_valid;
    wire [7:0]  tx_data;

    Golden_slave Slave_instance (
        .clk(wif.clk),
        .rst_n(wif.rst_n),
        .tx_valid(tx_valid),
        .MOSI(wif.MOSI),
        .SS_n(wif.SS_n),
        .tx_data(tx_data),
        .rx_data_ref(rx_data),
        .rx_valid_ref(rx_valid),
        .MISO_ref(wif.MISO_ref)
    );

    Golden_ram Ram_instance (
        .clk(wif.clk),
        .rst_n(wif.rst_n),
        .rx_valid(rx_valid),
        .din(rx_data),
        .dout_ref(tx_data),
        .tx_valid_ref(tx_valid)
    );
endmodule