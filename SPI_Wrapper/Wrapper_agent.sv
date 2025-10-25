package Wrapper_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Wrapper_driver_pkg::*;
    import Wrapper_monitor_pkg::*;
    import Wrapper_sequencer_pkg::*;
    import Wrapper_config_pkg::*;
    import Wrapper_seq_item_pkg::*;

    class Wrapper_agent extends uvm_agent;
        `uvm_component_utils(Wrapper_agent)
        Wrapper_driver driver;
        Wrapper_monitor monitor;
        Wrapper_sequencer sequencer;
        Wrapper_cfg Wrapper_config;
        uvm_analysis_port #(Wrapper_seq_item) agent_ap;

        function new(string name = "Wrapper_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if (!uvm_config_db#(Wrapper_cfg)::get(this, "", "wrapper_CFG", Wrapper_config)) begin
                `uvm_fatal("NOVIF", "Cannot get cfg from uvm_config_db")
            end
            if (Wrapper_config.is_active == UVM_ACTIVE) begin
                driver      = Wrapper_driver::type_id::create("driver", this);
                sequencer   = Wrapper_sequencer::type_id::create("sequencer", this);
            end
            monitor = Wrapper_monitor::type_id::create("monitor", this);
            agent_ap = new("agent_ap", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if (Wrapper_config.is_active == UVM_ACTIVE) begin
                driver.seq_item_port.connect(sequencer.seq_item_export);
                driver.driver_vif       = Wrapper_config.Wrapper_vif;
                sequencer.sequencer_vif = Wrapper_config.Wrapper_vif;
            end
            monitor.monitor_ap.connect(agent_ap);
            monitor.monitor_vif         = Wrapper_config.Wrapper_vif;
        endfunction : connect_phase

    endclass: Wrapper_agent
endpackage