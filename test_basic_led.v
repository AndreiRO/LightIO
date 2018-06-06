`timescale 1ns / 100ps

`include "definitions.v"


module test_basic_led;
	
	wire led;
	wire irq;
	wire clock;
	
	basic_led basic_led(.led(led), .irq(irq), .cl(clock));
	
	
	initial
	begin
		#4000000 $finish;
	end
endmodule