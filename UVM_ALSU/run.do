vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
#add wave /top/ALSU_IF/*
run -all