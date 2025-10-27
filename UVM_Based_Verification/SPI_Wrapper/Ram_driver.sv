package Ram_driver_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;

    class Ram_driver extends uvm_driver #(Ram_seq_item);
        `uvm_component_utils(Ram_driver)

        virtual Ram_if driver_vif;
        Ram_seq_item stim_seq_item;

        function new(string name = "Ram_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item = Ram_seq_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);

                driver_vif.rst_n    = stim_seq_item.rst_n;
                driver_vif.rx_valid = stim_seq_item.rx_valid;
                driver_vif.din      = stim_seq_item.din;
                @(negedge driver_vif.clk);

                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask : run_phase
    endclass: Ram_driver
endpackage