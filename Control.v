`timescale 1ns / 1ns

module Control(
	input  [6 -1:0] OpCode   ,
	input  [6 -1:0] Funct    ,
	output [2 -1:0] PCSrc    ,
	output [4 -1:0] Branch   ,
	output RegWrite          ,
	output [2 -1:0] RegDst   ,
	output MemRead           ,
	output MemWrite          ,
	output [2 -1:0] MemtoReg ,
	output ALUSrc1           ,
	output [2 -1:0] ALUSrc2  ,
	output ExtOp             ,
	output LuOp              ,
	output [4 -1:0] ALUOp
);
	

	// Your code below (for question 1)
	assign PCSrc = (OpCode == 6'h02 || OpCode == 6'h3)? 2'b01:
		(OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09))? 2'b10: 2'b00;
	
	// {branch, greater, less, equal}
	assign Branch = (OpCode == 6'h04)? 4'b1001:	// beq
		(OpCode == 6'h05)? 4'b1000:	// bne
		(OpCode == 6'h06)? 4'b1011:	// blez
		(OpCode == 6'h07)? 4'b1100:	// bgtz
		(OpCode == 6'h01)? 4'b1010: 4'b0; // bltz

	assign RegWrite = (OpCode == 6'h2b || OpCode == 6'h04 || OpCode == 6'h05 ||
		OpCode == 6'h06 || OpCode == 6'h07 || OpCode == 6'h01 ||
		OpCode == 6'h02 || (OpCode == 6'h00 && Funct == 6'h08))? 0: 1;

	assign RegDst = (OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09))? 2'b10:
		(OpCode == 6'h00 || OpCode == 6'h1c)? 2'b01 : 2'b00;
	
	assign MemRead = (OpCode == 6'h23)? 1: 0;

	assign MemWrite = (OpCode == 6'h2b)? 1: 0;

	assign MemtoReg = (OpCode == 6'h23)? 2'b01:
		(OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09))? 2'b10: 2'b00;
	
	assign ALUSrc1 = (OpCode == 6'h00 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03))? 2'b01: 2'b00;

	assign ALUSrc2 = (OpCode == 6'h23 || OpCode == 6'h2b || OpCode == 6'h0f || OpCode == 6'h08 || OpCode == 6'h09 ||
		OpCode == 6'h0a || OpCode == 6'h0b || OpCode == 6'h0c ||  OpCode == 6'h0d)? 2'b01:
	 	(OpCode == 6'h06 || OpCode == 6'h07 || OpCode == 6'h01)? 2'b10:  0;
	
	assign ExtOp = (OpCode == 6'h23 || OpCode == 6'h2b ||  OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0a || OpCode == 6'h0b)? 1: 0;

	assign LuOp = (OpCode == 6'h0f)? 1: 0;
	// Your code above (for question 1)

	// set ALUOp
	assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h04 || OpCode == 6'h05 || OpCode == 6'h06 || OpCode == 6'h07 || OpCode == 6'h01)? 3'b001: 
		(OpCode == 6'h0c)? 3'b100: 
		(OpCode == 6'h0d)? 3'b011:
		(OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: 
		(OpCode == 6'h1c && Funct == 6'h02)? 3'b110:
		3'b000; //mul
		
	assign ALUOp[3] = OpCode[0];
endmodule