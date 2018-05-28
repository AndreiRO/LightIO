`timescale 1ns / 100ps

`include "definitions.v"

module test_encode_decode;
	reg clock;
	reg reset;
	
	reg [`PACKET_SIZE - 1:0] data_in;
	wire [`PACKET_SIZE - 1:0] data_out;

	wire led;
	wire done;
	wire irq;
	
	encoder encoder(
		.clock(clock),
		.reset(reset),
		.data(data_in),
		.led(led),
		.done(done)
	);
	
	decoder decoder(
		.clock(clock),
		.reset(reset),
		.data(data_out),
		.irq(irq),
		.signal(led)
	);
	
	initial
	begin
		reset = 0;
		clock = 0;
		data_in = 8'b1011_0110;
		
	end
	
	always
	begin
		#1 clock = !clock;
	end
	
	always
		#80 $finish;

endmodule