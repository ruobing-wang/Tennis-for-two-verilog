`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:44:50 11/25/2016 
// Design Name: 
// Module Name:    clk_div 
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
module clk_div(
input clk,
output clk_40ns,
output clk_80ns
    );

reg [2:0] counter = 0;
assign clk_40ns = counter[1];
assign clk_80ns = counter[2]; 
always@(posedge clk)
begin
	counter <= counter + 3'b1;
end

endmodule
