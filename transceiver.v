`include "definitions.v"

/* 
	Transceiver module
	
		- controls communication 
		
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
module transceiver(
	input wire clock,
	input wire reset,
	input wire tx_enable,
	input wire signal,
	input wire [`PACKET_SIZE - 1:0] data_in,
	output wire [`PACKET_SIZE - 1:0] data_out,
	output wire led,
	output wire irq_tx,
	output wire irq_rx);
	
	
	encoder encoder(
		.clock(clock),
		.reset(reset),
		.data(data_in),
		.done(irq_tx),
		.enable(tx_enable),
		.led(led));
		
	decoder decoder(
		.clock(clock),
		.reset(reset),
		.signal(signal),
		.data(data_out),
		.irq(irq_rx));
			
endmodule

