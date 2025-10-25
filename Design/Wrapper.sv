module wrapper  (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       MOSI,
    input  logic       SS_n,
    output logic       MISO
);
    wire [9:0]  rx_data;
    wire        rx_valid, tx_valid;
    wire [7:0]  tx_data;

    slave Slave_instance (
        .clk(clk),
        .rst_n(rst_n),
        .tx_valid(tx_valid),
        .MOSI(MOSI),
        .SS_n(SS_n),
        .tx_data(tx_data),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .MISO(MISO)
    );

    ram Ram_instance (
        .clk(clk),
        .rst_n(rst_n),
        .rx_valid(rx_valid),
        .din(rx_data),
        .dout(tx_data),
        .tx_valid(tx_valid)
    );
endmodule