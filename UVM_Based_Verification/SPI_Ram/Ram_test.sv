package Ram_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_env_pkg::*;
    import Ram_config_pkg::*;
    import Ram_read_only_seq_pkg::*;
    import Ram_write_read_seq_pkg::*;
    import Ram_write_only_seq_pkg::*;
    import Ram_reset_seq_pkg::*;

    class Ram_test extends uvm_test;
        `uvm_component_utils(Ram_test)

        Ram_env env;
        Ram_read_only_seq read_only_sequence;
        Ram_write_read_seq write_read_sequence;
        Ram_write_only_seq write_only_sequence;
        Ram_reset_seq reset_sequence;
        Ram_cfg Ram_config;
        
        function new(string name = "Ram_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = Ram_env::type_id::create("env", this);
            read_only_sequence = Ram_read_only_seq::type_id::create("read_only_sequence");
            write_read_sequence = Ram_write_read_seq::type_id::create("write_read_sequence");
            write_only_sequence = Ram_write_only_seq::type_id::create("write_only_sequence");
            reset_sequence = Ram_reset_seq::type_id::create("reset_sequence");
            Ram_config = Ram_cfg::type_id::create("Ram_config");

            if(!uvm_config_db#(virtual Ram_if)::get(this, "", "vif", Ram_config.Ram_vif))
                `uvm_fatal("NOVIF", "Virtual interface must be set for:")
                
            Ram_config.is_active = UVM_ACTIVE; // Set agent to active mode
            
            uvm_config_db#(Ram_cfg)::set(this, "*", "CFG", Ram_config);
            
        endfunction : build_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            // Start with reset sequence
            `uvm_info("run_phase", "Starting reset sequence", UVM_LOW)
            reset_sequence.start(env.agent.sequencer);
            `uvm_info("run_phase", "Completed reset sequence", UVM_LOW)

            // Then run main sequences

            `uvm_info("run_phase", "Starting write only sequence", UVM_LOW)
            write_only_sequence.start(env.agent.sequencer);
            `uvm_info("run_phase", "Completed write only sequence", UVM_LOW)
            
            `uvm_info("run_phase", "Starting read only sequence", UVM_LOW)
            read_only_sequence.start(env.agent.sequencer);
            `uvm_info("run_phase", "Completed read only sequence", UVM_LOW)

            `uvm_info("run_phase", "Starting write read sequence", UVM_LOW)
            write_read_sequence.start(env.agent.sequencer);
            `uvm_info("run_phase", "Completed write read sequence", UVM_LOW)

            phase.drop_objection(this);
        endtask : run_phase
    endclass: Ram_test
endpackage