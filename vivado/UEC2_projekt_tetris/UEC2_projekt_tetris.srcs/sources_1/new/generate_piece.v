`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2020 04:07:47
// Design Name: 
// Module Name: generate_piece
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


module generate_piece(
    input wire pclk,
    input wire reset,
    input wire [3:0] block_code,
    input wire [5:0] xpos,
    input wire [5:0] ypos,
    input wire [1:0] rotation,
    
    output reg [10:0] blk1,
    output reg [10:0] blk2,
    output reg [10:0] blk3,
    output reg [10:0] blk4,
    output reg [3:0] width,
    output reg [3:0] height
    );
    
    localparam SCREEN_WIDTH=32, ERROR_BLOCK=11'b11111111111,
    ERROR_PIECE=4'b0000, I_PIECE=4'b0001, L_PIECE=4'b0010, J_PIECE=4'b0011,
    T_PIECE=4'b0100, SQUARE_PIECE=4'b0101, Z_PIECE=4'b0110, S_PIECE=4'b0111, 
    END_SCREEN=4'b1000;
    reg [10:0] blk1_nxt=0, blk2_nxt=0, blk3_nxt=0, blk4_nxt=0;
    reg [3:0] width_nxt=0, height_nxt=0;
    
always @(*) begin
  if (reset) begin
        blk1_nxt=ERROR_BLOCK;
        blk2_nxt=ERROR_BLOCK;
        blk3_nxt=ERROR_BLOCK;
        blk4_nxt=ERROR_BLOCK;
        width_nxt=0;
        height_nxt=0;
    end
    
  else begin
    case(block_code)
        ERROR_PIECE,END_SCREEN: begin //error piece
            blk1_nxt=ERROR_BLOCK;
            blk2_nxt=ERROR_BLOCK;
            blk3_nxt=ERROR_BLOCK;
            blk4_nxt=ERROR_BLOCK;
            width_nxt=0;
            height_nxt=0;
        end
        
        I_PIECE: begin //long piece (I shaped)
        if (rotation==0 || rotation==2) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            blk3_nxt=((ypos+2)*SCREEN_WIDTH)+xpos;
            blk4_nxt=((ypos+3)*SCREEN_WIDTH)+xpos;
            width_nxt=1;
            height_nxt=4;
            end
        else begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=(ypos*SCREEN_WIDTH)+xpos+1;
            blk3_nxt=(ypos*SCREEN_WIDTH)+xpos+2;
            blk4_nxt=(ypos*SCREEN_WIDTH)+xpos+3;
            width_nxt=4;
            height_nxt=1;
            end
        end
        
        L_PIECE: begin // L shaped piece 
        if (rotation==0) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            blk3_nxt=((ypos+2)*SCREEN_WIDTH)+xpos;
            blk4_nxt=((ypos+2)*SCREEN_WIDTH)+xpos+1;
            width_nxt=2;
            height_nxt=3;
            end
        else if (rotation==1) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=((ypos)*SCREEN_WIDTH)+xpos+1;
            blk3_nxt=((ypos)*SCREEN_WIDTH)+xpos+2;
            blk4_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            width_nxt=3;
            height_nxt=2;
            end
        else if (rotation==2) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=((ypos)*SCREEN_WIDTH)+xpos+1;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            blk4_nxt=((ypos+2)*SCREEN_WIDTH)+xpos+1;
            width_nxt=2;
            height_nxt=3;
            end
        else begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos+2;
            blk2_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+2;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            blk4_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            width_nxt=3;
            height_nxt=2;
            end
        end
        
        J_PIECE: begin //inverted L shaped piece 
        if (rotation==0) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos+1;
            blk2_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            blk3_nxt=((ypos+2)*SCREEN_WIDTH)+xpos+1;
            blk4_nxt=((ypos+2)*SCREEN_WIDTH)+xpos;
            width_nxt=2;
            height_nxt=3;
            end
        else if (rotation==1) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            blk4_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+2;
            width_nxt=3;
            height_nxt=2;
            end
        else if (rotation==2) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=((ypos)*SCREEN_WIDTH)+xpos+1;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            blk4_nxt=((ypos+2)*SCREEN_WIDTH)+xpos;
            width_nxt=2;
            height_nxt=3;
            end
        else begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=(ypos*SCREEN_WIDTH)+xpos+1;
            blk3_nxt=(ypos*SCREEN_WIDTH)+xpos+2;
            blk4_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+2;
            width_nxt=3;
            height_nxt=2;
            end
        end
        
        T_PIECE: begin //T shaped piece 
        if (rotation==0) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=(ypos*SCREEN_WIDTH)+xpos+1;
            blk3_nxt=(ypos*SCREEN_WIDTH)+xpos+2;
            blk4_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            width_nxt=3;
            height_nxt=2;
            end
        else if (rotation==1) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos+1;
            blk2_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            blk4_nxt=((ypos+2)*SCREEN_WIDTH)+xpos+1;
            width_nxt=2;
            height_nxt=3;
            end
        else if (rotation==2) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos+1;
            blk2_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            blk4_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+2;
            width_nxt=3;
            height_nxt=2;
            end
        else begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            blk4_nxt=((ypos+2)*SCREEN_WIDTH)+xpos;
            width_nxt=2;
            height_nxt=3;
            end
        end
        
        SQUARE_PIECE: begin //square piece
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=(ypos*SCREEN_WIDTH)+xpos+1;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            blk4_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            width_nxt=2;
            height_nxt=2;
            end
        
        Z_PIECE: begin //Z shaped piece 
        if (rotation==0||rotation==2) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=(ypos*SCREEN_WIDTH)+xpos+1;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            blk4_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+2;
            width_nxt=3;
            height_nxt=2;
            end
        else begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos+1;
            blk2_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            blk4_nxt=((ypos+2)*SCREEN_WIDTH)+xpos;
            width_nxt=2;
            height_nxt=3;
            end
        end
        
        S_PIECE: begin //S shaped piece 
        if (rotation==0||rotation==2) begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos+1;
            blk2_nxt=(ypos*SCREEN_WIDTH)+xpos+2;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            blk4_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            width_nxt=3;
            height_nxt=2;
            end
        else begin
            blk1_nxt=(ypos*SCREEN_WIDTH)+xpos;
            blk2_nxt=((ypos+1)*SCREEN_WIDTH)+xpos;
            blk3_nxt=((ypos+1)*SCREEN_WIDTH)+xpos+1;
            blk4_nxt=((ypos+2)*SCREEN_WIDTH)+xpos+1;
            width_nxt=2;
            height_nxt=3;
            end
        end
        
        default: begin
            blk1_nxt=ERROR_BLOCK;
            blk2_nxt=ERROR_BLOCK;
            blk3_nxt=ERROR_BLOCK;
            blk4_nxt=ERROR_BLOCK;
            width_nxt=0;
            height_nxt=0;
        end
    endcase
    end 
end
    
always @(posedge pclk) begin
    blk1<=blk1_nxt;
    blk2<=blk2_nxt;
    blk3<=blk3_nxt;
    blk4<=blk4_nxt;
    width<=width_nxt;
    height<=height_nxt;
end
    
endmodule
