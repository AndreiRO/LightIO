`timescale 1ns / 100ps

`include "definitions.v"


module test_clock_divider();
	
	
	reg clock;
	wire clock_d_2,
		 clock_d_4,
		 clock_d_8;
	
	clock_divider #(.factor(`FACTOR_2)) clock_divider_2(
		.clock(clock),
		.clock_d(clock_d_2)
	);
	
	clock_divider #(.factor(`FACTOR_4)) clock_divider_4(
		.clock(clock),
		.clock_d(clock_d_4)
	);
	
	clock_divider #(.factor(`FACTOR_8)) clock_divider_8(
		.clock(clock),
		.clock_d(clock_d_8)
	);
	
	initial
		clock = 1;
		
	always
	begin
		clock = !clock;
		#1;
	end
	
	
	always
		#17 $finish;
	
endmodule