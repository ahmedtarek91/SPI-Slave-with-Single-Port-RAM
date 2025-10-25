package Wrapper_coverage_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Wrapper_seq_item_pkg::*;
    import Wrapper_shared_pkg::*;

    class Wrapper_coverage extends uvm_component;
        `uvm_component_utils(Wrapper_coverage)
        uvm_analysis_export #(Wrapper_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(Wrapper_seq_item) cov_fifo;
        Wrapper_seq_item cov_item;

        // Functional Coverage
        covergroup cg_Wrapper;
            cp_SS_n: coverpoint cov_item.SS_n {
                bins SS_n_OTHER     = (1=> 0[*13] => 1);
                bins SS_n_READ_DATA = (1=> 0[*23] => 1);
                bins SS_n_one2zero  = (1 => 0);
            }
            cp_MOSI: coverpoint cov_item.MOSI {
                bins write_address  = (0=>0=>0);
                bins write_data     = (0=>0=>1);
                bins read_address   = (1=>1=>0);
                bins read_data      = (1=>1=>1);
            }
            cross_MOSI_SS_n: cross cp_MOSI, cp_SS_n {
                option.cross_auto_bin_max = 0;
                bins Read_data_SS_n_READ_DATA   = binsof(cp_MOSI.read_data) && binsof(cp_SS_n.SS_n_READ_DATA);
                bins Write_data_SS_n_OTHER      = binsof(cp_MOSI.write_data) && binsof(cp_SS_n.SS_n_OTHER);
                bins Read_address_SS_n_OTHER    = binsof(cp_MOSI.read_address) && binsof(cp_SS_n.SS_n_OTHER);
                bins Write_address_SS_n_OTHER   = binsof(cp_MOSI.write_address) && binsof(cp_SS_n.SS_n_OTHER);
            }
            
        endgroup : cg_Wrapper

        function new(string name = "Wrapper_coverage", uvm_component parent = null);
            super.new(name, parent);
            cg_Wrapper = new();
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
                cg_Wrapper.sample();
            end
        endtask : run_phase
    endclass: Wrapper_coverage
endpackage