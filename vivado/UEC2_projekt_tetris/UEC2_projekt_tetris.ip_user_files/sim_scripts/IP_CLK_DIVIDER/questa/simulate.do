onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib IP_CLK_DIVIDER_opt

do {wave.do}

view wave
view structure
view signals

do {IP_CLK_DIVIDER.udo}

run -all

quit -force
