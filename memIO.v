`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:31:35 11/16/2014 
// Design Name: 
// Module Name:    memIO 
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
module memIO(
	input clk,
	input ps2_clk,
	input ps2_data,
	input f_memwrite,
	input [31:0] memaddr,
	input [31:0] writedata,
	
	output [31:0] readdata,
	
	// keyboard port
	output [15:0] kb_char,
	
	// fractcore params
	output [31:0] fcPanX,
	output [31:0] fcPanY
	
	// vga port
	//input [10:0] vga_addr,
	//output [7:0] vga_code
    );

	wire [31:0] datamem_read;
	wire [15:0] keyboard_read;
	//wire [7:0] screen_code;
	//assign readdata = (memaddr[13] & ~memaddr[14]) ? data_read :
	//	(~memaddr[13] & memaddr[14]) ? {24'b0, screen_code} : 32'b0;

	assign readdata = memaddr[14:13] == 2'b01 ? datamem_read :
			memaddr[14:13] == 2'b11 ? {16'b0, keyboard_read} : 32'b0;

	// f_write[1] is data_mem write flag
	//   equivalent to (memaddr[14:13]==2'b01 ? 1'b1, 1'b0)
	// f_write[0] is screen_mem write flag
	//   equivalent to (memaddr[14:13]==2'b10 ? 1'b1, 1'b0)
	// UPDATE: don't use f_write. Just use memaddr[15] and memaddr[14] directly.
	//
	//wire [1:0] f_write = {memaddr[13], memaddr[14]};

	data_mem datamem(
		.clk(clk),
		.f_memwrite(f_memwrite & (memaddr[14:13] == 2'b01)),
		.addr(memaddr[12:0]),
		.writedata(writedata),
		
		.readdata(datamem_read),
		
		// fractcore params
		.fcpanX(fcPanX),
		.fcpanY(fcPanY)
	);

	keyboard kb(clk, ps2_clk, ps2_data, keyboard_read);
	assign kb_char = keyboard_read;
	
	/*
	screen_mem screenmem(
		.clk(clk),
		.f_write(f_memwrite & memaddr[14]),
		.write_code(writedata[7:0]),
		.addr(memaddr[10:0]),
		
		.screen_code(screen_code),
		
		// vga port
		.vga_addr(vga_addr),
		.vga_code(vga_code)
	);*/

endmodule
