`timescale 1ns / 1ns

module Bus(
	input  reset		, 
	input  clk			,  
	output [4 -1:0] sel	,
	output [8 -1:0] seg	,
	input  Rx_Serial	,
	output Tx_Serial
);
	wire Read;
	wire Write;
	wire [32 -1:0] Address;
	wire [32 -1:0] Write_data;
	wire [32 -1:0] Read_data;

	parameter BCD_ADDR = 32'h4000_0010;

	wire [2 -1:0] id;
	assign id = (Address[30] == 0)? 0:
		(Address == BCD_ADDR)? 1: 2;
	
	wire [32 -1:0] Read_data0;
	wire [32 -1:0] Read_data1;
	wire [32 -1:0] Read_data2;

	assign Read_data = (id == 0)? Read_data0:
		(id == 1)? Read_data1:
		(id == 2)? Read_data2: 32'b0;

	// CPU on the bus
	CPU cpu1(
		.reset				(reset			),
		.clk				(clk			),
		.MemBus_Read		(Read			),
		.MemBus_Write		(Write			),
		.MemBus_Address		(Address		),
		.MemBus_Write_Data  (Write_data		),
		.MemBus_Read_Data	(Read_data		)
	);
	
	// RAM address from 0x000 to 0x7FF, 512 words
	DataMemory#(
		.RAM_SIZE_BIT		(9						)
	) DM1(
		.reset				(reset					),
		.clk				(clk					),
		.MemRead			((id == 0) && Read		),
		.MemWrite			((id == 0) && Write		),
		.Address			(Address				),
		.Write_data			(Write_data				),
		.Read_data			(Read_data0				)
	);

	// BCD in 0x4000_0010(BCD_ADDR)
	BCD bcd(
		.reset				(reset					),
		.clk				(clk					),
		.StatusRead			((id == 1) && Read		),
		.StatusWrite		((id == 1) && Write		),
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
		.MemRead			((id == 2) && Read		),
		.MemWrite			((id == 2) && Write		),
		.Address			(Address				),
		.Write_data			(Write_data				),
		.Read_data			(Read_data2				),
		.Rx_Serial			(Rx_Serial				),
		.Tx_Serial			(Tx_Serial				)
	);
			
endmodule