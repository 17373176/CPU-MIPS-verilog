`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:23:10 11/19/2018 
// Design Name: 
// Module Name:    DM 
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
module DM( 
	 input clk,
    input clr,
	 input [9:0] A,
    input [31:0] WD,
    input SD, //存数信号
    input LD, //取数信号
	 input [31:0] PC, /*指令存储的地址，来自IFU*/
    output [31:0] RD
    );

	reg [31:0] ram[0:1023]; //32x1024RAM
	
	reg [31:0] data = 32'h00000000; //中间变量，读取数据
	
	wire [31:0] addr = {19'b0, A, 2'b0}; //输出地址乘4
	
	integer i;
	initial /*初始化数据存储器*/
		for(i = 0; i <= 1023; i = i + 1) ram[i] <= 32'h0;  
	
	always @(posedge clk) begin /*时钟上升沿将数据写入寄存器,同步复位*/
		if(clr) /*复位信号有效*/
			for(i = 0; i <= 1023; i = i + 1) ram[i] <= 32'h0;  
		else if(SD) begin/*存数信号有效*/
			ram[A] <= WD;
			$display("@%h: *%h <= %h", PC, addr, WD);
		end
	end
	
	always @(*) begin /*取数和其他无关*/
		if(LD && !(clr && clk)) data <= ram[A];
	end
	
	//连接线网
	assign RD = data;
	
endmodule
