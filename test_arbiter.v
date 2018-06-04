`timescale 1ns / 100ps

`include "definitions.v"


module test_arbiter;
	
	reg clock;
	reg reset;
	reg in_priority;
	reg in_normal;
	
	
	wire out_priority;
	wire out_normal;
	
	arbiter arbiter(clock, reset, in_priority, in_normal, out_priority, out_normal);
	
	
	initial
	begin
		reset = 1;
		clock = 1;
		#1 clock = 0;
		reset = 0;
		
		in_priority = 0;
		in_normal = 0;
		
	end
	
	always
		#1 clock = !clock;
		
	always
	begin
		in_priority	= 0;
		in_normal	= 0;
		#3;

		in_priority	= 1;
		in_normal	= 0;
		#3;
		
		in_priority	= 0;
		in_normal	= 1;
		#3;
		
		in_priority	= 1;
		in_normal	= 1;
		#3;

		$finish;
	end
	
endmodule