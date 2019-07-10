`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:53:53 10/26/2018 
// Design Name: 
// Module Name:    string 
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
module string(
    input clk,
    input clr,
    input [7:0] in,
    output reg out
    );

	parameter 
		S0 = 2'b00,//¶ººÅ¸ô¿ª
		S1 = 2'b01,
		S2 = 2'b10,
		S3 = 2'b11;
	
	reg [1:0] state = S0;
	initial out = 0;
	
	always @(posedge clk or posedge clr) begin
		if(clr) begin //Òì²½¸´Î»
			state <= S0;
			out <= 0;
		end
		else begin
			case(state)
				S0:
					if(in <= 8'b00111001 && in >= 8'b00110000) begin
						state <= S1;
						out <= 1;
					end
					else begin
						state <= S3;
						out <= 0;
					end
				S1:
					if(in == 8'b00101010 || in == 8'b00101011) begin
						state <= S2;
						out <= 0;
					end
					else begin
						out <= 0;
						state <= S3;
					end
				S2:
					if(in <= 8'b00111001 && in >= 8'b00110000) begin
						state <= S1;
						out <= 1;
					end
					else begin
						out <= 0;
						state <= S3;
					end
				S3: begin
					out <= 0;
					state <= S3;
					end
				default: begin
					out <= 0;
					state <= 2'bx;
					end
			endcase
		end
	end
endmodule
