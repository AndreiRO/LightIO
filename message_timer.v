`include "definitions.v"

/* 
	Timer module
	
		- sends timeout signal for resending
		a message in case the ack wasn't received
		
	Parameters
	
		- clock: system clock
		- reset: module reset (sets internal counters to 0
		- irq: timeout IRQ

*/

module message_timer #(parameter divider = 256)(
	input wire clock,
	input wire reset,
	output reg irq);
	
	reg [8:0] counter;
	
	initial
		counter = 0;
		
	always @(posedge clock)
	begin
		irq <= 0;
		if (reset)
			counter <= 0;
		else begin
			if (counter == divider)
			begin
				irq <= 1;
				counter <= 0;
			end else
				counter <= counter + 1'b1;
		end
		
	end
	
	
endmodule