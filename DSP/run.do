vlib work 
vlog DSP.v DSP_TB.sv +cover -covercells
vsim -voptargs=+acc work.DSP_TB -cover
add wave *
coverage save DSP_TB.ucdb -onexit -du DSP
run -all 
coverage exclude -du DSP -togglenode {mult_out[36]}
coverage exclude -du DSP -togglenode {mult_out[37]}
coverage exclude -du DSP -togglenode {mult_out[38]}
coverage exclude -du DSP -togglenode {mult_out[39]}
coverage exclude -du DSP -togglenode {mult_out[40]}
coverage exclude -du DSP -togglenode {mult_out[41]}
coverage exclude -du DSP -togglenode {mult_out[42]}
coverage exclude -du DSP -togglenode {mult_out[43]}
coverage exclude -du DSP -togglenode {mult_out[44]}
coverage exclude -du DSP -togglenode {mult_out[45]}
coverage exclude -du DSP -togglenode {mult_out[46]}
coverage exclude -du DSP -togglenode {mult_out[47]}

#quit -sim 
vcover report DSP_TB.ucdb -details -annotate -all -output coverge_DSP.txt