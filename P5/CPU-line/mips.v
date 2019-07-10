`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:18:43 11/19/2018 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
	 input reset
    );
//F级
	//IFU信号
	wire PCsrc_D; //PC选择器选择信号
	wire [31:0] Instr,	
		  PC, PC_, //PC当前、PC+4的值
		  NPC; //跳转地址
	//流水级寄存器
	wire [31:0] Instr_D,
		  PC_D;
	
//D级
	//GRF信号
	wire r_WE; /*寄存器写入使能信号*/
	wire [4:0]A1, A2, r_WA; /*三个地址*/
	wire [31:0] r_WD, /*写入数据*/
	     RD1, RD2;
	//流水级寄存器
	wire [31:0] Instr_E;
	wire [31:0] PC_E,
		  RD1_E, RD2_E;
	wire [4:0] Rs_E, Rt_E, Rd_E;
	wire [31:0] EXT_E;
	
//E级
	//ALU信号
	wire [31:0] B; /*B来源于RD2或ext,A来源于RD1*/
	wire [3:0] ALUOp;
   wire [31:0] Result;
	//流水级寄存器
	wire [31:0] Instr_M, ALUOut_M,
		  WData_M;
	wire [4:0] WReg_M;
	wire [31:0] PC_M;
	
//M级
	//数据存储器
	wire [31:0] RD_W, Instr_W, ALUOut_W;
	wire [4:0] WReg_W;
	wire [31:0] PC_W, RF_WD;
	
//暂停or转发or冲突信号
	wire stall_D, stall_F,
		  reset_E; /*清空EX寄存器*/
	wire [2:0] f_Rs_D, f_Rt_D, f_jr_D, f_A_E, f_B_E;
	wire [1:0] f_Data_M, f_RD1_D ,f_RD2_D;
	

IFU F_IFU(
    .CLK(clk), .RESET(reset), 
    .PCsrc_D(PCsrc_D), .NPC(NPC),
    .Instr(Instr), .PC(PC), .PC_(PC_),
	 .Instr_D(Instr_D), .PC_D(PC_D),
	 .stall_D(stall_D), .stall_F(stall_F)
    );

GRF D_GRF(
    .CLK(clk), .RESET(reset), 
	 .PCsrc_D(PCsrc_D),
	 .PC_D(PC_D), .Instr_D(Instr_D), .Instr_E(Instr_E), .PC_E(PC_E), 
	 .RD1_E(RD1_E), .RD2_E(RD2_E), .Rs_E(Rs_E), .Rt_E(Rt_E), .Rd_E(Rd_E), .EXT_E(EXT_E),
	 .NPC(NPC), .f_Rs_D(f_Rs_D), .f_Rt_D(f_Rt_D), .f_jr_D(f_jr_D), 
	 .f_RD1_D(f_RD1_D), .f_RD2_D(f_RD2_D), .reset_E(reset_E), .ALUOut_M(ALUOut_M), .PC_M(PC_M),
	 .RD_W(RD_W), .ALUOut_W(ALUOut_W), .PC_W(PC_W), .RF_WD(RF_WD), .Instr_W(Instr_W),
	 .WReg_W(WReg_W)
    );

ALU E_ALU(
	 .CLK(clk), .RESET(reset), 
	 .Instr_E(Instr_E), .PC_E(PC_E), 
	 .RD1_E(RD1_E), .RD2_E(RD2_E), .Rs_E(Rs_E), .Rt_E(Rt_E), .Rd_E(Rd_E), .EXT_E(EXT_E),
	 .Instr_M(Instr_M), .ALUOut_M(ALUOut_M), .WData_M(WData_M),
    .WReg_M(WReg_M), .PC_M(PC_M), 
    .f_A_E(f_A_E), .f_B_E(f_B_E), .f_Data_M(f_Data_M),
    .RF_WD(RF_WD), .RD_W(RD_W), .ALUOut_W(ALUOut_W), .PC_W(PC_W)
    );
	 
DM M_DM(
	 .clk(clk), .clr(reset), 
	 .Instr_M(Instr_M), .ALUOut_M(ALUOut_M), .PC_M(PC_M), 
	 .WData_M(WData_M), .WReg_M(WReg_M),
	 .f_Data_M(f_Data_M),
	 .Instr_W(Instr_W), .ALUOut_W(ALUOut_W), .PC_W(PC_W), .RD_W(RD_W), .WReg_W(WReg_W), .RF_WD(RF_WD)
    );
	 
hazard HAZARD(
	 .stall_F(stall_F), .stall_D(stall_D),
	 .f_Rs_D(f_Rs_D), .f_Rt_D(f_Rt_D), .reset_E(reset_E), /*清空EX寄存器*/
	 .f_jr_D(f_jr_D), .f_A_E(f_A_E), .f_B_E(f_B_E), .f_Data_M(f_Data_M), .f_RD1_D(f_RD1_D), .f_RD2_D(f_RD2_D),
	 .Instr_D(Instr_D), .Instr_E(Instr_E), .Instr_M(Instr_M), .Instr_W(Instr_W)
	 );


endmodule
