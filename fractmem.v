`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:49:16 12/01/2014 
// Design Name: 
// Module Name:    screen_mem 
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
module fractmem(
input clk,
input write,
input write_pixel,
input [18:0] write_addr,
input [18:0] out_addr,
output out_pixel
    );

// 640x480
reg pixel_mem [19199:0];
initial $readmemb("pixels.txt", pixel_mem, 0, 19199);

always @(posedge clk)
	pixel_mem[write_addr] <= write ? write_pixel : pixel_mem[write_addr];

assign out_pixel = pixel_mem[out_addr];

endmodule
