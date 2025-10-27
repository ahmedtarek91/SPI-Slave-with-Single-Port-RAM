module RAM (Ram_if.DUT rif);

reg [7:0] MEM [255:0];

reg [7:0] Rd_Addr, Wr_Addr;

always @(posedge rif.clk) begin
    if (~rif.rst_n) begin
        rif.dout      <= 0;
        rif.tx_valid  <= 0;
        Rd_Addr       <= 0;
        Wr_Addr       <= 0;
    end
    else
        if (rif.rx_valid) begin
            case (rif.din[9:8])
                2'b00   : Wr_Addr       <= rif.din[7:0];
                2'b01   : MEM[Wr_Addr]  <= rif.din[7:0];
                2'b10   : Rd_Addr       <= rif.din[7:0];
                2'b11   : rif.dout      <= MEM[Rd_Addr]; //bug: Wr_Addr ==> Rd_Addr
                default : rif.dout      <= 0;
            endcase
            //bug: tx_valid signal should only be updated when rx_valid is high, not on every clock cycle.
            rif.tx_valid <= (rif.din[9] && rif.din[8])? 1'b1 : 1'b0;
        end
        
end
endmodule