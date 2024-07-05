`timescale 1ns / 1ns

module UART#(
    parameter CLKS_PER_BIT  = 10417,
    parameter BASE_ADDR     = 32'h4000_0020
)(
    input reset,
    input clk,
    input MemRead,
    input MemWrite,
    input  [32 -1:0] Address,
	input  [32 -1:0] Write_data,
	output [32 -1:0] Read_data,
    input Rx_Serial,
    output Tx_Serial
);

    parameter Tx_ADDR   = BASE_ADDR - 8 ;
    parameter Rx_ADDR   = BASE_ADDR - 4 ;
    parameter Cond_ADDR = BASE_ADDR     ;

    reg  [32 -1:0] Rx_Data  ;
    reg  [32 -1:0] Tx_Data  ;
    reg  [32 -1:0] Cond     ;
    assign Read_data = (Address == Tx_ADDR)? Tx_Data:
        (Address == Rx_ADDR)? Rx_Data:
        (Address == Cond_ADDR)? Cond: 32'b0;
    
    /*--------------------------------UART RX-------------------------*/
    wire Rx_DV  ;
    wire Rx_Byte;
    
    uart_rx#(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uart_rx_inst(
        .i_Clock(clk),
        .i_Rx_Serial(Rx_Serial),
        .o_Rx_DV(Rx_DV),
        .o_Rx_Byte(Rx_Byte)
    );
    /*--------------------------------UART TX-------------------------*/
    reg Tx_DV;
    wire Tx_Active;
    wire Tx_Done;
    
    uart_tx#(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uart_tx_inst(
        .i_Clock(clk),
        .i_Tx_DV(Tx_DV),
        .i_Tx_Byte(Tx_Data[7:0]),
        .o_Tx_Active(Tx_Active),
        .o_Tx_Serial(Tx_Serial),
        .o_Tx_Done(Tx_Done)
    );
    
    /*----------------------------------BUS Control----------------------------*/
    always @(posedge clk or posedge reset)begin
        if (reset) begin
            Rx_Data <= 32'b0;
            Tx_Data <= 32'b0;
            Cond <= 32'b0;

            Tx_DV <= 1'b0;
        end else begin
            if (Rx_DV) begin
                Rx_Data[7:0] <= Rx_Byte;
            end

            if (MemRead && Address == Cond_ADDR) begin
                Cond[1] <= Tx_Done;
                Cond[2] <= Rx_DV;
            end else begin
                Cond[1] <= Tx_Done || Cond[1];
                Cond[2] <= Rx_DV || Cond[2];
            end
            Cond[3] <= Tx_Active;
            
            if (MemWrite) begin
                if (Address == Tx_ADDR) begin
                    Tx_Data <= Write_data;
                    Tx_DV <= 1;
                end
            end else
                Tx_DV <= 0;
        end
    end
endmodule
