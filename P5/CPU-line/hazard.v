`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:02:09 12/03/2018 
// Design Name: 
// Module Name:    hazard 
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
module hazard(
	//暂停转发信号
	 output stall_F, stall_D,
	 output [2:0] f_Rs_D, f_Rt_D,
	 output reset_E,/*清空EX寄存器*/
	 output [2:0] f_jr_D, f_A_E, f_B_E,
	 output [1:0] f_Data_M, f_RD1_D, f_RD2_D,
	 
	 input [31:0] Instr_D, Instr_E, Instr_M, Instr_W
	 
    );
	 
	 wire stall_b, stall_cal_r, stall_cal_i, stall_load, stall_store, stall_jr;
	 
	 reg [5:0] op_D, op_E, op_M, op_W,
				  fun_D, fun_E, fun_M, fun_W;
	 reg [4:0] Rs_D, Rs_E, Rs_M, Rs_W, 
				  Rt_D, Rt_E, Rt_M, Rt_W, 
				  Rd_D, Rd_E, Rd_M, Rd_W;
				  
	 wire addu_D, addu_E, addu_M, addu_W,
			subu_D, subu_E, subu_M, subu_W,
			ori_D, ori_E, ori_M, ori_W,
			lw_D, lw_E, lw_M, lw_W,
			sw_D, sw_E, sw_M, sw_W,
			beq_D, beq_E, beq_M, beq_W,
			lui_D, lui_E1, lui_M, lui_W,
			jr_D, jr_E, jr_M, jr_W,
			jal_D, jal_E, jal_M, jal_W,
			lb_D, lb_E, lb_M, lb_W,
			blez_D, blez_E, blez_M, blez_W,
			rotrv_D, rotrv_E, rotrv_M, rotrv_W,
			bltzal_D, bltzal_E, bltzal_M, bltzal_W,
			clz_D, clz_E, clz_M, clz_W;
	
ctrl CTRL_D(
	 .Func(fun_D), .Op(op_D), .addu(addu_D), .subu(subu_D), .ori(ori_D), .lw(lw_D), .sw(sw_D), .beq(beq_D), .lui(lui_D), .jr(jr_D), .jal(jal_D), .lb(lb_D), .blez(blez_D), .rotrv(rotrv_D), .bltzal(bltzal_D), .clz(clz_D)
    );
	 
ctrl CTRL_E(
	 .Func(fun_E), .Op(op_E), .addu(addu_E), .subu(subu_E), .ori(ori_E), .lw(lw_E), .sw(sw_E), .beq(beq_E), .lui(lui_E), .jr(jr_E), .jal(jal_E), .lb(lb_E), .blez(blez_E), .rotrv(rotrv_E), .bltzal(bltzal_E), .clz(clz_E)
    );
	 
ctrl CTRL_M(
	 .Func(fun_M), .Op(op_M), .addu(addu_M), .subu(subu_M), .ori(ori_M), .lw(lw_M), .sw(sw_M), .beq(beq_M), .lui(lui_M), .jr(jr_M), .jal(jal_M), .lb(lb_M), .blez(blez_M), .rotrv(rotrv_M), .bltzal(bltzal_M), .clz(clz_M)
    );

ctrl CTRL_W(
	 .Func(fun_W), .Op(op_W), .addu(addu_W), .subu(subu_W), .ori(ori_W), .lw(lw_W), .sw(sw_W), .beq(beq_W), .lui(lui_W), .jr(jr_W), .jal(jal_W), .lb(lb_W), .blez(blez_W), .rotrv(rotrv_W), .bltzal(bltzal_W), .clz(clz_W)
    );
	  
	 
					
	 wire cal_r_D = addu_D || subu_D || rotrv_D || clz_D, cal_r_E = addu_E || subu_E || rotrv_E || clz_E, 
			cal_r_M = addu_M || subu_M || rotrv_M || clz_M, cal_r_W = addu_W || subu_W || rotrv_W || clz_W,
			
			cal_i_D = lui_D || ori_D, cal_i_E = lui_E || ori_E,
			cal_i_M = lui_M || ori_M, cal_i_W = lui_W || ori_W,
			
			load_D  = lw_D || lb_D, load_E  = lw_E || lb_E,
			load_M  = lw_M || lb_M, load_W  = lw_W || lb_W,
			
			store_D = sw_D, store_E = sw_E, store_M = sw_M, store_W = sw_W;
	
	initial begin
		op_D <= 0; op_E <= 0; op_M <= 0; op_W <= 0;
		fun_D <= 0; fun_E <= 0; fun_M <= 0; fun_W <= 0;
	   Rs_D <= 0; Rs_E <= 0; Rs_M <= 0; Rs_W <= 0; 
		Rt_D <= 0; Rt_E <= 0; Rt_M <= 0; Rt_W <= 0; 
		Rd_D <= 0; Rd_E <= 0; Rd_M <= 0; Rd_W <= 0;
	end
	
	always @(*) begin
		op_D <= Instr_D[31:26]; op_E <= Instr_E[31:26]; op_M <= Instr_M[31:26]; op_W <= Instr_W[31:26];
		fun_D <= Instr_D[5:0]; fun_E <= Instr_E[5:0]; fun_M <= Instr_M[5:0]; fun_W <= Instr_W[5:0];
	   Rs_D <= Instr_D[25:21]; Rs_E <= Instr_E[25:21]; Rs_M <= Instr_M[25:21]; Rs_W <= Instr_W[25:21]; 
		Rt_D <= Instr_D[20:16]; Rt_E <= Instr_E[20:16]; Rt_M <= Instr_M[20:16]; Rt_W <= Instr_W[20:16]; 
		Rd_D <= Instr_D[15:11]; Rd_E <= Instr_E[15:11]; Rd_M <= Instr_M[15:11]; Rd_W <= Instr_W[15:11];
	end
			
	 
	 
	 assign stall_F = stall_b || stall_cal_r || stall_cal_i || stall_load || stall_store || stall_jr,
	 
			  stall_D = stall_F,
			  
			  reset_E = stall_F,
			  
			  stall_b = beq_D && (
				 (cal_r_E && ((Rd_E == Rs_D && Rs_D != 0) || (Rd_E == Rt_D && Rt_D != 0))) ||
				 (cal_i_E && ((Rt_E == Rs_D && Rs_D != 0) || (Rt_E == Rt_D && Rt_D != 0))) ||
				 (load_E && ((Rt_E == Rt_D && Rt_D != 0) || (Rt_E == Rs_D && Rs_D != 0))) ||
				 (load_M && ((Rt_M == Rt_D && Rt_D != 0) || (Rt_M == Rs_D && Rs_D != 0)))) ||
				 (blez_D || bltzal_D) && (
				 (cal_r_E && Rd_E == Rs_D && Rs_D != 0) ||
				 (cal_i_E && Rt_E == Rs_D && Rs_D != 0) ||
				 (load_E && Rt_E == Rs_D && Rs_D != 0) ||
				 (load_M && Rt_M == Rs_D && Rs_D != 0)),
			  
			  stall_cal_r = load_E && cal_r_D && ((Rt_E == Rs_D && Rs_D != 0) || (Rt_E == Rt_D && Rt_D != 0)),
			 
			  stall_cal_i = load_E && cal_i_D && Rt_E == Rs_D && Rs_D != 0,
			  
			  stall_load = load_E && load_D && Rt_E == Rs_D && Rs_D != 0,
			  
			  stall_store = load_E && store_D && Rt_E == Rs_D && Rs_D != 0,
			  
			  stall_jr = jr_D && Rs_D != 0 && (
					(cal_r_E && Rd_E == Rs_D) ||
					(cal_i_E && Rt_E ==Rs_D) ||
					(load_E && Rt_E == Rs_D) || 
					(load_M && Rt_M == Rs_D)
					),
					
			//寄存器文件内部转发		
			  f_RD1_D = (cal_r_D || cal_i_D || load_D || store_D) && cal_r_W && Rs_D == Rd_W && Rd_W != 0 ? 2'b01 :   
							(cal_r_D || cal_i_D || load_D || store_D) && cal_i_W && Rs_D == Rt_W && Rt_W != 0 ? 2'b01 :
							(cal_r_D || cal_i_D || load_D || store_D) && load_W && Rs_D == Rt_W && Rt_W != 0 ? 2'b01 :  
							(cal_r_D || cal_i_D || load_D || store_D) && (jal_W || bltzal_W) && Rs_D == 5'h1f ? 2'b10 : 2'b00,
							// 寄存机内部转发解决冒险， 跳转并链接保存的指令需要增加信号

			  f_RD2_D = (cal_r_D || store_D) && cal_r_W && Rt_D == Rd_W && Rd_W != 0 ? 2'b01 :   
							(cal_r_D || store_D) && cal_i_W && Rt_D == Rt_W && Rt_W != 0 ? 2'b01 : 
							(cal_r_D || store_D) && load_W && Rt_D == Rt_W && Rt_W != 0 ? 2'b01 : 
							(cal_r_D || store_D) && (jal_W || bltzal_W) && Rt_D == 5'h1f ? 2'b10: 2'b00,
							// 寄存机内部转发解决冒险， 跳转并保存的指令需要增加信号
					
			//beq转发							 
			  f_Rs_D = (beq_D || blez_D || bltzal_D) && (jal_E || bltzal_E) && Rs_D == 5'h1f ? 3'b100 :
						  (beq_D || blez_D || bltzal_D) && (jal_M || bltzal_M) && Rs_D == 5'h1f ? 3'b101 :
						  (beq_D || blez_D || bltzal_D) && cal_r_M && Rs_D == Rd_M && Rd_M != 0 ? 3'b001 :
						  (beq_D || blez_D || bltzal_D) && cal_i_M && Rs_D == Rt_M && Rt_M != 0 ? 3'b001 :
						  (beq_D || blez_D || bltzal_D) && cal_r_W && Rs_D == Rd_W && Rd_W != 0 ? 3'b010 :
						  (beq_D || blez_D || bltzal_D) && cal_i_W && Rs_D == Rt_W && Rt_W != 0 ? 3'b010 :
						  (beq_D || blez_D || bltzal_D) && load_W && Rs_D == Rt_W && Rt_W != 0 ? 3'b011 : 
						  (beq_D || blez_D || bltzal_D) && (jal_W || bltzal_W) && Rs_D == 5'h1f ? 3'b110 : 3'b000,
						  // 写入寄存器数据冒险，跳转并保存的指令需要增加信号
			  
			  f_Rt_D =  beq_D && (jal_E || bltzal_E) && Rt_D == 5'h1f ? 3'b100 :
							beq_D && (jal_M || bltzal_M) && Rt_D == 5'h1f ? 3'b101 :
							beq_D && cal_r_M && Rt_D == Rd_M && Rd_M != 0 ? 3'b001 :
						   beq_D && cal_i_M && Rt_D == Rt_M && Rt_M != 0 ? 3'b001 :
						   beq_D && cal_r_W && Rt_D == Rd_W && Rd_W != 0 ? 3'b010 : 
						   beq_D && cal_i_W && Rt_D == Rt_W && Rt_W != 0 ? 3'b010 :
						   beq_D && load_W && Rt_D == Rt_W && Rt_W != 0 ? 3'b011 : 
							beq_D && (jal_W || bltzal_W) && Rt_D == 5'h1f ? 3'b110 : 3'b000,
							// 写入寄存器数据冒险，跳转并保存的指令需要增加信号
			
			//jr转发， RS寄存器冒险
			  f_jr_D = jr_D && (jal_E || bltzal_E) && Rs_D == 5'h1f ? 3'b100 :
						  jr_D && cal_r_M && Rs_D == Rd_M && Rd_M != 0 ? 3'b001 :
						  jr_D && cal_i_M && Rs_D == Rt_M && Rt_M != 0 ? 3'b001 :
						  jr_D && (jal_M || bltzal_M) && Rs_D == 5'h1f ? 3'b101 :	
						  jr_D && cal_r_W && Rs_D == Rd_W && Rd_W != 0 ? 3'b010 :
						  jr_D && cal_i_W && Rs_D == Rt_W && Rt_W != 0 ? 3'b010 :
						  jr_D && load_W && Rs_D == Rt_W && Rt_W != 0 ? 3'b011 : 	  
						  jr_D && (jal_W || bltzal_W) && Rs_D == 5'h1f ? 3'b110 : 3'b000, //写31号寄存器冲突
			
			//E级ALU转发
			  f_A_E = (cal_r_E || cal_i_E || load_E || store_E) && cal_r_M && Rs_E == Rd_M && Rd_M != 0 ? 3'b010 :
					  	 (cal_r_E || cal_i_E || load_E || store_E) && cal_i_M && Rs_E == Rt_M && Rt_M != 0 ? 3'b010 :
						 (cal_r_E || cal_i_E || load_E || store_E) && (jal_M || bltzal_M) && Rs_E == 5'h1f ? 3'b100 :
					  	 (cal_r_E || cal_i_E || load_E || store_E) && cal_r_W && Rs_E == Rd_W && Rd_W != 0 ? 3'b001 :
						 (cal_r_E || cal_i_E || load_E || store_E) && cal_i_W && Rs_E == Rt_W && Rt_W != 0 ? 3'b001 :
						 (cal_r_E || cal_i_E || load_E || store_E) && load_W && Rs_E == Rt_W && Rt_W != 0 ? 3'b011 :
						 (cal_r_E || cal_i_E || load_E || store_E) && (jal_W || bltzal_W) && Rs_E == 5'h1f ? 3'b101 : 3'b000,
							// 写入寄存器数据冒险，跳转并保存的指令需要增加信号

			  f_B_E = (cal_r_E || store_E) && cal_r_M && Rt_E == Rd_M && Rd_M != 0 ? 3'b010 :
						 (cal_r_E || store_E) && cal_i_M && Rt_E == Rt_M && Rt_M != 0 ? 3'b010 :
						 (cal_r_E || store_E) && (jal_M || bltzal_M) && Rt_E == 5'h1f ? 3'b100 :
						 (cal_r_E || store_E) && cal_r_W && Rt_E == Rd_W && Rd_W != 0 ? 3'b001 :
						 (cal_r_E || store_E) && cal_i_W && Rt_E == Rt_W && Rt_W != 0 ? 3'b001 :
						 (cal_r_E || store_E) && load_W && Rt_E == Rt_W && Rt_W != 0 ? 3'b011 : 
						 (cal_r_E || store_E) && (jal_W || bltzal_W) && Rt_E == 5'h1f ? 3'b101 :	3'b000,
							// 写入寄存器数据冒险，跳转并保存的指令需要增加信号
			
			 //数据存储器的数据转发
			  f_Data_M = store_M && load_W && Rt_M == Rt_W && Rt_W !=0 ? 2'b01 :
							 store_M && (jal_W || bltzal_W) && Rt_M == 5'h1f ? 2'b10 : 2'b00;
							 // 写入寄存器数据冒险，跳转并保存的指令需要增加信号

endmodule
