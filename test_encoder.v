`timescale 1ns / 100ps

`include "definitions.v"

module test_encoder;
	
	reg clock;
	reg reset;
	reg [`PACKET_SIZE - 1:0] data;
	reg enable;

	wire led;
	wire done;
	
	
	encoder encoder(
		.clock(clock),
		.reset(reset),
		.data(data),
		.led(led),
		.done(done),
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
		data = 8'b1011_0110;
		#74 $finish;
	end
	
	always
		#1 clock = !clock;

	
	
endmodule