`include "definitions.v"

/* 
	Error Correcting Code module
	
		- Employs a Hamming(15, 11) code that can
		correct one error and detect 2 errors
		+ 1 extra overall parity bit
		to enable SEC-DED
		
	Parameters
		- packet: packet to be encoded
		- frame: frame to be decoded
		- codeword: encoded packet
		- data: decoded frame
		- operation: `OP_ENDODE ^ `OP_DECODE
*/

module ecc(input wire [`PACKET_SIZE - 1:0] packet,
		   input wire [`FRAME_SIZE - 1:0] frame,
		   output reg [`FRAME_SIZE - 1:0] codeword,
		   output reg [`PACKET_SIZE - 1:0] data,
		   input wire operation,
		   output reg irq,
		   output reg correct);

	reg p1, p2, p4, p8;
	reg d3, d5, d6, d7, d9, d10, d11, d12, d13, d14, d15;
	reg o, o2; /* overall parity bit */
	reg s1, s2, s4, s8;
	
	
	initial
	begin
		irq = 1'b0;
	end
	
	always @(packet, frame)
	begin
		irq = 1'b0;
		correct = 1'bz;
		
		if (operation == `OP_ENCODE)
		begin
			/* unfold packet */
			{d15, d14, d13, d12, d11, d10, d9, d7, d6, d5, d3} = packet[`PACKET_SIZE - 1:0];
			
			/* calculate parity */
			p1 = d3 + d5 +  d7 +  d9 +  d11 + d13 + d15;
			p2 = d3 + d6 +  d7 +  d10 + d11 + d14 + d15;
			p4 = d5 + d6 +  d7 +  d12 + d13 + d14 + d15;
			p8 = d9 + d10 + d11 + d12 + d13 + d14 + d15;
			
			/* overall parity bit */
			o = p1 + p2 + d3 + p4 + d5 + d6 + d7 + p8 + d9 + d10 + d11 + d12 + d13 + d14 + d15;

			/* set output */
			codeword = {o, d15, d14, d13, d12, d11, d10, d9, p8, d7, d6, d5, p4, d3, p2, p1};
			data = 11'bzzz_zzzz_zzzz;
			irq = 1;
		end else if (operation == `OP_DECODE)
		begin
			correct = 1'bz;
			/* unfold */
			{o, d15, d14, d13, d12, d11, d10, d9, p8, d7, d6, d5, p4, d3, p2, p1} = frame;
			
			/* calculate syndrome */
			s1 = p1 + d3 + d5 +  d7 +  d9 +  d11 + d13 + d15;
			s2 = p2 + d3 + d6 +  d7 +  d10 + d11 + d14 + d15;
			s4 = p4 + d5 + d6 +  d7 +  d12 + d13 + d14 + d15;
			s8 = p8 + d9 + d10 + d11 + d12 + d13 + d14 + d15;
			
			o2 = o + p1 + p2 + d3 + p4 + d5 + d6 + d7 + p8 + d9 + d10 + d11 + d12 + d13 + d14 + d15;

			/* decode */
			case ({o2, s8, s4, s2, s1})
				/* no bit or overall bit modification */
				5'b0_0000: begin correct = 1; end
				5'b1_0000: begin correct = 1; end
					
				/* 1 bit error correction */
				5'b1_0001: begin correct = 1; end 				/* parity bit modified */
				5'b1_0010: begin correct = 1; end				/* parity bit modified */
				5'b1_0011: begin d3 = !d3; correct = 1; end 	/* d3 */
				5'b1_0100: begin correct = 1; end				/* parity bit modified */
				5'b1_0101: begin d5 = !d5; correct = 1; end 	/* d5 */
				5'b1_0110: begin d6 = !d6; correct = 1; end 	/* d6 */
				5'b1_0111: begin d7 = !d7; correct = 1; end 	/* d7 */
				5'b1_1000: begin correct = 1; end				/* parity bit modified */
			
				5'b1_1001: begin d9 = !d9; correct = 1; end		/* d9 */
				5'b1_1010: begin d10 = !d10; correct = 1; end	/* d10 */
				5'b1_1011: begin d11 = !d11; correct = 1; end	/* d11 */
				5'b1_1100: begin d12 = !d12; correct = 1; end	/* d12 */
				5'b1_1101: begin d13 = !d13; correct = 1; end	/* d13 */
				5'b1_1110: begin d14 = !d14; correct = 1; end	/* d14 */
				5'b1_1111: begin d15 = !d15; correct = 1; end	/* d13 */
				default: correct = 0;
			endcase
			
			if (correct == 1)
				data = {d15, d14, d13, d12, d11, d10, d9, d7, d6, d5, d3};
			else
				data = 11'bzzz_zzzz_zzzz;
			codeword = 16'bzzzz_zzzz_zzzz_zzzz;
			irq = 1;
		end
	end
	
endmodule