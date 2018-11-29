module ObjectLocation(
	input logic reset, clk,
	input logic [2:0] command,
	output int Ox, Oy, Oh, Ow
	);

	always_ff @(posedge clk)
	begin
		if(reset)
		begin
			Ox <= 320;
			Oy <= 240;
			Oh <= 24;
			Ow <= 32;
		end
		else
		begin
			case(command)
				0:	begin		  //No movement
						Ox <= Ox; 
						Oy <= Oy;
					end
				1:	Ox <= Ox - 5; // Left
				2:	Ox <= Ox + 5; // Right
				3:	Oy <= Oy - 5; // Up
				4:	Oy <= Oy + 5; // Down
				default: begin	  //No movement
							Ox <= Ox; 
							Oy <= Oy;
						end
			endcase // command
		end
	end
endmodule // ObjectLocation
