`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:02 10/11/2018 
// Design Name: 
// Module Name:    code 
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
module code(
    input Clk,
    input Reset,
    input Slt,
    input En,
    output [63:0] Output0,
    output [63:0] Output1
    );
	//每个计数器初值为0，复位操作也会复位每个计数器当前的有效时钟周期。
	reg [63:0] Output0, Output1;
	//reg Clk;
	
	initial begin
		Output0 = 0;
		Output1 = 0;
	end
	
	integer i = 0;//用于计算时钟周期数
	
	always @(posedge Clk) begin
	//时钟上升沿来到，将两个计数器同时清零
		if(Reset) begin
			Output0 <= 0;
			Output1 <= 0;
			i <= 0; 
			//#5;/*Clk = 0;*///复位时钟周期，延时5ns正好是时钟上升沿
		end
		//如果使能端有效
		if(En) begin
			if(!Slt) begin//选择信号高电平,将这个有效时钟信号计入计数器0，每经过1个属于计数器0的有效时钟周期，计数器0累加1
				Output0 <= Output0 + 1;
			end
			else begin//选择信号低电平,将这个有效时钟信号计入计数器1，每经过4个属于计数器1的有效时钟周期，计数器1累加1
				i = i + 1;
				if(i == 4) begin
					i <= 0;
					Output1 <= Output1 + 1;
				end
			end
		end
	end

endmodule
