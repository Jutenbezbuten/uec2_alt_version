`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2020 11:33:57 PM
// Design Name: 
// Module Name: TETRIS_Main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TETRIS_Main (
  input wire PS2Data,
  input wire PS2Clk,
  input wire clk,
  input wire btnC,
  input wire btnU,
  input wire btnD,
  input wire btnL,
  input wire btnR,
  input wire switch_space,
  input wire switch_enter,
  
  
  output reg Vsync,
  output reg Hsync,
  
  output reg [3:0] vgaRed,
  output reg [3:0] vgaGreen,
  output reg [3:0] vgaBlue
  );

wire clk65MHz,  clk_rand;
wire [10:0] vcount;
wire [10:0] hcount;
wire vsync, hsync;
wire vblnk, hblnk;
wire locked;

IP_CLK_DIVIDER CLK_GENERATOR 
 (
    .pclk(clk),
    .reset(switch_enter),
 
    .locked(locked),
    .clk65MHz(clk65MHz),
    .clk_rand(clk_rand)
 );

vga_timing vga_timing_source
(
  .pclk(clk65MHz),
  .reset(switch_enter),

  .vcount(vcount),
  .vsync(vsync),
  .vblnk(vblnk),
  .hcount(hcount),
  .hsync(hsync),
  .hblnk(hblnk)
  );

wire [3:0] Green_to_main, Red_to_main, Blue_to_main;
wire [10:0] vcount_to_main;
wire [10:0] hcount_to_main;
wire vsync_to_main, hsync_to_main;
wire vblnk_to_main, hblnk_to_main;

wire [3:0] Green_Out, Red_Out, Blue_Out;
wire [10:0] vcount_frame;
wire [10:0] hcount_frame;
wire vsync_frame, hsync_frame;
wire vblnk_frame, hblnk_frame;


GAME_FRAME FRAME_VIDEO_CONTROLL(
   .clk(clk65MHz),
   .hcount(hcount_to_main),
   .vcount(vcount_to_main),
   .hsync(hsync_to_main),
   .vsync(vsync_to_main),
   .hblnk(hblnk_to_main),
   .vblnk(vblnk_to_main),
   .reset(switch_enter),
   .VGARed(Red_to_main),
   .VGAGreen(Green_to_main),
   .VGABlue(Blue_to_main),
   
   .VGARed_out(Red_Out),
   .VGAGreen_out(Green_Out),
   .VGABlue_out(Blue_Out),
   .hcount_out(hcount_frame),
   .vcount_out(vcount_frame),
   .hsync_out(hsync_frame),
   .vsync_out(vsync_frame),
   .hblnk_out(hblnk_frame),
   .vblnk_out(vblnk_frame)
    );


wire [2:0] random_block;    
    
falserandom_generator random_blocks(
        .clkrand(clk_rand),
        .reset(switch_enter),
        
        .rand(random_block)
        );
    
    
game_logic_unit tetris_logic(
    .pclk(clk65MHz),
    .reset(switch_enter),
    .random(random_block),
    .hsync(hsync),
    .vsync(vsync),
    .hblnk(hblnk),
    .vblnk(vblnk),
    .hcount(hcount),
    .vcount(vcount),
    .btnU(btnU),
    .btnD(btnD),
    .btnL(btnL),
    .btnR(btnR),
    .switch_enter(btnC),
    .switch_space(switch_space),

    .VGARed_out(Red_to_main),
    .VGAGreen_out(Green_to_main),
    .VGABlue_out(Blue_to_main),
    .hsync_out(hsync_to_main),
    .vsync_out(vsync_to_main),
    .hblnk_out(hblnk_to_main),
    .vblnk_out(vblnk_to_main),
    .hcount_out(hcount_to_main),
    .vcount_out(vcount_to_main)
);

always @(posedge clk65MHz)begin
   Vsync<=vsync_frame;
   Hsync<=hsync_frame;
 
   vgaRed <= Red_Out;
   vgaGreen <= Green_Out;
   vgaBlue <= Blue_Out;
end


endmodule