`timescale 1ns / 1ns

module test();
	
	reg reset   ;
	reg clk     ;
	reg clk2	;

	wire [3:0] sel;
	wire [7:0] seg;
	wire Rx_Serial;
	wire Tx_Serial;
	
	Bus bus1(  
		.reset			(reset		), 
		.clk			(clk		),
		.sel			(sel		),
		.seg			(seg		),
		.Rx_Serial		(Rx_Serial	),
		.Tx_Serial		(Tx_Serial	)
	);
	
	initial begin
		reset   = 1;
		clk     = 0;
		clk2	= 0;
		#10 reset = 0;
	end
	
	always #5 clk = ~clk;

	always #52083 clk2 = ~clk2;
		
endmodule
