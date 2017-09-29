`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:13:54 11/29/2016 
// Design Name: 
// Module Name:    bar_ctl 
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
module bar_ctl(
input clk,
input w_state,
input s_state,
input Ua_state,
input Da_state,
input ESC_state,
input start,
input [3:0] state,
output reg [9:0] bar_a_y = 10'd205,
output reg [9:0] bar_b_y = 10'd205,
output reg [9:0] bar_a_y_speed = 0,
output reg [9:0] bar_b_y_speed = 0
    );

reg clk_50Hz = 0;
reg [20:0] counter = 0;
parameter BAR_SPEED = 10'd3;
parameter BAR_LENGTH = 10'd70;
parameter BAR_WIDTH = 10'd18;


always@(posedge clk or negedge start)
begin
	if(!start)
		counter <= 21'd0;
	else if(state == 4'd5 || state ==4'd6)
		counter <= counter;
	else if(counter == 21'd1_000_000)
		begin
		clk_50Hz <= 1;
		counter <= counter + 21'd1;
		end
	else if(counter == 21'd2_000_000)
		begin
		counter <= 21'd0;
		clk_50Hz <= 0;
		end
	else
		counter <= counter + 21'd1;
end

always@(*)
begin
	if(ESC_state)
		begin
			bar_a_y_speed <= 10'd0;
			bar_b_y_speed <= 10'd0;
		end
	else
		begin
			bar_a_y_speed <= s_state ? (w_state ? 10'd0 :  BAR_SPEED ): (w_state ? -BAR_SPEED : 10'd0 );
			bar_b_y_speed <= Da_state ? (Ua_state ? 10'd0 :  BAR_SPEED ): (Ua_state ? -BAR_SPEED : 10'd0 );
		end
end


always@(posedge clk_50Hz or negedge start)
begin
	if(!start)
		begin
			bar_a_y <= 10'd205;
		end
	else if(bar_a_y + bar_a_y_speed <= 10'd5)
		begin
			bar_a_y <= bar_a_y;
		end
	else if(bar_a_y + bar_a_y_speed >= 10'd475 - BAR_LENGTH)
		begin
			bar_a_y <= bar_a_y;
		end
	else
		bar_a_y <= bar_a_y + bar_a_y_speed;
end

/*
always@(posedge clk_50Hz or negedge start)
begin
	if(!start)
		begin
			bar_b_x <= 10'd630 - BAR_WIDTH;
		end
	else if(bar_b_x + bar_b_x_speed >= 10'd635 - BAR_WIDTH)
		begin
			bar_b_x <= bar_b_x;
		end
	else if(bar_b_x + bar_b_x_speed <= 10'd320)
		begin
			bar_b_x <= bar_b_x;
		end
	else
		bar_b_x <= bar_b_x + bar_b_x_speed;
end
*/
always@(posedge clk_50Hz or negedge start)
begin
	if(!start)
		begin
			bar_b_y <= 10'd205;
		end
	else if(bar_b_y + bar_b_y_speed <= 10'd5)
		begin
			bar_b_y <= bar_b_y;
		end
	else if(bar_b_y + bar_b_y_speed >= 10'd475 - BAR_LENGTH)
		begin
			bar_b_y <= bar_b_y;
		end
	else
		bar_b_y <= bar_b_y + bar_b_y_speed;
end

endmodule
