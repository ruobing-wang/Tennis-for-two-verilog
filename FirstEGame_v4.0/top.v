`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:24:35 11/24/2016 
// Design Name: 
// Module Name:    top 
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
module top(
input clk,
input rst,
input [15:0] MemDB,
//input ps2_clk,
//input ps2_data,
input [4:0] clt,
output [2:0] red,
output [2:0] green,
output [1:0] blue,
output hsync,
output vsync,
output [25:0] MemAdr,
output we_L,
output oe_L,
output ce_L,
output lb_L,
output ub_L,
output RamADV_L,
output RamCLK,
output RamCRE,
output FlashCS,
output [3:0] sel,
output [7:0] data
    );

assign we_L = 1;
assign oe_L = 0;
assign ce_L = 0;
assign lb_L = 0;
assign ub_L = 0;
assign RamADV_L = 0;
assign RamCLK = 0;
assign RamCRE = 0;
assign FlashCS = 1;

clk_div	u_clk_div(
.clk			(clk),
.clk_40ns	(clk_40ns),
.clk_80ns	(clk_80ns)
    );
wire [9:0] hcount;
wire [9:0] vcount;
wire [15:0] data_out;
wire [15:0] data_out_bar_a;
wire [15:0] data_out_bar_b;
wire [9:0] ball_x;
wire [9:0] ball_y;
wire [8:0] addr;
wire [10:0] addr_bar_a;
wire [10:0] addr_bar_b;
wire [9:0] bar_a_y;
wire [9:0] bar_b_y;
wire start;
wire [3:0] state;
wire [1:0] Winner;

wire w_state ;
wire s_state ;
wire Ua_state;
wire Da_state;
wire Pause;
wire [1:0] win;

/*
wire w_state;
wire a_state;
wire d_state;
wire s_state;
wire La_state;
wire Ua_state;
wire Da_state;
wire Ra_state;
wire ESC_state;
*/
/*
keyboard_ctl	u_keyboard_ctl(
.clk		(clk),
.rst		(rst),
.ps2_clk	(ps2_clk),
.ps2_data(ps2_data),
.w_state	(w_state),
.a_state	(a_state),
.d_state	(d_state),
.s_state	(s_state),
.La_state(La_state),
.Ua_state(Ua_state),
.Da_state(Da_state),
.Ra_state(Ra_state),
.ESC_state(ESC_state)
    );
*/
Glitch_Reduce u_Glitch_Reduce(
.clk		(clk),
.rst		(rst),
.clt		(clt),
.w_state	(w_state),
.s_state	(s_state),
.Ua_state(Ua_state),
.Da_state(Da_state),
.Pause	(Pause)
    );
	 
score	u_score(
.clk		(clk),
.rst		(rst),
.win		(win),
.start	(start),
.sel		(sel),
.data		(data),
.Winner 	(Winner)
    );
	 
Main_FSM u_Main_FSM(
.clk		(clk),
.rst		(rst),
.w_state	(w_state),
.s_state	(s_state),
.Ua_state(Ua_state),
.Da_state(Da_state),
.Pause	(Pause),
.Winner 	(Winner),
.start	(start),
.state	(state)
    );

bar_ctl u_bar_ctl(
.clk		(clk),
.w_state	(w_state),
.s_state	(s_state),
.Ua_state(Ua_state),
.Da_state(Da_state),
.ESC_state(Pause),
.start	(start),
.state	(state),
.bar_a_y	(bar_a_y),
.bar_b_y	(bar_b_y)
    );
	 
ram_ctl	u_ram_ctl(
.display		(display),
.clk_40ns	(clk_40ns),
.clk_80ns	(clk_80ns),
.rst			(rst),
.MemDB		(MemDB),
.hcount		(hcount),
.vcount		(vcount),
.data_out	(data_out),
.data_out_bar_a(data_out_bar_a),
.data_out_bar_b(data_out_bar_b),
.ball_x		(ball_x),
.ball_y		(ball_y),
.bar_a_y		(bar_a_y),
.bar_b_y		(bar_b_y),
.state		(state),
.red			(red),
.green		(green),
.blue			(blue),
.addr			(addr),
.addr_bar_a	(addr_bar_a),
.addr_bar_b	(addr_bar_b),
.MemAdr		(MemAdr)
    );

VGA_Display	u_VGA_Display(
.rst			(rst),
.clk_40ns	(clk_40ns),
.hsync		(hsync),
.vsync		(vsync),
.display		(display),
.hcount		(hcount),
.vcount		(vcount)
    );

ball_fsm	u_ball_fsm(
.clk		(clk),
.start	(start),
.state	(state),
.bar_a_y	(bar_a_y),
.bar_b_y	(bar_b_y),
.ball_x	(ball_x),
.ball_y	(ball_y),
.win		(win)
    );


rom_ctl u_rom_ctl(
.clk				(clk),
.addr				(addr),
.addr_bar_a		(addr_bar_a),
.addr_bar_b		(addr_bar_b),
.data_out		(data_out),
.data_out_bar_a(data_out_bar_a),
.data_out_bar_b(data_out_bar_b)
    );

endmodule
