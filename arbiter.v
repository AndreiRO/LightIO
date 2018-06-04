`include "definitions.v"

/* 
	Arbiter module
	
		- Sends and receives bytes
		
		
	Parameters
	
		- clock: system clock
		- reset: module reset (sets internal counters to 0
		- tx_enable: start sending a packet
		- signal: values from PIN
		- data_in: the packet to be sent
		- data_out: packet received
		- led: led output value
		- irq_tx: packet sent
		- irq_rx: packet received
*/

`define NO_OUTPUT		0
`define PRIORITY_OUTPUT	1
`define NORMAL_OUTPUT	2

module arbiter(input wire clock,
			   input wire reset,
			   input wire in_priority,
			   input wire in_normal,
			   
			   output reg out_priority,
			   output reg out_normal);
			
	reg [1:0] state;

	initial
	begin
		out_priority = 0;
		out_normal = 0;
		state = `NO_OUTPUT;
	end
			   
			   
	always @(posedge clock)
	begin
		if (reset)
		begin
			out_normal = 0;
			out_priority = 0;
			state = `NO_OUTPUT;
		end else
		begin
			if (state == `PRIORITY_OUTPUT && in_priority == 0)
			begin
				out_priority = 0;
				state = `NO_OUTPUT;
			end else if (state == `NORMAL_OUTPUT && in_normal == 0)
			begin
				out_normal = 0;
				state = `NO_OUTPUT;
			end
			
			if (state == `NO_OUTPUT)
			begin
				if (in_priority == 1)
				begin
					out_priority = 1;
					state = `PRIORITY_OUTPUT;
				end else if (in_normal == 1)
				begin
					out_normal = 1;
					state = `NORMAL_OUTPUT;
				end
			end
			
		end
		
	end
	
	
endmodule




