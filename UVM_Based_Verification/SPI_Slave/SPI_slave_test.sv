package SPI_slave_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_slave_env_pkg::*;
    import SPI_slave_config_pkg::*;
    import SPI_slave_main_seq_pkg::*;
    import SPI_slave_reset_seq_pkg::*;

    class SPI_slave_test extends uvm_test;
        `uvm_component_utils(SPI_slave_test)

        SPI_slave_env env;
        SPI_slave_reset_seq reset_sequence;
        SPI_slave_main_seq main_sequence;
        SPI_slave_cfg SPI_slave_config;
        
        function new(string name = "SPI_slave_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = SPI_slave_env::type_id::create("env", this);
            reset_sequence = SPI_slave_reset_seq::type_id::create("reset_sequence");
            main_sequence = SPI_slave_main_seq::type_id::create("main_sequence");
            SPI_slave_config = SPI_slave_cfg::type_id::create("SPI_slave_config");

            if(!uvm_config_db#(virtual SPI_slave_if)::get(this, "", "vif", SPI_slave_config.SPI_vif))
                `uvm_fatal("NOVIF", "Virtual interface must be set for:")

            SPI_slave_config.is_active = UVM_ACTIVE;
                
            uvm_config_db#(SPI_slave_cfg)::set(this, "*", "CFG", SPI_slave_config);
            
        endfunction : build_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            // Start with reset sequence
            `uvm_info("run_phase", "Starting reset sequence", UVM_LOW)
            reset_sequence.start(env.agent.sequencer);
            `uvm_info("run_phase", "Completed reset sequence", UVM_LOW)

            // Then run main sequence
            `uvm_info("run_phase", "Starting main sequence", UVM_LOW)
            main_sequence.start(env.agent.sequencer);
            `uvm_info("run_phase", "Completed main sequence", UVM_LOW)

            phase.drop_objection(this);
        endtask : run_phase
    endclass: SPI_slave_test
endpackage