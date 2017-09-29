`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:08:22 11/25/2016 
// Design Name: 
// Module Name:    VGA_Display 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGA_Display(
input rst,
input clk_40ns,
output hsync,
output vsync,
output reg display,
output reg [9:0] hcount = 0 ,
output reg [9:0] vcount = 0
    );
	 


assign hsync = (hcount < 96)?1'b0:1'b1;
always@(posedge clk_40ns or posedge rst)
begin
	if(rst)
		hcount <= 0;
	else if(hcount == 799)
		hcount <= 0;
	else
		hcount <= hcount + 10'b1;
end

assign vsync = (vcount < 2)? 1'b0 : 1'b1;
always@(posedge clk_40ns or posedge rst)
begin
	if(rst)
		vcount <= 0;
	else if(hcount == 799)
		if(vcount == 520)
			vcount <= 0;
		else
			vcount <= vcount + 10'b1;
	else
		vcount <= vcount;
end

always@(posedge clk_40ns or posedge rst)
begin
	if(rst)
		display <= 0;
	else if(hcount >= 144 && hcount <= 783 && vcount >= 31 && vcount <= 510)
		display <= 1;
	else
		display <= 0;
end



endmodule
