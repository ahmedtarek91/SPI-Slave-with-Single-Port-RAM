module Golden_ram (Ram_if.Golden rif);

    reg [7:0] mem [255:0];
    reg [7:0] rd_address, wr_address;

    always @(posedge rif.clk) begin
        if (!rif.rst_n) begin
            rif.dout_ref <= 0;
            rif.tx_valid_ref <= 0;
            rd_address <= 0;
            wr_address <= 0;
        end 
        else if (rif.rx_valid) begin
            if (rif.din[9:8] == 2'b00) begin
                wr_address <= rif.din [7:0];
                rif.tx_valid_ref <= 0; 
            end 
            else if (rif.din[9:8] == 2'b01) begin
                mem[wr_address] <= rif.din [7:0];
                rif.tx_valid_ref <= 0; 
            end
            else if (rif.din[9:8] == 2'b10) begin
                rd_address <= rif.din [7:0];
                rif.tx_valid_ref <= 0; 
            end
            else if (rif.din[9:8] == 2'b11) begin
                rif.dout_ref <= mem[rd_address];
                rif.tx_valid_ref <= 1; 
            end 
        end 
    end

endmodule