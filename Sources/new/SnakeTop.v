`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2021 11:50:18
// Design Name: 
// Module Name: square
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


module SnakeTop(
    input clk,
    input reset,
    input W,
    input A,
    input S,
    input D,
    output reg vga_hsync,
    output reg vga_vsync,
    output reg [3:0] vga_r,
    output reg [3:0] vga_g,
    output reg [3:0] vga_b
    );
    
    wire Clk_25,locked, Clk_Deb, Clk_Snake;
    wire [9:0] sx,sy;
    wire hsync,vsync,de;
    wire key,keypress;
    wire [2:0] Dir;
    wire q_draw, collide, over, food_draw;
    
    
    ClkDiv M1(clk, reset, Clk_Deb, Clk_Snake);
    
    assign key = W || A || S || D || collide;
    debounce M2(Clk_Deb, reset, key, keypress);
    
    SnakeFSM M3(keypress, reset, W,A,S,D, collide, Dir);
    
    clk_wiz_0 M4(.reset(reset), .clk_in(clk), .clk_out(Clk_25), .locked(locked));
    
    VGA_480p M5(Clk_25, !locked, sx, sy, hsync, vsync, de);
    
    SnakeBody M6(clk, reset, sx, sy, Dir, q_draw, collide, over, food_draw);
    
    
    
    always@(posedge Clk_25)
    begin
    vga_hsync <= hsync;
    vga_vsync <= vsync;
    if(Dir != 5) begin
        if(food_draw) begin
            vga_r <= 4'hf;
            vga_g <= 4'h0;
            vga_b <= 4'h0;
        end
        else begin
            vga_r <= !de ? 4'h0 : (q_draw ? 4'h9 : 4'h2);
            vga_g <= !de ? 4'h0 : (q_draw ? 4'h9 : 4'h2);
            vga_b <= !de ? 4'h0 : (q_draw ? 4'h9 : 4'h2);
        end
    end
    else begin
        vga_r <= 4'h0;
        vga_g <= 4'h0;
        vga_b <= 4'hf;
    end
    end
    
endmodule
