`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: COMP 541
// Engineer: Forrest Li
// 
// Create Date:    22:51:50 11/16/2014 
// Design Name: 
// Module Name:    vgadisplay 
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

module vgadisplay(
	input clk,
	input [7:0] screen_code,
	
	output hsync,
	output vsync,
	output [2:0] red,
	output [2:0] green,
	output [2:1] blue,
	output [10:0] screen_addr
    );

	wire activevideo;
	wire [`xbits-1:0] x; // 10 bits
	wire [`ybits-1:0] y; // 10 bits
	// 9:8 - selected bitmap character
	// 7:0 - position in the 16x16 character
	wire [9:0] bitmap_addr;
	wire [7:0] pixel;
	
	// 16x16 characters
	// y'=floor(y/16)=y[9:4] (same with x)
	// y'*40+x' = y'<<5 + y'<<3 + x'
	assign screen_addr = {y[9:4], 5'b0} + {y[9:4], 3'b0} + {5'b0, x[9:4]};
	
	// y'=y%16=y[3:0] (same with x)
	// y'*16+x' = y'<<4 + x'
	assign bitmap_addr[7:0] = {y[3:0], 4'b0} + {4'b0, x[3:0]};
	assign bitmap_addr[9:8] = screen_code[1:0];

	// pixel to rgb
	assign red[2:0] = activevideo ? pixel[7:5] : 3'b0;
	assign green[2:0] = activevideo ? pixel[4:2] : 3'b0;
	assign blue[2:1] = activevideo ? pixel[1:0] : 2'b0;

	vgatimer timer(
		.clk(clk),
		
		.hsync(hsync),
		.vsync(vsync),
		.activevideo(activevideo),
		.x(x),
		.y(y)
	);
	
	bitmap_mem #(10) bitmapmem(
		.addr(bitmap_addr),
		.pixel(pixel)
	);

endmodule
