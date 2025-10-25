module Golden_slave(
    input  logic             clk,
    input  logic             MOSI,
    input  logic             rst_n,
    input  logic             SS_n,
    input  logic             tx_valid,
    input  logic [7:0]       tx_data,
    output logic [9:0]       rx_data_ref,
    output logic             rx_valid_ref,
    output logic             MISO_ref
);
    import SPI_slave_shared_pkg::*;

    // FSM signals
    SPI_slave_state_e   state          ,next_state;
    reg                                 next_rx_valid;
    reg [9:0]                           next_rx_data;
    reg                                 next_MISO;
    reg                 rd_addr_loaded ,next_rd_addr_loaded;
    int                 counter_ref    ,next_counter_ref;
     
    // state memory
    always @ (posedge clk) begin 
        if (~rst_n) begin 
            state           <= IDLE;
            rd_addr_loaded  <= 0;
            rx_valid_ref    <= 0;
            MISO_ref        <= 0;
            rx_data_ref     <= 0;
            counter_ref     <= 0;
        end
        else begin 
            state           <= next_state;
            rd_addr_loaded  <= next_rd_addr_loaded;
            rx_valid_ref    <= next_rx_valid;
            MISO_ref        <= next_MISO;
            rx_data_ref     <= next_rx_data;
            counter_ref     <= next_counter_ref;
        end
    end

    // next state logic
    always @(*) begin
        // default 
        next_state          = state;
        next_rd_addr_loaded = rd_addr_loaded;
        next_rx_valid   = rx_valid_ref;
        next_MISO       = MISO_ref;
        next_rx_data    = rx_data_ref;
        next_counter_ref    = counter_ref;

        case (state)
            IDLE: begin
                next_rx_valid   = 0;

                if (~SS_n)                  next_state = CHK_CMD;
            end

            CHK_CMD: begin 
                if      (SS_n)              next_state = IDLE;
                else if (~MOSI)             next_state = WRITE;
                else begin
                    if  (rd_addr_loaded)    next_state = READ_DATA;
                    else                    next_state = READ_ADD;
                end
                next_counter_ref = 10;
            end

            WRITE: begin
                if (SS_n)                   next_state = IDLE;

                if (counter_ref > 0) begin
                    next_rx_data [next_counter_ref-1] = MOSI;
                    next_counter_ref = counter_ref - 1;

                end

                else next_rx_valid = 1;
            end

            READ_ADD: begin
                if (SS_n)                   next_state = IDLE;

                if (counter_ref > 0) begin
                    next_rx_data [next_counter_ref-1] = MOSI;
                    next_counter_ref = counter_ref - 1;

                end
                else begin 
                    next_rx_valid = 1;
                    next_rd_addr_loaded = 1;
                end
            end

            READ_DATA: begin 
                if (SS_n)                   next_state = IDLE;

                if (tx_valid) // Data is ready to be serialed out on MISO
                begin 
                    next_rx_valid = 0;
                    if (counter_ref > 0) begin 
                        next_counter_ref = counter_ref - 1;  
                        next_MISO = tx_data[counter_ref-1];
                    end
                    else next_rd_addr_loaded = 0;
                end
                else begin
                    if (counter_ref > 0) begin
                    next_rx_data [next_counter_ref-1] = MOSI;
                    next_counter_ref = counter_ref - 1;
                    end
                    else begin 
                        next_rx_valid = 1;
                        next_counter_ref = 9;
                    end
                end
            end
        endcase
    end

endmodule
