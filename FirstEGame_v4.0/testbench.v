`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:37:52 12/02/2016
// Design Name:   top
// Module Name:   D:/Files built by Me/ISE/FirstEGame_v4.0/testbench.v
// Project Name:  FirstEGame_v4.0
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

	// Inputs
	reg clk;
	reg rst;
	reg [15:0] MemDB;
	reg [4:0] clt;

	// Outputs
	wire [2:0] red;
	wire [2:0] green;
	wire [1:0] blue;
	wire hsync;
	wire vsync;
	wire [25:0] MemAdr;
	wire we_L;
	wire oe_L;
	wire ce_L;
	wire lb_L;
	wire ub_L;
	wire RamADV_L;
	wire RamCLK;
	wire RamCRE;
	wire FlashCS;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.rst(rst), 
		.MemDB(MemDB), 
		.clt(clt), 
		.red(red), 
		.green(green), 
		.blue(blue), 
		.hsync(hsync), 
		.vsync(vsync), 
		.MemAdr(MemAdr), 
		.we_L(we_L), 
		.oe_L(oe_L), 
		.ce_L(ce_L), 
		.lb_L(lb_L), 
		.ub_L(ub_L), 
		.RamADV_L(RamADV_L), 
		.RamCLK(RamCLK), 
		.RamCRE(RamCRE), 
		.FlashCS(FlashCS)
	);
	always
	begin
		clk=0;#1;
		clk=1;#1;
	end
	
	initial begin
		// Initialize Inputs
		rst = 0;
		MemDB = 0;
		clt = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

