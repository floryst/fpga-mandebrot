`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: COMP 541
// Engineer: Forrest Li
// 
// Create Date:    11:00:39 11/16/2014 
// Design Name: 
// Module Name:    mipsCPU 
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
module mipsCPU(
	input clk,
	input rst,
	input [31:0] instr,
	input [31:0] readdata,

	output [31:0] pc,
	output [31:0] memaddr,
	output [31:0] writedata,
	output f_memwrite
    );

	wire [5:0] opcode;
	wire [5:0] func;
	wire [4:0] alufn;
	wire f_bne, f_beq, f_regwrite, f_zeroextend, f_dst_rt_rd, 
			f_shiftval, f_alusrc, f_mem2reg, f_jump1, f_jump2, f_lui;

	datapath mipsdatapath(
		.clk(clk),
		.readmem(readdata),
		.instr(instr),
		
		// input flags
		.alufn(alufn),
		.f_regwrite(f_regwrite),
		.f_bne(f_bne),
		.f_beq(f_beq),
		.f_zeroextend(f_zeroextend),
		.f_dst_rt_rd(f_dst_rt_rd),
		.f_shiftval(f_shiftval),
		.f_alusrc(f_alusrc),
		.f_mem2reg(f_mem2reg),
		.f_jump1(f_jump1),
		.f_jump2(f_jump2),
		.f_lui(f_lui),
		
		.memaddr(memaddr),
		.writedata(writedata),
		.pc(pc),
		.func(func),
		.opcode(opcode)
	);

	control mipscontrol(
		.opcode(opcode),
		.func(func),
		
		.alufn(alufn),
		.f_memwrite(f_memwrite),
		.f_regwrite(f_regwrite),
		.f_bne(f_bne),
		.f_beq(f_beq),
		.f_zeroextend(f_zeroextend),
		.f_dst_rt_rd(f_dst_rt_rd),
		.f_shiftval(f_shiftval),
		.f_alusrc(f_alusrc),
		.f_mem2reg(f_mem2reg),
		.f_jump1(f_jump1),
		.f_jump2(f_jump2),
		.f_lui(f_lui)
	);

endmodule
