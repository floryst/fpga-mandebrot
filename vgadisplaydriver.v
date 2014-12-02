`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Engineer:  Montek Singh
// Create Date:    10/1/2014 
//
//////////////////////////////////////////////////////////////////////////////////

module vgadisplaydriver(
    input clk,
    output [2:0] red,             // Nexys 3
    output [2:0] green,           // Nexys 3
    output [2:1] blue,            // Nexys 3
    output hsync,
    output vsync,

	 // fractmem
	 output [18:0] fractmem_addr,
	 input fractmem_pixel
    );

   wire [9:0] x;
   wire [9:0] y;
   vgatimer myvgatimer(clk, hsync, vsync, activevideo, x, y);

	assign fractmem_addr = (y[9:2] * 160) + x[9:2];

	wire [7:0] pixel;
	assign pixel = fractmem_pixel ? 8'b00000000 : 8'b11111111;
	assign {red,green,blue} = activevideo == 1 ? pixel : 8'b00000000;
endmodule