module IRSPI(
	input logic IRsensor, clk, reset,  // This SPI will use the RC5 code. 
	output logic toDec
	);
	
	int timer = 0;
	int counter = 0;
	logic read;

	always_ff @(posedge Irsensor)
	begin
		if (reset)
		begin
			counter = 0;
			timer = 0;
			read = 0;
		end
		else
		begin
			counter <= counter + 1;
			if (counter < 890)
			begin
				read <= ~read;
			end
			always_ff @(posedge clk)  // Measure the time btween each pulse.
			begin
				timer <= timer + 1;
				if(timer > 1300)
				begin
					counter <= 0;
				end
			end
