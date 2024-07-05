`timescale 1ns / 1ns

module DataMemory#(
	parameter RAM_SIZE_BIT  = 8
)(
	input  reset    , 
	input  clk      ,  
	input  MemRead  ,
	input  MemWrite ,
	input  [32 -1:0] Address    ,
	input  [32 -1:0] Write_data ,
	output [32 -1:0] Read_data
);
	
	// RAM size is 2^{RAM_SIZE_BIT} words, each word is 4 bytes
	parameter RAM_SIZE      = 1 << RAM_SIZE_BIT;
	
	// RAM_data is an array of 256 32-bit registers
	reg [31:0] RAM_data [RAM_SIZE - 1: 0];

	// read data from RAM_data as Read_data
	assign Read_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h0;
	
	// write Write_data to RAM_data at clock posedge
	integer i;
	always @(posedge reset or posedge clk)begin
		if (reset) begin
			// -------- Paste Data Memory Configuration Below (Data-q1.txt)
			// RAM_data[0] <= 3;
			// RAM_data[1] <= 2;
			// RAM_data[2] <= 1;
			// RAM_data[3] <= 3;

			RAM_data[0] <= 32'h0014;
			RAM_data[1] <= 32'h41a8;

			RAM_data[2] <= 32'h3af2;
			RAM_data[3] <= 32'hacda;

			RAM_data[4] <= 32'h0c2b;
			RAM_data[5] <= 32'hb783;

			RAM_data[6] <= 32'hdac9;
			RAM_data[7] <= 32'h8ed9;

			RAM_data[8] <= 32'h09ff;
			RAM_data[9] <= 32'h2f44;

			RAM_data[10] <= 32'h044e;
			RAM_data[11] <= 32'h9899;

			RAM_data[12] <= 32'h3c56;
			RAM_data[13] <= 32'h128d;

			RAM_data[14] <= 32'hdbe3;
			RAM_data[15] <= 32'hd4b4;

			RAM_data[16] <= 32'h3748;
			RAM_data[17] <= 32'h3918;

			RAM_data[18] <= 32'h4112;
			RAM_data[19] <= 32'hc399;

			RAM_data[20] <= 32'h4955;

			for (i = 21; i < 32; i = i + 1)
				RAM_data[i] <= 32'h0;

			// bcd static data
			RAM_data[32+0] <= 32'b00111111;
            RAM_data[32+1] <= 32'b00000110;
            RAM_data[32+2] <= 32'b01011011;
            RAM_data[32+3] <= 32'b01001111;
            RAM_data[32+4] <= 32'b01100110;
            RAM_data[32+5] <= 32'b01101101;
            RAM_data[32+6] <= 32'b01111101;
            RAM_data[32+7] <= 32'b00000111;
            RAM_data[32+8] <= 32'b01111111;
            RAM_data[32+9] <= 32'b01101111;
			RAM_data[32+10] <= 32'b01110111;
			RAM_data[32+11] <= 32'b11111111;
			RAM_data[32+12] <= 32'b00111001;
			RAM_data[32+13] <= 32'b10111111;
			RAM_data[32+14] <= 32'b01111001;
			RAM_data[32+15] <= 32'b01110001;

			for (i = 48; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h0;
			// -------- Paste Data Memory Configuration Above
		end
		else if (MemWrite) begin
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		end
	end
			
endmodule
