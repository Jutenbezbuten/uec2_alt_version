`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2020 08:38:27 PM
// Design Name: 
// Module Name: falserandom_generator
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


module falserandom_generator(
    input wire clkrand,
    input wire reset,
    
    output wire [2:0] rand
    );
    
reg [2:0] rand_count;
    
always@(posedge clkrand)begin
    if(reset)begin
        rand_count<=0;  
        end
    else begin
        if(rand_count==6)begin
            rand_count<=0;
            end
        else begin
            rand_count<=rand_count+1;
            end
        end
    end

assign rand = rand_count;
    
endmodule
