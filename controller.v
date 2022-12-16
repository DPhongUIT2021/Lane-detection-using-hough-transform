


module controller(ctrl_preO, ctrl_memoO, ctrl_maxO, ctrl_postO, ctrl_queueO, inc_address, reset, clk
			, reset_memo, reset_pre, reset_max, reset_post, reset_canny, reset_queue
			, eq_179, end_point, j_gt_1000, state, queue_empty, end_post);
			parameter msb_ctrl_pre = 29, msb_ctrl_memo = 12, msb_ctrl_max = 16, msb_ctrl_post = 10, msb_ctrl_queue = 3
			, S0 = 5'h00, S1 = 5'h01, S2 = 5'h02, S3 = 5'h03, S4 = 4'h04, S5 = 5'h05, S6 = 5'h06, S7 = 5'h07, S8 = 5'h08
			, S9 = 5'h09, S10 = 5'h0A, S11 = 5'h0B, S12 = 5'h0C, S13 = 5'h0D, S14 = 5'h0E, S15 = 5'h0F, S16 = 5'h10
			, S_Reset = 5'h1F;
			
			input clk, reset;
			input eq_179, end_point;
			input j_gt_1000, queue_empty;
			
		   output[msb_ctrl_memo:0] ctrl_memoO;
			output[msb_ctrl_pre:0] ctrl_preO;
			output[msb_ctrl_max:0] ctrl_maxO;
			output[msb_ctrl_post:0] ctrl_postO;
			output[msb_ctrl_queue:0] ctrl_queueO;
			output inc_address, end_post;
			output reset_memo, reset_pre, reset_max, reset_post, reset_canny, reset_queue;
			output[4:0] state;
				
			reg[4:0] state, next_state;
			reg we_memo_post;
			reg end_post;
			
			wire[msb_ctrl_memo:0] ctrl_memo[2:5];
			wire[msb_ctrl_memo:0] ctrl_memo_post_S14;
			wire[msb_ctrl_pre:0] ctrl_pre[0:3];
			wire[msb_ctrl_pre:0] ctrl_pre_post[8:14];
			wire[msb_ctrl_max:0] ctrl_max[4:7];
			wire[msb_ctrl_post-1:0] ctrl_post[8:14];
			wire[msb_ctrl_queue:0] ctrl_queue[8:16];
			wire post_switch;
					
			//	ctrl_memo  reset sA[3:0] sB[3:0] wR, wPhi, wCnt, we, ctrl_add
			assign ctrl_memo[2] = 13'b1000_1000_1000_0;
			assign ctrl_memo[3] = 13'b0100_0100_0100_0;
			assign ctrl_memo[4] = 13'b0010_0010_0010_0;
			assign ctrl_memo[5] = 13'b0000_0000_0001_0;
			assign ctrl_memo_post_S14 = 13'b0001_0001_0000_1;
						
			// ctrl_max      sA sB sM1 sM2 wM1 wM2 wTmp wEQ
			assign ctrl_max[4] = 17'b100_1000_10_00_00_00_0_1;
			assign ctrl_max[5] = 17'b100_0010_00_10_01_01_0_0;
			assign ctrl_max[6] = 17'b010_0001_00_10_10_10_1_0;
			assign ctrl_max[7] = 17'b001_0001_01_01_11_11_0_0;
			
			// ctrl_pre         
			assign ctrl_pre[0] = 30'b1000000_0001000_10000_1000_010_100_0;
			assign ctrl_pre[1] = 30'b0100000_0010000_10000_1000_001_100_0;
			assign ctrl_pre[2] = 30'b0010000_0100000_01000_0100_000_100_0; 
			assign ctrl_pre[3] = 30'b0001000_1000000_00100_1000_100_000_0;
			
			// ctrl_pre_post mulA[6:0] mulB[6:0] addA[4:0] addB[3:0] R1,R2,R2,add[2:0],smux_gt90  
			assign ctrl_pre_post[8]  = 30'b0000100_0000100_10000_0010_100_100_1;
			assign ctrl_pre_post[9]  = 30'b0010000_0001000_10000_1000_010_100_0;
			assign ctrl_pre_post[10] = 30'b0010000_0010000_10000_1000_001_100_0;
			assign ctrl_pre_post[11] = 30'b0000010_0000010_00000_0000_010_000_0;
			assign ctrl_pre_post[12] = 30'b0000010_0000001_00000_0000_001_000_0;
			assign ctrl_pre_post[13] = 30'b0000001_0000001_00010_0001_000_010_0;
			assign ctrl_pre_post[14] = 30'b0000001_0000010_00001_0001_000_001_0;	

			// ctrl_post     gt90.cos.sin_X0.Y0_(J.J_rst.J_sign)_Xi.Yi  	
			assign ctrl_post[8]  = 10'b100_00_000_00;
			assign ctrl_post[9]  = 10'b000_00_000_00;
			assign ctrl_post[10] = 10'b010_00_000_00;
			assign ctrl_post[11] = 10'b001_00_000_00;
			assign ctrl_post[12] = 10'b000_10_010_00;
			assign ctrl_post[13] = 10'b000_01_001_10;
			assign ctrl_post[14] = 10'b000_00_100_01;
			
			// ctrl_queue 			en w/r sel_M[1:0] // write/remove (1: write; 0:remove)
			assign ctrl_queue[15] = 4'b1_1_10;
			assign ctrl_queue[16] = 4'b1_1_01;
			assign ctrl_queue[12] = 4'b1_0_00;

			// reset block
			assign reset_pre = (state == S_Reset);
			assign reset_memo = (state == S_Reset);
			assign reset_max = (state == S_Reset);
			assign reset_post = (state == S_Reset);
			assign reset_canny = (state == S_Reset);
			assign reset_queue = (state == S_Reset);
			
			assign ctrl_preO = (state == 0) ? ctrl_pre[0]
									: (state == 1) ? ctrl_pre[1]
									: (state == 2) ? ctrl_pre[2]
									: (state == 3) ? ctrl_pre[3]
									: (state == 4) ? ctrl_pre[0]
									: (state == 5) ? ctrl_pre[1]
									: (state == 6) ? ctrl_pre[2]
									: (state == 7) ? ctrl_pre[3]
										: (state == 8) ? ctrl_pre_post[8]
										: (state == 9) ? ctrl_pre_post[9]
										: (state == 10) ? ctrl_pre_post[10]
										: (state == 11) ? ctrl_pre_post[11]
										: (state == 12) ? ctrl_pre_post[12]
										: (state == 13) ? ctrl_pre_post[13]
										: (state == 14) ? ctrl_pre_post[14]
									: {msb_ctrl_pre+1{1'bz}};
			
			assign ctrl_memoO = (state == 0) ? ctrl_memo[4]
										: (state == 1) ? ctrl_memo[5]
										: (state == 2) ? ctrl_memo[2]
										: (state == 3) ? ctrl_memo[3]
										: (state == 4) ? ctrl_memo[4]
										: (state == 5) ? ctrl_memo[5]
										: (state == 6) ? ctrl_memo[2]
										: (state == 7) ? ctrl_memo[3]
											: (state == 14) ? ctrl_memo_post_S14
										: {msb_ctrl_memo+1{1'bz}};
			
			assign ctrl_maxO = (state == 0) ? ctrl_max[4]
									: (state == 1) ? ctrl_max[5]
									: (state == 2) ? ctrl_max[6]
									: (state == 3) ? ctrl_max[7]
									: (state == 4) ? ctrl_max[4]
									: (state == 5) ? ctrl_max[5]
									: (state == 6) ? ctrl_max[6]
									: (state == 7) ? ctrl_max[7]
									: {msb_ctrl_max+1{1'bz}};
									
			
			assign ctrl_postO[msb_ctrl_post:1] = (state == 8) ? {ctrl_post[8]}
									: (state == 9) ? {ctrl_post[9]}
									: (state == 10) ? {ctrl_post[10]}
									: (state == 11) ? {ctrl_post[11]}
									: (state == 12) ? {ctrl_post[12]}
									: (state == 13) ? {ctrl_post[13]}
									: (state == 14) ? {ctrl_post[14]}
									: {msb_ctrl_post+1{1'bz}};
									assign ctrl_postO[0] = we_memo_post;
			assign ctrl_queueO[msb_ctrl_queue:0] = (state == 15) ? ctrl_queue[15]
												: (state == 16) ? ctrl_queue[16]
												: (state == 12) ? ctrl_queue[12]
												: {1'b0, {msb_ctrl_queue{1'bz}} };
			
									
			assign inc_address = (((state == S7) | (state == S3)) & eq_179)	|  (state == S13 & j_gt_1000 & queue_empty);
			assign post_switch = ((state == S7) | (state == S3) & eq_179 & end_point);
			
			always @(state, end_point) begin
						if(end_point & ((state == S7) | (state == S3))) next_state = S15;
						else	begin case(state)
									S_Reset: next_state = S0;
									S0: next_state = S1;
									S1: next_state = S2;
									S2: next_state = S3;
									S3: next_state = S4;  
									S4: next_state = S5;
									S5: next_state = S6;
									S6: next_state = S7;
									S7: next_state = S0;
									S8: next_state = S9;
									S9: next_state = S10;
									S10: next_state = S11;
									S11: next_state = S12;
									S12: next_state = S13;
									S13: begin if(j_gt_1000 & queue_empty) next_state = S0;
													else next_state = S14;
											end
									S14: begin 	if(j_gt_1000) begin
														if(queue_empty == 1'b0) next_state = S8;
														else next_state = S0;
												end else next_state = S13;
										  end
									S15: next_state = S16;
									S16: next_state = S8;
									default: next_state = S_Reset;
						            endcase
						end

			end
			
			always @(negedge clk) begin
						if(reset) state = S_Reset;
						else state <= next_state;
			end
			always @(posedge clk) begin
					if(state == 14) we_memo_post = 1;
					else we_memo_post = 0;
			end
endmodule

