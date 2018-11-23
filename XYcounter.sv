module XYcounter(
	input logic clk, reset,
	output logic vsync, hsync, enable,
	output int x, y
	);
//Set up a bunch of timing spec variables.
	const int HS_STA = 16;
	const int HS_END = 16 + 96;
	const int HA_STA = 16 + 96 + 48;
	const int VS_STA = 480 + 11;
	const int VS_END = 480 + 11 + 2;
	const int VA_END = 480;
	const int LINE = 800;
	const int SCREEN = 525;


//Set up horizontal and vertical counters.
	int hcount = 0;
	int vcount = 0;

//Count that shit out
	always_ff @(posedge clk)
	begin
		if(reset)
		begin
			enable <= 0;
			hcount <= 0;
			vcount <= 0;
			x <= 0;
			y <= 0;
		end
		hsync <= (hcount < HS_STA || hcount > HS_END);
		vsync <= (vcount < VS_STA || vcount > VS_END);
		if (hcount == LINE)
		begin
			hcount <= 0;
			vcount <= vcount + 1;
		end
		else
		begin
			hcount <= hcount + 1;
		end
		if(vcount == SCREEN)
		begin
			vcount <= 0;
		end
		if(hcount > HA_STA)
		begin
			x <= (hcount - HA_STA);
		end
		if(vcount < VA_END)
		begin
			y <= vcount;
		end
		if(hcount > HA_STA && vcount < VA_END)
		begin
			enable <= 1;
		end
		else
		begin
			enable <= 0;
		end

	end

endmodule
