`timescale 1ns / 100ps

`include "definitions.v"


module test_timer;
	
	reg clock;
	reg reset;	
	wire irq;

	
	message_timer message_timer(clock, reset, irq);
	
	initial
	begin
		clock = 0;
		reset = 0;
	end
	
	always
	begin
		#1 clock = !clock;
	end
	
endmodule