`timescale 1ns / 1ns

module CPU(
	input  reset                        , 
	input  clk                          , 
	output MemRead                      , 
	output MemWrite                     ,
	output [32 -1:0] MemBus_Address     , 
	output [32 -1:0] MemBus_Write_Data  , 
	input  [32 -1:0] Device_Read_Data 	,
	output [ 3 -1:0] sel				,
	output [ 8 -1:0] seg
);

	// PC register
	reg  [31 :0] PC;
	wire [31 :0] PC_plus_4;
	
	assign PC_plus_4 = PC + 32'd4;

	reg [2:0] EX_Rs_Hazard;
	reg [2:0] EX_Rt_Hazard;
	reg MEM_Hazard;

	// PipeLine register
	reg [32-1:0] IF_ID_Reg;
	`define IF_ID_Instruction IF_ID_Reg

	reg [139-1:0] ID_EX_Reg;
	`define ID_EX_Branch ID_EX_Reg[3:0]
	`define ID_EX_Rs ID_EX_Reg[8:4]
	`define ID_EX_RRs ID_EX_Reg[40:9]
	`define ID_EX_Rt ID_EX_Reg[45:41]
	`define ID_EX_RRt ID_EX_Reg[77:46]
	`define ID_EX_ALUSrc1 ID_EX_Reg[78]
	`define ID_EX_ALUSrc2 ID_EX_Reg[80:79]
	`define ID_EX_ALUImm ID_EX_Reg[112:81]
	`define ID_EX_ALUShamt ID_EX_Reg[117:113]
	`define ID_EX_ALUCtl ID_EX_Reg[122:118]
	`define ID_EX_Sign ID_EX_Reg[123]
	`define ID_EX_SrcReg ID_EX_Reg[128:124]
	`define ID_EX_MemRead ID_EX_Reg[129]
	`define ID_EX_MemWrite ID_EX_Reg[130]
	`define ID_EX_RegWrite ID_EX_Reg[131]
	`define ID_EX_RegDst ID_EX_Reg[136:132]
	`define ID_EX_MemtoReg ID_EX_Reg[138:137]

	reg [79-1:0] EX_MEM_Reg;
	`define EX_MEM_SrcReg EX_MEM_Reg[4:0]
	`define EX_MEM_ALUout EX_MEM_Reg[36:5]
	`define EX_MEM_MemRead EX_MEM_Reg[37]
	`define EX_MEM_MemWrite EX_MEM_Reg[38]
	`define EX_MEM_WriteData EX_MEM_Reg[70:39]
	`define EX_MEM_RegWrite EX_MEM_Reg[71]
	`define EX_MEM_RegDst EX_MEM_Reg[76:72]
	`define EX_MEM_MemtoReg EX_MEM_Reg[78:77]

	reg [38-1:0] MEM_WB_Reg;
	`define MEM_WB_RegWrite MEM_WB_Reg[0]
	`define MEM_WB_RegDst MEM_WB_Reg[5:1]
	`define MEM_WB_WriteData MEM_WB_Reg[37:6]

	wire [5 -1:0] stall				;
	wire [5 -1:0] flush				;
	
	// Instruction Memory
	wire [31 :0] Instruction;
	InstructionMemory instruction_memory1(
		.Address        (PC             ), 
		.Instruction    (Instruction    )
	);

	// Control
	wire [2 -1:0] RegDst    	;
	wire [2 -1:0] PCSrc     	;
	wire [4 -1:0] Branch    	;
	wire [2 -1:0] MemtoReg  	;
	wire          ALUSrc1   	;
	wire [2 -1:0] ALUSrc2   	;
	wire [4 -1:0] ALUOp     	;
	wire          ExtOp     	;
	wire          LuOp      	;
	wire          RegWrite  	;
	wire [5 -1:0] Write_register;

	assign Write_register = (RegDst == 2'b00)? `IF_ID_Instruction[20:16]:
		(RegDst == 2'b01)? `IF_ID_Instruction[15:11]: 5'b11111;
	
	Control control1(
		.OpCode     (`IF_ID_Instruction[31:26]	), 
		.Funct      (`IF_ID_Instruction[ 5: 0]	),
		.PCSrc      (PCSrc						), 
		.Branch     (Branch						), 
		.RegWrite   (RegWrite					), 
		.RegDst     (RegDst						), 
		.MemRead    (MemRead					),	
		.MemWrite   (MemWrite					), 
		.MemtoReg   (MemtoReg					),
		.ALUSrc1    (ALUSrc1					), 
		.ALUSrc2    (ALUSrc2					), 
		.ExtOp      (ExtOp						), 
		.LuOp       (LuOp						),	
		.ALUOp      (ALUOp						)
	);
	
	// Extend
	wire [32 -1:0] Ext_out;
	assign Ext_out = { ExtOp? {16{`IF_ID_Instruction[15]}}: 16'h0000, `IF_ID_Instruction[15:0]};
	
	wire [32 -1:0] LU_out;
	assign LU_out = LuOp? {`IF_ID_Instruction[15:0], 16'h0000}: Ext_out;
	
	// Register File
	wire [32 -1:0] Databus1;
	wire [32 -1:0] Databus2;
	wire [32 -1:0] Databus3;

	RegisterFile register_file1(
		.reset          (reset						), 
		.clk            (clk						),
		.RegWrite       (`MEM_WB_RegWrite    		), 
		.Read_register1 (`IF_ID_Instruction[25:21]	), 
		.Read_register2 (`IF_ID_Instruction[20:16]	), 
		.Write_register (`MEM_WB_RegDst				),
		.Write_data     (`MEM_WB_WriteData			), 
		.Read_data1     (Databus1					), 
		.Read_data2     (Databus2					)
	);
	
	// ALU Control
	wire [5 -1:0] ALUCtl;
	wire          Sign  ; 

	ALUControl alu_control1(
		.ALUOp  (ALUOp					), 
		.Funct  (`IF_ID_Instruction[5:0]), 
		.ALUCtl (ALUCtl					), 
		.Sign   (Sign					)
	);
		
	// ALU
	wire [32 -1:0] ALU_in1;
	wire [32 -1:0] ALU_in2;
	wire [32 -1:0] ALU_out;
	wire           Zero   ;
	wire           Less   ;

	assign ALU_in1 = `ID_EX_ALUSrc1? {27'h00000, `ID_EX_ALUShamt}: `ID_EX_RRs;
	assign ALU_in2 = (`ID_EX_ALUSrc2 == 2'b01)? `ID_EX_ALUImm:
		(`ID_EX_ALUSrc2 == 2'b10)? 32'b0: `ID_EX_RRt;

	ALU alu1(
		.in1    (ALU_in1    ), 
		.in2    (ALU_in2    ), 
		.ALUCtl (`ID_EX_ALUCtl	), 
		.Sign   (`ID_EX_Sign	), 
		.out    (ALU_out    ), 
		.zero   (Zero       ),
		.less   (Less       )
	);
		
	// Data Memory
	wire [32 -1:0] MemBus_Read_Data ;

	assign MemBus_Address       = `EX_MEM_ALUout;
	assign MemBus_Write_Data    = `EX_MEM_WriteData;
	
	// Warning: PC data is passed in ALUout!
	assign Databus3 = (`EX_MEM_MemtoReg == 2'b00)? `EX_MEM_ALUout:
		(`EX_MEM_MemtoReg == 2'b01)? MemBus_Read_Data: `EX_MEM_ALUout;

	Bus bus1(
		.reset      (reset				), 
		.clk        (clk				), 
		.Address    (MemBus_Address		), 
		.Write_data (MemBus_Write_Data	), 
		.Read_data  (MemBus_Read_Data	), 
		.MemRead    (`EX_MEM_MemRead	), 
		.MemWrite   (`EX_MEM_MemWrite	),
		.sel		(sel				),
		.seg		(seg				)
	);

	// Load Use Hazard
	assign stall = (`ID_EX_MemRead && `ID_EX_RegDst != 5'b0 &&
		(`ID_EX_RegDst == `IF_ID_Instruction[25:21] || `ID_EX_RegDst == `IF_ID_Instruction[20:16]))?
		5'b11: 5'b0;

	// Control Hazard
	assign flush = (`ID_EX_Branch && Zero)? 5'b11:
		(PCSrc == 2'b01 || PCSrc == 2'b10)? 5'b1: 5'b0;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			PC <= 0;
			IF_ID_Reg <= 0;
			ID_EX_Reg <= 0;
			EX_MEM_Reg <= 0;
			MEM_WB_Reg <= 0;
		end else begin
			// Normal Operations here
			// IF stage
			if (flush[0]) begin
				IF_ID_Reg <= 0;
			end else if (stall[1]) begin
				IF_ID_Reg <= IF_ID_Reg;
			end else begin
				`IF_ID_Instruction <= Instruction;
			end

			// ID stage
			// ID/EX Forward Unit
			if (flush[1]) begin
				ID_EX_Reg <= 0;
			end else if (stall[2]) begin
				ID_EX_Reg <= ID_EX_Reg;
			end else if (stall[1] && ~stall[2]) begin
				ID_EX_Reg <= 0;
			end else begin
				if (PCSrc != 0 && RegWrite) begin
					`ID_EX_RRs <= PC;
					EX_Rs_Hazard <= 2'b11;
				end else if (`ID_EX_RegWrite && `ID_EX_RegDst != 5'b0 && `ID_EX_RegDst == `IF_ID_Instruction[25:21]) begin
					`ID_EX_RRs <= ALU_out;
					EX_Rs_Hazard <= 2'b01;
				end else if (`EX_MEM_RegWrite && `EX_MEM_RegDst != 5'b0 && `EX_MEM_RegDst == `IF_ID_Instruction[25:21]) begin
					`ID_EX_RRs <= Databus3;
					EX_Rs_Hazard <= 2'b10;
				end else begin
					`ID_EX_RRs <= Databus1;
					EX_Rs_Hazard <= 2'b00;
				end

				if (PCSrc != 0 && RegWrite) begin
					`ID_EX_RRt <= 0;
					EX_Rs_Hazard <= 2'b11;
				end else if (`ID_EX_RegWrite && `ID_EX_RegDst != 5'b0 && `ID_EX_RegDst == `IF_ID_Instruction[20:16]) begin
					`ID_EX_RRt <= ALU_out;
					EX_Rt_Hazard <= 2'b01;
				end else if (`EX_MEM_RegWrite && `EX_MEM_RegDst != 5'b0 && `EX_MEM_RegDst == `IF_ID_Instruction[20:16]) begin
					`ID_EX_RRt <= Databus3;
					EX_Rt_Hazard <= 2'b10;
				end else begin
					`ID_EX_RRt <= Databus2;		
					EX_Rt_Hazard <= 2'b00;
				end

				`ID_EX_Branch <= Branch;
				`ID_EX_Rs <= `IF_ID_Instruction[25:21];
				`ID_EX_Rt <= `IF_ID_Instruction[20:16];
				`ID_EX_ALUSrc1 <= ALUSrc1;
				`ID_EX_ALUSrc2 <= ALUSrc2;
				`ID_EX_ALUImm <= LU_out;
				`ID_EX_ALUShamt <= `IF_ID_Instruction[10:6];
				`ID_EX_ALUCtl <= ALUCtl;
				`ID_EX_Sign <= Sign;
				`ID_EX_SrcReg <= `IF_ID_Instruction[20:16];
				`ID_EX_MemRead <= MemRead;
				`ID_EX_MemWrite <= MemWrite;
				`ID_EX_RegWrite <= RegWrite;
				`ID_EX_RegDst <= Write_register;
				`ID_EX_MemtoReg <= MemtoReg;
			end

			// EX stage
			// EX/MEM Forward Unit
			if (flush[2]) begin
				EX_MEM_Reg <= 0;
			end else if (stall[3]) begin
				EX_MEM_Reg <= 1;
			end else if (stall[2] && ~stall[3]) begin
				EX_MEM_Reg <= 0;
			end else begin
				if (`MEM_WB_RegWrite && `MEM_WB_RegDst != 5'b0 && `MEM_WB_RegDst == `ID_EX_Rt) begin
					`EX_MEM_WriteData <= `MEM_WB_WriteData;
					MEM_Hazard <= 1;
				end else begin
					`EX_MEM_WriteData <= `ID_EX_RRt;
					MEM_Hazard <= 0;
				end

				`EX_MEM_SrcReg <= `ID_EX_Rt;
				`EX_MEM_ALUout <= ALU_out;
				`EX_MEM_MemRead <= `ID_EX_MemRead;
				`EX_MEM_MemWrite <= `ID_EX_MemWrite;
				`EX_MEM_WriteData <= `ID_EX_RRt;
				`EX_MEM_RegWrite <= `ID_EX_RegWrite;
				`EX_MEM_RegDst <= `ID_EX_RegDst;
				`EX_MEM_MemtoReg <= `ID_EX_MemtoReg;
			end

			// MEM stage
			if (flush[3]) begin
				MEM_WB_Reg <= 0;
			end else if (stall[4]) begin
				MEM_WB_Reg <= MEM_WB_Reg;
			end else if (stall[3] && ~stall[4]) begin
				MEM_WB_Reg <= 0;
			end else begin
				`MEM_WB_RegWrite <= `EX_MEM_RegWrite;
				`MEM_WB_RegDst <= `EX_MEM_RegDst;
				`MEM_WB_WriteData <= Databus3;
			end

			// PC generate
			if (stall[0]) begin
				PC <= PC;
			end else if (`ID_EX_Branch == 4'b1001 && Zero) begin
				// Warning: Truncate PC value here
				// PC - 4 to compensate the PC-increment in pipeline
				PC <= PC - 4 + {`ID_EX_ALUImm, 2'b00};
			end else if (`ID_EX_Branch == 4'b1000 && (~Zero)) begin
				// Warning: Truncate PC value here
				// PC - 4 to compensate the PC-increment in pipeline
				PC <= PC - 4 + {`ID_EX_ALUImm, 2'b00};
			end else if (`ID_EX_Branch == 4'b1011 && (Zero || Less)) begin
				// Warning: Truncate PC value here
				// PC - 4 to compensate the PC-increment in pipeline
				PC <= PC - 4 + {`ID_EX_ALUImm, 2'b00};
			end else if (`ID_EX_Branch == 4'b1100 && ~(Zero || Less)) begin
				// Warning: Truncate PC value here
				// PC - 4 to compensate the PC-increment in pipeline
				PC <= PC - 4 + {`ID_EX_ALUImm, 2'b00};
			end else if (`ID_EX_Branch == 4'b1010 && Less) begin
				// Warning: Truncate PC value here
				// PC - 4 to compensate the PC-increment in pipeline
				PC <= PC - 4 + {`ID_EX_ALUImm, 2'b00};
			end else if (PCSrc == 2'b01) begin
				PC <= {PC[31:28], `IF_ID_Instruction[25:0], 2'b00};
			end else if (PCSrc == 2'b10) begin
				PC <= Databus1;
			end else
				PC <= PC_plus_4;
		end
	end

endmodule