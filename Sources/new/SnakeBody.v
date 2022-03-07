`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2021 12:11:57
// Design Name: 
// Module Name: SnakeBody
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


module SnakeBody(
    //input Clk_Snake,
    input clk2,
    input clk3,
    input clk5,
    input clk10,
    input reset,
    input [9:0] sx,
    input [9:0] sy,
    input [2:0] Dir,
    output reg head_draw,
    output reg snake_draw,
    output reg collide,
    output reg food_draw,
    output reg [7:0] food_count
    );
    
    reg [9:0] head_x, head_y;
    reg [9:0] body_x [13:0];
    reg [9:0] body_y [13:0];
    reg [3:0] len;
    integer i;
    wire Clk_Snake;
    
    assign Clk_Snake = (len < 10)? clk2 : (len < 15)? clk3 : (len < 20)? clk5 : clk10;
    
    always@(posedge Clk_Snake, posedge reset)
        begin: snake_head_motion
            if(reset) begin //assign initial head position
                head_x <= 288;
                head_y <= 224;
            end
            else begin
                case(Dir)
                    1: begin //Up
                        head_x <= head_x;
                        if(head_y == 0) head_y <= 480-32;
                        else head_y <= head_y - 32;
                    end
                    2: begin //Down
                        head_x <= head_x;
                        if(head_y == 480-32) head_y <= 0;
                        else head_y <= head_y + 32;
                    end
                    3: begin //Left
                        head_y <= head_y;
                        if(head_x == 0) head_x <= 640-32;
                        else head_x <= head_x - 32;
                    end
                    4:begin //Right
                        head_y <= head_y;
                        if(head_x == 640-32) head_x <= 0;
                        else head_x <= head_x + 32;
                    end
                    default: begin
                        head_x <= head_x;
                        head_y <= head_y;
                    end 
                endcase
            end
        end
        
        always@(posedge Clk_Snake, posedge reset)
        begin: snake_body_motion
            if(reset) begin //assign initial positions
                body_x[0] <= 256;
                body_y[0] <= 224;
                body_x[1] <= 224;
                body_y[1] <= 224;
            end
            else begin
                case(Dir)
                    0: begin
                        for (i=0; i<=13; i=i+1) begin //Game has not started - Snake doesnt move
                            body_x[i] <= body_x[i];
                            body_y[i] <= body_y[i];
                        end
                    end
                    5: begin
                        for (i=0; i<=13; i=i+1) begin //Game over - Snake doesnt move
                            body_x[i] <= body_x[i];
                            body_y[i] <= body_y[i];
                        end
                    end
                    default: begin //Game in progress - Snake moves
                        for (i=1; i<=13; i=i+1) begin
                            body_x[i] <= body_x[i-1];
                            body_y[i] <= body_y[i-1];
                        end
                        body_x[0] <= head_x;
                        body_y[0] <= head_y;
                    end
                endcase
            end
        end
        
        always@(*)
        begin: display_snake
                case(len)
                    3: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    4: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    5: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    6: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    7: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    8: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    9: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32)||
                        (sx > body_x[7] && sx < body_x[7] +32) && (sy > body_y[7] && sy < body_y[7] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    10: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32)||
                        (sx > body_x[7] && sx < body_x[7] +32) && (sy > body_y[7] && sy < body_y[7] +32)||
                        (sx > body_x[8] && sx < body_x[8] +32) && (sy > body_y[8] && sy < body_y[8] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    11: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32)||
                        (sx > body_x[7] && sx < body_x[7] +32) && (sy > body_y[7] && sy < body_y[7] +32)||
                        (sx > body_x[8] && sx < body_x[8] +32) && (sy > body_y[8] && sy < body_y[8] +32)||
                        (sx > body_x[9] && sx < body_x[9] +32) && (sy > body_y[9] && sy < body_y[9] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    12: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32)||
                        (sx > body_x[7] && sx < body_x[7] +32) && (sy > body_y[7] && sy < body_y[7] +32)||
                        (sx > body_x[8] && sx < body_x[8] +32) && (sy > body_y[8] && sy < body_y[8] +32)||
                        (sx > body_x[9] && sx < body_x[9] +32) && (sy > body_y[9] && sy < body_y[9] +32)||
                        (sx > body_x[10] && sx < body_x[10] +32) && (sy > body_y[10] && sy < body_y[10] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    13: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32)||
                        (sx > body_x[7] && sx < body_x[7] +32) && (sy > body_y[7] && sy < body_y[7] +32)||
                        (sx > body_x[8] && sx < body_x[8] +32) && (sy > body_y[8] && sy < body_y[8] +32)||
                        (sx > body_x[9] && sx < body_x[9] +32) && (sy > body_y[9] && sy < body_y[9] +32)||
                        (sx > body_x[10] && sx < body_x[10] +32) && (sy > body_y[10] && sy < body_y[10] +32)||
                        (sx > body_x[11] && sx < body_x[11] +32) && (sy > body_y[11] && sy < body_y[11] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    14: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32)||
                        (sx > body_x[7] && sx < body_x[7] +32) && (sy > body_y[7] && sy < body_y[7] +32)||
                        (sx > body_x[8] && sx < body_x[8] +32) && (sy > body_y[8] && sy < body_y[8] +32)||
                        (sx > body_x[9] && sx < body_x[9] +32) && (sy > body_y[9] && sy < body_y[9] +32)||
                        (sx > body_x[10] && sx < body_x[10] +32) && (sy > body_y[10] && sy < body_y[10] +32)||
                        (sx > body_x[11] && sx < body_x[11] +32) && (sy > body_y[11] && sy < body_y[11] +32)||
                        (sx > body_x[12] && sx < body_x[12] +32) && (sy > body_y[12] && sy < body_y[12] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                    15: begin
                        if((sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32)||
                        (sx > body_x[7] && sx < body_x[7] +32) && (sy > body_y[7] && sy < body_y[7] +32)||
                        (sx > body_x[8] && sx < body_x[8] +32) && (sy > body_y[8] && sy < body_y[8] +32)||
                        (sx > body_x[9] && sx < body_x[9] +32) && (sy > body_y[9] && sy < body_y[9] +32)||
                        (sx > body_x[10] && sx < body_x[10] +32) && (sy > body_y[10] && sy < body_y[10] +32)||
                        (sx > body_x[11] && sx < body_x[11] +32) && (sy > body_y[11] && sy < body_y[11] +32)||
                        (sx > body_x[12] && sx < body_x[12] +32) && (sy > body_y[12] && sy < body_y[12] +32)||
                        (sx > body_x[13] && sx < body_x[13] +32) && (sy > body_y[13] && sy < body_y[13] +32))
                        snake_draw <= 1;
                        else snake_draw <= 0;
                    end
                endcase
        end
        
        always@(*)
        begin: display_head
            if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32))
                head_draw = 1;
            else
                head_draw = 0;
        end
        
        always@(*)
        begin: game_over
            if(reset) collide = 0;
            else begin
            case(len)
                5: begin
                    if((head_x == body_x[0] && head_y == body_y[0]) ||
                    (head_x == body_x[1] && head_y == body_y[1]) ||
                    (head_x == body_x[2] && head_y == body_y[2]) ||
                    (head_x == body_x[3] && head_y == body_y[3])) collide = 1;
                    else collide = 0;
                end 
                6: begin
                    if((head_x == body_x[0] && head_y == body_y[0]) ||
                    (head_x == body_x[1] && head_y == body_y[1]) ||
                    (head_x == body_x[2] && head_y == body_y[2]) ||
                    (head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]))
                    collide = 1;
                    else collide = 0;
                end
                7: begin
                    if((head_x == body_x[0] && head_y == body_y[0]) ||
                    (head_x == body_x[1] && head_y == body_y[1]) ||
                    (head_x == body_x[2] && head_y == body_y[2]) ||
                    (head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]))
                    collide = 1;
                    else collide = 0;
                end
                8: begin
                    if((head_x == body_x[0] && head_y == body_y[0]) ||
                    (head_x == body_x[1] && head_y == body_y[1]) ||
                    (head_x == body_x[2] && head_y == body_y[2]) ||
                    (head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]) ||
                    (head_x == body_x[6] && head_y == body_y[6]))
                    collide = 1;
                    else collide = 0;
                end
                9: begin
                    if((head_x == body_x[0] && head_y == body_y[0]) ||
                    (head_x == body_x[1] && head_y == body_y[1]) ||
                    (head_x == body_x[2] && head_y == body_y[2]) ||
                    (head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]) ||
                    (head_x == body_x[6] && head_y == body_y[6]) ||
                    (head_x == body_x[7] && head_y == body_y[7]))
                    collide = 1;
                    else collide = 0;
                end
                10: begin
                    if((head_x == body_x[0] && head_y == body_y[0]) ||
                    (head_x == body_x[1] && head_y == body_y[1]) ||
                    (head_x == body_x[2] && head_y == body_y[2]) ||
                    (head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]) ||
                    (head_x == body_x[6] && head_y == body_y[6]) ||
                    (head_x == body_x[7] && head_y == body_y[7]) ||
                    (head_x == body_x[8] && head_y == body_y[8]))
                    collide = 1;
                    else collide = 0;
                end
                11: begin
                    if((head_x == body_x[0] && head_y == body_y[0]) ||
                    (head_x == body_x[1] && head_y == body_y[1]) ||
                    (head_x == body_x[2] && head_y == body_y[2]) ||
                    (head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]) ||
                    (head_x == body_x[6] && head_y == body_y[6]) ||
                    (head_x == body_x[7] && head_y == body_y[7]) ||
                    (head_x == body_x[8] && head_y == body_y[8]) ||
                    (head_x == body_x[9] && head_y == body_y[9]))
                    collide = 1;
                    else collide = 0;
                end
                12: begin
                    if((head_x == body_x[0] && head_y == body_y[0]) ||
                    (head_x == body_x[1] && head_y == body_y[1]) ||
                    (head_x == body_x[2] && head_y == body_y[2]) ||
                    (head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]) ||
                    (head_x == body_x[6] && head_y == body_y[6]) ||
                    (head_x == body_x[7] && head_y == body_y[7]) ||
                    (head_x == body_x[8] && head_y == body_y[8]) ||
                    (head_x == body_x[9] && head_y == body_y[9]) ||
                    (head_x == body_x[10] && head_y == body_y[10]))
                    collide = 1;
                    else collide = 0;
                end
                13: begin
                    if((head_x == body_x[0] && head_y == body_y[0]) ||
                    (head_x == body_x[1] && head_y == body_y[1]) ||
                    (head_x == body_x[2] && head_y == body_y[2]) ||
                    (head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]) ||
                    (head_x == body_x[6] && head_y == body_y[6]) ||
                    (head_x == body_x[7] && head_y == body_y[7]) ||
                    (head_x == body_x[8] && head_y == body_y[8]) ||
                    (head_x == body_x[9] && head_y == body_y[9]) ||
                    (head_x == body_x[10] && head_y == body_y[10]) ||
                    (head_x == body_x[11] && head_y == body_y[11]))
                    collide = 1;
                    else collide = 0;
                end
                14: begin
                    if((head_x == body_x[0] && head_y == body_y[0]) ||
                    (head_x == body_x[1] && head_y == body_y[1]) ||
                    (head_x == body_x[2] && head_y == body_y[2]) ||
                    (head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]) ||
                    (head_x == body_x[6] && head_y == body_y[6]) ||
                    (head_x == body_x[7] && head_y == body_y[7]) ||
                    (head_x == body_x[8] && head_y == body_y[8]) ||
                    (head_x == body_x[9] && head_y == body_y[9]) ||
                    (head_x == body_x[10] && head_y == body_y[10]) ||
                    (head_x == body_x[11] && head_y == body_y[11]) ||
                    (head_x == body_x[12] && head_y == body_y[12]))
                    collide = 1;
                    else collide = 0;
                end
                15: begin 
                    if((head_x == body_x[0] && head_y == body_y[0]) ||
                    (head_x == body_x[1] && head_y == body_y[1]) ||
                    (head_x == body_x[2] && head_y == body_y[2]) ||
                    (head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]) ||
                    (head_x == body_x[6] && head_y == body_y[6]) ||
                    (head_x == body_x[7] && head_y == body_y[7]) ||
                    (head_x == body_x[8] && head_y == body_y[8]) ||
                    (head_x == body_x[9] && head_y == body_y[9]) ||
                    (head_x == body_x[10] && head_y == body_y[10]) ||
                    (head_x == body_x[11] && head_y == body_y[11]) ||
                    (head_x == body_x[12] && head_y == body_y[12]) ||
                    (head_x == body_x[13] && head_y == body_y[13]))
                        collide = 1;
                    else collide = 0;
                end
            endcase
            end
        end
        
        reg [9:0] count_x,count_y,food_x,food_y;
        
        always@(posedge Clk_Snake, posedge reset)
        begin : food_position_counter
            if(reset) begin
                count_x <= 0;
                count_y <= 448;
            end
            else begin
                if(count_x == 608)
                    count_x <= 0;
                else
                    count_x <= count_x + 32;
                if(count_y == 0)
                    count_y <= 448;
                else
                    count_y <= count_y - 32;
            end
        end
        
        always@(posedge Clk_Snake, posedge reset)
        begin: snake_grow
            if(reset) begin
                food_count <= 0;
                len <= 3;
                food_x <= 416;
                food_y <= 160;
            end 
            else begin
                if((food_x == head_x) && (food_y == head_y)) begin
                    food_count <= food_count + 1;
                    if(len != 15) len <= len +1;
                    food_x <= count_x;
                    food_y <= count_y;
                end
                else begin
                    food_count <= food_count;
                    len <= len;
                    food_x <= food_x;
                    food_y <= food_y;
                end
            end
        end
        
        always@(*)
        begin
            if((sx > food_x && sx < food_x +32) && (sy > food_y && sy < food_y +32))
                food_draw <= 1;
            else
                food_draw <= 0;
        end
    
endmodule
