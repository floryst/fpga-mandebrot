`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:30:57 09/15/2014 
// Design Name: 
// Module Name:    xycounter 
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
module xycounter #(parameter width=4, height=3)(
input clk, input on,
output reg [$clog2(width)-1:0] x=0,
output reg [$clog2(height)-1:0] y=0
    );

	always @(posedge clk) begin
		if (on) begin
			y <= y>=height-1 ? 0 : (x==width-1 ? y+1 : y);
			x <= x==width-1 ? 0 : x+1;
		end
	end

endmodule
