module Golden_slave(SPI_slave_if.Golden sif);
    import SPI_slave_shared_pkg::*;

    // FSM signals
    SPI_slave_state_e   state          ,next_state;
    reg                                 next_rx_valid;
    reg [9:0]                           next_rx_data;
    reg                                 next_MISO;
    reg                 rd_addr_loaded ,next_rd_addr_loaded;
    int                 counter        ,next_counter;
     
    // state memory
    always @ (posedge sif.clk) begin 
        if (~sif.rst_n) begin 
            state            <= IDLE;
            rd_addr_loaded   <= 0;
            sif.rx_valid_ref <= 0;
            sif.MISO_ref     <= 0;
            sif.rx_data_ref  <= 0;
            counter          <= 0;
        end
        else begin 
            state            <= next_state;
            rd_addr_loaded   <= next_rd_addr_loaded;
            sif.rx_valid_ref <= next_rx_valid;
            sif.MISO_ref     <= next_MISO;
            sif.rx_data_ref  <= next_rx_data;
            counter          <= next_counter;
        end
    end

    // next state logic
    always @(*) begin
        // default 
        next_state           = state;
        next_rd_addr_loaded  = rd_addr_loaded;
        next_rx_valid        = sif.rx_valid_ref;
        next_MISO            = sif.MISO_ref;
        next_rx_data         = sif.rx_data_ref;
        next_counter         = counter;

        case (state)
            IDLE: begin
                next_rx_valid   = 0;

                if (~sif.SS_n) next_state = CHK_CMD;
            end

            CHK_CMD: begin 
                if (sif.SS_n) next_state = IDLE;
                else if (~sif.MOSI) next_state = WRITE;
                else begin
                    if  (rd_addr_loaded) next_state = READ_DATA;
                    else next_state = READ_ADD;
                end
                next_counter = 10;
            end

            WRITE: begin
                if (sif.SS_n) next_state = IDLE;

                if (counter > 0) begin
                    next_rx_data [next_counter-1] = sif.MOSI;
                    next_counter = counter - 1;
                end

                else next_rx_valid = 1;
            end

            READ_ADD: begin
                if (sif.SS_n) next_state = IDLE;

                if (counter > 0) begin
                    next_rx_data [next_counter-1] = sif.MOSI;
                    next_counter = counter - 1;
                end
                else begin 
                    next_rx_valid = 1;
                    next_rd_addr_loaded = 1;
                end
            end

            READ_DATA: begin 
                if (sif.SS_n) next_state = IDLE;

                // Data is ready to be serialed out on MISO
                if (sif.tx_valid) 
                begin 
                    next_rx_valid = 0;
                    if (counter > 0) begin 
                        next_counter = counter - 1;  
                        next_MISO = sif.tx_data[counter-1];
                    end
                    else next_rd_addr_loaded = 0;
                end
                else begin
                    if (counter > 0) begin
                        next_rx_data [next_counter-1] = sif.MOSI;
                        next_counter = counter - 1;
                    end
                    else begin 
                        next_rx_valid = 1;
                        // added a cycle delay before sending MISO data
                        next_counter = 8;
                    end
                end
            end
        endcase
    end
endmodule
