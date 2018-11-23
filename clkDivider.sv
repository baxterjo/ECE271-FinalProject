module clkDivider #(parameter N = 2)
	(input logic clk, reset,
		output logic modClk);

	int counter = 0;

	always_ff @(posedge clk)
	begin
		if(reset)
		begin
			counter <= 0;
			modClk <= 0;
		end
		else
		begin
			counter <= counter + 1;
			if (counter == N / 2)
			begin
				modClk <= ~modClk;
				counter <= 0;
			end
		end
	end
endmodule // clkDivider
