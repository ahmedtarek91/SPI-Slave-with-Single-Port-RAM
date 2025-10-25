package SPI_slave_driver_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_slave_seq_item_pkg::*;

    class SPI_slave_driver extends uvm_driver #(SPI_slave_seq_item);
        `uvm_component_utils(SPI_slave_driver)

        virtual SPI_slave_if driver_vif;
        SPI_slave_seq_item stim_seq_item;

        function new(string name = "SPI_slave_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item = SPI_slave_seq_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);

                driver_vif.SS_n        = stim_seq_item.SS_n;
                driver_vif.rst_n       = stim_seq_item.rst_n;
                driver_vif.MOSI        = stim_seq_item.MOSI;
                driver_vif.tx_data     = stim_seq_item.tx_data;
                driver_vif.tx_valid    = stim_seq_item.tx_valid;
                driver_vif.array_for_MOSI = stim_seq_item.array_for_MOSI;
                @(negedge driver_vif.clk);

                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask : run_phase
    endclass: SPI_slave_driver
endpackage