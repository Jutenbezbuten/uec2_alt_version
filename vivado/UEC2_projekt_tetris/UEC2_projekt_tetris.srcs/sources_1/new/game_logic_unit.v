`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2020 09:09:47 PM
// Design Name: 
// Module Name: game_logic_unit
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
 
 
module game_logic_unit(
    input wire pclk,
    input wire reset,
    input wire [2:0] random,
    input wire hsync,
    input wire vsync,
    input wire hblnk,
    input wire vblnk,
    input wire [10:0] hcount,
    input wire [10:0] vcount,
    input wire btnU,
    input wire btnD,
    input wire btnL,
    input wire btnR,
    input wire switch_enter,
    input wire switch_space,
 
    output reg [3:0] VGARed_out,
    output reg [3:0] VGAGreen_out,
    output reg [3:0] VGABlue_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg [10:0] hcount_out,
    output reg [10:0] vcount_out
    );
 
localparam TITLESCREEN=0, GAMEPLAY=1, MOV_LEFT=2, MOV_RIGHT=3, ROT_LEFT=4,
ROT_RIGHT=5, FALL_SLOW=6, FALL_FAST=7, CLEAR_ROW=8,GAME_OVER=9,
 
A_BUTTON=16'h1C, W_BUTTON=16'h1D, S_BUTTON=16'h1B, D_BUTTON=16'h23,
SPACE_BUTTON=16'h29, ENTER_BUTTON=16'h5A,
 
LEFT_EDGE=2, GAME_WIDTH=16, SCREEN_WIDTH=32,GAME_HEIGHT=24, ERROR_BLOCK=11'b11111111111;
 
 integer i;
 integer j;
 integer k;
 integer l;
 integer m;
 
reg [3:0] state=TITLESCREEN; 
reg [3:0] state_nxt=TITLESCREEN;
 //entire board, divided into 32x32 pixel squares. Every "1" means there is an immovable block          
reg [(SCREEN_WIDTH*GAME_HEIGHT)-1:0] board=0, board_nxt=0;

wire clk1Hz;
reg game_reset=0, game_reset_nxt=0;

clk1Hz clk1HZ_generator(
    .clk65MHz(pclk),
    .reset(switch_enter),
    .game_reset(game_reset),
    
    .clk1Hz(clk1Hz)
    );
    
 
 wire but_up;
wire but_down;
wire but_left;
wire but_right;
wire sw_enter;
wire sw_space;

debauns db_up(
    .raw(btnU),
    .clk(pclk),

    .enabled(but_up)
);

debauns db_down(
    .raw(btnD),
    .clk(pclk),

    .enabled(but_down)
);

debauns db_left(
    .raw(btnL),
    .clk(pclk),

    .enabled(but_left)
);

debauns db_right(
    .raw(btnR),
    .clk(pclk),

    .enabled(but_right)
);

debauns db_enter(
    .raw(switch_enter),
    .clk(pclk),

    .enabled(sw_enter)
);

debauns db_space(
    .raw(switch_space),
    .clk(pclk),

    .enabled(sw_space)
);
 
reg [3:0] blk_code=0;
reg [5:0] x_pos=(LEFT_EDGE+(GAME_WIDTH/2)), y_pos=0;
reg [1:0] rotation=0;
wire [10:0] blk1, blk2, blk3, blk4;
wire [3:0] width, height;
 
//this module keeps track of the current moving piece
generate_piece current_piece(
    .pclk(pclk),
    .reset(reset),
    .block_code(blk_code),
    .xpos(x_pos),
    .ypos(y_pos),
    .rotation(rotation),
 
    .blk1(blk1),
    .blk2(blk2),
    .blk3(blk3),
    .blk4(blk4),
    .width(width),
    .height(height)
);
 
wire [3:0] VGARed, VGAGreen, VGABlue;
wire hsync_nxt, vsync_nxt;
wire hblnk_nxt, vblnk_nxt;
 
//this module sends over data needed to display the current moving piece
//as well as the fallen pieces
ingame_graphic ingame_graphics(
    .pclk(pclk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .hblnk(hblnk),
    .vblnk(vblnk),
    .hcount(hcount),
    .vcount(vcount),
    .block1(blk1),
    .block2(blk2),
    .block3(blk3),
    .block4(blk4),
    .board(board),
    .block_code(blk_code),
 
    .VGARed_out(VGARed),
    .VGABlue_out(VGABlue),
    .VGAGreen_out(VGAGreen),
    .hsync_out(hsync_nxt),
    .vsync_out(vsync_nxt),
    .hblnk_out(hblnk_nxt),
    .vblnk_out(vblnk_nxt) 
);
 
wire [5:0] test_x_pos, test_y_pos;
wire [1:0] test_rotation;
wire [10:0] test_blk1, test_blk2, test_blk3, test_blk4;
wire [3:0] test_width, test_height;
 
//the next two modules generate test parameters to check if
//user's movement is executable
test_move show_me_your_moves(
    .pclk(pclk),
    .clk1Hz(clk1Hz),
    .reset(reset),
    .game_reset(game_reset),
    .xpos(x_pos),
    .ypos(y_pos),
    .rotation(rotation),
    .btn_left_en(but_left),
    .btn_right_en(but_right),
    .btn_up_en(but_up),
    .btn_down_en(but_down),
    .btn_space_en(sw_space),
 
    .test_x(test_x_pos),
    .test_y(test_y_pos),
    .test_rot(test_rotation)
);
 
reg [3:0] blk_code_semi=0;

always @(posedge pclk)begin
    blk_code_semi<=blk_code;
end
 
 
generate_piece test_piece(
    .pclk(pclk),
    .reset(reset),
    .block_code(blk_code_semi),
    .xpos(test_x_pos),
    .ypos(test_y_pos),
    .rotation(test_rotation),
 
    .blk1(test_blk1),
    .blk2(test_blk2),
    .blk3(test_blk3),
    .blk4(test_blk4),
    .width(test_width),
    .height(test_height)
);
 
//function to check if the test piece intersects with the fallen pieces
function check_if_intersects;
    input wire [10:0] block1;
    input wire [10:0] block2;
    input wire [10:0] block3;
    input wire [10:0] block4;
    begin
    check_if_intersects=board[block1]||board[block2]||board[block3]||board[block4];
    end    
endfunction
wire test_intersection=check_if_intersects(test_blk1,test_blk2,test_blk3,test_blk4);
 
wire [5:0] row_to_check;
wire ready_to_remove;
//this module tests whether there is a row to be removed
clear_row clear_row(
    .pclk(pclk),
    .reset(reset),
    .board(board),
 
    .row(row_to_check),
    .ready(ready_to_remove)
);
 
reg [5:0] x_pos_nxt=0, y_pos_nxt=0;
reg [1:0] rotation_nxt=0;
reg [2:0] blk_code_nxt=0;
 
reg [5:0] row_to_clear;
reg [5:0] row_to_clear_nxt=0;
 
 
//this wire turns to 1 when current position intersects with inactive blocks
//and the moving piece is still at the top of the board
wire game_over=y_pos==0 && check_if_intersects(blk1,blk2,blk3,blk4); 

always @(*) begin
    if (reset) begin
        y_pos_nxt=0;
        x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
        board_nxt=0;
        blk_code_nxt=0;
        rotation_nxt=0;
        row_to_clear_nxt=0;
        game_reset_nxt=0;
        state_nxt=TITLESCREEN;
    end
    else if ((state==TITLESCREEN||state==GAME_OVER) && (sw_enter)) begin
        board_nxt=0;
        blk_code_nxt=(random+1);
        x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
        y_pos_nxt=0;
        rotation_nxt=0;
        row_to_clear_nxt=0;
        state_nxt=GAMEPLAY;
        game_reset_nxt=1;
    end
    else if(game_over) begin
        for (m=0; m<=767; m=m+1) begin
            if (m==blk1) begin
                board_nxt[blk1]=1;
            end
            else if (m==blk2) begin
                board_nxt[blk2]=1;
            end
            else if (m==blk3) begin
                board_nxt[blk3]=1;
            end
            else if (m==blk4) begin
                board_nxt[blk4]=1;
            end
            else begin
                board_nxt[m]=board[m];
            end
        end
        state_nxt=GAME_OVER;
        blk_code_nxt=0;
        y_pos_nxt=y_pos;
        x_pos_nxt=x_pos;
        rotation_nxt=rotation;
        row_to_clear_nxt=row_to_clear;
        game_reset_nxt=0;
    end
    else if (state==GAMEPLAY) begin
        if (clk1Hz)begin
            if((height+y_pos)==(GAME_HEIGHT-1) || test_intersection) begin
                for (j=0; j<=767; j=j+1) begin
                    if (j==blk1) begin
                        board_nxt[blk1]=1;
                    end
                    else if (j==blk2) begin
                        board_nxt[blk2]=1;
                    end
                    else if (j==blk3) begin
                        board_nxt[blk3]=1;
                    end
                    else if (j==blk4) begin
                        board_nxt[blk4]=1;
                    end
                    else begin
                        board_nxt[j]=board[j];
                    end
                end                  
                blk_code_nxt=(random+1);
                x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                y_pos_nxt=0;
                rotation_nxt=0;
                game_reset_nxt=1;
                state_nxt=GAMEPLAY;
                row_to_clear_nxt=row_to_clear;
            end
            else begin
                y_pos_nxt=y_pos+1;
                x_pos_nxt=x_pos;
                rotation_nxt=rotation;
                blk_code_nxt=blk_code;
                board_nxt=board;
                state_nxt=GAMEPLAY;
                row_to_clear_nxt=row_to_clear;
                game_reset_nxt=0;
            end
        end
        else if (but_left) begin
            if(x_pos>LEFT_EDGE && !test_intersection)begin
                x_pos_nxt=x_pos-1;
                blk_code_nxt=blk_code;
                y_pos_nxt=y_pos;
                board_nxt=board;
                rotation_nxt=rotation;
                row_to_clear_nxt=row_to_clear;
                state_nxt=GAMEPLAY;
                game_reset_nxt=0;
            end
            else begin
                x_pos_nxt=x_pos;
                blk_code_nxt=blk_code;
                y_pos_nxt=y_pos;
                board_nxt=board;
                rotation_nxt=rotation;
                row_to_clear_nxt=row_to_clear;
                state_nxt=GAMEPLAY;
                game_reset_nxt=0;
            end
        end
        else if (but_right) begin
            if((x_pos+width)<(GAME_WIDTH+LEFT_EDGE) && !test_intersection)begin
                x_pos_nxt=x_pos+1;
                blk_code_nxt=blk_code;
                y_pos_nxt=y_pos;
                board_nxt=board;
                rotation_nxt=rotation;
                row_to_clear_nxt=row_to_clear;
                state_nxt=GAMEPLAY;
                game_reset_nxt=0;
            end
            else begin
                x_pos_nxt=x_pos;
                blk_code_nxt=blk_code;
                y_pos_nxt=y_pos;
                board_nxt=board;
                rotation_nxt=rotation;
                row_to_clear_nxt=row_to_clear;
                state_nxt=GAMEPLAY;
                game_reset_nxt=0;
            end
        end
        else if (but_up) begin
            if((LEFT_EDGE<=(x_pos+test_width)<(LEFT_EDGE+GAME_WIDTH)) &&
            (0<=(y_pos+test_height)<GAME_HEIGHT) && !test_intersection) begin
                rotation_nxt=rotation-1;
                blk_code_nxt=blk_code;
                y_pos_nxt=y_pos;
                board_nxt=board;
                x_pos_nxt=x_pos;
                row_to_clear_nxt=row_to_clear;
                state_nxt=GAMEPLAY;
                game_reset_nxt=0;
            end
            else begin
                rotation_nxt=rotation;
                blk_code_nxt=blk_code;
                y_pos_nxt=y_pos;
                board_nxt=board;
                x_pos_nxt=x_pos;
                row_to_clear_nxt=row_to_clear;
                state_nxt=GAMEPLAY;
                game_reset_nxt=0;
            end 
        end
        else if (but_down) begin
            if((LEFT_EDGE<=(x_pos+test_width)<(LEFT_EDGE+GAME_WIDTH)) &&
            (0<=(y_pos+test_height)<GAME_HEIGHT) && !test_intersection) begin
                rotation_nxt=rotation+1;
                blk_code_nxt=blk_code;
                y_pos_nxt=y_pos;
                board_nxt=board;
                x_pos_nxt=x_pos;
                row_to_clear_nxt=row_to_clear;
                state_nxt=GAMEPLAY;
                game_reset_nxt=0;
            end
            else begin
                rotation_nxt=rotation;
                blk_code_nxt=blk_code;
                y_pos_nxt=y_pos;
                board_nxt=board;
                x_pos_nxt=x_pos;
                row_to_clear_nxt=row_to_clear;
                state_nxt=GAMEPLAY;
                game_reset_nxt=0;
            end
        end
        else if (sw_space) begin
            if((height+y_pos)==(GAME_HEIGHT-2) || test_intersection) begin
                y_pos_nxt=y_pos+1;
                x_pos_nxt=x_pos;
                rotation_nxt=rotation;
                blk_code_nxt=blk_code;
                board_nxt=board;
                state_nxt=GAMEPLAY;
                row_to_clear_nxt=row_to_clear;
                game_reset_nxt=0;
            end
            else if((height+y_pos)==(GAME_HEIGHT-1)|| test_intersection) begin
                for (j=0; j<=767; j=j+1) begin
                    if (j==blk1) begin
                        board_nxt[blk1]=1;
                    end
                    else if (j==blk2) begin
                        board_nxt[blk2]=1;
                    end
                    else if (j==blk3) begin
                        board_nxt[blk3]=1;
                    end
                    else if (j==blk4) begin
                        board_nxt[blk4]=1;
                    end
                    else begin
                        board_nxt[j]=board[j];
                    end
                end
                blk_code_nxt=(random+1);
                x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                y_pos_nxt=0;
                rotation_nxt=0;
                game_reset_nxt=1;
                row_to_clear_nxt=row_to_clear;
                state_nxt=GAMEPLAY;
            end
            else begin
                board_nxt=board;
                y_pos_nxt=y_pos+2;
                x_pos_nxt=x_pos;
                rotation_nxt=rotation;
                blk_code_nxt=blk_code;
                game_reset_nxt=0;
                row_to_clear_nxt=row_to_clear;
                state_nxt=GAMEPLAY;
            end
        end
        else if (ready_to_remove) begin
            row_to_clear_nxt=row_to_check;
            state_nxt=CLEAR_ROW;
            y_pos_nxt=y_pos;
            x_pos_nxt=x_pos;
            rotation_nxt=rotation;
            blk_code_nxt=blk_code;
            board_nxt=board;
            game_reset_nxt=0;
        end
        else begin
            row_to_clear_nxt=row_to_clear;
            x_pos_nxt=x_pos;
            y_pos_nxt=y_pos;
            rotation_nxt=rotation;
            blk_code_nxt=blk_code;
            board_nxt=board;
            state_nxt=GAMEPLAY;
            game_reset_nxt=0;
        end
    end
    else if (state==CLEAR_ROW) begin
        if (row_to_clear==0) begin
            for (l=0; l<=767; l=l+1) begin
                if (l>=LEFT_EDGE && l<(LEFT_EDGE+GAME_WIDTH)) begin
                    board_nxt[l]=0;
                end
                else begin
                    board_nxt[l]=board[l];
                end
            end
            //board_nxt=board;
            //board_nxt[LEFT_EDGE +:GAME_WIDTH]=0;
            row_to_clear_nxt=row_to_clear;
            state_nxt=GAMEPLAY;
            x_pos_nxt=x_pos;
            y_pos_nxt=y_pos;
            rotation_nxt=rotation;
            blk_code_nxt=blk_code;
            game_reset_nxt=0;
        end
        else begin
            for(k=0;k<=767;k=k+1) begin
                if (k>=((row_to_clear*SCREEN_WIDTH)+LEFT_EDGE) &&
                k<(((row_to_clear*SCREEN_WIDTH)+LEFT_EDGE)+GAME_WIDTH)) begin
                    board_nxt[k]=board[k-SCREEN_WIDTH];
                end
                else begin
                    board_nxt[k]=board[k];
                end
            end
            //board_nxt=board;
            //board_nxt[((row_to_clear*SCREEN_WIDTH)+LEFT_EDGE) +:GAME_WIDTH]=board[(((row_to_clear-1)*SCREEN_WIDTH)+LEFT_EDGE) +:GAME_WIDTH];
            row_to_clear_nxt=row_to_clear-1;
            state_nxt=CLEAR_ROW;
            x_pos_nxt=x_pos;
            y_pos_nxt=y_pos;
            rotation_nxt=rotation;
            blk_code_nxt=blk_code;
            game_reset_nxt=0;
        end
    end
    else begin
        state_nxt=state;
        row_to_clear_nxt=row_to_clear;
        x_pos_nxt=x_pos;
        y_pos_nxt=y_pos;
        rotation_nxt=rotation;
        blk_code_nxt=blk_code;
        board_nxt=board;
        game_reset_nxt=0;
    end
end


/*
always @(*) begin
    if (reset) begin
        y_pos_nxt=0;
        x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
        state_nxt=TITLESCREEN;
        board_nxt=0;
        blk_code_nxt=0;
        rotation_nxt=0;
        row_to_clear_nxt=0;
    end
    else begin
        case(state) 
        TITLESCREEN:begin
            if(sw_enter)begin
                board_nxt=0;
                blk_code_nxt=(random+1);
                x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                y_pos_nxt=0;
                rotation_nxt=0;
                state_nxt=GAMEPLAY;
                row_to_clear_nxt=0;
            end
            else begin
                state_nxt=TITLESCREEN;
                row_to_clear_nxt=row_to_clear;
                x_pos_nxt=x_pos;
                y_pos_nxt=y_pos;
                rotation_nxt=rotation;
                blk_code_nxt=blk_code;
                board_nxt=board;
                end
        end
 
        GAME_OVER: begin
            if(sw_enter)begin
                 board_nxt=0;
                 blk_code_nxt=(random+1);
                 x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                 y_pos_nxt=0;
                 rotation_nxt=0;
                 state_nxt=GAMEPLAY;
                 row_to_clear_nxt=0;
            end
            else begin
                 board_nxt=board;
                 state_nxt=GAME_OVER;
                 blk_code_nxt=4'b1000;
                 row_to_clear_nxt=0;
                 rotation_nxt=rotation;
                 x_pos_nxt=x_pos;
                 y_pos_nxt=y_pos;
            end
       end
 
        GAMEPLAY: begin
            if (clk1Hz)begin
                if((height+y_pos)<(GAME_HEIGHT-1) && !test_intersection) begin
                    y_pos_nxt=y_pos+1;
                    x_pos_nxt=x_pos;
                    rotation_nxt=rotation;
                    blk_code_nxt=blk_code;
                    board_nxt=board;
                    state_nxt=GAMEPLAY;
                    row_to_clear_nxt=row_to_clear;
                end
                else begin
                    for (i=0; i<=767; i=i+1) begin
                        if (i==blk1) begin
                            board_nxt[blk1]=1;
                        end
                        else if (i==blk2) begin
                            board_nxt[blk2]=1;
                        end
                        else if (i==blk3) begin
                            board_nxt[blk3]=1;
                        end
                        else if (i==blk4) begin
                            board_nxt[blk4]=1;
                        end
                        else begin
                            board_nxt[i]=board[i];
                        end
                    end                  
                    blk_code_nxt=(random+1);
                    x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                    y_pos_nxt=0;
                    rotation_nxt=0;
                    state_nxt=GAMEPLAY;
                    row_to_clear_nxt=row_to_clear;
                end
            end
            else if (ready_to_remove) begin
                row_to_clear_nxt=row_to_check;
                state_nxt=CLEAR_ROW;
                y_pos_nxt=y_pos;
                x_pos_nxt=x_pos;
                rotation_nxt=rotation;
                blk_code_nxt=blk_code;
                board_nxt=board;
                end
            else if (game_over)begin
                board_nxt=0;
                state_nxt=GAME_OVER;
                blk_code_nxt=0;
                y_pos_nxt=y_pos;
                x_pos_nxt=x_pos;
                rotation_nxt=rotation;
                row_to_clear_nxt=row_to_clear;
            end
            else begin
                if (but_left) begin
                    if(x_pos>LEFT_EDGE && !test_intersection)begin
                        x_pos_nxt=x_pos-1;
                    end
                    else begin
                        x_pos_nxt=x_pos;
                    end
                    blk_code_nxt=blk_code;
                    y_pos_nxt=y_pos;
                    board_nxt=board;
                    rotation_nxt=rotation;
                    row_to_clear_nxt=row_to_clear;
                end
                else if (but_right) begin
                    if((x_pos+width)<(GAME_WIDTH+LEFT_EDGE-1) && !test_intersection)begin
                        x_pos_nxt=x_pos+1;
                    end
                    else begin
                        x_pos_nxt=x_pos;
                    end
                    blk_code_nxt=blk_code;
                    y_pos_nxt=y_pos;
                    board_nxt=board;
                    rotation_nxt=rotation;
                    row_to_clear_nxt=row_to_clear;
                end
                else if (but_up) begin
                    if(LEFT_EDGE<=(x_pos+test_width)<(LEFT_EDGE+GAME_WIDTH) &&
                        0<=(y_pos+test_height)<GAME_HEIGHT && !test_intersection) begin
                            rotation_nxt=rotation-1;
                    end
                    else begin
                        rotation_nxt=rotation;
                    end
                    blk_code_nxt=blk_code;
                    y_pos_nxt=y_pos;
                    board_nxt=board;
                    x_pos_nxt=x_pos;
                    row_to_clear_nxt=row_to_clear; 
                end
                else if (but_down) begin
                    if(LEFT_EDGE<=(x_pos+test_width)<(LEFT_EDGE+GAME_WIDTH) &&
                        0<=(y_pos+test_height)<GAME_HEIGHT && !test_intersection) begin
                            rotation_nxt=rotation+1;
                    end
                    else begin
                            rotation_nxt=rotation;
                    end
                    blk_code_nxt=blk_code;
                    y_pos_nxt=y_pos;
                    board_nxt=board;
                    x_pos_nxt=x_pos;
                    row_to_clear_nxt=row_to_clear;
                end
                else if (sw_space) begin
                    if((height+y_pos)<(GAME_HEIGHT-2) && !test_intersection) begin
                        board_nxt=board;
                        y_pos_nxt=y_pos+2;
                        x_pos_nxt=x_pos;
                        rotation_nxt=rotation;
                        blk_code_nxt=blk_code;
                    end
                    else begin
                        for (j=0; j<=767; j=j+1) begin
                            if (j==blk1) begin
                                board_nxt[blk1]=1;
                            end
                            else if (j==blk2) begin
                                board_nxt[blk2]=1;
                            end
                            else if (j==blk3) begin
                                board_nxt[blk3]=1;
                            end
                            else if (j==blk4) begin
                                board_nxt[blk4]=1;
                            end
                            else begin
                                board_nxt[j]=board[j];
                            end
                        end
                        blk_code_nxt=(random+1);
                        x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                        y_pos_nxt=0;
                        rotation_nxt=0;
                    end
                    row_to_clear_nxt=row_to_clear;
                end
                else begin
                    row_to_clear_nxt=row_to_clear;
                    x_pos_nxt=x_pos;
                    y_pos_nxt=y_pos;
                    rotation_nxt=rotation;
                    blk_code_nxt=blk_code;
                    board_nxt=board;
                end
                state_nxt=GAMEPLAY;
            end
        end
        CLEAR_ROW: begin
            if (row_to_clear==0) begin
                for (l=0; l<=767; l=l+1) begin
                    if (l>=LEFT_EDGE && l<(LEFT_EDGE+GAME_WIDTH)) begin
                        board_nxt[l]=0;
                    end
                    else begin
                        board_nxt[l]=board[l];
                    end
                end
                row_to_clear_nxt=row_to_clear;
                state_nxt=GAMEPLAY;
            end
            else begin
               for(k=0;k<=767;k=k+1) begin
                   if (k>=((row_to_clear*SCREEN_WIDTH)+LEFT_EDGE) &&
                   k<(((row_to_clear*SCREEN_WIDTH)+LEFT_EDGE)+GAME_WIDTH)) begin
                       board_nxt[k]=board[k-SCREEN_WIDTH];
                   end
                   else begin
                       board_nxt[k]=board[k];
                   end
                end
                row_to_clear_nxt=row_to_clear-1;
                state_nxt=CLEAR_ROW;
            end
            x_pos_nxt=x_pos;
            y_pos_nxt=y_pos;
            rotation_nxt=rotation;
            blk_code_nxt=blk_code;
        end
       default: begin
            state_nxt=state;
            row_to_clear_nxt=row_to_clear;
            x_pos_nxt=x_pos;
            y_pos_nxt=y_pos;
            rotation_nxt=rotation;
            blk_code_nxt=blk_code;
            board_nxt=board;
            end
    endcase
    end
end
*/
always @(posedge pclk)begin
    VGARed_out<=VGARed;
    VGAGreen_out<=VGAGreen;
    VGABlue_out<=VGABlue;
    hsync_out<=hsync_nxt;
    vsync_out<=vsync_nxt;
    hblnk_out<=hblnk_nxt;
    vblnk_out<=vblnk_nxt;
    hcount_out<=hcount;
    vcount_out<=vcount;
    state<=state_nxt;
    game_reset<=game_reset_nxt;
 
    y_pos<=y_pos_nxt;
    x_pos<=x_pos_nxt;
    board<=board_nxt;
    row_to_clear<=row_to_clear_nxt;
    blk_code<=blk_code_nxt;
    rotation<=rotation_nxt;
end
 
endmodule