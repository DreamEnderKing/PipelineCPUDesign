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
			// bcd static data
			RAM_data[0] <= 32'b00111111;
            RAM_data[1] <= 32'b00000110;
            RAM_data[2] <= 32'b01011011;
            RAM_data[3] <= 32'b01001111;
            RAM_data[4] <= 32'b01100110;
            RAM_data[5] <= 32'b01101101;
            RAM_data[6] <= 32'b01111101;
            RAM_data[7] <= 32'b00000111;
            RAM_data[8] <= 32'b01111111;
            RAM_data[9] <= 32'b01101111;
			RAM_data[10] <= 32'b01110111;
			RAM_data[11] <= 32'b11111111;
			RAM_data[12] <= 32'b00111001;
			RAM_data[13] <= 32'b10111111;
			RAM_data[14] <= 32'b01111001;
			RAM_data[15] <= 32'b01110001;

			for (i = 16; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h0;
			// -------- Paste Data Memory Configuration Above
		end
		else if (MemWrite) begin
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		end
	end
			
endmodule
