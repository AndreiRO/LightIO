
module counter (input reset, input clk, output reg[3:0] out);

always @(posedge reset)
	out = 0;

always @(posedge clk) begin
	out <= out + 1;
end
endmodule
