vlib work
vlog -f src_files.list +cover -covercells +define+SIM
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
do wave.do
coverage save slave_top.ucdb -onexit
coverage exclude -src SPI_slave.sv -line 29 -code s
coverage exclude -src SPI_slave.sv -line 28 -code b
coverage exclude -src SPI_slave.sv -line 71 -code b
coverage exclude -du SPI_slave_if -togglenode cs
coverage exclude -du SPI_slave_if -togglenode cs_ref
run -all
