`include "definitions.v"

/* 
	Lossy channel module
	
		Simulates a lossy channel that can modify up to
		parameter bits and loose;
		
	Parameters
		- in: data in
		- out: data out
		- irq: operation finished

*/
module lossy_channel(
		input wire [`FRAME_SIZE - 1:0] in,
		output wire [`FRAME_SIZE - 1:0] out,
		output wire irq);
		
		reg [3:0] counter;
		reg [3:0] seq;
		
		reg [`FRAME_SIZE - 1:0] data;
		
		reg  irq_lossy;
		wire irq_noisy;
		
		assign irq = irq_lossy | irq_noisy;
		
		noisy_channel noisy_channel(data, out, irq_noisy);
		
		initial
		begin
			counter = 0;
			seq = 4'b1101;
		end

		always @(in)
		begin
			irq_lossy <= 0;
			if (seq[counter] == 1)
			begin
				data <= in;
			end else
				irq_lossy <= 1;
			
			counter <= counter + 1'b1;
		end
		
endmodule