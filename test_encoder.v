`timescale 1ns / 100ps

`include "definitions.v"

module test_encoder;
	
	reg clock;
	reg reset;
	reg [`FRAME_SIZE - 1:0] data;
	reg start;

	wire led;
	wire irq;
	
	
	encoder encoder(
		.clock(clock),
		.reset(reset),
		.data(data),
		.led(led),
		.irq(irq),
		.start(start)
	);

	initial
	begin
		clock	= 0;
	end
	
	always
	begin
		
		data = 16'b0100_1111_1011_0110;
		start = 1;
		wait(irq == 1);
		start = 0;
		#3 $finish;
		
	end
	
	always
		#1 clock = !clock;

	
	
endmodule