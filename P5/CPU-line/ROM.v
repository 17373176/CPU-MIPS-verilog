`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:37:19 11/19/2018 
// Design Name: 
// Module Name:    ROM 
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
module ROM(
    input [9:0] A,
    output [31:0] D 
    );

	//assign A = 10'b0000000001;

	reg [31:0] rom[0:1023]; //4k_32bit*1024的ROM
	initial 
		$readmemh("code.txt", rom, 0 , 1023); //十六进制存储指令	

	assign D = rom[A];
	
endmodule
