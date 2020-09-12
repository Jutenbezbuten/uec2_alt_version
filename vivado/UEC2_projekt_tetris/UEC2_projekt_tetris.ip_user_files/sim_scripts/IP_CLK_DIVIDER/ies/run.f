-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../UEC2_projekt_tetris.srcs/sources_1/ip/IP_CLK_DIVIDER/IP_CLK_DIVIDER_clk_wiz.v" \
  "../../../../UEC2_projekt_tetris.srcs/sources_1/ip/IP_CLK_DIVIDER/IP_CLK_DIVIDER.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

