`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:56:53 12/01/2016 
// Design Name: 
// Module Name:    Main_FSM 
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
module Main_FSM(
input clk,
input rst,
input w_state,
input s_state,
input Ua_state,
input Da_state,
input Pause,
input [1:0] Winner,
output reg start,
output reg [3:0] state
    );

wire Up ;
wire Down ;
wire Back ;
wire Enter ;
wire PAUSE ;
reg Up1  = 0,Up2 = 0;
reg Down1 = 0, Down2 =0;
reg Back1 = 0, Back2 = 0;
reg Enter1 =0, Enter2 = 0;
reg Pause1= 0,Pause2= 0;
reg Mark = 0;
reg [27:0] Wait = 0;
reg flag = 0;

assign Up = Up1 && ~Up2;
assign Down = Down1 && ~Down2;
assign Back = Back1 && ~Back2;
assign Enter = Enter1 && ~Enter2;
assign PAUSE = Pause1 && ~Pause2;

always@(posedge clk or posedge rst)
begin
	if(rst)
		begin
			Up1 <= 0;
			Up2 <=0;
		end
	else
		begin
			Up1 <= Ua_state;
			Up2 <= Up1;
		end
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		begin
			Down1 <= 0;
			Down2 <=0;
		end
	else
		begin
			Down1 <= s_state;
			Down2 <= Down1;
		end
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		begin
			Enter1 <= 0;
			Enter2 <=0;
		end
	else
		begin
			Enter1 <= Da_state;
			Enter2 <= Enter1;
		end
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		begin
			Back1 <= 0;
			Back2 <=0;
		end
	else
		begin
			Back1 <= w_state;
			Back2 <= Back1;
		end
end

always@(posedge clk or posedge rst)
begin
	if(rst)
		begin
			Pause1 <= 0;
			Pause2 <=0;
		end
	else
		begin
			Pause1 <= Pause;
			Pause2 <= Pause1;
		end
end

always@(posedge clk or posedge rst)
begin
	if(rst)
		start <= 0;
	else if(state ==4'd3 || state == 4'd5 || state == 4'd6)
		start <= 1;
	else 
		start <= 0;
end

always@(posedge clk or posedge rst)
begin
	if(rst)
		Wait <= 0;
	else if(Wait == 28'd200_000_000)
	begin
		Wait <= 0;
		flag <= 0;
	end
	else if(Mark ==1)
	begin
		Wait <= 0;
		flag <= 1;
	end
	else if(flag)
		Wait <= Wait +28'd1;
	else
		Wait <= Wait;
end

always@(posedge clk or posedge rst)
begin
	if(rst)
		state <= 3'd0;
	else
		case(state)
			4'd0:
				begin
					if(Up)
						state <= 3'd2;
					else if(Down)
						state <= 3'd1;
					else if(Enter)
						state <= 3'd3;
					else
						state <= state;
				end
			4'd1:
				begin
					if(Up)
						state <= 3'd0;
					else if(Down)
						state <= 3'd2;
					else if (Enter)
						state <= 3'd4;
					else
						state <= state;
					
				end
			4'd2:
				begin
					if(Up)
						state <= 3'd1;
					else if(Down)
						state <= 3'd0;
					else if(Enter)
						state <= 3'd7;
					else
						state <= state;
				end
			4'd3:
				begin
					if(PAUSE)
						state <= 3'd5;
					else
						state <= state;
				end
			4'd4:
				begin
					if(Enter||Back)
						state <= 3'd1;
					else
						state <= state;
				end
			4'd5:
				begin
					if(PAUSE)
						state <= 3'd3;
					else if(Enter || Back)
						state <= 3'd3;
					else if(Up || Down)
						state <= 3'd6;
					else
						state <= state;
				end
			4'd6:
				begin
					if(PAUSE || Back)
						state <= 3'd3;
					else if(Up || Down)
						state <= 3'd5;
					else if(Enter && Winner == 1)
					begin
						state <= 4'd8;
						Mark <= 1;
					end
					else if(Enter && Winner == 2)
					begin
						state <= 4'd9;
						Mark <= 1;
					end
					else if( Enter && Winner ==3)
					begin	
						state <= 4'd10;
						Mark <= 1;
					end
					else 
						state <= state;
				end
			4'd7:
				begin
					state <= state;
				end
			4'd8:
				begin
					if(Mark == 1)
						Mark <= 0;
					else if(flag)
						state <= state;
					else
						state <= 4'b0;
				end
			4'd9:
				begin
					if(Mark == 1)
						Mark <= 0;
					else if(flag)
						state <= state;
					else
						state <= 4'b0;
				end
			4'd10:
				begin
					if(Mark == 1)
						Mark <= 0;
					else if(flag)
						state <= state;
					else
						state <= 4'b0;
				end
			default: state <= 3'd0;
		endcase
end


endmodule
