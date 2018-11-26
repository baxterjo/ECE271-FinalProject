module FinalProjectTopLevel(
	input logic clk, reset, ps2In,
	input logic [1:0] sel,
	input logic [2:0] a,b,
	output logic vsync, hsync,
	output logic[3:0] VGA_R, VGA_G, VGA_B
	);

// internal wires
	logic clk25M, clk500, enable;
	logic [2:0] command, ps2ToMux;
	int Cx, Cy, Ox, Oy, Ow, Oh;

// modules 
	PS2_SPID p0(clk, ps2In, ps2ToMux);
	multiplexer mux0(a, b, ps2ToMux, sel, command);
	ObjectLocation L0(~reset, clk500, command, Ox, Oy, Oh, Ow);
	clkDivider #(100000) clk1(clk, ~reset, clk500);
	clkDivider #(2) clk0(clk, ~reset, clk25M);
	XYcounter X0(clk25M, ~reset, vsync, hsync, enable, Cx, Cy);
	RGBcontrol RGB0(enable, Cx, Cy, Ox, Oy, Oh, Ow, VGA_R, VGA_G, VGA_B);
	
	
endmodule
	