



`timescale 1ps/1ps

module tb_datapath();
			parameter msb_ctrl_pre = 29, msb_ctrl_memo = 12, msb_ctrl_max = 16, msb_ctrl_post = 10, msb_ctrl_queue = 3
			, msb = 15, msb_j = 11
			, msb_phi = 7, msb_r = 11, msb_cnt = 15, msb_M = 35, msb_xi_yi = 11;
			parameter T = 2, msb_point = 15;
			
			reg clk, reset_ctrl;
			reg [msb_j-1:0] j_real;
			reg j_sign;

			wire[msb:0] phi_degree, r_pre;
			wire[msb_r:0] r_int, M1_r, M2_r, M_r;
			wire[msb_phi:0] phi_int, M1_phi, M2_phi, M_phi;
			wire[msb_cnt:0] cnt_int;
			wire[msb_M:0] M1, M2;
			wire[msb:0] add_memo;
			wire[msb_j:0] j, j_inc;
			wire[msb_point:0] x, y;
			
			wire reset_canny, reset_max, reset_memo, reset_pre, reset_post, reset_queue, queue_empty;
			wire[msb_ctrl_memo:0] ctrl_memo;
			wire[msb_ctrl_pre:0] ctrl_pre;
			wire[msb_ctrl_max:0] ctrl_max;
			wire[msb_ctrl_post:0] ctrl_post;
			wire[msb_ctrl_queue:0] ctrl_queue;
			wire inc_address, eq_179, end_point, j_gt_1000;
			wire [msb_xi_yi:0] xi, yi;
			wire[7:0] cnt_xy;
			wire[4:0] state;

			
			initial begin		
					clk = 0;
					reset_ctrl = 1;
					#(T) reset_ctrl = 0;
					
			end
			
			image_canny img_canny(.clk(clk), .x(x), .y(y), .reset(reset_canny), .inc_address(inc_address), .end_point(end_point), .cnt_xy(cnt_xy));
			
			controller md_ctrl(.ctrl_preO(ctrl_pre), .ctrl_memoO(ctrl_memo), .ctrl_maxO(ctrl_max), .ctrl_postO(ctrl_post), .ctrl_queueO(ctrl_queue)
			, .inc_address(inc_address), .reset(reset_ctrl), .clk(clk)
			, .reset_memo(reset_memo), .reset_pre(reset_pre), .reset_max(reset_max), .reset_post(reset_post), .reset_canny(reset_canny), .reset_queue(reset_queue)
			, .eq_179(eq_179), .end_point(end_point), .j_gt_1000(j_gt_1000), .state(state), .queue_empty(queue_empty) );
			
			block_pre bk_pre(.clk(clk), .reset_pre(reset_pre), .reset_post(reset_post), .x(x), .y(y), .ctrl_pre(ctrl_pre), .ctrl_post(ctrl_post), .phi_degree(phi_degree)
			, .r_pre(r_pre), .M_phi(M_phi), .r_int(r_int), .M_r(M_r), .j_inc(j_inc), .j(j), .eq_179(eq_179), .xi(xi), .yi(yi), .j_gt_1000(j_gt_1000) );
									
			block_memo bk_memo(.clk(clk), .reset_memo(reset_memo), .r_pre(r_pre), .phi_degree(phi_degree)
									, .ctrl(ctrl_memo), .r_int(r_int), .phi_int(phi_int), .out_add(add_memo), .cnt_int(cnt_int), .j(j), .eq_179(eq_179) );
									
			block_find_max bk_find_max(.clk(clk), .reset(reset_max), .r_int(r_int), .phi_int(phi_int)
									, .cnt_int(cnt_int), .ctrl(ctrl_max), .M1_phi(M1_phi), .M1_r(M1_r), .M2_phi(M2_phi), .M2_r(M2_r), .cnt_tmp(add_memo) );
									
			block_queue  bk_queue(.clk(clk), .reset(reset_queue), .M1_r(M1_r), .M1_phi(M1_phi), .M2_r(M2_r), .M2_phi(M2_phi), .ctrl_queue(ctrl_queue), .r_out(M_r), .phi_out(M_phi), .queue_empty(queue_empty));		
			
			
			assign j_inc[msb_j:0] = add_memo[msb_j:0];
			
			
			always #(T/2) begin 
						clk = ~clk;
			end
			// ==================== display phi_int, r_int===========================
//			always @(state == 0 || state == 4) begin 
//					$display("(phi_int, r_int, cnt) = (%d , %d, %d) ", phi_int, r_int, cnt_int);
//					
//			end
		// always #(T*2) begin 
		// $display("time:%0t - (j, xi, yi) = (%d , %d , %d) --- sign_j = ", $realtime, j_real, xi, yi, j_sign);
		
// end


// always @(posedge clk) begin 
		// if(state == 5'b0000) begin
			// //$display("(phi_int, r_int) = (%d , %d )", phi_int, r_int);
			// if(phi_int == 32 ||  phi_int == 18) begin
					// $display("time:%0t - (x, y, n_xy) = (%d , %d , %d) ... (phi_int, r_int, cnt) = (%d , %d , %d)", $realtime, x, y, cnt_xy, phi_int, r_int, cnt_int);	
			// end
		// end
// end
//			always @(negedge clk) begin
//					if(state == 14) begin
//							if(xi > 0 && yi > 0) $display("time:%0t - (j_real, xi, yi) = (%d, %d, %d) ", $realtime, j_real, xi, yi);
//					end
//			end
			
			
//			always @(posedge clk) begin
//						if(ctrl_post[1]) {j_sign, j_real} <= j[msb_j:0];
//			end


			
endmodule


