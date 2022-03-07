`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2021 22:47:43
// Design Name: 
// Module Name: VGA_480p
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


module VGA_480p(
    input clk,
    input reset,
    output reg [9:0] pos_x,
    output reg [9:0] pos_y,
    output hsync,
    output vsync,
    output data_en
    );
    
    parameter HA_END = 639, HS_BEG = HA_END + 16, HS_END = HS_BEG + 96, LINE = 799;
    parameter VA_END = 479, VS_BEG = VA_END + 10, VS_END = VS_BEG + 2, SCREEN = 524;
    
    assign hsync = ~(pos_x >= HS_BEG && pos_x < HS_END);
    assign vsync = ~(pos_y >= VS_BEG && pos_y < VS_END);
    assign data_en = (pos_x <= HA_END && pos_y <= VA_END);
    
    always@(posedge clk)
    begin
        if(reset) begin
            pos_x <= 0;
            pos_y <= 0;
        end
        else begin
            if(pos_x == LINE) begin
                pos_x <= 0;
                if(pos_y == SCREEN)
                    pos_y <= 0;
                else
                    pos_y <= pos_y +1;
            end
            else
                pos_x <= pos_x +1;
        end
    end
    
endmodule
