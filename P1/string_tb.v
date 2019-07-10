`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:19:18 10/26/2018
// Design Name:   string
// Module Name:   D:/ISE_code/P1/string_tb.v
// Project Name:  P1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: string
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module string_tb;

	// Inputs
	reg clk;
	reg clr;
	reg [7:0] in;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	string uut (
		.clk(clk), 
		.clr(clr), 
		.in(in), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		
		clr = 0;
		in = 0;

		// Wait 100 ns for global reset to finish
		
        in = "9";
		 #10;
		 in="+";
		 #10;
		 in="9";
		// Add stimulus here
	end
       always #5 clk=~clk;
		
		
	   initial #800 clr=1;
endmodule

