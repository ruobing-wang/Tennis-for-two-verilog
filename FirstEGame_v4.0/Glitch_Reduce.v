`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:16:29 12/01/2016 
// Design Name: 
// Module Name:    Glitch_Reduce 
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
module Glitch_Reduce(
input clk,
input rst,
input [4:0] clt,
output reg w_state = 0,
output reg s_state = 0,
output reg Ua_state = 0,
output reg Da_state = 0,
output reg Pause = 0
    );
	 
reg [19:0] coutw = 20'd0;
reg [19:0] couts = 20'd0;
reg [19:0] coutU = 20'd0;
reg [19:0] coutD = 20'd0;
reg [19:0] coutP = 20'd0;

	 

always@(posedge clk or posedge rst)
begin 
	if(rst)
		coutw <= 0;
	else if(coutw ==20'd1_000_000)
		coutw <= 0;
	else if(clt[0] != w_state)
		coutw <= coutw + 20'd1;
	else
		coutw <= 0;
end 

always@(posedge clk or posedge rst)
begin 
	if(rst)
		w_state <= 0;
	else if( coutw == 20'd1_000_000)
		begin
		w_state <= clt[0];
		end
end

always@(posedge clk or posedge rst)
begin 
	if(rst)
		couts <= 0;
	else if(couts ==20'd1_000_000)
		couts <= 0;
	else if(clt[1] != s_state)
		couts <= couts + 20'd1;
	else
		couts <= 0;
end 

always@(posedge clk or posedge rst)
begin 
	if(rst)
		s_state <= 0;
	else if( couts == 20'd1_000_000)
		begin
		s_state <= clt[1];
		end
end

always@(posedge clk or posedge rst)
begin 
	if(rst)
		coutU <= 0;
	else if(coutU ==20'd1_000_000)
		coutU <= 0;
	else if(clt[2] != Ua_state)
		coutU <= coutU + 20'd1;
	else
		coutU <= 0;
end 

always@(posedge clk or posedge rst)
begin 
	if(rst)
		Ua_state <= 0;
	else if( coutU == 20'd1_000_000)
		begin
		Ua_state <= clt[2];
		end
end

always@(posedge clk or posedge rst)
begin 
	if(rst)
		coutD <= 0;
	else if(coutD ==20'd1_000_000)
		coutD <= 0;
	else if(clt[3] != Da_state)
		coutD <= coutD + 20'd1;
	else
		coutD <= 0;
end 

always@(posedge clk or posedge rst)
begin 
	if(rst)
		Da_state <= 0;
	else if( coutD == 20'd1_000_000)
		begin
		Da_state <= clt[3];
		end
end

always@(posedge clk or posedge rst)
begin 
	if(rst)
		coutP <= 0;
	else if(coutP ==20'd1_000_000)
		coutP <= 0;
	else if(clt[4] != Pause)
		coutP <= coutP + 20'd1;
	else
		coutP <= 0;
end 

always@(posedge clk or posedge rst)
begin 
	if(rst)
		Pause <= 0;
	else if( coutP == 20'd1_000_000)
		begin
		Pause <= clt[4];
		end
end


endmodule

