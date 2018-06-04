`include "definitions.v"

/* 
	Encoder module
	
		- responsible for physically encoding the data
		- 
		
	Parameters
	
		- clock: system clock
		- reset: module reset (sets internal counters to 0
		- data: the packet to be sent
		- led: led output value
		- irq: notification signaling encoding done

*/
module encoder(input wire clock,
			   input wire reset,
			   input wire start,
			   input wire [`FRAME_SIZE - 1:0] data, 
			   output reg led,
			   output reg irq); 

	/* counts intervals for D-PPM (Differential Pulse Position Modulation) */
	reg [`COUNTER_SIZE - 1:0]	counter;
	
	/* represents the current bit to send */
	reg [`COUNTER_SIZE:0]		current_bit;
	

	/* STATE 0 no message
	   STATE 1 just send the first impulse 
	   STATE 2 start sending the others
	   */
	reg [1:0]					current_state;	

	initial
	begin
		/* reset internal logic */
		led				= `LED_OFF;
		counter			= 0;
		irq				= 0;
		current_bit		= 0;
		current_state	= 0;

	end

	always @(posedge clock)
	begin
		/* output is almost always in OFF state */
		led <= `LED_OFF;

		if (reset == 1)
		begin
			/* reset internal logic */
			counter			<= 0;
			current_bit		<= 0;
			irq 			<= 0;
			current_state	<= 0;
		end else
		begin
			if (start && current_state == 0)
			begin
				current_bit <= 0;
				counter <= 0;
				current_state <= 1;
				led <= `LED_ON;
			end else if (start && current_state == 1)
			begin
				if (current_bit < `FRAME_SIZE)
				begin
					counter <= counter + 1'b1;

					if (data[current_bit] == 0 &&
					   counter == `INTERVAL_LOW)
					begin
						led	<= `LED_ON;
						counter	<= 0;
						current_bit <= current_bit + 1'b1;
						
					end else if (data[current_bit] == 1 &&
							counter == `INTERVAL_HIGH)
					begin
						led	<= `LED_ON;
						counter	<= 0;
						current_bit <= current_bit + 1'b1;
					end			
				end else
				begin
					current_state = 2;
					irq <= 1;
				end
			end else if (start == 0)
			begin
				current_state <= 0;
				irq <= 0;
			end
		end
	end
endmodule
	