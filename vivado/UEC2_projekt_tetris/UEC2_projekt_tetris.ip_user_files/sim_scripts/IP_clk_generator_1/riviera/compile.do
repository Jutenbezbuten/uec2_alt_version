vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"C:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../UEC2_projekt_tetris.srcs/sources_1/ip/IP_clk_generator_1/IP_clk_generator_clk_wiz.v" \
"../../../../UEC2_projekt_tetris.srcs/sources_1/ip/IP_clk_generator_1/IP_clk_generator.v" \

vlog -work xil_defaultlib \
"glbl.v"

