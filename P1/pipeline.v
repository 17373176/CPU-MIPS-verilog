`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:55:50 10/12/2018 
// Design Name: 
// Module Name:    pipeline 
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
module pipeline(
	input clk,
	input [31:0] A1,
	input [31:0] A2,
	input [31:0] B1,
	input [31:0] B2,
	output reg [31:0] C = 0
    );
	
	reg [31:0] step1 [2:1];
	//reg [31:0] step2 = 0;
	integer i;
	
	initial begin
		for( i = 1 ; i <= 2; i = i + 1) begin
			step1[i] = 0;
		end
	end
	
	always @(posedge clk) begin
		step1[1] <= A1 * B1;
		step1[2] <= A2 * B2;
		
		C <= step1[1] + step1[2];
	end
endmodule
