`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:42:41 11/25/2016 
// Design Name: 
// Module Name:    ram_ctl 
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
module ram_ctl(
input display,
input clk_40ns,
input clk_80ns,
input rst,
input [15:0] MemDB,
input [9:0] hcount,
input [9:0] vcount,
input [15:0] data_out,
input [15:0] data_out_bar_a,
input [15:0] data_out_bar_b,
input [9:0] ball_x,
input [9:0] ball_y,
input [9:0] bar_a_y,
input [9:0] bar_b_y,
input [3:0] state,
output reg [2:0] red,
output reg [2:0] green,
output reg [1:0] blue,
output reg [8:0] addr = 0,
output reg [10:0] addr_bar_a = 0,
output reg [10:0] addr_bar_b = 0,
output reg [25:0] MemAdr = 0
    );

parameter RADIUS = 10'd10;
parameter BALL_PIXELS = 9'd400;
parameter BAR_LENGTH = 10'd70;
parameter BAR_WIDTH = 10'd18;
parameter BAR_PIXELS = 11'd1260;
parameter bar_a_x = 10'd5;
parameter bar_b_x = 10'd617;

reg flag = 0;
reg flag_bar_a = 0;
reg flag_bar_b = 0;
reg [9:0] ball_x_tem = 0;	// Register the position temporarily, for when it is being displayed, it can't move.
reg [9:0] ball_y_tem = 0;
reg [9:0] bar_a_x_tem = 0;
reg [9:0] bar_a_y_tem = 0;
reg [9:0] bar_b_x_tem = 0;
reg [9:0] bar_b_y_tem = 0;
reg [25:0] state_offset = 26'd0;


always@(posedge clk_80ns or posedge rst)
begin
	if(rst)
		begin
			ball_x_tem <= 0;
			ball_y_tem <= 0;
		end
	else if( addr ==  BALL_PIXELS - 2)
		begin
			ball_x_tem <= 0;
			ball_y_tem <= 0;
		end
	else if( (vcount - 31) == (ball_y - RADIUS -1))
		begin
			ball_x_tem <= ball_x;
			ball_y_tem <= ball_y;
		end
	else
		begin
			ball_x_tem <= ball_x_tem;
			ball_y_tem <= ball_y_tem;
		end
end

always@(posedge clk_80ns or posedge rst)
begin
	if(rst)
		begin
			bar_a_x_tem <= 0;
			bar_a_y_tem <= 0;
		end
	else if( addr_bar_a ==  BAR_PIXELS - 2)
		begin
			bar_a_x_tem <= 0;
			bar_a_y_tem <= 0;
		end
	else if( (vcount - 31) == (bar_a_y - 1))
		begin
			bar_a_x_tem <= bar_a_x;
			bar_a_y_tem <= bar_a_y;
		end
	else
		begin
			bar_a_x_tem <= bar_a_x_tem;
			bar_a_y_tem <= bar_a_y_tem;
		end
end

always@(posedge clk_80ns or posedge rst)
begin
	if(rst)
		begin
			bar_b_x_tem <= 0;
			bar_b_y_tem <= 0;
		end
	else if( addr_bar_b ==  BAR_PIXELS - 2)
		begin
			bar_b_x_tem <= 0;
			bar_b_y_tem <= 0;
		end
	else if( (vcount - 31) == (bar_b_y - 1))
		begin
			bar_b_x_tem <= bar_b_x;
			bar_b_y_tem <= bar_b_y;
		end
	else
		begin
			bar_b_x_tem <= bar_b_x_tem;
			bar_b_y_tem <= bar_b_y_tem;
		end
end


always@(posedge clk_80ns or posedge rst)
begin
	if(rst)
		begin
		addr <= 0;
		flag <= 0;
		end
	else if(addr == BALL_PIXELS -2 )
		begin
		addr <= 0;
		flag <= 0;
		end
	else if((hcount - 144) >= (ball_x_tem - RADIUS) && (hcount - 144) <= (ball_x_tem +RADIUS-1) && (vcount - 31) >=  (ball_y_tem
				-RADIUS) && (vcount -31) <= (ball_y_tem +RADIUS-1) && ball_x_tem != 10'b0)
		begin
			flag <= 1;
			addr <= addr + 9'd2;
		end
	else 
		begin
		addr <= addr;
		flag <= 0;
		end
end


always@(posedge clk_80ns or posedge rst)
begin
	if(rst)
		begin
		addr_bar_a <= 0;
		flag_bar_a <= 0;
		end
	else if(addr_bar_a == BAR_PIXELS -2 )
		begin
		addr_bar_a <= 0;
		flag_bar_a <= 0;
		end
	else if((hcount - 144) >= bar_a_x_tem && (hcount - 144) <= (bar_a_x_tem + BAR_WIDTH -1 ) && (vcount - 31) >=  bar_a_y_tem
				 && (vcount -31) <= (bar_a_y_tem + BAR_LENGTH - 1) && bar_a_x_tem != 10'b0)
		begin
			flag_bar_a <= 1;
			addr_bar_a <= addr_bar_a + 9'd2;
		end
	else 
		begin
		addr_bar_a <= addr_bar_a;
		flag_bar_a <= 0;
		end
end

always@(posedge clk_80ns or posedge rst)
begin
	if(rst)
		begin
		addr_bar_b <= 0;
		flag_bar_b <= 0;
		end
	else if(addr_bar_b == BAR_PIXELS -2 )
		begin
		addr_bar_b <= 0;
		flag_bar_b <= 0;
		end
	else if((hcount - 144) >= bar_b_x_tem && (hcount - 144) <= (bar_b_x_tem + BAR_WIDTH -1 ) && (vcount - 31) >=  bar_b_y_tem
				 && (vcount -31) <= (bar_b_y_tem + BAR_LENGTH - 1) && bar_b_x_tem != 10'b0)
		begin
			flag_bar_b <= 1;
			addr_bar_b <= addr_bar_b + 9'd2;
		end
	else 
		begin
		addr_bar_b <= addr_bar_b;
		flag_bar_b <= 0;
		end
end

always@(*)
begin
	case(state)
		4'd0:	state_offset <= 26'd0;
		4'd1: state_offset <= 26'd153600;
		4'd2: state_offset <= 26'd307200;
		4'd3: state_offset <= 26'd460800;
		4'd4: state_offset <= 26'd614400;
		4'd5: state_offset <= 26'd768000;
		4'd6:	state_offset <= 26'd921600;
		4'd8: state_offset <= 26'd1075200;
		4'd9: state_offset <= 26'd1228800;
		4'd10: state_offset <= 26'd1382400;
	default: state_offset <= state_offset;
	endcase
end



always@(posedge clk_80ns or posedge rst)
begin
	if(rst)
		MemAdr <= 0;
	else if(vcount == 0)
		MemAdr <= state_offset;
	else if(MemAdr == state_offset + 26'd153599)
		MemAdr <= state_offset;
	else if(display == 1)
		MemAdr <= MemAdr + 26'b1;
	else
		MemAdr <= MemAdr;
end

reg pcounter;
always@(posedge clk_40ns or posedge rst)
begin
	if(rst)
		pcounter <= 0;
	else if(display == 1)
		pcounter <= ~pcounter;
	else
		pcounter <= 0;
end


always@(posedge clk_40ns)
begin
	if(state == 4'd7)
		begin
			red <= 3'b000;
			green <= 3'b000;
			blue <= 3'b00;
		end
	else if(display == 1)
		begin
			if(flag_bar_a == 1&&(state == 4'd3||state == 4'd5||state==4'd6))
				begin
					red <= (pcounter == 0)? data_out_bar_a[15:13]:data_out_bar_a[7:5];
					green <= (pcounter == 0)? data_out_bar_a[12:10]:data_out_bar_a[4:2];
					blue <= (pcounter == 0)? data_out_bar_a[9:8]:data_out_bar_a[1:0];
				end
			else if(flag_bar_b == 1&&(state == 4'd3||state == 4'd5||state==4'd6))
				begin
					red <= (pcounter == 0)? data_out_bar_b[15:13]:data_out_bar_b[7:5];
					green <= (pcounter == 0)? data_out_bar_b[12:10]:data_out_bar_b[4:2];
					blue <= (pcounter == 0)? data_out_bar_b[9:8]:data_out_bar_b[1:0];
				end
			else
				begin
				if(flag == 1 && (state == 4'd3||state == 4'd5||state ==4'd6) )
					begin
						red <= (pcounter == 0)? ((data_out[15:8]== 8'd0)? MemDB[15:13] :data_out[15:13]):((data_out[15:8]== 8'd0)? MemDB[7:5] :data_out[7:5]);
						green <= (pcounter == 0)? ((data_out[15:8]== 8'd0)? MemDB[12:10] :data_out[12:10]):((data_out[15:8]== 8'd0)? MemDB[4:2] :data_out[4:2]);
						blue <= (pcounter == 0)? ((data_out[15:8]== 8'd0)? MemDB[9:8] :data_out[9:8]):((data_out[15:8]== 8'd0)? MemDB[1:0] :data_out[1:0]);
					end
				else
					begin
						red <= (pcounter == 0) ? MemDB[15:13] : MemDB[7:5];
						green <= (pcounter == 0)? MemDB[12:10] : MemDB[4:2];
						blue <= (pcounter == 0)? MemDB[9:8] : MemDB[1:0];
					end
				end
		end
	else
		begin
			red <= 3'b000;
			green <= 3'b000;
			blue <= 3'b00;
		end
end


endmodule
