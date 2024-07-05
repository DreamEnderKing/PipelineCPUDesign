`timescale 1ns / 1ns
module top(
    input reset			,
    input clk			,
	input [5:0] gpio	,
    output [3:0] sel	,
    output [7:0] seg	,
	output ResetLed		,
	input  Rx_Serial	,
	output Tx_Serial
);

	wire [3:0] bus_sel;
	wire [7:0] bus_seg;

	assign sel = gpio[4]? gpio[3:0]: bus_sel;
	assign seg = gpio[5]? 8'hFF: bus_seg;
	assign ResetLed = reset;

	Bus bus1(
		.reset		(reset		),
		.clk		(clk		),
		.sel		(bus_sel	),
		.seg		(bus_seg	),
		.Rx_Serial	(Rx_Serial	),
		.Tx_Serial	(Tx_Serial	)
	);
endmodule
