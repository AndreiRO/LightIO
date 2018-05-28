/* 
	Clock divider module
	
	- divides a clock signal by a given parameter factor
	
	Parameters
	
	- clock: the clock signal to divide
	- clock_d: the divided clock signal
	- factor: the factor of clock division
	*/
module clock_divider(input wire clock,
					 output reg clock_d);
	parameter factor = 1;
	
	reg [factor - 1:0] counter;
	
	initial
	begin
		clock_d	= 0;
		counter	= 0;
	end
	
	always @(clock)
	begin
		if (counter == 0)
		begin
			clock_d <= !clock_d;
			counter <= counter + 1;
		end else
		begin
			counter <= counter + 1;
		end

	end
	
endmodule