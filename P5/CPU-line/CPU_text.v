`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:25:16 11/24/2018
// Design Name:   mips
// Module Name:   D:/ISE_code/P5/CPU_text.v
// Project Name:  P4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
 
module CPU_text;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	mips uut(
	.clk(clk),
	.reset(reset)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		//#10 reset=1;
		#12 reset = 0;
		// Wait 100 ns for global reset to finish
        
		// Add stimulus here

	end
	
	
	always begin
		#5 clk = ~clk;
	end
endmodule

