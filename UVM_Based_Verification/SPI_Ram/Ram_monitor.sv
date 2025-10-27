package Ram_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;

    class Ram_monitor extends uvm_monitor;
        `uvm_component_utils(Ram_monitor)

        virtual Ram_if monitor_vif;
        Ram_seq_item rsp_seq_item;
        uvm_analysis_port #(Ram_seq_item) monitor_ap;

        function new(string name = "Ram_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor_ap = new("monitor_ap", this);
        endfunction : build_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = Ram_seq_item::type_id::create("rsp_seq_item");

                @(negedge monitor_vif.clk);
                rsp_seq_item.rst_n        = monitor_vif.rst_n;
                rsp_seq_item.rx_valid     = monitor_vif.rx_valid;
                rsp_seq_item.din          = monitor_vif.din;
                rsp_seq_item.tx_valid     = monitor_vif.tx_valid;
                rsp_seq_item.tx_valid_ref = monitor_vif.tx_valid_ref;
                rsp_seq_item.dout         = monitor_vif.dout;
                rsp_seq_item.dout_ref     = monitor_vif.dout_ref;

                monitor_ap.write(rsp_seq_item);
                `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
                
            end
        endtask : run_phase
    endclass: Ram_monitor
    
endpackage