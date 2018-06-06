`timescale 1ns / 100ps

`include "definitions.v"


module test_simple_petra;
	
	reg clock;
	reg reset;
	reg send_message;
	reg [`MESSAGE_SIZE - 1:0] data_in;
	wire [`MESSAGE_SIZE - 1:0] data_out;
	
	wire irq_tx;
	wire irq_rx;
	wire signal;
	wire led;
	
	arbiter arbiter();
	petra petra(clock, reset, send_message, data_in, data_out,
				irq_tx, irq_rx, signal, led);
				
	initial
	begin
		clock = 0;
		reset = 0;
		send_message = 0;
		data_in = 8'b0101_0000;
	end
	
	always
	begin
		send_message = 0;
		#100 $finish;
	end
		
	
	always
		#1 clock = !clock;
	
	
endmodule