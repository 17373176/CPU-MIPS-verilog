`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:34:02 10/26/2018 
// Design Name: 
// Module Name:    gray 
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
module gray(
    input Clk,
    input Reset,
    input En,
    output reg [2:0] Output,
    output reg Overflow
    );
	
	initial begin
		Output = 2'b0;
		Overflow = 2'b0;
	end
	
	always @(posedge Clk) begin
	//时钟上升沿来到，将两个计数器同时清零
		if(Reset) begin
			Output <= 0;
			Overflow <= 0;
		end
		//如果使能端有效
		else if(En) begin
			if(Output == 3'b100) begin
				Output <= 3'b000;
				Overflow <= 'b1;
			end
			else begin
				case(Output)
					3'b000:
						Output <= 3'b001;
					3'b001:
						Output <= 3'b011;
					3'b011:
						Output <= 3'b010;
					3'b010:
						Output <= 3'b110;
					3'b110:
						Output <= 3'b111;
					3'b111:
						Output <= 3'b101;
					3'b101:
						Output <= 3'b100;
					default: Output <= 3'bx;
				endcase
			end
		end
	end




endmodule
