module Ram_sva(Ram_if.DUT rif);
    import Ram_shared_pkg::*;

    //Sequences
    sequence write_addr_seq;
            (rif.rx_valid && (rif.din[9:8] == WRITE_ADDR));
    endsequence

    sequence write_data_seq;
            (rif.rx_valid && (rif.din[9:8] == WRITE_DATA));
    endsequence

    sequence read_addr_seq;
            (rif.rx_valid && (rif.din[9:8] == READ_ADDR));
    endsequence

    sequence read_data_seq;
            (rif.rx_valid && (rif.din[9:8] == READ_DATA));
    endsequence

    //Properties
    property reset;
        @(posedge rif.clk) !rif.rst_n |=> (!rif.dout) && (!rif.tx_valid);
    endproperty

    property read_data_tx_valid;
        @(posedge rif.clk) disable iff (!rif.rst_n)
            read_data_seq |=> (rif.tx_valid) |-> ##[1:$] (!rif.tx_valid);
    endproperty

    property other_tx_valid;
        @(posedge rif.clk) disable iff (!rif.rst_n)
            (write_addr_seq or write_data_seq or read_addr_seq) |=> (!rif.tx_valid);
    endproperty

    property write_addr_write_data;
        @(posedge rif.clk) disable iff (!rif.rst_n)
            write_addr_seq |-> ##[1:$] write_data_seq;
    endproperty

    property read_addr_read_data;
        @(posedge rif.clk) disable iff (!rif.rst_n)
            read_addr_seq |-> ##[1:$] read_data_seq;
    endproperty

    //Assertions
    assert property (reset)                 else $error ("Reset failed: dout and tx_valid should be zero after reset");
    assert property (read_data_tx_valid)    else $error ("Read data tx_valid failed: tx_valid should be set after read data command and cleared afterwards");
    assert property (other_tx_valid)        else $error ("Other operations tx_valid failed: tx_valid should be zero after other commands");
    assert property (write_addr_write_data) else $error ("Write addr-data sequence failed: write data command did not follow write address command");
    assert property (read_addr_read_data)   else $error ("Read addr-data sequence failed: read data command did not follow read address command");

    // Coverage
    cover property (reset);
    cover property (read_data_tx_valid);
    cover property (other_tx_valid);
    cover property (write_addr_write_data);
    cover property (read_addr_read_data);
endmodule : Ram_sva