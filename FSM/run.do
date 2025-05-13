vlib work 
vlog FSM_010.v const.sv FSM_010_TB.sv +cover -covercells
vsim -voptargs=+acc work.FSM_010_TB -cover
add wave *
coverage save FSM_010_TB.ucdb -onexit -du FSM_010
run -all 
coverage exclude -src FSM_010.v -line 21
coverage exclude -src FSM_010.v -line 42 -code s
#quit -sim 
vcover report FSM_010_TB.ucdb -details -annotate -all -output coverge_FSM.txt
