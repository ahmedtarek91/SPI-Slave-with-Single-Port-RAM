package Wrapper_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Wrapper_seq_item_pkg::*;

    class Wrapper_monitor extends uvm_monitor;
        `uvm_component_utils(Wrapper_monitor)

        virtual Wrapper_if monitor_vif;
        Wrapper_seq_item rsp_seq_item;
        uvm_analysis_port #(Wrapper_seq_item) monitor_ap;

        function new(string name = "Wrapper_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor_ap = new("monitor_ap", this);
        endfunction : build_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = Wrapper_seq_item::type_id::create("rsp_seq_item");

                @(negedge monitor_vif.clk);
                rsp_seq_item.SS_n            = monitor_vif.SS_n;
                rsp_seq_item.rst_n           = monitor_vif.rst_n;
                rsp_seq_item.MOSI            = monitor_vif.MOSI;
                rsp_seq_item.MISO            = monitor_vif.MISO;
                rsp_seq_item.MISO_ref        = monitor_vif.MISO_ref;

                monitor_ap.write(rsp_seq_item);
                `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
                
            end
        endtask : run_phase
    endclass: Wrapper_monitor
    
endpackage