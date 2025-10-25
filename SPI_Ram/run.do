vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
do wave.do
coverage save ram_top.ucdb -onexit
coverage exclude -src RAM.sv -line 21 -code s
coverage exclude -src RAM.sv -line 21 -code b
run -all