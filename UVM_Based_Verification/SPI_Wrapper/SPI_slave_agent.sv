package SPI_slave_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_slave_driver_pkg::*;
    import SPI_slave_monitor_pkg::*;
    import SPI_slave_sequencer_pkg::*;
    import SPI_slave_config_pkg::*;
    import SPI_slave_seq_item_pkg::*;

    class SPI_slave_agent extends uvm_agent;
        `uvm_component_utils(SPI_slave_agent)
        SPI_slave_driver driver;
        SPI_slave_monitor monitor;
        SPI_slave_sequencer sequencer;
        SPI_slave_cfg SPI_slave_config;
        uvm_analysis_port #(SPI_slave_seq_item) agent_ap;

        function new(string name = "SPI_slave_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if (!uvm_config_db#(SPI_slave_cfg)::get(this, "", "slave_CFG", SPI_slave_config)) begin
                `uvm_fatal("NOVIF", "Cannot get cfg from uvm_config_db")
            end
            if (SPI_slave_config.is_active == UVM_ACTIVE) begin // only build driver and sequencer if agent is active
                driver      = SPI_slave_driver::type_id::create("driver", this);
                sequencer   = SPI_slave_sequencer::type_id::create("sequencer", this);
            end

            monitor = SPI_slave_monitor::type_id::create("monitor", this);
            agent_ap = new("agent_ap", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if (SPI_slave_config.is_active == UVM_ACTIVE) begin // only connect driver and sequencer if agent is active
                driver.seq_item_port.connect(sequencer.seq_item_export);
                driver.driver_vif       = SPI_slave_config.Slave_vif;
                sequencer.sequencer_vif = SPI_slave_config.Slave_vif;
            end
            monitor.monitor_ap.connect(agent_ap);
            monitor.monitor_vif = SPI_slave_config.Slave_vif;
            
        endfunction : connect_phase

    endclass: SPI_slave_agent
endpackage