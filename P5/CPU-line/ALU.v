`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:22:53 11/19/2018 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
	 input CLK, RESET,
	 //上一级流水级寄存器输出信号
	 input [31:0] Instr_E,
	 input [31:0] PC_E,
	 input [31:0] RD1_E, RD2_E,
	 input [4:0] Rs_E, Rt_E, Rd_E,
	 input [31:0] EXT_E,
	 
	 //EX流水级寄存器
	 output reg [31:0] Instr_M, ALUOut_M,
	 output reg [31:0] WData_M, 
	 output reg [4:0] WReg_M,
	 output reg [31:0] PC_M,
	 
	 //暂停信号
	 input [2:0] f_A_E, f_B_E,
	 input [1:0] f_Data_M,
	 
	 //从WB级转发得到的输入
	 input [31:0] RF_WD, RD_W, ALUOut_W, PC_W
    );
	 
	 //本级需要用到的输入控制信号
	 wire RegDst_E, Alusel_E, clz_E;
	 wire [3:0] ALUOp_E;
	 
ctrl E_CTRL(
	 .Func(Instr_E[5:0]), .Op(Instr_E[31:26]), .RegDst(RegDst_E), .ALUOp(ALUOp_E), .Alusel(Alusel_E), .clz(clz_E)
    );
	 
	 initial begin
		Instr_M <= 0;ALUOut_M <= 0;WReg_M <= 0; WData_M <= 0;PC_M <= 0;
	 end
//流水级寄存器赋值
	 always @(posedge CLK) begin
		if(RESET) begin
			Instr_M <= 0;ALUOut_M <= 0;WReg_M <= 0; WData_M <= 0; PC_M <= 0;
		end
		else begin
			Instr_M <= Instr_E;
			ALUOut_M <= Result;
			WReg_M <= RegDst_E ? Rd_E : Rt_E; //寄存器存储地址选择
			WData_M <= (f_B_E == 3'b000) ? RD2_E : 
						  (f_B_E == 3'b001) ? ALUOut_W :
						  (f_B_E == 3'b010) ? ALUOut_M : 
						  (f_B_E == 3'b100) ? (PC_M + 32'h8) :
						  (f_B_E == 3'b101) ? (PC_W + 32'h8) : RF_WD; //存储器存储数据选择
						  
			PC_M <= PC_E;
		end
	 end
	 
//ALU功能
	wire [31:0] A, B, HI, OR; //加载立即数，或立即数
	wire [31:0] Result;
	
	assign HI = {B[15:0], 16'b0}, /*加载至高位*/
			 OR = {16'b0, B[15:0]}, /*立即数或高位补零*/
			 A = (f_A_E == 3'b000) ? RD1_E : 
				  (f_A_E == 3'b001) ? ALUOut_W :
				  (f_A_E == 3'b010) ? ALUOut_M : 
				  (f_A_E == 3'b100) ? (PC_M + 32'h8) :
				  (f_A_E == 3'b101) ? (PC_W + 32'h8) : RF_WD, 
			 B = Alusel_E ? EXT_E : 
				  (f_B_E == 3'b000) ? RD2_E : 
				  (f_B_E == 3'b001) ? ALUOut_W :
				  (f_B_E == 3'b010) ? ALUOut_M : 
				  (f_B_E == 3'b100) ? (PC_M + 32'h8) :
				  (f_B_E == 3'b101) ? (PC_W + 32'h8) : RF_WD;
	 
	assign Result = ALUOp_E == 4'b0001 ? (A + B) : 
						 ALUOp_E == 4'b0010 ? (A - B) : 
						 ALUOp_E == 4'b0100 ? A | OR :
						 ALUOp_E == 4'b1000 ? HI : 
						 ALUOp_E == 4'b1001 ? temp : 
						 ALUOp_E == 4'b1010 ? count : 32'h0;
	
	/*clz， rotrv指令部分, 注意标注区分*/
	 wire [4:0] s = A[4:0];
	 reg [31:0] temp; // rotrv指令
	 reg count; // clz指令统计个数, 初始为32
	 initial begin
	 	temp = 0;
		count = 32;
	 end
	
	 integer i, index;
	 always @(*) begin
	   /*rotrv*/
		 for(i = $signed(s)-1; i >= 0; i=i-1) begin
		 	temp[index] = B[i];
			index = index - 1;
	 	 end
		 for(i = 31; i >= $signed(s); i=i-1) begin
			temp[index] = B[i];
			index = index - 1;
		 end
	   /*******/
		
		/* clz */
		 for(i = 31; i >= 0 && A[i] != 'b1; i=i-1)begin
		 end
		 count = 31 - i;
		/*******/
	 end
	/***********/
	
endmodule
