module ram (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        rx_valid,
    input  logic [9:0]  din,
    output logic [7:0]  dout,
    output logic        tx_valid
);

    reg [7:0] mem [255:0];
    reg [7:0] rd_address, wr_address;

    always @(posedge clk) begin
        if (!rst_n) begin
            dout                <= 0;
            tx_valid            <= 0;
            rd_address          <= 0;
            wr_address          <= 0;
        end 
        else if (rx_valid) begin
            if (din[9:8] == 2'b00) begin
                wr_address      <= din[7:0];
                tx_valid        <= 0; 
            end 
            else if (din[9:8] == 2'b01) begin
                mem[wr_address] <= din[7:0];
                tx_valid        <= 0; 
            end
            else if (din[9:8] == 2'b10) begin
                rd_address      <= din[7:0];
                tx_valid        <= 0; 
            end
            else if (din[9:8] == 2'b11) begin
                dout            <= mem[rd_address];
                tx_valid        <= 1; 
            end 
        end 
    end

endmodule