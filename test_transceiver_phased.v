`timescale 1ns / 100ps

`include "definitions.v"


module test_transceiver_phased;
	
	reg clock_1;
	reg clock_2;

	reg reset;
	wire reset_rx;
	assign reset_rx = 0;
	
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
		.clock(clock_1),
		.reset(reset),
		.tx_enable(tx_en_1),
		.signal(led_2),
		.data_in(data_in_1),
		.data_out(data_out_1),
		.led(led_1),
		.irq_tx(irq_tx_1),
		.irq_rx(irq_rx_1));
		
	
	transceiver t2(
		.clock(clock_2),
		.reset(reset_rx),
		.tx_enable(tx_en_2),
		.signal(led_1),
		.data_in(data_in_2),
		.data_out(data_out_2),
		.led(led_2),
		.irq_tx(irq_tx_2),
		.irq_rx(irq_rx_2));
	
	initial
	begin
		clock_1	= 0;
		clock_2 = 0;
		tx_en_1	= 0;
		tx_en_2	= 0;
		reset	= 0;
	end
	
	always
	begin
		clock_1 = !clock_1;
		#0.25 clock_2 = !clock_2;
		#0.75;
	end
	
	always
	begin
		data_in_1 = 16'b0101_0000_0100_0101;
		tx_en_1 = 1;
		wait(irq_tx_1 == 1 && irq_rx_2 == 1);
		tx_en_1 = 0;
		#2 $finish;
	end
	
	
endmodule
