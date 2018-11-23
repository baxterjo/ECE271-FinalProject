module ObjectLocation(
	input logic reset, clk,
	input logic [2:0] command,
	output int Ox, Oy, Oh, Ow
	);
	
	always_ff @(posedge clk)
	begin
		if(reset)
		begin
			Oh <= 24;
			Ow <= 32;
			Ox <= (640 / 2) - (Ow / 2);
			Oy <= (480 / 2) - (Oh / 2);
		end
		case(command)
			0:	begin
					Ox <= Ox; 
					Oy <= Oy;
				end
			1:	Ox <= Ox - 5;
			2:	Ox <= Ox + 5;
			3:	Oy <= Oy - 5;
			4:	Oy <= Oy + 5;
			default: begin
						Ox <= Ox; 
						Oy <= Oy;
					end
		endcase // command
	end
endmodule // ObjectLocation
