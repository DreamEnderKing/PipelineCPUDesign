`timescale 1ns / 1ns
module top(
    input reset,
    input clk,
	input [5:0] gpio,
	output MemRead,
	output MemWrite,
	output ResetLed,
    output [3:0] sel,
    output [7:0] seg
    );

	wire [3:0] cpu_sel;
	wire [7:0] cpu_seg;

	assign sel = gpio[4]? gpio[3:0]: cpu_sel;
	assign seg = gpio[5]? 8'hFF: cpu_seg;
	assign ResetLed = reset;

	CPU cpu1(
		.reset    (reset     ),
		.clk      (clk       ),
		.MemRead  (MemRead   ),
		.MemWrite (MemWrite  ),
		.sel      (cpu_sel   ),
		.seg      (cpu_seg   )
	);
endmodule
