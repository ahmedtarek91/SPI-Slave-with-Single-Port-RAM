package SPI_slave_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_slave_seq_item_pkg::*;

    class SPI_slave_monitor extends uvm_monitor;
        `uvm_component_utils(SPI_slave_monitor)

        virtual SPI_slave_if monitor_vif;
        SPI_slave_seq_item rsp_seq_item;
        uvm_analysis_port #(SPI_slave_seq_item) monitor_ap;

        function new(string name = "SPI_slave_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor_ap = new("monitor_ap", this);
        endfunction : build_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = SPI_slave_seq_item::type_id::create("rsp_seq_item");

                @(negedge monitor_vif.clk);
                rsp_seq_item.SS_n          = monitor_vif.SS_n;
                rsp_seq_item.rst_n         = monitor_vif.rst_n;
                rsp_seq_item.MOSI          = monitor_vif.MOSI;
                rsp_seq_item.tx_data       = monitor_vif.tx_data;
                rsp_seq_item.tx_valid      = monitor_vif.tx_valid;
                rsp_seq_item.rx_data       = monitor_vif.rx_data;
                rsp_seq_item.rx_data_ref   = monitor_vif.rx_data_ref;
                rsp_seq_item.MISO          = monitor_vif.MISO;
                rsp_seq_item.MISO_ref      = monitor_vif.MISO_ref;
                rsp_seq_item.rx_valid      = monitor_vif.rx_valid;
                rsp_seq_item.rx_valid_ref  = monitor_vif.rx_valid_ref;
                rsp_seq_item.cs            = monitor_vif.cs;

                monitor_ap.write(rsp_seq_item);
                `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
                
            end
        endtask : run_phase
    endclass: SPI_slave_monitor
    
endpackage