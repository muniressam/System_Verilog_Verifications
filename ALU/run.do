vlib work 
vlog ALU.v const.sv ALU_TB.sv +cover -covercells
vsim -voptargs=+acc work.ALU_TB -cover
add wave *
coverage save ALU_TB.ucdb -onexit -du ALU_4_bit
run -all 
coverage exclude -src ALU.v -line 21
coverage exclude -src ALU.v -line 26 -code s
#quit -sim 
vcover report ALU_TB.ucdb -details -annotate -all -output coverge_ALU.txt