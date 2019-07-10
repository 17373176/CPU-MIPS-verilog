`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:35:38 10/12/2018 
// Design Name: 
// Module Name:    id_fsm 
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
module id_fsm(
	input [7:0] char,
	input clk,
	output reg out
    );

	reg state = 0;//¼ÇÂ¼µ±Ç°×´Ì¬
	
	initial begin
		out = 0;
	end
	
	integer flag = 0;
	
	always @(posedge clk) begin
		if((char >= 8'b01100001 && char <= 8'b01111010) || (char >= 8'b01000001 && char <= 8'b01011010) || (char >= 8'b00110000 && char <= 8'b00111001)) begin
			if((char >= 8'b01100001 && char <= 8'b01111010) || (char >= 8'b01000001 && char <= 8'b01011010)) begin
				if(flag) begin
					state <= 1;
					flag <= 0;
					out <= 0;
				end
				else begin
					state <= 1;
					out <= 0;
				end
			end
			else begin
				if(state)begin
					state <= 1;
					out <= 1;
					flag <= 1;
				end
			end
		end
		else begin
			state <= 0;
			flag <= 0;
			out <= 0;
		end
	end
	
endmodule
