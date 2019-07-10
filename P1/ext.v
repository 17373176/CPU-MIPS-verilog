`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:04:35 10/26/2018 
// Design Name: 
// Module Name:    ext 
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
module ext(
    input [15:0] imm,
    input [1:0] EOp,
    output reg [31:0] ext
    );
	
	always @(*) begin
		case(EOp)
			2'b00:	
				if(imm[15] == 'b1) ext = {16'hffff, imm};
				else ext = {16'h0000, imm};
			2'b01:	
				ext = {16'h0000, imm};
			2'b10:	
				ext = {imm, 16'h0000};
			2'b11:	
				if(ext[31]) ext = {2'b11, 12'hfff, imm, 2'b00};
				else ext = {2'b00, 12'h000, imm, 2'b00};
		endcase
	end


endmodule
