`include "definitions.v"

/* 
	Main communications module
	
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

/* 
	FSM description
	
	TX FSM:
	
	* TX_INITIAL:
		send_message => transition to TX_WAIT_ARBITER
			set *current_message*
			trigger arbiter			
		ack_send  => transition to TX_ECC_ENCODE
					 RX receives a message and tries to send an ACK/NACK
					 sets current_type to ACK/NACK
					 set current_packet
					 start encoding process
					 (arbiter allows (N)ACK message transmission)
					 
	
	* TX_WAIT_ARBITER
		message_send => transition to TX_ENCODE
			set current_packter
			start ECC process
								
	
	* TX_ECC_ENCODE
		perform ECC encoding
		tx_ecc_irq => transition to  TX_TYPE_SELECT				
		

*/

`define MSG_NORMAL 2'b00
`define MSG_ACK 2'b01
`define MSG_NACK 2'b10
`define MSG_EXTENDED 2'b11

`define TX_INITIAL 0
`define TX_WAIT_ARBITER 1
`define TX_ECC_ENCODE 2
`define TX_TYPE_SELECT 3
`define TX_TRANSFER_NORMAL 4
`define TX_TRANSFER_NORMAL_IN_PROGRESS 5
`define TX_TRANSFER_ACK 6


`define RX_INITIAL 0
`define RX_ACK 0
`define RX_NACK 1

module petra(
	input wire clock,
	input wire reset,

	input wire send_message,
	
	input wire [`MESSAGE_SIZE - 1:0] data_in,
	output reg [`MESSAGE_SIZE - 1:0] data_out,
	
	output reg irq_tx,
	output reg irq_rx,
	
	input wire signal,
	output wire led
	);

	reg [3:0] tx_state;
	reg [3:0] rx_state;
	
	wire rx_ecc_operation;
	assign rx_ecc_operation = `OP_DECODE;
	
	wire tx_ecc_operation;
	assign tx_ecc_operation = `OP_ENCODE;
	
	reg tx_seq; /* current sequence number in TX */
	reg rx_seq; /* current sequence number in RX */
	
	reg arbiter_message; /* trigger arbiter for ACK */
	reg arbiter_ack; /* trigger arbiter for (N)ACK */
	
	reg [`PACKET_SIZE - 1:0] rx_ack; /* current ACK to send */
	reg [`MESSAGE_SIZE - 1:0] current_message; /* current TX message */
	reg [`PACKET_SIZE - 1:0] current_packet; /* current TX packet */
	wire [`FRAME_SIZE - 1:0] current_frame; /* current TX frame */

	/* 00 - normal, 01 - ACK, 10 - NACK, 11 - EXTENDED */
	reg [1:0] current_type; /* current message type */

	wire ack_send; /* arbiter output that enables sending an (N)ACK */
	wire message_send; /* arbiter output that enables sending a normal message */

	reg tx_start_transfer; /* start bit transfer */

	wire tx_ecc_irq; /* ECC process finished */
	wire tx_timeout; /* timeout for receiving RX */
	
	/* IRQ notification from transceiver */
	wire transceiver_irq_rx;
	wire transceiver_irq_tx;
	
	/* 01 - ACK 10 - NACK */
	reg [1:0] rx_notify_ack; /* RX unit notifies that ACK was received */
	
	reg tx_timer_reset; /* reset tx timer, the timer notifies ACK wasn't received */
	
	ecc tx_ecc(.packet(current_packet),
			   .frame(),
			   .codeword(current_frame),
			   .data(),
			   .irq(tx_ecc_irq),
			   .operation(tx_ecc_operation),
			   .correct());
	ecc rx_ecc(.packet(),
			   .frame(),
			   .codeword(),
			   .data(),
			   .irq(),
			   .operation(rx_ecc_operation));
	
	transceiver transceiver(.clock(clock),
							.reset(reset),
							.tx_enable(tx_start_transfer),
							.signal(signal),
							.led(led),
							.data_in(current_frame),
							.data_out(),
							.irq_tx(transceiver_irq_tx),
							.irq_rx(transceiver_irq_rx));
	arbiter arbiter(.clock(clock),
					.reset(reset),
					
					.in_priority(arbiter_ack),
					.in_normal(arbiter_message),
					
					.out_priority(ack_send),
					.out_normal(message_send));
	
	message_timer tx_timer(.clock(clock),
						   .reset(tx_timer_reset),
						   .irq(tx_timeout));
	
	initial
	begin
		tx_state = `TX_INITIAL;
		rx_state = `RX_INITIAL;
	
		current_packet = 0;
		current_type = 0;
		
		arbiter_message = 0;
		arbiter_ack = 0;
		
		tx_seq = 0;
		rx_seq = 0;
	end
	
	always @(posedge clock)
	begin
		if (reset)
		begin
			tx_state <= `TX_INITIAL;
			rx_state <= `RX_INITIAL;
		end else
		begin
			
			case (tx_state)
				`TX_INITIAL: begin
					if (ack_send)
					begin
						/* transition to TX_ECC_ENCODE */
						if (rx_ack == `RX_ACK)
							current_type <= `MSG_ACK;
						else if (rx_ack == `RX_NACK)
							current_type <= `MSG_NACK;
						tx_state <= `TX_ECC_ENCODE;
						current_packet <= {rx_seq, current_type, 8'b0000_0000};
					end else if (send_message)
					begin
						/* transition to TX_WAIT_ARBITER */
						current_message <= data_in;
						current_type <= `MSG_NORMAL;
						tx_state <= `TX_WAIT_ARBITER;
						arbiter_message <= 1;
					end
				end
				
				`TX_WAIT_ARBITER: begin
					if (message_send)
					begin
						tx_state <= `TX_ECC_ENCODE;
						current_packet <= {tx_seq, `MSG_NORMAL, current_message};
					end
					
				end
				`TX_ECC_ENCODE: begin
					if (tx_ecc_irq) begin
						tx_state <= `TX_TYPE_SELECT;
					end				
				end

				`TX_TYPE_SELECT: begin

					if (current_type == `MSG_NORMAL)
						tx_state <= `TX_TRANSFER_NORMAL;
					else if (current_type == `MSG_ACK || current_type == `MSG_NACK)
						tx_state <= `TX_TRANSFER_ACK;
					tx_start_transfer <= 1;
				end
			
			
			
			
				`TX_TRANSFER_NORMAL: begin
					/* set timer */
					tx_timer_reset <= 1;
					tx_state <= `TX_TRANSFER_NORMAL_IN_PROGRESS;
				end
				
				`TX_TRANSFER_NORMAL_IN_PROGRESS: begin
					/* set timer */
					tx_timer_reset <= 0;
					
					if (tx_timeout || rx_notify_ack == `MSG_NACK)
					begin
						tx_start_transfer <= 0;
						tx_state <= `TX_TYPE_SELECT;
					end else if (rx_notify_ack == `MSG_ACK)
					begin
						tx_seq <= !tx_seq;
						arbiter_message <= 0;
						tx_state <= `TX_INITIAL;
					end
				end
				
				`TX_TRANSFER_ACK: begin
					if (transceiver_irq_tx)
					begin
						arbiter_ack <= 0;
						tx_state <= `TX_INITIAL;
					end
				end
			
			endcase
			
			
		end
		
	end
	
endmodule