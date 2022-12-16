

module datapath(clk, reset_pre, reset, x, y, ctrl_pre, ctrl_memo, ctrl_find_max, ctrl_post, post_flag);
			parameter msb_ctrl_pre = 29, msb_ctrl_memo = 11, msb_ctrl_max = 16, msb_ctrl_post = 8
			, msb = 15
			, msb_phi = 7, msb_r = 11, msb_cnt = 15, msb_M = 35, msb_xy = 15;
			input[msb_xy:0] x, y;
			input clk, reset_pre, post_flag;
			input[2:0] reset;
			input[msb_ctrl_pre:0] ctrl_pre;
			input[msb_ctrl_memo:0] ctrl_memo;
			input[msb_ctrl_max:0] ctrl_find_max;
			input[msb_ctrl_post:0] ctrl_post;

			wire[msb_xy:0] phi_degree, r_pre;
			wire[msb_r:0] r_int, M1_r, M2_r, M_r;
			wire[msb_phi:0] phi_int, M1_phi, M2_phi, M_phi;
			wire[msb_cnt:0] cnt_int;
			wire[msb_M:0] M1, M2;
			wire[msb:0] add_memo, j;


			block_pre bk_pre(.clk(clk), .reset(reset_pre), .reset_post(reset[2]), .x(x), .y(y), .ctrl_pre(ctrl_pre), .ctrl_post(ctrl_post), .phi_degree(phi_degree)
			, .r_pre(r_pre), .phi_int(phi_int), .M_phi(M_phi), .r_int(r_int), .M_r(M_r), .add_memo(add_memo), .j(j), .post_flag(post_flag));
									
			block_memo bk_memo(.clk(clk), .reset(reset[1]), .r_pre(r_pre), .phi_degree(phi_degree)
									, .ctrl(ctrl_memo), .r_int(r_int), .phi_int(phi_int), .out_add(add_memo), .cnt_int(cnt_int), .j(j));
									
			block_find_max bk_find_max(.clk(clk), .reset(), .r_int(r_int), .phi_int(phi_int)
									, .cnt_int(cnt_int), .ctrl(ctrl_find_max), .M1_phi(M1_phi), .M1_r(M1_r), .M2_phi(M2_phi), .M2_r(M2_r), .cnt_tmp(add_memo));
									
			// test M_r = 424; M_phi = 32
			assign M_r = 12'd424;
			assign M_phi = 8'd32;
									

endmodule


