module slave(
    input  logic             clk,
    input  logic             MOSI,
    input  logic             rst_n,
    input  logic             SS_n,
    input  logic             tx_valid,
    input  logic [7:0]       tx_data,
    output logic [9:0]       rx_data,
    output logic             rx_valid,
    output logic             MISO
);
    typedef enum logic [2:0] {
        IDLE      = 3'b000,
        WRITE     = 3'b001,
        CHK_CMD   = 3'b010,
        READ_ADD  = 3'b011,
        READ_DATA = 3'b100
    } SPI_slave_state_e;

    // FSM signals
    (*fsm_encoding ="sequential"*)
    SPI_slave_state_e   state          ,next_state;
    reg                                 next_rx_valid;
    reg [9:0]                           next_rx_data;
    reg                                 next_MISO;
    reg                 rd_addr_loaded ,next_rd_addr_loaded;
    int                 counter        ,next_counter;
     
    // state memory
    always @ (posedge clk) begin 
        if (~rst_n) begin 
            state           <= IDLE;
            rd_addr_loaded  <= 0;
            rx_valid        <= 0;
            MISO            <= 0;
            rx_data         <= 0;
            counter         <= 0;
        end
        else begin 
            state           <= next_state;
            rd_addr_loaded  <= next_rd_addr_loaded;
            rx_valid        <= next_rx_valid;
            MISO            <= next_MISO;
            rx_data         <= next_rx_data;
            counter         <= next_counter;
        end
    end

    // next state logic
    always @(*) begin
        // default 
        next_state          = state;
        next_rd_addr_loaded = rd_addr_loaded;
        next_rx_valid       = rx_valid;
        next_MISO           = MISO;
        next_rx_data        = rx_data;
        next_counter        = counter;

        case (state)
            IDLE: begin
                next_rx_valid   = 0;

                if (~SS_n)                  next_state = CHK_CMD;
            end

            CHK_CMD: begin 
                if (SS_n)                   next_state = IDLE;
                else if (~MOSI)             next_state = WRITE;
                else begin
                    if  (rd_addr_loaded)    next_state = READ_DATA;
                    else                    next_state = READ_ADD;
                end
                next_counter = 10;
            end

            WRITE: begin
                if (SS_n)                   next_state = IDLE;

                if (counter > 0) begin
                    next_rx_data [next_counter-1] = MOSI;
                    next_counter = counter - 1;
                end

                else next_rx_valid = 1;
            end

            READ_ADD: begin
                if (SS_n)                   next_state = IDLE;

                if (counter > 0) begin
                    next_rx_data [next_counter-1] = MOSI;
                    next_counter = counter - 1;
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
                    if (counter > 0) begin 
                        next_counter = counter - 1;  
                        next_MISO = tx_data[counter-1];
                    end
                    else next_rd_addr_loaded = 0;
                end
                else begin
                    if (counter > 0) begin
                        next_rx_data [next_counter-1] = MOSI;
                        next_counter = counter - 1;
                    end
                    else begin 
                        next_rx_valid = 1;
                        next_counter = 9; // added a cycle delay before sending MISO data
                    end
                end
            end
        endcase
    end

endmodule
