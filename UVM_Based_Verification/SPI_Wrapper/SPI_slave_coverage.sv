package SPI_slave_coverage_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_slave_seq_item_pkg::*;
    import SPI_slave_shared_pkg::*;

    class SPI_slave_coverage extends uvm_component;
        `uvm_component_utils(SPI_slave_coverage)
        uvm_analysis_export #(SPI_slave_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(SPI_slave_seq_item) cov_fifo;
        SPI_slave_seq_item cov_item;

        // Functional Coverage
        covergroup cg_SPI_slave;
            cp_rxdata: coverpoint cov_item.rx_data[9:8] {
                bins all_values[] = {[0:3]};
                bins all_transitions[] = (0 => 0), (0 => 1), (0 => 2), (0 => 3),
                                      (1 => 0), (1 => 1), (1 => 2), (1 => 3),
                                      (2 => 0), (2 => 1), (2 => 2), (2 => 3),
                                      (3 => 0), (3 => 1), (3 => 2), (3 => 3);
                ignore_bins rx_data_bins_ignored[] = (0 => 3),(2 => 1),(1 => 2);// Ignore invalid transactions as they require multiple bit toggles at same cycle
            }
            
            cp_SS_n: coverpoint cov_item.SS_n {
                bins SS_n_OTHER = (1=> 0[*13] => 1);
                bins SS_n_READ_DATA = (1=> 0[*23] => 1);
                bins SS_n_one2zero = (1 => 0);
            }
            cp_MOSI: coverpoint cov_item.MOSI {
                bins write_address = (0=>0=>0);
                bins write_data = (0=>0=>1);
                bins read_address = (1=>1=>0);
                bins read_data = (1=>1=>1);
            }
            cross_MOSI_SS_n: cross cp_MOSI, cp_SS_n {
                option.cross_auto_bin_max = 0;
                bins Read_data_SS_n_one2zero = binsof(cp_MOSI.read_data) && binsof(cp_SS_n.SS_n_one2zero);
                bins Write_data_SS_n_one2zero = binsof(cp_MOSI.write_data) && binsof(cp_SS_n.SS_n_one2zero);
                bins Read_address_SS_n_one2zero = binsof(cp_MOSI.read_address) && binsof(cp_SS_n.SS_n_one2zero);
                bins Write_address_SS_n_one2zero = binsof(cp_MOSI.write_address) && binsof(cp_SS_n.SS_n_one2zero);
            }
        endgroup : cg_SPI_slave

        function new(string name = "SPI_slave_coverage", uvm_component parent = null);
            super.new(name, parent);
            cg_SPI_slave = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction : connect_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(cov_item);
                cg_SPI_slave.sample();
            end
        endtask : run_phase


    endclass: SPI_slave_coverage
    
endpackage