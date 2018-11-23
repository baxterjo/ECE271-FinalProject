module clkmodifier(
	input logic clk, reset,
	output logic clk25
	);
	//Cut the clock in half
	always_ff @(posedge clk)
	begin
		if (reset)
		begin
			clk25 <= 0;
		end
		clk25 <= ~clk25;
	end
endmodule
