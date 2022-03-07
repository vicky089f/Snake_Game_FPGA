`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2021 12:18:55
// Design Name: 
// Module Name: SnakeFSM
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


module SnakeFSM(
    input clkFSM,
    input reset,
    input W,
    input A,
    input S,
    input D,
    input X,
    output reg [2:0] state
    );
    
    parameter start = 0, Up = 1, Down = 2, Left = 3, Right = 4, Over = 5;
    
    reg [2:0] next;
    
    always@(posedge clkFSM, posedge reset)
    begin
        if(reset)
            state <= 0;
        else
            state <= next;
    end
    
    always@(clkFSM)
    begin
        if(X) next <= Over;
        else begin
            case(state)
                start: begin
                    case({W,A,S,D})
                        4'b1000: next <= Up;
                        4'b0010: next <= Down;
                        4'b0001: next <= Right;
                        default: next <= start;
                    endcase
                end
                Up: begin
                    case({W,A,S,D})
                        4'b0001: next <= Right;
                        4'b0100: next <= Left;
                        default: next <= Up;
                    endcase
                end
                Down: begin
                    case({W,A,S,D})
                        4'b0001: next <= Right;
                        4'b0100: next <= Left;
                        default: next <= Down;
                    endcase
                end
                Left: begin
                    case({W,A,S,D})
                        4'b1000: next <= Up;
                        4'b0010: next <= Down;
                        default: next <= Left;
                    endcase
                end
                Right: begin
                    case({W,A,S,D})
                        4'b1000: next <= Up;
                        4'b0010: next <= Down;
                        default: next <= Right;
                    endcase
                end
                Over: next <= Over;
                default: next <= start;
            endcase
        end
    end
    
endmodule
