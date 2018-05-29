`timescale 1ns / 100ps

`include "definitions.v"

module test_encode_decode(output wire t);
	reg clock;
	reg reset;
	reg enable;
	
	assign t = 0;
	
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
		.done(done),
		.enable(enable)
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
		clock = 0;
		data_in = 8'b1011_0110;
		
		enable = 1;
		reset = 1;
		#2 reset = 0;
	end
	
	always
	begin
		#1 clock = !clock;
	end
	
	always
	begin
		wait(done == 1);
		reset = 1;
		#3;
		data_in = 8'b1111_0100;
		reset = 0;
		wait(done == 1);
		#2;
		$finish;
	end
endmodule