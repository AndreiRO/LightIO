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
			   input wire enable,
			   input wire [`FRAME_SIZE - 1:0] data, 
			   output wire led,
			   output reg irq); 

	/* counts intervals for D-PPM (Differential Pulse Position Modulation) */
	reg [`COUNTER_SIZE - 1:0]	counter;
	
	/* represents the current bit to send */
	reg [`COUNTER_SIZE:0]		current_bit;

	reg							_led;

	assign led = (enable == 1) ? _led : 1'b0;

	initial
	begin
		/* reset internal logic */
		_led			= `LED_OFF;
		counter			= 0;
		irq			= 0;
		current_bit		= 0;
	end

	always @(posedge clock)
	begin

		if (reset == 1)
		begin
			/* reset internal logic */
			_led			<= `LED_ON;
			counter			<= 0;
			current_bit		<= 0;
			irq 			<= 0;
		end else
		begin
			/* output is almost always in OFF state */
			_led <= `LED_OFF;

			if (current_bit < `FRAME_SIZE)
			begin
				counter <= counter + 1'b1;

				if (data[current_bit] == 0 &&
				   counter == `INTERVAL_LOW)
				begin
					_led	<= `LED_ON;
					counter	<= 0;
					current_bit <= current_bit + 1'b1;
					
				end
				else if (data[current_bit] == 1 &&
						counter == `INTERVAL_HIGH)
				begin
					_led	<= `LED_ON;
					counter	<= 0;
					current_bit <= current_bit + 1'b1;
				end				
			end else
				irq <= 1;

		end
	end
	

endmodule
	