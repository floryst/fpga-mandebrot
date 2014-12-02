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
	input f_memwrite,
	input [31:0] memaddr,
	input [31:0] writedata,
	
	output [31:0] readdata,
	
	// vga port
	input [10:0] vga_addr,
	output [7:0] vga_code
    );

	wire [31:0] data_read;
	wire [7:0] screen_code;
	assign readdata = (memaddr[13] & ~memaddr[14]) ? data_read :
		(~memaddr[13] & memaddr[14]) ? {24'b0, screen_code} : 32'b0;


	// f_write[1] is data_mem write flag
	//   equivalent to (memaddr[14:13]==2'b01 ? 1'b1, 1'b0)
	// f_write[0] is screen_mem write flag
	//   equivalent to (memaddr[14:13]==2'b10 ? 1'b1, 1'b0)
	// UPDATE: don't use f_write. Just use memaddr[15] and memaddr[14] directly.
	//
	//wire [1:0] f_write = {memaddr[13], memaddr[14]};

	data_mem datamem(
		.clk(clk),
		.f_memwrite(f_memwrite & memaddr[13]),
		.addr(memaddr[12:0]),
		.writedata(writedata),
		
		.readdata(data_read)
	);
	
	screen_mem screenmem(
		.clk(clk),
		.f_write(f_memwrite & memaddr[14]),
		.write_code(writedata[7:0]),
		.addr(memaddr[10:0]),
		
		.screen_code(screen_code),
		
		// vga port
		.vga_addr(vga_addr),
		.vga_code(vga_code)
	);

endmodule
