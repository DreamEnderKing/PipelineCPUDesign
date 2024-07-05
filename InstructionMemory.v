`timescale 1ns / 1ns

module InstructionMemory(
	input      [32 -1:0] Address, 
	output reg [32 -1:0] Instruction
);
	
	always @(*)
		case (Address[9:2])

			// -------- Paste Binary Instruction Below (Inst-q1-1/Inst-q1-2.txt)
8'd0: Instruction <= 32'h241a0001;
8'd1: Instruction <= 32'h8c080000;
8'd2: Instruction <= 32'h20040004;
8'd3: Instruction <= 32'h00082821;
8'd4: Instruction <= 32'h20010004;
8'd5: Instruction <= 32'h03a1e822;
8'd6: Instruction <= 32'hafa80000;
8'd7: Instruction <= 32'h0c10000c;
8'd8: Instruction <= 32'h8fa80000;
8'd9: Instruction <= 32'h23bd0004;
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
8'd33: Instruction <= 32'h8fa40000;
8'd34: Instruction <= 32'h8fa50004;
8'd35: Instruction <= 32'h8fbf0008;
8'd36: Instruction <= 32'h23bd000c;
8'd37: Instruction <= 32'h03e00008;
8'd38: Instruction <= 32'h00054080;
8'd39: Instruction <= 32'h01044020;
8'd40: Instruction <= 32'h8d080000;
8'd41: Instruction <= 32'h20010001;
8'd42: Instruction <= 32'h00a14822;
8'd43: Instruction <= 32'h0120582a;
8'd44: Instruction <= 32'h15600009;
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
8'd64: Instruction <= 32'h15600005;
8'd65: Instruction <= 32'h8d0b0000;
8'd66: Instruction <= 32'had0b0004;
8'd67: Instruction <= 32'h20010004;
8'd68: Instruction <= 32'h01014022;
8'd69: Instruction <= 32'h0810003f;
8'd70: Instruction <= 32'had490000;
8'd71: Instruction <= 32'h03e00008;
8'd72: Instruction <= 32'h21080001;
8'd73: Instruction <= 32'h00082080;
8'd74: Instruction <= 32'h240500fa;
8'd75: Instruction <= 32'h24061000;
8'd76: Instruction <= 32'h3c074000;
8'd77: Instruction <= 32'h20e70010;
8'd78: Instruction <= 32'h24080000;
8'd79: Instruction <= 32'h0104482a;
8'd80: Instruction <= 32'h11200018;
8'd81: Instruction <= 32'h24090000;
8'd82: Instruction <= 32'h0125502a;
8'd83: Instruction <= 32'h11400013;
8'd84: Instruction <= 32'h240a0100;
8'd85: Instruction <= 32'h8d190000;
8'd86: Instruction <= 32'h0146582a;
8'd87: Instruction <= 32'h1160000d;
8'd88: Instruction <= 32'h332b000f;
8'd89: Instruction <= 32'h216b0020;
8'd90: Instruction <= 32'h000b5880;
8'd91: Instruction <= 32'h8d6c0000;
8'd92: Instruction <= 32'h018a6025;
8'd93: Instruction <= 32'hacec0000;
8'd94: Instruction <= 32'h0019c902;
8'd95: Instruction <= 32'h000a5040;
8'd96: Instruction <= 32'h3c010001;
8'd97: Instruction <= 32'h342d86a0;
8'd98: Instruction <= 32'h21adffff;
8'd99: Instruction <= 32'h15a0fffe;
8'd100: Instruction <= 32'h08100056;
8'd101: Instruction <= 32'h21290001;
8'd102: Instruction <= 32'h08100052;
8'd103: Instruction <= 32'h21080004;
8'd104: Instruction <= 32'h0810004f;
8'd105: Instruction <= 32'h24080f3f;
8'd106: Instruction <= 32'hace80000;
8'd107: Instruction <= 32'h24080000;
8'd108: Instruction <= 32'h3c054000;
8'd109: Instruction <= 32'h20a50018;
8'd110: Instruction <= 32'h24060004;
8'd111: Instruction <= 32'h0104482a;
8'd112: Instruction <= 32'h1120000c;
8'd113: Instruction <= 32'h8d190000;
8'd114: Instruction <= 32'h3c09ff00;
8'd115: Instruction <= 32'h13200007;
8'd116: Instruction <= 32'h01395024;
8'd117: Instruction <= 32'h000a5602;
8'd118: Instruction <= 32'hacaa0000;
8'd119: Instruction <= 32'h8cab0008;
8'd120: Instruction <= 32'h1566fffe;
8'd121: Instruction <= 32'h0019ca00;
8'd122: Instruction <= 32'h08100073;
8'd123: Instruction <= 32'h21080004;
8'd124: Instruction <= 32'h0810006f;
8'd125: Instruction <= 32'h0810007d;
			// -------- Paste Binary Instruction Above
			
			default: Instruction <= 32'h00000000;
		endcase
		
endmodule
