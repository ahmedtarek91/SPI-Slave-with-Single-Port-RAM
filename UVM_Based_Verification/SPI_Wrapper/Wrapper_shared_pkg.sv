package Wrapper_shared_pkg;
    parameter WRITE_ADDR = 3'b000;
    parameter WRITE_DATA = 3'b001;
    parameter READ_ADDR  = 3'b110;
    parameter READ_DATAA   = 3'b111;

    typedef enum logic [2:0] {
        IDLE      = 3'b000,
        WRITE     = 3'b001,
        CHK_CMD   = 3'b010,
        READ_ADD  = 3'b011,
        READ_DATA = 3'b100
    } SPI_slave_state_e;
endpackage : Wrapper_shared_pkg