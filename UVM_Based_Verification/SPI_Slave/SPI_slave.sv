module SLAVE (SPI_slave_if.DUT sif);
import SPI_slave_shared_pkg::*;

SPI_slave_state_e cs, ns;

int       counter;
reg       received_address;


always @(posedge sif.clk) begin
    if (~sif.rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (sif.SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (sif.SS_n)
                ns = IDLE;
            else begin
                if (~sif.MOSI)
                    ns = WRITE;
                else begin
                    if (received_address) 
                        ns = READ_DATA; //bug: READ_ADD ==> READ_DATA
                    else
                        ns = READ_ADD; //bug: READ_DATA ==> READ_ADD
                end
            end
        end
        WRITE : begin
            if (sif.SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (sif.SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (sif.SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge sif.clk) begin
    if (~sif.rst_n) begin 
        sif.rx_data <= 0;
        sif.rx_valid <= 0;
        received_address <= 0;
        sif.MISO <= 0;
        counter <= 0; // bug: reset counter on reset
    end
    else begin
        case (cs)
            IDLE : begin
                sif.rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;
            end
            WRITE : begin
                if (counter > 0) begin
                    sif.rx_data[counter-1] <= sif.MOSI;
                    counter <= counter - 1;
                end
                else begin
                    sif.rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    sif.rx_data[counter-1] <= sif.MOSI;
                    counter <= counter - 1;
                end
                else begin
                    sif.rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (sif.tx_valid) begin
                    sif.rx_valid <= 0; 
                    if (counter > 0) begin
                        sif.MISO <= sif.tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin
                        sif.rx_data[counter-1] <= sif.MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        sif.rx_valid <= 1;
                        counter <= 8;
                    end
                end
            end
        endcase
    end
end

///////////////////////////////////////////////////////////
`ifdef SIM
    // Properties
    property p_IDLE_to_CHK_CMD;
        @(posedge sif.clk) disable iff (!sif.rst_n) (cs == IDLE && !sif.SS_n) |=> (cs == CHK_CMD);
    endproperty


    property p_CHK_CMD_to_WRITE;
        @(posedge sif.clk) disable iff (!sif.rst_n) (cs == CHK_CMD && !sif.MOSI) |=> (cs == WRITE);
    endproperty


    property p_CHK_CMD_to_READ_ADD;
        @(posedge sif.clk) disable iff (!sif.rst_n) (cs == CHK_CMD && sif.MOSI && !received_address) |=> (cs == READ_ADD);  
    endproperty


    property p_CHK_CMD_to_READ_DATA;
        @(posedge sif.clk) disable iff (!sif.rst_n) (cs == CHK_CMD && sif.MOSI && received_address) |=> (cs == READ_DATA);
    endproperty


    property p_WRITE_to_IDLE;
        @(posedge sif.clk) disable iff (!sif.rst_n) (cs == WRITE && sif.SS_n) |=> (cs == IDLE);
    endproperty


    property p_READ_ADD_to_IDLE;
        @(posedge sif.clk) disable iff (!sif.rst_n) (cs == READ_ADD && sif.SS_n) |=> (cs == IDLE);
    endproperty


    property p_READ_DATA_to_IDLE;
        @(posedge sif.clk) disable iff (!sif.rst_n) (cs == READ_DATA && sif.SS_n) |=> (cs == IDLE);
    endproperty


    // Assertions
    assert property (p_IDLE_to_CHK_CMD) else $error("Illegal FSM transition: IDLE must only go to CHK_CMD");
    assert property (p_CHK_CMD_to_READ_ADD) else $error("Illegal FSM transition: CHK_CMD must only go to READ_AD");
    assert property (p_CHK_CMD_to_READ_DATA) else $error("Illegal FSM transition: CHK_CMD must only go toREAD_DATA");
    assert property (p_CHK_CMD_to_WRITE) else $error("Illegal FSM transition: CHK_CMD must only go to WRITE");
    assert property (p_WRITE_to_IDLE) else $error("Illegal FSM transition: WRITE must return to IDLE");
    assert property (p_READ_ADD_to_IDLE) else $error("Illegal FSM transition: READ_ADD must return to IDLE");
    assert property (p_READ_DATA_to_IDLE) else $error("Illegal FSM transition: READ_DATA must return to IDLE");

    //Coverage
    cover property (p_IDLE_to_CHK_CMD);
    cover property (p_CHK_CMD_to_READ_ADD);
    cover property (p_CHK_CMD_to_READ_DATA);
    cover property (p_CHK_CMD_to_WRITE);
    cover property (p_WRITE_to_IDLE);
    cover property (p_READ_ADD_to_IDLE);
    cover property (p_READ_DATA_to_IDLE);
    
`endif
endmodule