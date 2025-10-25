package Ram_coverage_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;
    import Ram_shared_pkg::*;

    class Ram_coverage extends uvm_component;
        `uvm_component_utils(Ram_coverage)
        uvm_analysis_export #(Ram_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(Ram_seq_item) cov_fifo;
        Ram_seq_item cov_item;

        // Functional Coverage
        covergroup cg_Ram;
            cp_din: coverpoint cov_item.din[9:8] {
                bins all_values[]       = {[0:3]};
                bins read_data          = {READ_DATA};
                bins wr_addr_2_wr_data  = (WRITE_ADDR => WRITE_DATA);
                bins rd_addr_2_rd_addr  = (READ_ADDR => READ_DATA);
            }
            cp_rx_valid: coverpoint cov_item.rx_valid {
                bins rx_valid_0 = {0};
                bins rx_valid_1 = {1};
            }
            cp_tx_valid: coverpoint cov_item.tx_valid {
                bins tx_valid_0 = {0};
                bins tx_valid_1 = {1};
            }
            cross_din_rx_valid: cross cp_din, cp_rx_valid {
                option.cross_auto_bin_max = 0;
                bins din_all_values_rx_valid_1 = binsof (cp_din.all_values) && binsof (cp_rx_valid.rx_valid_1);
            }

            cross_din_tx_valid: cross cp_din, cp_tx_valid {
                option.cross_auto_bin_max = 0;
                bins din_read_data_tx_valid_1 = binsof (cp_din.read_data) && binsof (cp_tx_valid.tx_valid_1);
            }
            
        endgroup : cg_Ram

        function new(string name = "Ram_coverage", uvm_component parent = null);
            super.new(name, parent);
            cg_Ram = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export  = new("cov_export", this);
            cov_fifo    = new("cov_fifo", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction : connect_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(cov_item);
                cg_Ram.sample();
            end
        endtask : run_phase


    endclass: Ram_coverage
    
endpackage