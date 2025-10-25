module RAM (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        rx_valid,
    input  logic [9:0]  din,
    output logic [7:0]  dout,
    output logic        tx_valid
);

reg [7:0] MEM [255:0];

reg [7:0] Rd_Addr, Wr_Addr;

always @(posedge clk) begin
    if (~rst_n) begin
        dout      <= 0;
        tx_valid  <= 0;
        Rd_Addr   <= 0;
        Wr_Addr   <= 0;
    end
    else
        if (rx_valid) begin
            case (din[9:8])
                2'b00   : Wr_Addr       <= din[7:0];
                2'b01   : MEM[Wr_Addr]  <= din[7:0];
                2'b10   : Rd_Addr       <= din[7:0];
                2'b11   : dout          <= MEM[Rd_Addr]; // bug: Wr_Addr ==> Rd_Addr
                default : dout          <= 0;
            endcase
            //bug: tx_valid signal should only be updated when rx_valid is high, not on every clock cycle.
            tx_valid <= (din[9] && din[8])? 1'b1 : 1'b0; 
        end
        
end
endmodule