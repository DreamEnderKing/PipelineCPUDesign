`timescale 1ns / 1ns
module top(
    input reset			,
    input clk			,
	input [5:0] gpio	,
    output [3:0] sel	,
    output [7:0] seg	,
	output ResetLed		,
	input  Rx_Serial	,
	output Tx_Serial	,
	output RxLed		,
	output TxLed
);

	wire [3:0] bus_sel;
	wire [7:0] bus_seg;
	reg  clk2;
	reg  [32-1:0] counter;

	assign sel = gpio[4]? gpio[3:0]: bus_sel;
	assign seg = gpio[5]? 8'hFF: bus_seg;
	assign ResetLed = reset;
	assign RxLed = ~Rx_Serial;
	assign TxLed = ~Tx_Serial;

	initial begin
		clk2 <= 0;
		counter <= 32'b0;
	end

	always @(posedge clk) begin
		if (counter == 32'd1) begin
			clk2 <= ~clk2;
			counter <= 32'd0;
		end else
			counter <= counter + 1;
	end

	Bus bus1(
		.reset		(reset		),
		.clk		(clk		),
		.sel		(bus_sel	),
		.seg		(bus_seg	),
		.Rx_Serial	(Rx_Serial	),
		.Tx_Serial	(Tx_Serial	)
	);
endmodule
