`timescale 1ns / 100ps

`include "definitions.v"

module test_encoder;
	
	reg clock;
	reg reset;
	reg [`FRAME_SIZE - 1:0] data;
	reg enable;

	wire led;
	wire irq;
	
	
	encoder encoder(
		.clock(clock),
		.reset(reset),
		.data(data),
		.led(led),
		.irq(irq),
		.enable(enable)
	);

	initial
	begin
		clock	= 0;
		reset	= 1;

		enable = 1;
		#2 reset = 0;		
	end
	
	always
	begin
		data = 16'b0100_1111_1011_0110;
		wait(irq == 1);
		#3 $finish;
		
	end
	
	always
		#1 clock = !clock;

	
	
endmodule