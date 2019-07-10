`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:43:05 11/19/2018 
// Design Name: 
// Module Name:    ctrl 
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
module ctrl(
	 input [5:0] Func, Op,
	 output RegDst, 
	 output Branch, 
	 output MtoR, 
	 output MW, MR, 
	 output [3:0] ALUOp,
	 output Alusel, 
	 output EXTOp, 
	 output RW, 
	 output J, Jal, Jr
    );
	
	//中间结果为指令
	wire addu, 
		  subu,
		  ori,
		  lw,
		  sw,
		  beq,
		  lui,
		  j,
		  jal,
		  jr;
	
	assign addu = (Op == 6'b000000 && Func == 6'b100001) ? 'b1 : 'b0,
			 subu = (Op == 6'b000000 && Func == 6'b100011) ? 'b1 : 'b0,
			 ori  = (Op == 6'b001101) ? 'b1 : 'b0,
			 lw   = (Op == 6'b100011) ? 'b1 : 'b0,
			 sw   = (Op == 6'b101011) ? 'b1 : 'b0,
			 beq  = (Op == 6'b000100) ? 'b1 : 'b0,
			 lui  = (Op == 6'b001111) ? 'b1 : 'b0,
			 j    = (Op == 6'b000010) ? 'b1 : 'b0,
			 jal  = (Op == 6'b000011) ? 'b1 : 'b0,
			 jr   = (Op == 6'b000000 && Func == 6'b001000 ) ? 'b1 : 'b0;
	//输出控制信号
	assign RegDst = (addu || subu) ? 'b1 : 'b0,
			 Branch = beq,
			 MtoR   = (addu || subu || ori || lui) ? 'b1 : 'b0,
			 MW     = sw,
			 MR     = lw,
			 ALUOp  = (addu || lw || sw) ? 4'b0001 : 
			{ 
				(subu || beq) ? 4'b0010 : 
				{ 
					ori ? 4'b0100 : 
					{
						lui ? 4'b1000 : 4'bx
					}
				}	
			},
			 Alusel = (ori || lw || sw || lui) ? 'b1 : 'b0,
			 EXTOp  = beq,
			 RW     = (addu || subu || ori || lw || lui || jal) ? 'b1 : 'b0,
			 J      = j,
			 Jal    = jal,
			 Jr     = jr;
	
endmodule
