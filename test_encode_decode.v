`timescale 1ns / 100ps

`include "definitions.v"

module test_encode_decode(output wire t);
	reg clock;
	reg reset;
	reg enable;
	
	assign t = 0;
	
	reg [`FRAME_SIZE - 1:0] data_in;
	wire [`FRAME_SIZE - 1:0] data_out;

	wire led;
	wire irq_tx;
	wire irq_rx;
	
	encoder encoder(
		.clock(clock),
		.reset(reset),
		.data(data_in),
		.led(led),
		.irq(irq_tx),
		.enable(enable)
	);
	
	decoder decoder(
		.clock(clock),
		.reset(reset),
		.data(data_out),
		.irq(irq_rx),
		.signal(led)
	);
	
	initial
	begin
		clock = 0;
		data_in = 16'b1111_0100_1011_0110;
		
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
		wait(irq_rx == 1 && irq_tx == 1);
		reset = 1;
		#4;
		data_in = 16'b0100_1111_1111_0100;
		reset = 0;
		#5;
		wait(irq_rx == 1 && irq_tx == 1);
		#2;
		$finish;
	end
endmodule