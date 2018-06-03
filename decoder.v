`include "definitions.v"

/* 
	Decoder module
	
		- responsible for physically decoding the data
		
	Parameters
	
		- clock: system clock
		- reset: module reset (sets internal counters to 0
		- data: the received packet
		- signal: input value taken from limiting amp.
		- irq: notifies a new received package
*/
module decoder(input wire clock,
			   input wire reset,
			   input wire signal,
			   output reg [`FRAME_SIZE - 1:0] data,
			   output reg irq);


	/* stores the number of intervals passed between pulses */
	reg [`COUNTER_SIZE - 1:0] 	counter;
	
	/* current index in data vector */
	reg [`COUNTER_SIZE:0] 		current_bit;

	/* whether a first pulse has already been received */
	reg							started;

	initial
	begin
		data		= 0;
		current_bit	= 0;
		counter		= 0;
		started		= 0;
		irq			= 0;
	end
	
	always @(posedge clock)
	begin
		if (reset == 1)
		begin
			data		<= 0;
			current_bit	<= 0;
			counter		<= 0;
			started		<= 0;
			irq			<= 0;
		end else
		begin
			if (signal == 1)
			begin
				if (started == 0)
				begin
					/* a new package is comming */
					started <= 1;
					irq <= 0;
					current_bit <= 0;
					counter <= 0;
				end else
				begin
					
					/* determine data bit based on intervals passed */
					if (counter >= `INTERVAL_HIGH - 1)
					begin
						data[current_bit] <= 1;
					end else if (counter >= `INTERVAL_LOW - 1)
					begin
						data[current_bit] <= 0;
					end
					
					
					
					/* move to next bit */
					if (current_bit == `FRAME_SIZE - 1)
					begin
						irq <= 1;
						current_bit <= 0;
						started <= 0;
					end else if (counter != 0)
					begin
						current_bit <= current_bit + 1'b1;
					end
					counter <= 0;
				end
			end else if (started == 1)
			begin
				if (counter > `INTERVAL_HIGH)
				begin
					data		<= 0;
					current_bit	<= 0;
					counter		<= 0;
					started		<= 0;
					irq			<= 0;
				end else
					counter <= counter + 1'b1;
			end
		end
		
	end
	
				   
endmodule