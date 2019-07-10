`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:24:45 10/11/2018 
// Design Name: 
// Module Name:    Adder_four 
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
module Adder_four(
	input a0,
	input a1,
	input b0,
	input b1,
	output s0,
	output s1,
	output Carry
    );
	wire c, cout1, cout2, cout3;
	assign {cout1, s0} = a0 + b0;
	assign {cout2, c} = cout1 + a1;
	assign {cout3, s1} = c + b1;
	assign Carry = cout2 +cout3;

endmodule
