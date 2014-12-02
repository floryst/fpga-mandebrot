`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: COMP 541
// Engineer: Forrest Li
// 
// Create Date:    12:13:45 11/16/2014 
// Design Name: 
// Module Name:    datapath 
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
module datapath(
	input clk,
	input [31:0] readmem,
	input [31:0] instr,
	
	input [4:0] alufn,
	input f_regwrite,
	input f_beq,
	input f_bne,
	input f_zeroextend,
	input f_dst_rt_rd,
	input f_shiftval,
	input f_alusrc,
	input f_mem2reg,
	// jump = {f_jump2,f_jump1}
	// jump=2'b00 - no jump
	// jump=2'b01 - j
	// jump=2'b10 - jr
	// jump=2'b11 - jal
	input f_jump1,
	input f_jump2,
	
	output [31:0] memaddr,
	output [31:0] writedata,
	output reg [31:0] pc = 32'b0,
	output [5:0] func,
	output [5:0] opcode
    );

	// main wires
	wire [4:0] reg1;
	wire [4:0] reg2;
	wire [4:0] writereg;
	wire [31:0] writeregdata;
	wire [31:0] reg1out;
	wire [31:0] reg2out;
	wire [31:0] srcA;
	wire [31:0] srcB;
	wire [31:0] aluout;
	// intermediates
	wire [31:0] pcplus4 = pc + 4'b0100;
	wire [31:0] pcplus8 = pc + 4'b1000;
	wire [31:0] branch_dst;
	wire [31:0] imm;
	wire [31:0] jumpaddr;
	// f_ for flag, l_ for logic
	wire f_Z;
	wire l_branch;

	assign opcode = instr[31:26];
	assign func = instr[5:0];
	
	// register file inputs (alu out & load word from datamem & jal ret ($31) store)
	assign writeregdata = f_mem2reg == 1 ? readmem : 
		(f_jump1 & f_jump2) ? pcplus8 : aluout;
	assign writereg = f_dst_rt_rd == 1 ? instr[15:11] : 
		(f_jump1 & f_jump2) ? 5'b11111 : instr[20:16];
	assign reg1 = instr[25:21];
	assign reg2 = instr[20:16];
	
	// zero extend
	assign imm = { (f_zeroextend == 1 ? 16'b0 : {16{instr[15]}}), instr[15:0] };

	// alu src (shifts & immediates)
	assign srcA = f_shiftval == 1 ? {27'b0, instr[10:6]} : reg1out;
	assign srcB = f_alusrc == 1 ? imm : reg2out;

	// branching
	assign l_branch = (f_beq & f_Z) | (f_bne & ~f_Z);
	assign branch_dst = pcplus4 + { imm[29:0], 2'b0 };
	
	// jumping
	assign jumpaddr = (f_jump2 & ~f_jump1) ? reg1out : { pcplus4[31:28], instr[25:0], 2'b0 };
	
	// load/store word
	assign memaddr = aluout;
	assign writedata = reg2out;

	always @(posedge clk)
		pc <= l_branch ? branch_dst : 
			(f_jump2 | f_jump1) ? jumpaddr : pcplus4;

	register_file regfile(
		.clk(clk),
		.f_regwrite(f_regwrite),
		.reg1(reg1),
		.reg2(reg2),
		.writereg(writereg),
		.writedata(writeregdata),
		
		.reg1out(reg1out),
		.reg2out(reg2out)
	);
	
	ALU #(32) alu(
		.A(srcA),
		.B(srcB),
		.ALUfn(alufn),
		
		.R(aluout),
		.FlagZ(f_Z)
	);

endmodule
