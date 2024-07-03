`timescale 1ns / 1ns

module InstructionMemory(
	input      [32 -1:0] Address, 
	output reg [32 -1:0] Instruction
);
	
	always @(*)
		case (Address[9:2])

			// -------- Paste Binary Instruction Below (Inst-q1-1/Inst-q1-2.txt)
8'd0:  Instruction <= 32'h241a0001;
8'd1:  Instruction <= 32'h8c080000;
8'd2:  Instruction <= 32'h20040004;
8'd3:  Instruction <= 32'h00082821;
8'd4:  Instruction <= 32'h20010004;
8'd5:  Instruction <= 32'h03a1e822;
8'd6:  Instruction <= 32'hafa80000;
8'd7:  Instruction <= 32'h0c10000c;
8'd8:  Instruction <= 32'h8fa80000;
8'd9:  Instruction <= 32'h23bd0004;
8'd10: Instruction <= 32'hac100000;
8'd11: Instruction <= 32'h08100048;
8'd12: Instruction <= 32'h2001000c;
8'd13: Instruction <= 32'h03a1e822;
8'd14: Instruction <= 32'hafa40000;
8'd15: Instruction <= 32'hafa50004;
8'd16: Instruction <= 32'hafbf0008;
8'd17: Instruction <= 32'h24080001;
8'd18: Instruction <= 32'h0105582a;
8'd19: Instruction <= 32'h1160000d;
8'd20: Instruction <= 32'h00082821;
8'd21: Instruction <= 32'h20010004;
8'd22: Instruction <= 32'h03a1e822;
8'd23: Instruction <= 32'hafa80000;
8'd24: Instruction <= 32'h0c100026;
8'd25: Instruction <= 32'h00022821;
8'd26: Instruction <= 32'h8fa60000;
8'd27: Instruction <= 32'h0c100038;
8'd28: Instruction <= 32'h8fa80000;
8'd29: Instruction <= 32'h23bd0004;
8'd30: Instruction <= 32'h8fa50004;
8'd31: Instruction <= 32'h21080001;
8'd32: Instruction <= 32'h08100012;
8'd33: Instruction <= 32'h8fbf0008;
8'd34: Instruction <= 32'h8fa50004;
8'd35: Instruction <= 32'h8fa40000;
8'd36: Instruction <= 32'h23bd000c;
8'd37: Instruction <= 32'h03e00008;
8'd38: Instruction <= 32'h00054080;
8'd39: Instruction <= 32'h01044020;
8'd40: Instruction <= 32'h8d080000;
8'd41: Instruction <= 32'h20010001;
8'd42: Instruction <= 32'h00a14822;
8'd43: Instruction <= 32'h0120582a;
8'd44: Instruction <= 32'h117a0009;
8'd45: Instruction <= 32'h22100001;
8'd46: Instruction <= 32'h00095080;
8'd47: Instruction <= 32'h01445020;
8'd48: Instruction <= 32'h8d4a0000;
8'd49: Instruction <= 32'h010a582a;
8'd50: Instruction <= 32'h11600003;
8'd51: Instruction <= 32'h20010001;
8'd52: Instruction <= 32'h01214822;
8'd53: Instruction <= 32'h0810002b;
8'd54: Instruction <= 32'h21220001;
8'd55: Instruction <= 32'h03e00008;
8'd56: Instruction <= 32'h20010001;
8'd57: Instruction <= 32'h00c14022;
8'd58: Instruction <= 32'h00084080;
8'd59: Instruction <= 32'h01044020;
8'd60: Instruction <= 32'h8d090004;
8'd61: Instruction <= 32'h00055080;
8'd62: Instruction <= 32'h01445020;
8'd63: Instruction <= 32'h010a582a;
8'd64: Instruction <= 32'h117a0005;
8'd65: Instruction <= 32'h8d0b0000;
8'd66: Instruction <= 32'had0b0004;
8'd67: Instruction <= 32'h20010004;
8'd68: Instruction <= 32'h01014022;
8'd69: Instruction <= 32'h0810003f;
8'd70: Instruction <= 32'had490000;
8'd71: Instruction <= 32'h03e00008;

			// -------- Paste Binary Instruction Above
			
			default: Instruction <= 32'h00000000;
		endcase
		
endmodule
