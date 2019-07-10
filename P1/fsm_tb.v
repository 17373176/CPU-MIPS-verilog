`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:31:46 10/12/2018
// Design Name:   fsm_1010
// Module Name:   D:/ISE_code/fsm_tb.v
// Project Name:  first
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fsm_1010
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fsm_tb;

	// Inputs
	reg clk;
	reg in;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	fsm_1010 uut (
		.clk(clk), 
		.in(in), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		in = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#10 ;
		in=0;
		#20;
		in=1;
		#20;
		in=1;
		#20;
		in=0;
		#20;
		in=1;
		#20;
		in=0;
		#10;
	end
   always #10 clk=~clk; 
endmodule

