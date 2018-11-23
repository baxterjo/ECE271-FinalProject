module FinalProjectTopLevel(
	input logic clk, reset,
	input logic [2:0] command,
	output logic vsync, hsync,
	output logic[3:0] VGA_R, VGA_G, VGA_B
	);
	logic clk25,enable;
	int Cx, Cy, Ox, Oy, Ow, Oh;
	
	ObjectLocation L0(~reset, clk25, command, Ox, Oy, Oh, Ow);
	clkmodifier M0(clk, ~reset, clk25);
	XYcounter X0(clk25, ~reset, vsync, hsync, enable, Cx, Cy);
	RGBcontrol RGB0(enable, Cx, Cy, Ox, Oy, Oh, Ow, VGA_R, VGA_G, VGA_B);
	
	
endmodule
	