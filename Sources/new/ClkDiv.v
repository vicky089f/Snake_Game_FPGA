`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:06:58 09/08/2021 
// Design Name: 
// Module Name:    ClkDiv 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ClkDiv(
    input clk_in,
    input reset,
    output clk_debounce,
    output clk_snake
    );

reg [24:0] val; //reg used for counting
assign clk_snake = val[24];
assign clk_debounce = val[18];

always@(posedge clk_in, posedge reset)
begin
	if(reset) val = 0;
	else val = val+1;
end

endmodule
