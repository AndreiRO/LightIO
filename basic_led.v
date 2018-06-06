`include "definitions.v"


module basic_led(output wire led, output wire irq, output wire cl);

	wire useless_reset;
	assign useless_reset = 0;

	reg start;
	assign cl = osc_clock;
	OSCH OSCH_inst(.STDBY(1'b0),
				   .OSC(osc_clock),
				   .SEDSTDBY());


	reg [`FRAME_SIZE - 1:0] data;

	encoder encoder(osc_clock,
			   useless_reset,
			   start,
			   data, 
			   led,
			   irq);
	
	reg [2:0] counter;
	
	initial
	begin
		data = 16'b0101_0101_0101_0101;
		counter = 0;
		start = 1;
	end

	always @(posedge osc_clock)
	begin
		
		if (irq)
			start <= 0;
		else
			start <= 1;
	end
endmodule