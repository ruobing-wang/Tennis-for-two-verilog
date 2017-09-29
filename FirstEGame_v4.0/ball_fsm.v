`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:49:00 11/28/2016 
// Design Name: 
// Module Name:    ball_fsm 
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
module ball_fsm(
input	clk,
input start,
input [9:0] bar_a_y,
input [9:0] bar_b_y,
input [3:0] state,
output reg [9:0] ball_x = 10'd132,
output reg [9:0] ball_y = 10'd280,
output reg [1:0] win = 0
    );

reg [9:0] x_speed = -3;
reg [9:0] y_speed = 3;
reg clk_50Hz = 0;
reg [20:0] counter = 0;
parameter BARRIER = 10'd5;
parameter RADIUS = 10'd10;
parameter BAR_WIDTH = 10'd17;
parameter BAR_LENGTH = 10'd69;
parameter bar_a_x = 10'd5;
parameter bar_b_x = 10'd617;
reg [5:0] random = 0;
reg [5:0] Wait = 0;
reg Mark = 0;

always@(posedge clk)
begin
	if(random == 6'b111111)
		random <= 6'b0;
	else 
		random <= random +6'b1;
end


always@(posedge clk or negedge start)
begin
	if(!start)
		counter <= 21'd0;
	else if(state == 3'd5 || state ==3'd6)
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

always@(posedge clk_50Hz or negedge start)
begin
	if(!start)
		begin
			ball_x <= 320;
			case({random[5],random[3],random[1]})
				0: x_speed <= -4;
				1: x_speed <= -4;
				2: x_speed <= -3;
				3: x_speed <= -3;
				4: x_speed <= 3;
				5: x_speed <= 3;
				6: x_speed <= 4;
				7: x_speed <= 4;
				default: x_speed <= -3; 
			endcase
			win<= 3'd0;
		end
	else if(x_speed == 0)
		x_speed <= -3;
	else if(win == 3'd1 || win == 3'd2)
		begin
			ball_x <= 320;
			case({random[5],random[3],random[1]})
				0: x_speed <= -4;
				1: x_speed <= -4;
				2: x_speed <= -3;
				3: x_speed <= -3;
				4: x_speed <= 3;
				5: x_speed <= 3;
				6: x_speed <= 4;
				7: x_speed <= 4;
				default: x_speed <= -3; 
			endcase
			win <= 3'd0;
		end
	else if(ball_x - RADIUS + x_speed <= bar_a_x + BAR_WIDTH && ball_y >= bar_a_y && ball_y <= bar_a_y + BAR_LENGTH)
		begin
			ball_x <= bar_a_x + BAR_WIDTH + RADIUS;
			x_speed <= -x_speed;
			win <= 3'd0;
		end
	else if(ball_x + RADIUS + x_speed >= bar_b_x  && ball_y >= bar_b_y && ball_y <= bar_b_y + BAR_LENGTH)
		begin
			ball_x <= bar_b_x - RADIUS;
			x_speed <= -x_speed;
			win <= 3'd0;
		end
	else if(ball_x + x_speed <= BARRIER + RADIUS)
	begin
		ball_x <= BARRIER + RADIUS;
		x_speed <= -x_speed;
		win <= 2'd2;
	end
	else if(ball_x + x_speed >= 10'd640-BARRIER-RADIUS)
	begin
		ball_x <= 640 - BARRIER -RADIUS;
		x_speed <= -x_speed;
		win <= 3'd1;
	end
	else if(Mark == 1)
		ball_x <= ball_x;
	else
	begin
		ball_x <= ball_x + x_speed;
		win <= 3'd0;
	end
end


always@(posedge clk_50Hz or negedge start)
begin
	if(!start)
		Wait <= 0;
	else if(win == 3'd1 || win ==3'd2)
	begin
		Wait <= 0;
		Mark <=1;
	end
	else if(Wait == 6'd50)
	begin
		Wait <= 0;
		Mark <= 0;
	end
	else if(Mark) 
		Wait <= Wait + 6'd1;
	else 
		Wait <= Wait;
end


always@(posedge clk_50Hz or negedge start)
begin
	if(!start)
		begin
			ball_y <= 240;
			case({random[4],random[2],random[0]})
				0: y_speed <= 4;
				1: y_speed <= 4;
				2: y_speed <= 3;
				3: y_speed <= 2;
				4: y_speed <= 2;
				5: y_speed <= 3;
				6: y_speed <= 4;
				7: y_speed <= 4;
				default: y_speed <= 3; 
			endcase
		end
	else if(win == 3'd1 || win == 3'd2)
		begin
			ball_y <= 240;
			case({random[4],random[2],random[0]})
				0: y_speed <= 4;
				1: y_speed <= 4;
				2: y_speed <= 3;
				3: y_speed <= 2;
				4: y_speed <= 2;
				5: y_speed <= 3;
				6: y_speed <= 4;
				7: y_speed <= 4;
				default: y_speed <= 3; 
			endcase
		end
	else if(ball_y + RADIUS <= bar_a_y &&ball_y + RADIUS + y_speed >= bar_a_y && ball_x >= bar_a_x && ball_x <= bar_a_x + BAR_WIDTH)
		begin
			ball_y <= bar_a_y - RADIUS;
			y_speed <= -y_speed;
		end
	else if(ball_y + RADIUS <= bar_b_y &&ball_y + RADIUS + y_speed >= bar_b_y && ball_x >= bar_b_x && ball_x <= bar_b_x + BAR_WIDTH)
		begin
			ball_y <= bar_b_y - RADIUS;
			y_speed <= -y_speed;
		end
	else if((ball_y-RADIUS >= bar_a_y + BAR_LENGTH)&& ball_y - RADIUS + y_speed <= bar_a_y + BAR_LENGTH && ball_x >= bar_a_x && ball_x <= bar_a_x + BAR_WIDTH)
		begin
			ball_y <= bar_a_y + RADIUS + BAR_LENGTH;
			y_speed <= -y_speed;
		end
	else if(ball_y -RADIUS >= bar_a_y + BAR_LENGTH && ball_y - RADIUS + y_speed <= bar_b_y + BAR_LENGTH && ball_x >= bar_b_x && ball_x <= bar_b_x + BAR_WIDTH)
		begin
			ball_y <= bar_b_y + RADIUS + BAR_LENGTH;
			y_speed <= -y_speed;
		end
	else if(ball_y + y_speed <= BARRIER + RADIUS)
	begin
		ball_y <= BARRIER + RADIUS;
		y_speed <= -y_speed;
	end
	else if(ball_y + y_speed >= 10'd480 - BARRIER - RADIUS)
	begin
		ball_y <= 10'd480 - BARRIER - RADIUS;
		y_speed <= -y_speed;
	end
	else if(Mark == 1)
		ball_y <= ball_y;
	else
	begin
		ball_y <= ball_y +y_speed;
	end
end

/*
always@(posedge clk_50Hz or negedge start)
begin
	if(!start)
	begin
		ball_x <= 330;
		ball_y <= 240;
	end
	else if(ball_x + x_speed - RADIUS <= bar_a_x + bar_a_x_speed + BAR_WIDTH && ball_x - RADIUS > bar_a_x +BAR_WIDTH&& ball_y >= bar_a_y && ball_y <= bar_a_y + BAR_LENGTH)
		begin
			ball_x <= bar_a_x + BAR_WIDTH + RADIUS;
			if(bar_a_x_speed > 10'd0)
				begin
				if(x_speed < 0)
					begin
						x_speed <= -(x_speed-10'd2);
					end
				else
					begin
						x_speed <= -(x_speed -10'd1);
					end
				end
			else if(bar_a_x_speed == 10'd0)
				begin
					x_speed <= -x_speed;
				end
			else
				begin
					if(x_speed < 10'd0)
						begin
							x_speed <= -(x_speed+10'd1);
						end
					else
						begin
							x_speed <= -(x_speed -10'd1);
						end
				end
			if(bar_a_y_speed > 0)
				begin
					y_speed <= y_speed +10'd1;
				end
			else if(bar_a_y_speed == 0)
				begin
					y_speed <= y_speed;
				end
			else
				begin
					y_speed <= y_speed -10'd1;
				end
		end // Collision at right part of ball A
	else if(ball_y + y_speed - RADIUS <= bar_a_y + bar_a_y_speed + BAR_LENGTH && ball_x - RADIUS > bar_a_x +BAR_LENGTH&& ball_x >= bar_a_x && ball_x <= bar_a_x + BAR_WIDTH)
		begin
			ball_y <= bar_a_y + BAR_LENGTH + RADIUS;
			if(bar_a_y_speed > 0)
				begin
				if(y_speed < 0)
					begin
						y_speed <= -(y_speed-10'd2);
					end
				else
					begin
						y_speed <= -(y_speed -10'd1);
					end
				end
			else if(bar_a_y_speed == 10'd0)
				begin
					y_speed <= -y_speed;
				end
			else
				begin
					if(y_speed < 0)
						begin
							y_speed <= -(y_speed+10'd1);
						end
					else
						begin
							y_speed <= -(y_speed -10'd1);
						end
				end
			if(bar_a_x_speed > 10'd0)
				begin
					x_speed <= x_speed +10'd1;
				end
			else if(bar_a_x_speed == 10'd0)
				begin
					x_speed <= x_speed;
				end
			else
				begin
					x_speed <= x_speed -10'd1;
				end
		end // Collision at down part of ball A
	else if(ball_x + x_speed + RADIUS >= bar_a_x + bar_a_x_speed && ball_x + RADIUS <= bar_a_x && ball_y >= bar_a_y && ball_y <= bar_a_y + BAR_LENGTH)
		begin
			ball_x <= bar_a_x - RADIUS;
			if(bar_a_x_speed > 10'd0)
				begin
				if(x_speed >= 10'd0)
					begin
						x_speed <= -(x_speed-10'd1);
					end
				else
					begin
						x_speed <= -(x_speed +10'd1);
					end
				end
			else if(bar_a_x_speed == 10'd0)
				begin
					x_speed <= -x_speed;
				end
			else
				begin
					if(x_speed >= 10'd0)
						begin
							x_speed <= -(x_speed+10'd2);
						end
					else
						begin
							x_speed <= -(x_speed -10'd1);
						end
				end
			if(bar_a_y_speed > 10'd0)
				begin
					y_speed <= y_speed +10'd1;
				end
			else if(bar_a_y_speed == 10'd0)
				begin
					y_speed <= y_speed;
				end
			else
				begin
					y_speed <= y_speed -10'd1;
				end
		end //Colision at left part of ball A
	else if(ball_y + y_speed + RADIUS >= bar_a_y + bar_a_y_speed && ball_y + RADIUS <= bar_a_y && ball_x >= bar_a_x && ball_x <= bar_a_x + BAR_WIDTH)
		begin
			ball_y <= bar_a_y - RADIUS;
			if(bar_a_y_speed > 10'd0)
				begin
				if(y_speed >= 10'd0)
					begin
						y_speed <= -(y_speed-10'd1);
					end
				else
					begin
						y_speed <= -(y_speed +10'd1);
					end
				end
			else if(bar_a_y_speed == 10'd0)
				begin
					y_speed <= -y_speed;
				end
			else
				begin
					if(y_speed >= 10'd0)
						begin
							y_speed <= -(y_speed+10'd2);
						end
					else
						begin
							y_speed <= -(y_speed -10'd1);
						end
				end
			if(bar_a_x_speed > 10'd0)
				begin
					x_speed <= x_speed +10'd1;
				end
			else if(bar_a_x_speed == 10'd0)
				begin
					x_speed <= x_speed;
				end
			else
				begin
					x_speed <= x_speed -10'd1;
				end
		end //Colision at Up part of ball A
	else if(ball_x + x_speed - RADIUS <= bar_b_x + bar_b_x_speed + BAR_WIDTH && ball_x - RADIUS > bar_b_x +BAR_WIDTH&& ball_y >= bar_b_y && ball_y <= bar_b_y + BAR_LENGTH)
		begin
			ball_x <= bar_b_x + BAR_WIDTH + RADIUS;
			if(bar_b_x_speed > 10'd0)
				begin
				if(x_speed < 10'd0)
					begin
						x_speed <= -(x_speed-10'd2);
					end
				else
					begin
						x_speed <= -(x_speed -10'd1);
					end
				end
			else if(bar_b_x_speed == 10'd0)
				begin
					x_speed <= -x_speed;
				end
			else
				begin
					if(x_speed < 10'd0)
						begin
							x_speed <= -(x_speed+10'd1);
						end
					else
						begin
							x_speed <= -(x_speed -10'd1);
						end
				end
			if(bar_b_y_speed > 10'd0)
				begin
					y_speed <= y_speed +10'd1;
				end
			else if(bar_b_y_speed == 10'd0)
				begin
					y_speed <= y_speed;
				end
			else
				begin
					y_speed <= y_speed -10'd1;
				end
		end // Collision at right part of ball B
	else if(ball_y + y_speed - RADIUS <= bar_b_y + bar_b_y_speed + BAR_LENGTH && ball_x - RADIUS > bar_b_x +BAR_LENGTH&& ball_x >= bar_b_x && ball_x <= bar_b_x + BAR_WIDTH)
		begin
			ball_y <= bar_b_y + BAR_LENGTH + RADIUS;
			if(bar_b_y_speed > 10'd0)
				begin
				if(y_speed < 10'd0)
					begin
						y_speed <= -(y_speed-10'd2);
					end
				else
					begin
						y_speed <= -(y_speed -10'd1);
					end
				end
			else if(bar_b_y_speed == 10'd0)
				begin
					y_speed <= -y_speed;
				end
			else
				begin
					if(y_speed < 10'd0)
						begin
							y_speed <= -(y_speed+10'd1);
						end
					else
						begin
							y_speed <= -(y_speed -10'd1);
						end
				end
			if(bar_b_x_speed > 10'd0)
				begin
					x_speed <= x_speed +10'd1;
				end
			else if(bar_b_x_speed == 10'd0)
				begin
					x_speed <= x_speed;
				end
			else
				begin
					x_speed <= x_speed -10'd1;
				end
		end // Collision at down part of ball B
	else if(ball_x + x_speed + RADIUS >= bar_b_x + bar_b_x_speed && ball_x + RADIUS <= bar_b_x && ball_y >= bar_b_y && ball_y <= bar_b_y + BAR_LENGTH)
		begin
			ball_x <= bar_b_x - RADIUS;
			if(bar_b_x_speed > 10'd0)
				begin
				if(x_speed >= 10'd0)
					begin
						x_speed <= -(x_speed-10'd1);
					end
				else
					begin
						x_speed <= -(x_speed +10'd1);
					end
				end
			else if(bar_b_x_speed == 10'd0)
				begin
					x_speed <= -x_speed;
				end
			else
				begin
					if(x_speed >= 10'd0)
						begin
							x_speed <= -(x_speed+10'd2);
						end
					else
						begin
							x_speed <= -(x_speed -10'd1);
						end
				end
			if(bar_b_y_speed > 10'd0)
				begin
					y_speed <= y_speed +10'd1;
				end
			else if(bar_b_y_speed == 10'd0)
				begin
					y_speed <= y_speed;
				end
			else
				begin
					y_speed <= y_speed -10'd1;
				end
		end //Colision at left part of ball B
	else if(ball_y + y_speed + RADIUS >= bar_b_y + bar_b_y_speed && ball_y + RADIUS <= bar_b_y && ball_x >= bar_b_x && ball_x <= bar_b_x + BAR_WIDTH)
		begin
			ball_y <= bar_b_y - RADIUS;
			if(bar_b_y_speed > 10'd0)
				begin
				if(y_speed >= 10'd0)
					begin
						y_speed <= -(y_speed-10'd1);
					end
				else
					begin
						y_speed <= -(y_speed +10'd1);
					end
				end
			else if(bar_b_y_speed == 10'd0)
				begin
					y_speed <= -y_speed;
				end
			else
				begin
					if(y_speed >= 10'd0)
						begin
							y_speed <= -(y_speed+10'd2);
						end
					else
						begin
							y_speed <= -(y_speed -10'd1);
						end
				end
			if(bar_b_x_speed > 10'd0)
				begin
					x_speed <= x_speed +10'd1;
				end
			else if(bar_b_x_speed == 10'd0)
				begin
					x_speed <= x_speed;
				end
			else
				begin
					x_speed <= x_speed -10'd1;
				end
		end //Colision at Up part of ball B
	else if (((ball_x + x_speed - BAR_WIDTH - bar_a_x)*(ball_x + x_speed - BAR_WIDTH - bar_a_x) + (ball_y + y_speed - bar_a_y )*
					(ball_y +y_speed - bar_a_y) <= 400 && (ball_x  - BAR_WIDTH - bar_a_x)*(ball_x - BAR_WIDTH - bar_a_x) + (ball_y - bar_a_y )*
					(ball_y - bar_a_y) > 400  ) || ((ball_x + x_speed - BAR_WIDTH - bar_b_x)*(ball_x + x_speed - BAR_WIDTH - bar_b_x) + (ball_y 
					 + y_speed - bar_b_y )*(ball_y +y_speed - bar_b_y) <= 400 && (ball_x  - BAR_WIDTH - bar_b_x)*(ball_x - BAR_WIDTH - bar_b_x) 
					 + (ball_y - bar_b_y )*(ball_y - bar_b_y) > 400  ))
			begin
				x_speed <= ((x_speed >= 0)? x_speed : -x_speed + (y_speed >= 0)? y_speed : -y_speed) / 10'd2;
				y_speed <= -((x_speed >= 0)? x_speed : -x_speed + (y_speed >= 0)? y_speed : -y_speed) / 10'd2;
			end
	else if (((ball_x + x_speed - bar_a_x)*(ball_x + x_speed - bar_a_x) + (ball_y + y_speed - bar_a_y )*
					(ball_y +y_speed - bar_a_y) <= 400 && (ball_x   - bar_a_x)*(ball_x  - bar_a_x) + (ball_y - bar_a_y )*
					(ball_y - bar_a_y) > 10'd400  ) || ((ball_x + x_speed  - bar_b_x)*(ball_x + x_speed - bar_b_x) + (ball_y 
					 + y_speed - bar_b_y )*(ball_y +y_speed - bar_b_y) <= 400 && (ball_x  - bar_b_x)*(ball_x - bar_b_x) 
					 + (ball_y - bar_b_y )*(ball_y - bar_b_y) > 400  ))
			begin
				x_speed <= -((x_speed >= 0)? x_speed : -x_speed + (y_speed >= 0)? y_speed : -y_speed) / 10'd2;
				y_speed <= -((x_speed >= 0)? x_speed : -x_speed + (y_speed >= 0)? y_speed : -y_speed) / 10'd2;
			end
	else if (((ball_x + x_speed  - bar_a_x)*(ball_x + x_speed  - bar_a_x) + (ball_y + y_speed - bar_a_y -BAR_LENGTH)*
					(ball_y +y_speed - bar_a_y-BAR_LENGTH) <= 400 && (ball_x  - bar_a_x)*(ball_x - bar_a_x) + (ball_y - bar_a_y - BAR_LENGTH )*
					(ball_y - bar_a_y - BAR_LENGTH) > 400  ) || ((ball_x + x_speed  - bar_b_x)*(ball_x + x_speed - bar_b_x) + (ball_y 
					 + y_speed - bar_b_y -BAR_LENGTH)*(ball_y +y_speed - bar_b_y-BAR_LENGTH) <= 400 && (ball_x - bar_b_x)*(ball_x  - bar_b_x) 
					 + (ball_y - bar_b_y )*(ball_y - bar_b_y) > 400  ))
			begin
				x_speed <= -((x_speed >= 0)? x_speed : -x_speed + (y_speed >= 0)? y_speed : -y_speed) / 10'd2;
				y_speed <= ((x_speed >= 0)? x_speed : -x_speed + (y_speed >= 0)? y_speed : -y_speed) / 10'd2;
			end
	else if (((ball_x + x_speed - BAR_WIDTH - bar_a_x)*(ball_x + x_speed - BAR_WIDTH - bar_a_x) + (ball_y + y_speed - bar_a_y - BAR_LENGTH )*
					(ball_y +y_speed - bar_a_y- BAR_LENGTH) <= 400 && (ball_x  - BAR_WIDTH - bar_a_x)*(ball_x - BAR_WIDTH - bar_a_x) + (ball_y - bar_a_y - BAR_LENGTH)*
					(ball_y - bar_a_y- BAR_LENGTH) > 400  ) || ((ball_x + x_speed - BAR_WIDTH - bar_b_x)*(ball_x + x_speed - BAR_WIDTH - bar_b_x) + (ball_y 
					 + y_speed - bar_b_y - BAR_LENGTH )*(ball_y +y_speed - bar_b_y-BAR_LENGTH) <= 400 && (ball_x  - BAR_WIDTH - bar_b_x)*(ball_x - BAR_WIDTH - bar_b_x) 
					 + (ball_y - bar_b_y -BAR_LENGTH)*(ball_y - bar_b_y-BAR_LENGTH) > 400  ))
			begin
				ball_y <= ball_y + (y_speed >= 0) ? 10'd1: -10'd1;
				x_speed <= ((x_speed >= 0)? x_speed : -x_speed + (y_speed >= 0)? y_speed : -y_speed) / 10'd2;
				y_speed <= ((x_speed >= 0)? x_speed : -x_speed + (y_speed >= 0)? y_speed : -y_speed) / 10'd2;
			end
	else if(ball_x + x_speed <= BARRIER + RADIUS)
	begin
		ball_x <= BARRIER + RADIUS;
		x_speed <= -x_speed;
	end
	else if(ball_y + y_speed <= BARRIER + RADIUS)
	begin
		ball_y <= BARRIER + RADIUS;
		y_speed <= -y_speed;
	end
	else if(ball_x + x_speed >= 10'd640-BARRIER-RADIUS)
	begin
		ball_x <= 640 - BARRIER -RADIUS;
		x_speed <= -x_speed;
	end
	else if(ball_y + y_speed >= 10'd480 - BARRIER - RADIUS)
	begin
		ball_y <= 10'd480 - BARRIER - RADIUS;
		y_speed <= -y_speed;
	end
	else
	begin
		ball_x <= ball_x + x_speed;
		ball_y <= ball_y + y_speed;
	end
end

always@(posedge clk_50Hz or negedge start)
begin
	
	else if(ball_y + y_speed - RADIUS <= bar_a_y + BAR_LENGTH && ball_y - RADIUS > bar_a_y +BAR_LENGTH&& ball_x >= bar_a_x && ball_x <= bar_a_x + BAR_WIDTH)
		begin
			ball_y <= bar_a_y + BAR_LENGTH + RADIUS;
			if(bar_a_y_speed > 0)
				begin
				if(y_speed >= 0)
					begin
						y_speed <= -(y_speed+1);
					end
				else
					begin
						y_speed <= -(y_speed -1);
					end
				end
			else if(bar_a_x_speed == 0)
				begin
					x_speed <= -x_speed;
				end
			else
				begin
					if(x_speed >= 0)
						begin
							x_speed <= -(x_speed-1);
						end
					else
						begin
							x_speed <= -(x_speed +1);
						end
				end
		end
	else if( (ball_x + x_speed - RADIUS <= bar_b_x + BAR_WIDTH && ball_x - RADIUS > bar_b_x +BAR_WIDTH&& ball_y >= bar_b_y && ball_y <= bar_b_y + BAR_LENGTH) )
		begin
			ball_x <= bar_b_x + BAR_WIDTH +RADIUS;
			if(bar_b_x_speed > 0)
				begin
				if(x_speed >= 0)
					begin
						x_speed <= -(x_speed+1);
					end
				else
					begin
						x_speed <= -(x_speed -1);
					end
				end
			else if(bar_a_x_speed == 0)
				begin
					x_speed <= -x_speed;
				end
			else
				begin
					if(x_speed >= 0)
						begin
							x_speed <= -(x_speed-1);
						end
					else
						begin
							x_speed <= -(x_speed +1);
						end
				end
		end
	else if(ball_x + x_speed + RADIUS >= bar_a_x  && ball_x + RADIUS <= bar_a_x && ball_y >= bar_a_y && ball_y <= bar_a_y + BAR_LENGTH)
		begin
			ball_x <= bar_a_x - RADIUS;
			if(bar_a_x_speed > 0)
				begin
				if(x_speed >= 0)
					begin
						x_speed <= -(x_speed-1);
					end
				else
					begin
						x_speed <= -(x_speed +1);
					end
				end
			else if(bar_a_x_speed == 0)
				begin
					x_speed <= -x_speed;
				end
			else
				begin
					if(x_speed >= 0)
						begin
							x_speed <= -(x_speed+1);
						end
					else
						begin
							x_speed <= -(x_speed -1);
						end
				end
		end
	else if(ball_x + x_speed + RADIUS >= bar_b_x  && ball_x + RADIUS <= bar_b_x && ball_y >= bar_b_y && ball_y <= bar_b_y + BAR_LENGTH)
		begin
			ball_x <= bar_b_x - RADIUS;
			if(bar_b_x_speed > 0)
				begin
				if(x_speed >= 0)
					begin
						x_speed <= -(x_speed-1);
					end
				else
					begin
						x_speed <= -(x_speed +1);
					end
				end
			else if(bar_b_x_speed == 0)
				begin
					x_speed <= -x_speed;
				end
			else
				begin
					if(x_speed >= 0)
						begin
							x_speed <= -(x_speed+1);
						end
					else
						begin
							x_speed <= -(x_speed -1);
						end
				end
		end
	else if (((ball_x + x_speed - BAR_WIDTH - bar_a_x)*(ball_x + x_speed - BAR_WIDTH - bar_a_x) + (ball_y + y_speed - bar_a_y )*
					(ball_y +y_speed - bar_a_y) <= 10'd400 && (ball_x  - BAR_WIDTH - bar_a_x)*(ball_x - BAR_WIDTH - bar_a_x) + (ball_y - bar_a_y )*
					(ball_y - bar_a_y) > 10'b400  )) || ((ball_x + x_speed - BAR_WIDTH - bar_b_x)*(ball_x + x_speed - BAR_WIDTH - bar_b_x) + (ball_y 
					 + y_speed - bar_b_y )*(ball_y +y_speed - bar_b_y) <= 10'd400 && (ball_x  - BAR_WIDTH - bar_b_x)*(ball_x - BAR_WIDTH - bar_b_x) 
					 + (ball_y - bar_b_y )*(ball_y - bar_b_y) > 10'd400  )))
			begin
				ball_x <= ball_x + (x_speed >= 0) ? 10'd1: -10'd1;
				x_speed <= ((x_speed >= 0)? x_speed : -x_speed) + (y_speed >= 0)? y_speed : -y_speed) / 2;
			end
	else if (((ball_x + x_speed - bar_a_x)*(ball_x + x_speed - bar_a_x) + (ball_y + y_speed - bar_a_y )*
					(ball_y +y_speed - bar_a_y) <= 10'd400 && (ball_x   - bar_a_x)*(ball_x  - bar_a_x) + (ball_y - bar_a_y )*
					(ball_y - bar_a_y) > 10'b400  )) || ((ball_x + x_speed  - bar_b_x)*(ball_x + x_speed - bar_b_x) + (ball_y 
					 + y_speed - bar_b_y )*(ball_y +y_speed - bar_b_y) <= 10'd400 && (ball_x  - bar_b_x)*(ball_x - bar_b_x) 
					 + (ball_y - bar_b_y )*(ball_y - bar_b_y) > 10'd400  )))
			begin
				ball_x <= ball_x + (x_speed >= 0) ? 10'd1: -10'd1;
				x_speed <= -((x_speed >= 0)? x_speed : -x_speed) + (y_speed >= 0)? y_speed : -y_speed) / 2;
			end
	else if (((ball_x + x_speed  - bar_a_x)*(ball_x + x_speed  - bar_a_x) + (ball_y + y_speed - bar_a_y -BAR_LENGTH)*
					(ball_y +y_speed - bar_a_y-BAR_LENGTH) <= 10'd400 && (ball_x  - bar_a_x)*(ball_x - bar_a_x) + (ball_y - bar_a_y - BAR_LENGTH )*
					(ball_y - bar_a_y - BAR_LENGTH) > 10'b400  )) || ((ball_x + x_speed  - bar_b_x)*(ball_x + x_speed - bar_b_x) + (ball_y 
					 + y_speed - bar_b_y -BAR_LENGTH)*(ball_y +y_speed - bar_b_y-BAR_LENGTH) <= 10'd400 && (ball_x - bar_b_x)*(ball_x  - bar_b_x) 
					 + (ball_y - bar_b_y )*(ball_y - bar_b_y) > 10'd400  )))
			begin
				ball_x <= ball_x + (x_speed >= 0) ? 10'd1: -10'd1;
				x_speed <= -((x_speed >= 0)? x_speed : -x_speed) + (y_speed >= 0)? y_speed : -y_speed) / 2;
			end
	else if (((ball_x + x_speed - BAR_WIDTH - bar_a_x)*(ball_x + x_speed - BAR_WIDTH - bar_a_x) + (ball_y + y_speed - bar_a_y - BAR_LENGTH )*
					(ball_y +y_speed - bar_a_y- BAR_LENGTH) <= 10'd400 && (ball_x  - BAR_WIDTH - bar_a_x)*(ball_x - BAR_WIDTH - bar_a_x) + (ball_y - bar_a_y - BAR_LENGTH)*
					(ball_y - bar_a_y- BAR_LENGTH) > 10'b400  )) || ((ball_x + x_speed - BAR_WIDTH - bar_b_x)*(ball_x + x_speed - BAR_WIDTH - bar_b_x) + (ball_y 
					 + y_speed - bar_b_y_BAR_LENGTH )*(ball_y +y_speed - bar_b_y-BAR_LENGTH) <= 10'd400 && (ball_x  - BAR_WIDTH - bar_b_x)*(ball_x - BAR_WIDTH - bar_b_x) 
					 + (ball_y - bar_b_y -BAR_LENGTH)*(ball_y - bar_b_y-BAR_LENGTH) > 10'd400  )))
			begin
				ball_x <= ball_x + (x_speed >= 0) ? 10'd1: -10'd1;
				x_speed <= ((x_speed >= 0)? x_speed : -x_speed) + (y_speed >= 0)? y_speed : -y_speed) / 2;
			end
	
	
	else
		ball_y <= ball_y + y_speed;
end
*/

endmodule
