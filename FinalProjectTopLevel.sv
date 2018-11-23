module FinalProjectTopLevel(
	input logic clk, reset,
	input logic [1:0] sel,
	input logic [2:0] a,b,c,
	output logic vsync, hsync,
	output logic[3:0] VGA_R, VGA_G, VGA_B
	);

// internal wires
	logic clk25,enable;
	logic [2:0] command;
	int Cx, Cy, Ox, Oy, Ow, Oh;

// modules 
	multiplexer mux0(a, b, c, sel, command);
	ObjectLocation L0(~reset, clk25, command, Ox, Oy, Oh, Ow);
	clkmodifier M0(clk, ~reset, clk25);
	XYcounter X0(clk25, ~reset, vsync, hsync, enable, Cx, Cy);
	RGBcontrol RGB0(enable, Cx, Cy, Ox, Oy, Oh, Ow, VGA_R, VGA_G, VGA_B);
	
	
endmodule
	