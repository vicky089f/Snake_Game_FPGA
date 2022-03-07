`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:16:04 09/22/2021 
// Design Name: 
// Module Name:    debounce 
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
module debounce(
    input clk,
    input reset,
    input in,
    output out
    );

reg q1,q2,q3;

assign out = q1 & q2 & ~q3;

always@(posedge clk, posedge reset)
begin
	if(reset) begin
		q1 <= 0;
		q2 <= 0;
		q3 <= 0;
	end
	else begin
		q1 <= in;
		q2 <= q1;
		q3 <= q2;
	end
end

endmodule
