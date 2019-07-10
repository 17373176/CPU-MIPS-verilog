`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:37:46 10/26/2018
// Design Name:   text
// Module Name:   D:/ISE_code/text_tb.v
// Project Name:  P1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: text
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module text_tb;

	// Inputs
	

	// Outputs
	wire [3:0] c;

	// Instantiate the Unit Under Test (UUT)
	text uut (
		
		.c(c)
	);

	initial begin
		// Initialize Inputs
		
		
	

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

