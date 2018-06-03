`timescale 1ns / 100ps

`include "definitions.v"


module test_ecc;
	
	reg [`PACKET_SIZE - 1:0] packet_1;
	reg [`PACKET_SIZE - 1:0] packet_2;
	
	wire [`FRAME_SIZE - 1:0] frame_1;
	wire [`FRAME_SIZE - 1:0] frame_2;

	wire [`FRAME_SIZE - 1:0] codeword_1;
	wire [`FRAME_SIZE - 1:0] codeword_2;
	
	wire [`PACKET_SIZE - 1:0] data_1;
	wire [`PACKET_SIZE - 1:0] data_2;

	reg operation_1;
	reg operation_2;
	
	wire irq_1;
	wire irq_2;
	wire irq_3;
	
	wire correct_1;
	wire correct_2;
	
	 ecc ecc_1(packet_1,
		     frame_1,
	         codeword_1,
	         data_1,
	         operation_1,
	         irq_1,
	         correct_1);
			 
	noisy_channel #(.error_no(1)) noisy_channel(
		codeword_1,
		frame_2,
		irq_3
	);	 
		
	ecc ecc_2(packet_2,
		     frame_2,
	         codeword_2,
	         data_2,
	         operation_2,
	         irq_2,
	         correct_2);
	
	initial
	begin
		operation_1 = `OP_ENCODE;
		operation_2 = `OP_DECODE;
		packet_1 = 11'b000_0100_0010;
		wait(irq_1 == 1 && irq_2 == 1 && irq_3 == 1);
		#3 $finish;
		
	end
	
endmodule