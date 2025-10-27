vlib work
vlog -f src_files.list +cover -covercells +define+SIM
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
do wave.do
coverage save wrapper_top.ucdb -onexit
coverage exclude -du Wrapper_if -togglenode cs
coverage exclude -du SPI_slave_if -togglenode cs
coverage exclude -du SPI_slave_if -togglenode cs_ref
coverage exclude -src SPI_slave.sv -line 39 -code b
coverage exclude -src SPI_slave.sv -line 82 -code b
coverage exclude -src SPI_slave.sv -line 40 -code s
coverage exclude -src SPI_RAM.sv -line 28 -code b
coverage exclude -src SPI_RAM.sv -line 28 -code s
run -all