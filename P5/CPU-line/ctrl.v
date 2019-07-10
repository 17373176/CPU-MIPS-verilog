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
	 output Branch,  /*beq跳转*/
	 output MtoR, 
	 output MW, MR, 
	 output [3:0] ALUOp,
	 output Alusel, 
	 output RW, 
	 output J, Jal, Jr, Jalr,
	 output LB,
	 
	 // 课上新增指令
	 //output bltzalr,
	 
	 output addu, subu, ori, lw, sw, beq, lui, j, jal, jr, lb, jalr, rotrv, rotr, blez, bltzal, /*sb,*/ clz
    );
	
	
	assign addu = (Op == 6'b000000 && Func == 6'b100001),
			 subu = (Op == 6'b000000 && Func == 6'b100011),
			 ori  = (Op == 6'b001101),
			 lw   = (Op == 6'b100011),
			 sw   = (Op == 6'b101011),
			 beq  = (Op == 6'b000100),
			 lui  = (Op == 6'b001111),
			 j    = (Op == 6'b000010),
			 jal  = (Op == 6'b000011),
			 jr   = (Op == 6'b000000 && Func == 6'b001000),
			 jalr = (Op == 6'b000000 && Func == 6'b001001),
			 lb   = (Op == 6'b100000),
			 blez = (Op == 6'b000110),
			 rotrv = (Op == 6'b000000 && Func == 6'b000110),
			 bltzal =(Op == 6'b000001),
			 rotr = (Op == 6'b000000 && Func == 6'b000010), //????? 
			 clz  = (Op == 6'b011100 && Func == 6'b100000);
			 //sb   = (Op == 6'b101000);
		    //课上新增指令
			 
	
	//输出控制信号
	assign RegDst = (addu || subu || rotrv || clz), // clz, rotrv, rotr选择rd寄存器写入
			 Branch = beq,
			 MtoR   = lw,
			 MW     = sw,
			 MR     = (lw || lb),
			 ALUOp  = (addu || lw || sw || lb) ? 4'b0001 : 
			{ 
				subu ? 4'b0010 : 
				{ 
					ori ? 4'b0100 : 
					{
						lui ? 4'b1000 : 
						rotrv ? 4'b1001 : //新增操作
						clz ? 4'b1010 : 4'bx //新增操作
					}
				}	
			},
			 Alusel = (ori || lw || sw || lui || lb),
			 RW     = (addu || subu || ori || lw || lui || jal || lb || rotrv || bltzal || clz), //写寄存器
			 J      = j,
			 Jal    = jal,
			 Jalr   = jalr,
			 Jr     = jr,
			 LB     = lb;
	
endmodule
