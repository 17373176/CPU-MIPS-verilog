`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:23:02 11/19/2018 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
	 input CLK,
	 input RESET,
	 input WE, /*寄存器写入使能信号*/
	 input [4:0]A1, A2, WA, /*三个地址*/
	 input [31:0] WD, /*写入数据*/
	 input [31:0] PC, /*指令存储的地址，来自IFU*/
	 output [31:0] RD1, RD2
    );
	
	reg [31:0] grf[0:31]; //32个寄存器
	
	integer i;
	initial /*初始化寄存器*/
		for(i = 0; i <= 31; i = i + 1) grf[i] <= 32'h0;
	
	always @(posedge CLK) begin /*时钟上升沿才写入数据，同步复位*/
		if(RESET) /*复位信号有效*/
			for(i = 0; i <= 31; i = i + 1) grf[i] <= 32'h0;
		else if(WE) begin/*写入使能信号有效*/
			if(WA != 32'h0) grf[WA] <= WD; /*保证0号寄存器为0*/
			$display("@%h: $%d <= %h", PC, WA, WD);
		end
	end
	
	//输出端口对应地址的寄存器的值
	assign RD1 = grf[A1];
	assign RD2 = grf[A2];
	
endmodule
