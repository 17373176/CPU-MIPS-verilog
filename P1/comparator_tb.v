`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:16:18 10/11/2018
// Design Name:   comparator
// Module Name:   D:/first/comparator_tb.v
// Project Name:  first
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: comparator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module comparator_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [3:0] a;
	reg [3:0] b;

	// Outputs
	wire c;

	// Instantiate the Unit Under Test (UUT)
	comparator uut (
		.clk(clk), 
		.reset(reset), 
		.a(a), 
		.b(b), 
		.c(c)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		a = 3;
		b = 1;

		// Wait 100 ns for global reset to finish
		#100 b = -1;
      
		// Add stimulus here

	end
   always #100 clk = ~clk;
      
endmodule

