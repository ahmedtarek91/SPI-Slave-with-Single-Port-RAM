package Wrapper_driver_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Wrapper_seq_item_pkg::*;

    class Wrapper_driver extends uvm_driver #(Wrapper_seq_item);
        `uvm_component_utils(Wrapper_driver)

        virtual Wrapper_if driver_vif;
        Wrapper_seq_item stim_seq_item;

        function new(string name = "Wrapper_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item = Wrapper_seq_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);

                driver_vif.rst_n            = stim_seq_item.rst_n;
                driver_vif.SS_n             = stim_seq_item.SS_n;
                driver_vif.MOSI             = stim_seq_item.MOSI;
                driver_vif.array_for_MOSI   = stim_seq_item.array_for_MOSI;
                driver_vif.old_operation    = stim_seq_item.old_operation;
                @(negedge driver_vif.clk);

                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask : run_phase
    endclass: Wrapper_driver
endpackage