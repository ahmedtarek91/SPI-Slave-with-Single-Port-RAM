package SPI_slave_shared_pkg;
    typedef enum logic [2:0] {
        IDLE      = 3'b000,
        WRITE     = 3'b001,
        CHK_CMD = 3'b010,
        READ_ADD  = 3'b011,
        READ_DATA = 3'b100
    } SPI_slave_state_e;

endpackage : SPI_slave_shared_pkg