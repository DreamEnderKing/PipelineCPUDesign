`timescale 1ns / 1ns

module Bus(
	input  reset    , 
	input  clk      ,  
	input  MemRead  ,
	input  MemWrite ,
	input  [32 -1:0] Address    ,
	input  [32 -1:0] Write_data ,
	output [32 -1:0] Read_data	,
	output [ 4 -1:0] sel		,
	output [ 8 -1:0] seg
);

	parameter BCD_ADDR = 32'h4000_0010;

	wire [2 -1:0] id = (Address[30] == 0)? 0:
		(Address == BCD_ADDR)? 1: 2;
	
	wire [32 -1:0] Read_data0;
	wire [32 -1:0] Read_data1;
	wire [32 -1:0] Read_data2;

	assign Read_data = (id == 0)? Read_data0:
		(id == 1)? Read_data1:
		(id == 2)? Read_data2: 32'b0;
	
	// RAM address from 0x000 to 0x7FF, 512 words
	DataMemory#(
		.RAM_SIZE_BIT		(9						)
	) DM1(
		.reset				(reset					),
		.clk				(clk					),
		.MemRead			((id == 0) && MemRead	),
		.MemWrite			((id == 0) && MemWrite	),
		.Address			(Address				),
		.Write_data			(Write_data				),
		.Read_data			(Read_data0				)
	);

	// BCD in 0x4000_0010(BCD_ADDR)
	BCD bcd(
		.reset				(reset					),
		.clk				(clk					),
		.StatusRead			((id == 1) && MemRead	),
		.StatusWrite		((id == 1) && MemWrite	),
		.Write_data			(Write_data             ),
		.Read_data			(Read_data1				),
		.sel				(sel					),
		.seg				(seg					)
	);

	// UART in 0x4000_0018-0x4000_0020(UART_ADDR)
	UART#(
		.CLKS_PER_BIT  		(10417 					), // 100MHz/9600Hz
    	.BASE_ADDR			(32'h4000_0020			)
	) uart(
		.reset				(reset					),
		.clk				(clk					),
		.MemRead			((id == 2) && MemRead	),
		.MemWrite			((id == 2) && MemWrite	),
		.Address			(Address				),
		.Write_data			(Write_data				),
		.Read_data			(Read_data2				)		
	);
			
endmodule