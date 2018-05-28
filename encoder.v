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
		- done: notification signaling encoding done

*/

module encoder(input wire clock,
			   input wire reset,
			   input wire [`PACKET_SIZE - 1:0] data, 
			   output reg led,
			   output reg done); 

	/* counts intervals for D-PPM (Differential Pulse Position Modulation) */
	reg [`COUNTER_SIZE - 1:0]	counter;
	
	/* represents the current bit to send */
	reg [`COUNTER_SIZE:0]		current_bit;
 
	/* TODO: improve design
		currently to_signal_done is set on negedge
		and on posedge done is set correspondingly
	*/
	reg							to_signal_done;
 
	initial
	begin
		/* reset internal logic */
		led				= `LED_ON;
		counter			= 0;
		done			= 0;
		current_bit		= 0;
		to_signal_done	= 0;
	end
	
	always @(posedge reset)
	begin
		/* reset internal logic */
		led				<= `LED_ON;
		counter			<= 0;
		done			<= 0;
		current_bit		<= 0;
		done 			<= 0;
		to_signal_done	<= 0;
	end
	
	always @(posedge clock)
	begin
		/* output is almost always in OFF state */
		led <= `LED_OFF;
		if (to_signal_done == 0)
		begin
			counter <= counter + 1;

			if (data[current_bit] == 0 &&
			   counter == `INTERVAL_LOW)
			begin
				led		<= `LED_ON;
				counter	<= 0;
				current_bit <= current_bit + 1;
			end
			else if (data[current_bit] == 1 &&
					counter == `INTERVAL_HIGH)
			begin
				led		<= `LED_ON;
				counter	<= 0;
				current_bit <= current_bit + 1;
			end
		end
		
		if (to_signal_done == 1)
			done <= 1;

	end
	
	always @(negedge clock)
	begin
		if (current_bit == `PACKET_SIZE)
			to_signal_done <= 1;
	end
	
endmodule
	