vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.top -cover
add wave *
coverage save top.ucdb -onexit
run -all
#quit -sim
vcover report top.ucdb -details -annotate -all -output coverage_count.txt
