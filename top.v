`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: COMP 541
// Engineer: Forrest Li
// 
// Create Date:    10:52:03 11/16/2014 
// Design Name: 
// Module Name:    top 
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
module top(
	input clk,
	input rst,
	
	output hsync,
	output vsync,
	output [2:0] red,
	output [2:0] green,
	output [2:1] blue
    );

	wire [31:0] pc;
	wire [31:0] instr;
	wire f_memwrite;
	wire [31:0] readdata;
	wire [31:0] writedata;
	wire [31:0] memaddr;
	wire [10:0] vga_addr;
	wire [7:0] vga_code;

	wire clk100, clk50, clk25, clk12;
	//clockdivider_Nexys3 clkdv(clk, clk100, clk50, clk25, clk12);
	assign clk50 = clk;
	
	mipsCPU cpu(
		.clk(clk50),
		.rst(rst),
		.instr(instr),
		.readdata(readdata),
		
		.pc(pc),
		.memaddr(memaddr),
		.writedata(writedata),
		.f_memwrite(f_memwrite)
	);

	// imem
	instr_mem imem(
		.pc(pc),

		.instr(instr)
	);

	// memio
	memIO memio(
		.clk(clk50),
		.f_memwrite(f_memwrite),
		.memaddr(memaddr),
		.writedata(writedata),
		
		.readdata(readdata),
		
		// vga port
		.vga_addr(vga_addr),
		.vga_code(vga_code)
	);

	// vgadisplay
	vgadisplay vga(
		.clk(clk),
		.screen_code(vga_code),
		
		.hsync(hsync),
		.vsync(vsync),
		.red(red),
		.green(green),
		.blue(blue),
		.screen_addr(vga_addr)
	);

endmodule
