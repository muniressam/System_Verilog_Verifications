vlib work
vlog config_reg_buggy_questa.svp config_reg_tb.sv +cover -covercells
vsim -voptargs=+acc work.config_reg_tb -cover
add wave *
coverage save config_reg_tb.ucdb -onexit 
run -all
#quit -sim
vcover report config_reg_tb.ucdb -details -annotate -all -output config_reg.txt
