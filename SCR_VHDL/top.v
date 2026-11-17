`timescale 1ns / 1ps

module top (
    input clk,
	input rst,
	input btnU,
    input sw,
    //vga output
	output [3:0] vgaRed,
	output [3:0] vgaGreen,
	output [3:0] vgaBlue,
	output hsync,
	output vsync
    );

    // vga
    wire clk_25MHz;
    wire valid;
	wire [9:0] h_cnt; //640
    wire [9:0] h_cnt_shifted;
	wire [9:0] v_cnt; //480
    Clock_Divider_2 #(.n(2)) cd4(clk, clk_25MHz);
    wire fps_pulse;
    vga_controller vga_inst (
		.pclk(clk_25MHz),
		.reset(rst),
		.hsync(hsync),
		.vsync(vsync),
		.valid(valid),
		.h_cnt(h_cnt),
		.v_cnt(v_cnt),
		.fps_pulse(fps_pulse)
	);
    assign h_cnt_shifted = h_cnt - 10'd175;

	// REMOVE THIS SHIT
	// tombol btnU -> satu pulsa lompat (debounce ~10 ms)
    wire ex_white;
    reg [19:0] db_cnt = 20'd0;
    reg btn_s0 = 1'b0, btn_s1 = 1'b0, btn_stable = 1'b0, btn_prev = 1'b0;
    always @(posedge clk) begin
        btn_s0 <= btnU;
        btn_s1 <= btn_s0;
        if (btn_s1 != btn_stable) begin
            if (db_cnt == 20'd999999) begin
                btn_stable <= btn_s1;
                db_cnt <= 20'd0;
            end else
                db_cnt <= db_cnt + 1'b1;
        end else
            db_cnt <= 20'd0;
        btn_prev <= btn_stable;
    end
    wire btn_pulse = btn_stable & ~btn_prev;
    clk_expander ex_1(btn_pulse, clk, ex_white);
	
    wire clk_fps, clk_ql;
    wire [8:0] base_offset;
    wire [9:0] birdY;
    wire [8:0] pipe1_X, pipe1_Y, pipe2_X, pipe2_Y;
    wire is_collide;
    wire [6:0] current_score;

    Clock_Divider #(.n(1666666)) cd600(clk, clk_fps);

    wire jump;
    assign jump = (sw == 1'b1) ? jump_ql : ex_white;

    wire jump_ql;
    qlearning ql(
        .birdY(birdY),
        .pipe1_X(pipe1_X),
        .pipe1_Y(pipe1_Y),
        .pipe2_X(pipe2_X),
        .pipe2_Y(pipe2_Y),
        .clk_fps(clk_fps),
        .rst(rst),
        .enable(sw),
        .is_collide(is_collide),
        .jump(jump_ql)
    );

    get_bird_pos gbp (
        .clk_fps(clk_fps),
        .jump(jump),
        .is_collide(is_collide),
        .rst(rst),
        .bird_pos(birdY)
    );

    collision_detection cd (
        .birdY(birdY),
        .pipe1_X(pipe1_X),
        .pipe1_Y(pipe1_Y),
        .pipe2_X(pipe2_X),
        .pipe2_Y(pipe2_Y),
        .is_collide(is_collide)
    );

    get_background_offset gbo (
        .clk_fps(clk_fps),
        .is_collide(is_collide),
        .jump(jump),
        .rst(rst),
        .offset(base_offset)
    );

    get_pipes_pos gpp (
        .clk_fps(clk_fps),
        .is_collide(is_collide),
        .jump(jump),
        .rst(rst),
        .pipe1_X(pipe1_X),
        .pipe1_Y(pipe1_Y),
        .pipe2_X(pipe2_X),
        .pipe2_Y(pipe2_Y),
        .current_score(current_score)
    );

	pixel_gen pixel_gen_inst (
		.rst(rst),
		.h_cnt(h_cnt_shifted),
        .v_cnt(v_cnt),
		.valid(valid),
        .clk_25MHz(clk_25MHz),
        .fps_pulse(fps_pulse),
		.vgaRed(vgaRed),
		.vgaGreen(vgaGreen),
		.vgaBlue(vgaBlue),
        .base_offset(base_offset),
        .birdY(birdY),
        .pipe1_X(pipe1_X),
        .pipe1_Y(pipe1_Y),
        .pipe2_X(pipe2_X),
        .pipe2_Y(pipe2_Y),
        .current_score(current_score)
	);

endmodule
