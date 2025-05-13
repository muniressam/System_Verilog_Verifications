vlib work
vlog ALSU.v const.sv ALSU_golden.sv ALSU_tb.sv +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
add wave *
coverage save ALSU_tb.ucdb -onexit -du ALSU -du ALSU_pkt
run -all
coverage exclude -src ALSU.v -line 115
coverage exclude -du ALSU -togglenode {cin_reg[1]}
#quit -sim
vcover report ALSU_tb.ucdb -details -annotate -all -output coverage_ALSU.txt
