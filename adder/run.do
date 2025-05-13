vlib work
vlog adder.v adder_tb.sv +cover -covercells
vsim -voptargs=+acc work.adder_tb -cover
add wave *
coverage save adder_tb.ucdb -onexit -du adder
run -all
#quit -sim
vcover report adder_tb.ucdb -details -annotate -all -output coverage_adder.txt




# (coverage save adder_tb.ucdb -onexit -du adder ) if i need to see only coverage of the design 
