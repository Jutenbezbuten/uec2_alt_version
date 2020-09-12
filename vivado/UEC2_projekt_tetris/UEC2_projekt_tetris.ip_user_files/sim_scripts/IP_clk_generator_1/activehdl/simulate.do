onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+IP_clk_generator -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.IP_clk_generator xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {IP_clk_generator.udo}

run -all

endsim

quit -force
