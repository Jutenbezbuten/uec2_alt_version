`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2020 08:49:57 PM
// Design Name: 
// Module Name: ingame_graphic
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


module ingame_graphic(
    input wire pclk,
    input wire reset,
    input wire hsync,
    input wire vsync,
    input wire hblnk,
    input wire vblnk,
    input wire [10:0] hcount,
    input wire [10:0] vcount,
    input wire [10:0] block1,
    input wire [10:0] block2,
    input wire [10:0] block3,
    input wire [10:0] block4,
    input wire [767:0] board,
    input wire [3:0] block_code,
    
    output reg [3:0] VGARed_out,
    output reg [3:0] VGABlue_out,
    output reg [3:0] VGAGreen_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg hblnk_out,
    output reg vblnk_out  
    );
    
localparam BLOCK_SIZE=32, LEFT_EDGE=2, GAME_WIDTH=16, SCREEN_WIDTH=32,
ERROR_PIECE=4'b0000, I_PIECE=4'b0001, L_PIECE=4'b0010, J_PIECE=4'b0011,
T_PIECE=4'b0100, SQUARE_PIECE=4'b0101, Z_PIECE=4'b0110, S_PIECE=4'b0111, 
END_SCREEN=4'b1000;

wire [10:0] current_block=(hcount/BLOCK_SIZE)+((vcount/BLOCK_SIZE)*SCREEN_WIDTH);
reg [3:0] VGARed_nxt, VGAGreen_nxt, VGABlue_nxt; 
reg hsync_nxt, vsync_nxt;
reg hblnk_nxt, vblnk_nxt;

always @* begin
    if (reset) begin
        VGARed_nxt=0;
        VGAGreen_nxt=0;
        VGABlue_nxt=0;
        hsync_nxt=0;
        vsync_nxt=0;
        hblnk_nxt=0;
        vblnk_nxt=0;
    end
    else if(hcount>=(BLOCK_SIZE*LEFT_EDGE)&&hcount<(BLOCK_SIZE*(LEFT_EDGE+GAME_WIDTH))) begin //checking if we're in the playable area
    //next, we're chcecking if a part the active piece is within the current 32x32 block
        if (current_block==block1||current_block==block2||current_block==block3||current_block==block4) begin
            case (block_code)
                ERROR_PIECE: begin //error, black
                    VGARed_nxt=0;
                    VGAGreen_nxt=0;
                    VGABlue_nxt=0;
                end
                I_PIECE: begin //I shaped, cyan
                    VGARed_nxt=1;
                    VGAGreen_nxt=15;
                    VGABlue_nxt=15;
                end
                L_PIECE: begin //L shaped, orange
                    VGARed_nxt=15;
                    VGAGreen_nxt=7;
                    VGABlue_nxt=0;
                end
                J_PIECE: begin //J shaped, blue
                    VGARed_nxt=1;
                    VGAGreen_nxt=1;
                    VGABlue_nxt=15;
                end
                T_PIECE: begin //T shaped, purple
                    VGARed_nxt=13;
                    VGAGreen_nxt=3;
                    VGABlue_nxt=15;
                end
                SQUARE_PIECE: begin //square, yellow
                    VGARed_nxt=15;
                    VGAGreen_nxt=15;
                    VGABlue_nxt=3;
                end
                Z_PIECE: begin //Z shaped, red
                    VGARed_nxt=15;
                    VGAGreen_nxt=3;
                    VGABlue_nxt=0;
                end
                S_PIECE: begin //S shaped, green
                    VGARed_nxt=1;
                    VGAGreen_nxt=15;
                    VGABlue_nxt=2;
                end
                default: begin
                    VGARed_nxt=0;
                    VGAGreen_nxt=0;
                    VGABlue_nxt=0;
                end
            endcase
        end
        else begin //if the current block is part of the already fallen pieces color it white, else color black
        VGARed_nxt=board[current_block] ? 15 : 0;
        VGAGreen_nxt=board[current_block] ? 15 : 0;
        VGABlue_nxt=board[current_block] ? 15 : 0;
        end
    end
    else begin //if not within playable area, color black (though that is changed in a later module)
        VGARed_nxt=0;
        VGAGreen_nxt=0;
        VGABlue_nxt=0;
    end
    hsync_nxt=hsync;
    vsync_nxt=vsync;
    hblnk_nxt=hblnk;
    vblnk_nxt=vblnk;
end  
    
always @(posedge pclk) begin
    VGARed_out<=VGARed_nxt;
    VGAGreen_out<=VGAGreen_nxt;
    VGABlue_out<=VGABlue_nxt;
    hsync_out<=hsync_nxt;
    vsync_out<=vsync_nxt;
    hblnk_out<=hblnk_nxt;
    vblnk_out<=vblnk_nxt;
end
endmodule
