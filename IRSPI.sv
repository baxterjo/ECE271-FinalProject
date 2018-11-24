module IRSPI(
	input logic IRsensor, clk,
	output logic toDec
	);
	
	int counter = 0;

	always_ff @(posedge IRsensor)
	begin
		counter <= 0;
		always_ff @(posedge clk)
		begin
			counter <= counter + 1;