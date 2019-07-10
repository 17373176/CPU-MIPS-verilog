`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:22:42 11/19/2018 
// Design Name: 
// Module Name:    IFU 
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
module IFU(	
    input CLK,
	 input RESET,
	 input PCsrc_D, //PC选择信号
	 input [31:0] NPC, //跳转地址
	 output [31:0]Instr,
	 output [31:0] PC, PC_, //PC当前、PC跳转的值
	 
	 //流水级寄存器
	 output reg [31:0] Instr_D,
	 output reg [31:0] PC_D,
	 
	 //暂停信号
	 input stall_D, stall_F
	 );
	 
	 initial begin
		Instr_D <= 0; PC_D <= 0;
	 end
	 
//流水级寄存器赋值
	always @(posedge CLK) begin /*如果暂停无效则更新，暂停有效则冻结*/
		if(RESET) begin
			Instr_D <= 0; PC_D <= 0;
		end
		else if(!stall_D) begin
			Instr_D <= Instr; PC_D <= PC;
		end
	end
	
	
//指令寄存器功能
	reg [31:0] rgt = 32'h00003000; //指令寄存器
	
	always @(posedge CLK) begin /*时钟上升沿,同步复位*/
		if(RESET) rgt <= 32'h00003000; //初始地址0x00003000
		else if(!stall_F) rgt <= PC_; //暂停无效则更新，否则冻结
	end
	
	assign PC = rgt;
	
	//调用ROM指令存储器
	ROM IM(
    .A(PC[11:2]), 
    .D(Instr)
    );
	
	assign PC_ = PCsrc_D ? NPC : (PC + 32'h4); 

endmodule
