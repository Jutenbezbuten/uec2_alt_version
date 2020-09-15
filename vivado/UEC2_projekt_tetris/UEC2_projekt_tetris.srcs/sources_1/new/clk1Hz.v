`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2020 01:58:00 PM
// Design Name: 
// Module Name: clk1Hz
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


module clk1Hz(
    input wire clk65MHz,
    input wire reset,
    input wire game_reset,
    
    output wire clk1Hz
    );
    
reg [27:0] counter=0;
reg clk_out=0, clk05Hz_out=0;

always @(posedge clk65MHz) begin
    if(reset||game_reset)begin
        clk_out<=0;
        counter<=0;
        end
    else begin
        if (counter==59999999) begin
            counter <= counter+1;
            clk_out<= 1;
        end
        else if(counter == 65000000)begin
            counter <= 0;
            clk_out<= 1;
            end
        else begin
            counter <= counter+1;
            clk_out<= 0;
            end
    end
end


assign clk1Hz=clk_out;    
    
endmodule
