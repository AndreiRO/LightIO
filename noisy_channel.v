`include "definitions.v"

/* 
	Noisy channel module
	
		Simulates a noisy channel that can modify up to
		parameter bits;
		
	Parameters
		- in: data in
		- out: data out
		- irq: operation finished

*/
module noisy_channel #(parameter error_no=1) (
		input wire [`FRAME_SIZE - 1:0] in,
		output reg [`FRAME_SIZE - 1:0] out,
		output reg irq);

	reg [15:0] position;
	reg [15:0] position2;
	integer i;

	initial
		i = 0;

	always @(in)
	begin
		irq = 0;
		out = in;
		
		position = $urandom % 8;
		i = i + 1;
		out[position] = !out[position];
		
		if (error_no == 2)
		begin
			position2 = $urandom(i) % 8;
			while (position == position2)
			begin
				position2 = $urandom(i) % 8;
				i = i + 1;
			end

			out[position2] = !out[position2];
		end
		
		irq = 1;
	end

endmodule