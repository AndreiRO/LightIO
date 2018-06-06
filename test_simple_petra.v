`timescale 1ns / 100ps

`include "definitions.v"


module test_simple_petra;
	
	reg clock;
	reg reset;
	
	reg send_message_1;
	reg send_message_2;
	
	reg [`MESSAGE_SIZE - 1:0] data_in_1;
	wire [`MESSAGE_SIZE - 1:0] data_out_1;
	
	reg [`MESSAGE_SIZE - 1:0] data_in_2;
	wire [`MESSAGE_SIZE - 1:0] data_out_2;
	
	wire irq_tx_1;
	wire irq_rx_1;
	
	wire irq_tx_2;
	wire irq_rx_2;

	
	wire led_2;
	wire led_1;

	petra petra1(clock, reset, send_message_1, data_in_1, data_out_1,
				irq_tx_1, irq_rx_1, led_2, led_1);
	
	petra petra2(clock, reset, send_message_2, data_in_2, data_out_2,
				irq_tx_2, irq_rx_2, led_1, led_2);
	
	initial
	begin
		clock = 0;
		reset = 0;
		send_message_1 = 0;
		data_in_1 = 8'b0101_0000;
	end
	
	always
	begin
		reset = 1;
		#4 reset = 0;
		send_message_1 = 1;
		wait (irq_tx_1 == 1 && irq_rx_2 == 1);
		#4 $finish;
	end
		
	
	always
		#1 clock = !clock;
	
	
endmodule