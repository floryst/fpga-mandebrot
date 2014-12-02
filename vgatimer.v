`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:56:44 10/07/2014 
// Design Name: 
// Module Name:    vgatimer 
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

`include "display640x480.v"
module vgatimer(
input clk,
output hsync,
output vsync,
output activevideo,
output [`xbits-1:0] x,
output [`ybits-1:0] y
    );

	reg [1:0] clk_count=0;
	always @(posedge clk)
		clk_count <= clk_count + 2'b01;
	//assign Every2ndTick = (clk_count[0] == 1'b1);
	assign Every4thTick = (clk_count[1:0] == 2'b11);
	
	xycounter #(`WholeLine, `WholeFrame) xy(clk, Every4thTick, x, y);

	assign hsync = (x < `hSyncStart) || (x >= `hSyncEnd);
	assign vsync = (y < `vSyncStart) || (y >= `vSyncEnd);
	assign activevideo = (x < `hVisible) && (y < `vVisible);

endmodule
