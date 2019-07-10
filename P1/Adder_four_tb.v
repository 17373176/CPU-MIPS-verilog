`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:28:19 10/11/2018
// Design Name:   Adder_four
// Module Name:   D:/first/Adder_four_tb.v
// Project Name:  first
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Adder_four
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Adder_four_tb;

	// Inputs
	reg a0;
	reg a1;
	reg b0;
	reg b1;

	// Outputs
	wire s0;
	wire s1;
	wire Carry;

	// Instantiate the Unit Under Test (UUT)
	Adder_four uut (
		.a0(a0), 
		.a1(a1), 
		.b0(b0), 
		.b1(b1), 
		.s0(s0), 
		.s1(s1), 
		.Carry(Carry)
	);

	initial begin
		// Initialize Inputs
		a0 = 0;
		a1 = 1;
		b0 = 1;
		b1 = 1;

		// Wait 100 ns for global reset to finish
		#100;
      #100 a0 = 1; a1 = 1; b0 = 1; b1 = 1;
		// Add stimulus here

	end
      
endmodule

