`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:22:42 11/19/2018 
// Design Name: 
// Module Name:    IFU 
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
module IFU(	
    input CLK,
	 input RESET,
	 input Zero,
	 input [31:0] beq, //指令中立即数imm移位且符号扩展后的值
	 input jump,
	 input jr,
	 inout [31:0] ra, //32位$ra的值($31=PC+4)
	 input [25:0] index, //instr_index(指令码后26位)
	 output [31:0] Instr,
	 output [31:0] PC, PC_ //PC当前、PC+4的值
	 );
	
	reg [31:0] rgt = 32'h00003000; //指令寄存器
	wire [31:0] PC_s; //PC的次态
	wire [31:0] index_s; //index在J和Jal指令下扩展的值
	wire [1:0] sel; //定义2bit-PC_s输出选择信号
	
	always @(posedge CLK) begin /*时钟上升沿,同步复位*/
		if(RESET) rgt <= 32'h00003000; //初始地址0x00003000
		else rgt <= PC_s;
	end
	
	assign PC = rgt;
	
	//调用ROM指令存储器
	ROM IM(
    .A(PC[11:2]), 
    .D(Instr)
    );
	
	assign PC_ = !Zero ? (PC + 32'h4) : (beq + PC + 32'h4); /*beq跳转指令的PC值*/
	assign index_s = {PC[31:28], index, 2'b0};
	
	assign sel = {jr, jump};
	//选择输出PC_s
	assign PC_s = (!sel[0] && !sel[1]) ? PC_ : /*sel=00输出为PC_*/
	{
		(sel[0] && !sel[1]) ? index_s : /*sel=01输出为index_*/
		{
			(!sel[0] && sel[1]) ? ra : 32'hx /*sel=10输出为ra,否则输出0*/
		}
	};


endmodule
