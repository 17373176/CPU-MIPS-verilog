`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:23:10 11/19/2018 
// Design Name: 
// Module Name:    DM 
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
module DM( 
	 input clk,
    input clr,
	 
	 //上一级流水级寄存器输出信号
	 input [31:0] Instr_M, ALUOut_M, PC_M, 
	 input [31:0] WData_M, 
	 input [4:0] WReg_M,

	 //本级需要用到的输入控制信号
	 input [1:0] f_Data_M,
	 
	 //流水级寄存器
	 output reg [31:0] Instr_W, ALUOut_W, PC_W, 
	 output reg [31:0] RD_W, 
	 output reg [4:0] WReg_W,
	 output [31:0] RF_WD
    );
	 
	 wire MtoR_M, MR_M, RW_M, LB_M, Jal_M;
	 wire MtoR_W, LB_W;
	 
ctrl M_CTRL(
	 .Func(Instr_M[5:0]), .Op(Instr_M[31:26]), .MtoR(MtoR_M), 
    .MW(MW_M), .MR(MR_M), .RW(RW_M),
    .Jal(Jal_M), .LB(LB_M)
    );
	 
ctrl D_W_CTRL(
	 .Func(Instr_W[5:0]), .Op(Instr_W[31:26]), .MtoR(MtoR_W), .LB(LB_W)
    );
	 
	 initial begin
		PC_W <= 0;Instr_W <= 0;ALUOut_W <= 0;RD_W <= 0;WReg_W <= 0;
	 end
//流水级寄存器赋值
	always @(posedge clk) begin
		if(clr) begin
			PC_W <= 0;Instr_W <= 0;ALUOut_W <= 0;RD_W <= 0;WReg_W <= 0;
		end
		else begin
			PC_W <= PC_M;
			Instr_W <= Instr_M;
			ALUOut_W <= ALUOut_M;
			RD_W <= RD;
			WReg_W <= WReg_M;
		end
	end

//存储器功能
	wire [9:0] A;
	wire [31:0] WD;
	wire SD; //存数信号
	wire [31:0] PC; /*当指令存储的地址*/
	wire [31:0] RD;
	wire [1:0] Byte; //LB字节地址选取
	reg [31:0] ram[0:1023]; //32x1024RAM
	wire [31:0] addr = {20'b0, A, 2'b0}; //输出地址乘4
	
	integer i;
	initial /*初始化数据存储器*/
		for(i = 0; i <= 1023; i = i + 1) ram[i] <= 32'h0;  
	
	always @(posedge clk) begin /*时钟上升沿将数据写入寄存器,同步复位*/
		//$display("%h %h", f_Data_M, WD);
		if(clr) /*复位信号有效*/
			for(i = 0; i <= 1023; i = i + 1) ram[i] <= 32'h0;  
		else if(SD) begin/*存数信号有效*/
			/*WD = SB_M ? {
					(Byte == 2'b11) ? {WD[31:24], {ram[A][23:0]}} :
					(Byte == 2'b10) ? {{ram[A][31:24]}, WD[23:16], {ram[A][15:0]}} :
					(Byte == 2'b01) ? {{ram[A][31:16]}, WD[15:8], {ram[A][7:0]}} : 
					{{ram[A][31:8]}, WD[7:0]}
				: WD,
				*/
			ram[A] <= WD;
			$display("%d@%h: *%h <= %h", $time, PC, addr, WD);
		end
	end
	
	//连接线网
	assign A = ALUOut_M[11:2],
			 WD = f_Data_M == 2'b01 ? RD_W : f_Data_M == 2'b10 ? (PC_W + 32'h8) : WData_M, // 跳转保存的寄存器PC+8
			 RD = ram[A],
			 PC = PC_M,
			 SD = MW_M,
			 RF_WD = LB_W ? { // lb取数, sb类似
						 (Byte == 2'b11) ? {{24{RD_W[31]}}, RD_W[31:24]} :
						 (Byte == 2'b10) ? {{24{RD_W[23]}}, RD_W[23:16]} :
						 (Byte == 2'b01) ? {{24{RD_W[15]}}, RD_W[15:8]} : 
						 {{24{RD_W[7]}}, RD_W[7:0]}
						 } : MtoR_W ? RD_W : ALUOut_W,
						 
			 Byte = ALUOut_W[1:0];
	
endmodule
