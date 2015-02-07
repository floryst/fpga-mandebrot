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
	input ps2_clk,
	input ps2_data,
	
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
	wire [15:0] kb_char;
	
	wire fract_ready;
	wire fract_pixel;
	wire [18:0] fractmem_write_addr;
	wire fractmem_out_pixel;
	wire [18:0] fractmem_out_addr;
	wire [31:0] fcPanX;
	wire [31:0] fcPanY;
	wire [31:0] fcZoom;

	wire clk100, clk50, clk25, clk12;
	clockdivider_Nexys3 clkdv(clk, clk100, clk50, clk25, clk12);
	//assign clk50 = clk;
	
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
		.ps2_clk(ps2_clk),
		.ps2_data(ps2_data),
		.f_memwrite(f_memwrite),
		.memaddr(memaddr),
		.writedata(writedata),
		
		.readdata(readdata),
		
		// keyboard port
		.kb_char(kb_char),
		
		// fractcore params
		.fcPanX(fcPanX),
		.fcPanY(fcPanY),
		.fcZoom(fcZoom)
		
		// vga port
		//.vga_addr(vga_addr),
		//.vga_code(vga_code)
	);

	/* vgadisplay
	vgadisplay vga(
		.clk(clk),
		.screen_code(vga_code),
		
		.hsync(hsync),
		.vsync(vsync),
		.red(red),
		.green(green),
		.blue(blue),
		.screen_addr(vga_addr)
	);*/
	
	fractcore fc(
		.clk(clk50),
		.centerx(fcPanX),
		.centery(fcPanY),
		.zoom(fcZoom),
		
		.ready(fract_ready),
		.pixel(fract_pixel),
		.write_addr(fractmem_write_addr)
	);
	
	fractmem fm(
		.clk(clk50),
		.write(fract_ready),
		.write_pixel(fract_pixel),
		.write_addr(fractmem_write_addr),
		
		// for vga display
		.out_pixel(fractmem_out_pixel),
		.out_addr(fractmem_out_addr)
	);
	
	vgadisplaydriver vga(
		.clk(clk),
		.red(red),
		.green(green),
		.blue(blue),
		.hsync(hsync),
		.vsync(vsync),
		
		// fractmem
		.fractmem_addr(fractmem_out_addr),
		.fractmem_pixel(fractmem_out_pixel)
	);

endmodule
