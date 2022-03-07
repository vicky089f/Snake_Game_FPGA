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
    input Clk100M,
    input reset,
    input [9:0] sx,
    input [9:0] sy,
    input [2:0] Dir,
    output reg q_draw,
    output reg collide,
    output reg over,
    output reg food_draw
    );
    
    reg [9:0] head_x, head_y;
    reg [9:0] body_x [13:0];
    reg [9:0] body_y [13:0];
    reg eat;
    reg [3:0] len;
    reg [7:0] food_count;
    integer i;
    reg Clk_Snake;
    reg clk2, clk3, clk5, clk10;
    reg [26:0] count2, count3, count5, count10;
    
    vio_0 V(Clk100M, food_count);
    
    always@(posedge Clk100M, posedge reset)
    begin
        if(reset) begin
            count2 <= 0;
            clk2 <= 0;
        end
        else begin
            if(count2 == 20000000) begin
                count2 <= 0;
                clk2 <= ~clk2;
            end
            else begin
                count2 <= count2 + 1;
                clk2 <= clk2;
            end
        end
    end
    
    always@(posedge Clk100M, posedge reset)
    begin
        if(reset) begin
            count3 <= 0;
            clk3 <= 0;
        end
        else begin
            if(count3 == 16666667) begin
                count3 <= 0;
                clk3 <= ~clk3;
            end
            else begin
                count3 <= count3 + 1;
                clk3 <= clk3;
            end
        end
    end
    
    always@(posedge Clk100M, posedge reset)
    begin
        if(reset) begin
            count5 <= 0;
            clk5 <= 0;
        end
        else begin
            if(count5 == 10000000) begin
                count5 <= 0;
                clk5 <= ~clk5;
            end
            else begin
                count5 <= count5 + 1;
                clk5 <= clk5;
            end
        end
    end
    
    always@(posedge Clk100M, posedge reset)
    begin
        if(reset) begin
            count10 <= 0;
            clk10 <= 0;
        end
        else begin
            if(count10 == 1000000) begin
                count10 <= 0;
                clk10 <= ~clk10;
            end
            else begin
                count10 <= count10 + 1;
                clk10 <= clk10;
            end
        end
    end
    
    always@(food_count) begin: change_snake_clock
        if(food_count < 10) Clk_Snake <= clk2;
        else if(food_count < 15) Clk_Snake <= clk3;
        else if(food_count < 20) Clk_Snake <= clk5;
        else Clk_Snake <= clk10;
    end
    
    always@(posedge Clk_Snake, posedge reset)
        begin: head_motion
            if(reset) begin
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
        begin: body_motion
            if(reset) begin
                body_x[0] <= 256;
                body_y[0] <= 224;
                body_x[1] <= 224;
                body_y[1] <= 224;
                body_x[2] <= 192;
                body_y[2] <= 224;
                body_x[3] <= 160;
                body_y[3] <= 224;
                
                body_x[4] <= 128;
                body_y[4] <= 224;
                body_x[5] <= 96;
                body_y[5] <= 224;
                body_x[6] <= 64;
                body_y[6] <= 224;
                body_x[7] <= 32;
                body_y[7] <= 224;
            end
            else begin
                case(Dir)
                    0: begin
                        for (i=0; i<=13; i=i+1) begin
                            body_x[i] <= body_x[i];
                            body_y[i] <= body_y[i];
                        end
                    end
                    5: begin
                        for (i=0; i<=13; i=i+1) begin
                            body_x[i] <= body_x[i];
                            body_y[i] <= body_y[i];
                        end
                    end
                    default: begin
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
        
        /*always@(*)
        begin
            if((sx >= head_x && sx < head_x +32) && (sy >= head_y && sy < head_y +32))
                q_draw = 1;
            else begin
                for(i=0; i<= 30; i=i+1) begin
                    if(i <= (len-2)) begin
                        if((sx >= body_x[i] && sx < body_x[i] +32) && (sy >= body_y[i] && sy < body_y[i] +32))
                            q_draw = 1;
                        else
                            q_draw = 0;
                    end
                end
            end
        end*/
        
        always@(*)
        begin: display_snake
            //if(Dir == 5) begin over <= 1; q_draw <= 0; end
            //else begin
                //over <= 0;
                case(len)
                    3: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32))
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    4: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32))
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    5: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32))
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    6: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32))
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    7: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32))
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    8: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32))
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    9: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32)||
                        (sx > body_x[7] && sx < body_x[7] +32) && (sy > body_y[7] && sy < body_y[7] +32))
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    10: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32)||
                        (sx > body_x[7] && sx < body_x[7] +32) && (sy > body_y[7] && sy < body_y[7] +32)||
                        (sx > body_x[8] && sx < body_x[8] +32) && (sy > body_y[8] && sy < body_y[8] +32))
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    11: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
                        (sx > body_x[1] && sx < body_x[1] +32) && (sy > body_y[1] && sy < body_y[1] +32)||
                        (sx > body_x[2] && sx < body_x[2] +32) && (sy > body_y[2] && sy < body_y[2] +32)||
                        (sx > body_x[3] && sx < body_x[3] +32) && (sy > body_y[3] && sy < body_y[3] +32)||
                        (sx > body_x[4] && sx < body_x[4] +32) && (sy > body_y[4] && sy < body_y[4] +32)||
                        (sx > body_x[5] && sx < body_x[5] +32) && (sy > body_y[5] && sy < body_y[5] +32)||
                        (sx > body_x[6] && sx < body_x[6] +32) && (sy > body_y[6] && sy < body_y[6] +32)||
                        (sx > body_x[7] && sx < body_x[7] +32) && (sy > body_y[7] && sy < body_y[7] +32)||
                        (sx > body_x[8] && sx < body_x[8] +32) && (sy > body_y[8] && sy < body_y[8] +32)||
                        (sx > body_x[9] && sx < body_x[9] +32) && (sy > body_y[9] && sy < body_y[9] +32))
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    12: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
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
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    13: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
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
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    14: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
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
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                    15: begin
                        if((sx > head_x && sx < head_x +32) && (sy > head_y && sy < head_y +32)||
                        (sx > body_x[0] && sx < body_x[0] +32) && (sy > body_y[0] && sy < body_y[0] +32)||
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
                        q_draw <= 1;
                        else q_draw <= 0;
                    end
                endcase
            //end
        end
        
        always@(*)
        begin: game_over
            case(len)
                5: begin
                    if(head_x == body_x[3] && head_y == body_y[3]) collide = 1;
                    else collide = 0;
                end 
                6: begin
                    if((head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]))
                    collide = 1;
                    else collide = 0;
                end
                7: begin
                    if((head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]))
                    collide = 1;
                    else collide = 0;
                end
                8: begin
                    if((head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]) ||
                    (head_x == body_x[6] && head_y == body_y[6]))
                    collide = 1;
                    else collide = 0;
                end
                9: begin
                    if((head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]) ||
                    (head_x == body_x[6] && head_y == body_y[6]) ||
                    (head_x == body_x[7] && head_y == body_y[7]))
                    collide = 1;
                    else collide = 0;
                end
                10: begin
                    if((head_x == body_x[3] && head_y == body_y[3]) ||
                    (head_x == body_x[4] && head_y == body_y[4]) ||
                    (head_x == body_x[5] && head_y == body_y[5]) ||
                    (head_x == body_x[6] && head_y == body_y[6]) ||
                    (head_x == body_x[7] && head_y == body_y[7]) ||
                    (head_x == body_x[8] && head_y == body_y[8]))
                    collide = 1;
                    else collide = 0;
                end
                11: begin
                    if((head_x == body_x[3] && head_y == body_y[3]) ||
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
                    if((head_x == body_x[3] && head_y == body_y[3]) ||
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
                    if((head_x == body_x[3] && head_y == body_y[3]) ||
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
                    if((head_x == body_x[3] && head_y == body_y[3]) ||
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
                if((head_x == body_x[3] && head_y == body_y[3]) ||
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
        begin
            if(reset) begin
                len <= 3;
                food_count <= 0;
                food_x <= 416;
                food_y <= 160;
            end 
            else begin
                if((food_x == head_x) && (food_y == head_y))begin
                    if(len != 15) len <= len +1;
                    food_count <= food_count + 1;
                    food_x <= count_x;
                    food_y <= count_y;
                end
                else begin
                    len <= len;
                    food_count <= food_count;
                    food_x <= food_x;
                    food_y <= food_y;
                end
            end
        end
        
        /*always@(Clk_Snake)
        begin
            if(reset) len <= 3;
            else begin
                if(eat) len <= len + 1;
                else len <= len;
            end
        end
        
        always@(posedge Clk_Snake, posedge reset)
        begin: food_position_assignment
            if(reset) begin
                food_x <= 416;
                food_y <= 160;
            end
            else begin
                if(eat == 1) begin
                    food_x <= count_x;
                    food_y <= count_y;
                end
                else begin
                    food_x <= food_x;
                    food_y <= food_y;
                end
            end
        end*/
        
        always@(*)
        begin
            if((sx > food_x && sx < food_x +32) && (sy > food_y && sy < food_y +32))
                food_draw <= 1;
            else
                food_draw <= 0;
        end
    
endmodule
