`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2020 02:23:40 PM
// Design Name: 
// Module Name: GAME_FRAME
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


module GAME_FRAME(
    input wire clk,
    input wire [10:0] hcount,
    input wire [10:0] vcount,
    input wire hsync,
    input wire vsync,
    input wire hblnk,
    input wire vblnk,
    input wire reset,
    input wire [3:0] VGARed,
    input wire [3:0] VGAGreen,
    input wire [3:0] VGABlue,
    
    output reg [3:0] VGARed_out,
    output reg [3:0] VGAGreen_out,
    output reg [3:0] VGABlue_out,
    output reg [10:0] hcount_out,
    output reg [10:0] vcount_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg hblnk_out,
    output reg vblnk_out
    );

reg [3:0] VGARed_nxt, VGAGreen_nxt, VGABlue_nxt;

always @* begin
    if(reset) begin
        VGARed_nxt = 0;
        VGAGreen_nxt = 0;
        VGABlue_nxt = 0;
        end
    else begin
        if(hblnk||vblnk)begin
            VGARed_nxt = 0;
            VGAGreen_nxt = 0;
            VGABlue_nxt = 0;
            end
        else begin
            if((hcount>63)&&(hcount<576))begin
                VGARed_nxt = VGARed;
                VGAGreen_nxt = VGAGreen;
                VGABlue_nxt = VGABlue;
                end
            else begin //tutaj by by³y te napisy, cnie
                VGARed_nxt = 8;
                VGAGreen_nxt = 8;
                VGABlue_nxt = 8;
                end
            end
       end
end

always @(posedge clk)begin
        VGARed_out <= VGARed_nxt;
        VGAGreen_out <= VGAGreen_nxt;
        VGABlue_out <= VGABlue_nxt;
        hcount_out <= hcount;
        vcount_out <= vcount;
        hsync_out <= hsync;
        vsync_out <= vsync;
        hblnk_out <= hblnk;
        vblnk_out <= vblnk;
end

endmodule
