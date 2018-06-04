`timescale 1ns / 100ps

`include "definitions.v"


module test_transceiver;
	
	reg clock;
	reg reset;
	
	reg tx_en_1;
	reg tx_en_2;
	
	wire led_1;
	wire led_2;
	
	wire irq_tx_1, irq_rx_1;
	wire irq_tx_2, irq_rx_2;
	
	reg [`FRAME_SIZE - 1: 0] data_in_1;
	reg [`FRAME_SIZE - 1: 0] data_in_2;
	
	wire [`FRAME_SIZE - 1: 0] data_out_1;
	wire [`FRAME_SIZE - 1: 0] data_out_2;
	
	transceiver t1(
		.clock(clock),
		.reset(reset),
		.tx_enable(tx_en_1),
		.signal(led_2),
		.data_in(data_in_1),
		.data_out(data_out_1),
		.led(led_1),
		.irq_tx(irq_tx_1),
		.irq_rx(irq_rx_1));
		
	
	transceiver t2(
		.clock(clock),
		.reset(reset),
		.tx_enable(tx_en_2),
		.signal(led_1),
		.data_in(data_in_2),
		.data_out(data_out_2),
		.led(led_2),
		.irq_tx(irq_tx_2),
		.irq_rx(irq_rx_2));
	
	initial
	begin
		clock	= 0;
		tx_en_1	= 0;
		tx_en_2	= 0;
		reset	= 0;
	end
	
	always
	begin
		reset = 1;
		#4 reset = 0;

		data_in_1 = 16'b0101_0000_0100_0101; // 50 'P' 45 'E'
		tx_en_1 = 1;
		wait(irq_tx_1 == 1 && irq_rx_2 == 1);
		tx_en_1 = 0;
		#4;
		
		data_in_2 = 16'b0101_0100_0101_0010; // 54 'T' 52 'R'
		tx_en_2 = 1;
		wait(irq_tx_2 == 1 && irq_rx_1 == 1);
		tx_en_2 = 0;
		#4;
	
		data_in_1 = 16'b0100_0001_0010_0001; // 41 'A' 21 '!'
		tx_en_1 = 1;
		wait(irq_tx_1 == 1 && irq_rx_2 == 1);
		tx_en_1 = 0;
		#4;
		$finish;
	end
	
	always
		#1 clock = !clock;
	
	
	
endmodule