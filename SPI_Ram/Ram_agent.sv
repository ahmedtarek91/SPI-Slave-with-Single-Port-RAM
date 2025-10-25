package Ram_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_driver_pkg::*;
    import Ram_monitor_pkg::*;
    import Ram_sequencer_pkg::*;
    import Ram_config_pkg::*;
    import Ram_seq_item_pkg::*;

    class Ram_agent extends uvm_agent;
        `uvm_component_utils(Ram_agent)
        Ram_driver driver;
        Ram_monitor monitor;
        Ram_sequencer sequencer;
        Ram_cfg Ram_config;
        uvm_analysis_port #(Ram_seq_item) agent_ap;

        function new(string name = "Ram_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if (!uvm_config_db#(Ram_cfg)::get(this, "", "CFG", Ram_config)) begin
                `uvm_fatal("NOVIF", "Cannot get cfg from uvm_config_db")
            end

             // only build driver and sequencer if agent is active
            if (Ram_config.is_active == UVM_ACTIVE) begin
                driver      = Ram_driver::type_id::create("driver", this);
                sequencer   = Ram_sequencer::type_id::create("sequencer", this);
            end
            
            monitor  = Ram_monitor::type_id::create("monitor", this);
            agent_ap = new("agent_ap", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            // only connect driver and sequencer if agent is active
            if (Ram_config.is_active == UVM_ACTIVE) begin
                driver.seq_item_port.connect(sequencer.seq_item_export);
                driver.driver_vif = Ram_config.Ram_vif;
            end
            monitor.monitor_ap.connect(agent_ap);
            monitor.monitor_vif = Ram_config.Ram_vif;
        endfunction : connect_phase

    endclass: Ram_agent
endpackage