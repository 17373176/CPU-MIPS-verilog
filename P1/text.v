`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:21:03 10/11/2018 
// Design Name: 
// Module Name:    text 
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
module text(
	output reg [3:0] c
    );
	reg [3:0] a ;
	reg b ;
	initial begin
		a = 4'b1000;
		
		b = 1;
		c=4'b0;
	
end
initial begin

#10;
	c=  signed(a)>>>b;
	
	$monitor("%b",c);
	end
endmodule
