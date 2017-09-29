`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:53:42 11/28/2016 
// Design Name: 
// Module Name:    rom_ctl 
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
module rom_ctl(
input clk,
input [8:0] addr,
input [10:0] addr_bar_a,
input [10:0] addr_bar_b,
output reg [15:0] data_out,
output reg [15:0] data_out_bar_a,
output reg [15:0] data_out_bar_b
    );

reg HorL = 0;
reg [8:0] addra;
reg [10:0] addra_bar_a;
reg [10:0] addra_bar_b;
wire [7:0] douta;
wire [7:0] douta_bar_a;
wire [7:0] douta_bar_b;


always@(posedge clk)
begin
	HorL <= ~HorL;
end

always@(posedge clk)
begin
	if(HorL)
		begin
			addra <= addr + 9'b1;
			data_out[15:8] <= douta;
		end
	else 
		begin
			addra <= addr;
			data_out[7:0] <= douta;
		end
end

always@(posedge clk)
begin
	if(HorL)
		begin
			addra_bar_a <= addr_bar_a + 9'b1;
			data_out_bar_a[15:8] <= douta_bar_a;
		end
	else 
		begin
			addra_bar_a <= addr_bar_a;
			data_out_bar_a[7:0] <= douta_bar_a;
		end
end

always@(posedge clk)
begin
	if(HorL)
		begin
			addra_bar_b <= addr_bar_b + 9'b1;
			data_out_bar_b[15:8] <= douta_bar_b;
		end
	else 
		begin
			addra_bar_b <= addr_bar_b;
			data_out_bar_b[7:0] <= douta_bar_b;
		end
end


pic_ball u_pic_ball (
  .clka(clk), // input clka
  .addra(addra), // input [8 : 0] addra
  .douta(douta) // output [7 : 0] douta
);

pic_bar_a u_pic_bar_a (
  .clka(clk), // input clka
  .addra(addra_bar_a), // input [10 : 0] addra
  .douta(douta_bar_a) // output [7 : 0] douta
);

pic_bar_b u_pic_bar_b (
  .clka(clk), // input clka
  .addra(addra_bar_b), // input [10 : 0] addra
  .douta(douta_bar_b) // output [7 : 0] douta
);

endmodule
