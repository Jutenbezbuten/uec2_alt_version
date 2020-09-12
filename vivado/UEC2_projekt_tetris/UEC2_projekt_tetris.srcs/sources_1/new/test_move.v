`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2020 17:39:29
// Design Name: 
// Module Name: test_move
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


module test_move(
    input wire pclk,
    input wire clk1Hz,
    input wire reset,
    input wire game_reset,
    input wire [5:0] xpos,
    input wire [5:0] ypos,
    input wire [1:0] rotation,
    input wire                   btn_left_en,
    input wire                   btn_right_en,
    input wire                   btn_up_en,
    input wire                   btn_down_en,
    input wire                   btn_space_en,
    
    output reg [5:0] test_x,
    output reg [5:0] test_y,
    output reg [1:0] test_rot
    );
    
reg [5:0] tx_nxt, ty_nxt;
reg [1:0] trot_nxt;
    
localparam A_BUTTON=16'h1C, W_BUTTON=16'h1D, S_BUTTON=16'h1B, D_BUTTON=16'h23, SPACE_BUTTON=16'h29, ENTER_BUTTON=16'h5A;
    
    always @(*) begin
    if (reset) begin
        tx_nxt=2;
        ty_nxt=0;
        trot_nxt=0;
    end
    else if (game_reset) begin
        tx_nxt=xpos;
        ty_nxt=ypos;
        trot_nxt=rotation;
    end
    else if (clk1Hz) begin //fall down one block
        tx_nxt=xpos;
        ty_nxt=ypos+1;
        trot_nxt=rotation;
    end
    else begin
        if (btn_left_en) begin //move left
            tx_nxt=xpos-1;
            ty_nxt=ypos;
            trot_nxt=rotation;
        end
        else if (btn_right_en) begin //move right
            tx_nxt=xpos+1;
            ty_nxt=ypos;
            trot_nxt=rotation;
        end
        else if (btn_up_en) begin //rotate left
            tx_nxt=xpos;
            ty_nxt=ypos;
            trot_nxt=rotation-1;
        end
        else if (btn_down_en) begin //rotate right
            tx_nxt=xpos;
            ty_nxt=ypos;
            trot_nxt=rotation+1;
        end
        else if (btn_space_en) begin //fall faster
            tx_nxt=xpos;
            ty_nxt=ypos+2;
            trot_nxt=rotation;
        end
        else begin //do nothing
            tx_nxt=xpos;
            ty_nxt=ypos;
            trot_nxt=rotation;
        end
    end
end

    always @(posedge pclk) begin
    test_x <= tx_nxt;
    test_y <= ty_nxt;
    test_rot <= trot_nxt;
    end

endmodule
