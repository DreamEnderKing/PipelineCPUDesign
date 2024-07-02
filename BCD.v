`timescale 1ns / 1ns

module BCD(
	input  reset				,
	input  clk					,
	input  StatusRead			,
	input  StatusWrite			,
	input  [32 -1:0] Write_data	,
	output [32 -1:0] Read_data	,
	output [ 3 -1:0] sel		,
	output [ 8 -1:0] seg
);

	reg  [32 -1:0] status;

	assign Read_data = StatusRead? status: 32'b0;
	assign sel = status[11:8];
	assign seg = status[ 7:0];

	always @(posedge clk or posedge reset) begin
		if (reset)
			status = 32'b0;
		else if (StatusWrite)
			status = Write_data;
	end

endmodule