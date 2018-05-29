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
	
	reg [`PACKET_SIZE - 1: 0] data_in_1;
	reg [`PACKET_SIZE - 1: 0] data_in_2;
	
	wire [`PACKET_SIZE - 1: 0] data_out_1;
	wire [`PACKET_SIZE - 1: 0] data_out_2;
	
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
		#4;
		
		data_in_1 = 8'b0101_0000; // 'P'
		reset = 1;
		tx_en_1 = 1;
		#3 reset = 0;
		wait(irq_tx_1 == 1 && irq_rx_2 == 1);
		tx_en_1 = 0;
		
		data_in_2 = 8'b0100_0101; // 'E'
		reset = 1;
		tx_en_2 = 1;
		#3 reset = 0;
		wait(irq_tx_2 == 1 && irq_rx_1 == 1);
		tx_en_2 = 0;
		
		data_in_1 = 8'b0101_0100; // 'T'
		reset = 1;
		tx_en_1 = 1;
		#3 reset = 0;
		wait(irq_tx_1 == 1 && irq_rx_2 == 1);
		tx_en_1 = 0;
		
		data_in_2 = 8'b0101_0010; // 'R'
		reset = 1;
		tx_en_2 = 1;
		#3 reset = 0;
		wait(irq_tx_2 == 1 && irq_rx_1 == 1);
		tx_en_2 = 0;
		
		data_in_1 = 8'b0100_0001; // 'A'
		reset = 1;
		tx_en_1 = 1;
		#3 reset = 0;
		wait(irq_tx_1 == 1 && irq_rx_2 == 1);
		tx_en_1 = 0;
	
		$finish;
	end
	
	always
		#1 clock = !clock;
	
	
	
endmodule