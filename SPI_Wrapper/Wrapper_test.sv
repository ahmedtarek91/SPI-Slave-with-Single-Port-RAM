package Wrapper_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Wrapper_env_pkg::*;
    import SPI_slave_env_pkg::*;
    import Ram_env_pkg::*;
    import Wrapper_config_pkg::*;
    import SPI_slave_config_pkg::*;
    import Ram_config_pkg::*;
    import Wrapper_read_only_seq_pkg::*;
    import Wrapper_write_read_seq_pkg::*;
    import Wrapper_write_only_seq_pkg::*;
    import Wrapper_reset_seq_pkg::*;

    class Wrapper_test extends uvm_test;
        `uvm_component_utils(Wrapper_test)

        Wrapper_env wrapper_env;
        SPI_slave_env slave_env;
        Ram_env ram_env;
        Wrapper_read_only_seq read_only_sequence;
        Wrapper_write_read_seq write_read_sequence;
        Wrapper_write_only_seq write_only_sequence;
        Wrapper_reset_seq reset_sequence;
        Wrapper_cfg Wrapper_config;
        SPI_slave_cfg Slave_config;
        Ram_cfg Ram_config;
        
        function new(string name = "Wrapper_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            wrapper_env          = Wrapper_env::type_id::create("wrapper_env", this);
            slave_env            = SPI_slave_env::type_id::create("slave_env", this);
            ram_env              = Ram_env::type_id::create("ram_env", this);
            read_only_sequence   = Wrapper_read_only_seq::type_id::create("read_only_sequence");
            write_read_sequence  = Wrapper_write_read_seq::type_id::create("write_read_sequence");
            write_only_sequence  = Wrapper_write_only_seq::type_id::create("write_only_sequence");
            reset_sequence       = Wrapper_reset_seq::type_id::create("reset_sequence");
            Wrapper_config       = Wrapper_cfg::type_id::create("Wrapper_config");
            Slave_config         = SPI_slave_cfg::type_id::create("Slave_config");
            Ram_config           = Ram_cfg::type_id::create("Ram_config");

            if(!uvm_config_db#(virtual Wrapper_if)::get(this, "", "wrapper_vif", Wrapper_config.Wrapper_vif))
                `uvm_fatal("NOVIF", "Virtual interface must be set for:")
            if(!uvm_config_db#(virtual SPI_slave_if)::get(this, "", "slave_vif", Slave_config.Slave_vif))
                `uvm_fatal("NOVIF", "Virtual interface must be set for:")
            if(!uvm_config_db#(virtual Ram_if)::get(this, "", "ram_vif", Ram_config.Ram_vif))
                `uvm_fatal("NOVIF", "Virtual interface must be set for:")

            Wrapper_config.is_active    = UVM_ACTIVE;
            Slave_config.is_active      = UVM_PASSIVE;
            Ram_config.is_active        = UVM_PASSIVE;
                
            uvm_config_db#(Wrapper_cfg)::set(this, "wrapper_env.*", "wrapper_CFG", Wrapper_config);
            uvm_config_db#(SPI_slave_cfg)::set(this, "slave_env.*", "slave_CFG", Slave_config);
            uvm_config_db#(Ram_cfg)::set(this, "ram_env.*", "ram_CFG", Ram_config);
            
        endfunction : build_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            // Start with reset sequence
            `uvm_info("run_phase", "Starting reset sequence", UVM_LOW)
            reset_sequence.start(wrapper_env.agent.sequencer);
            `uvm_info("run_phase", "Completed reset sequence", UVM_LOW)

            // Then run main sequences
            `uvm_info("run_phase", "Starting write only sequence", UVM_LOW)
            write_only_sequence.start(wrapper_env.agent.sequencer);
            `uvm_info("run_phase", "Completed write only sequence", UVM_LOW)

            `uvm_info("run_phase", "Starting read only sequence", UVM_LOW)
            read_only_sequence.start(wrapper_env.agent.sequencer);
            `uvm_info("run_phase", "Completed read only sequence", UVM_LOW)

            `uvm_info("run_phase", "Starting write read sequence", UVM_LOW)
            write_read_sequence.start(wrapper_env.agent.sequencer);
            `uvm_info("run_phase", "Completed write read sequence", UVM_LOW)

            phase.drop_objection(this);
        endtask : run_phase
    endclass: Wrapper_test
endpackage