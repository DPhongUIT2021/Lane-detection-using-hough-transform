

module block_memo(clk, reset_memo, r_pre, phi_degree, ctrl, r_int, phi_int, out_add, cnt_int, j, eq_179);
			parameter msb_ctrl_memo = 12
			, msb_phi = 7, msb_r = 11, x = 179, y = 2047, msb_cnt = 15, denta_j = 16'h0002, msb_j = 11, msb_adder = 15
			, msb = 15, round_UQ12_4_0 = 16'h0008, round_UQ12_4_1 = 16'h0018, round_UQ8_8 = 16'h008E;
			input[msb:0] phi_degree;
			input[msb:0] r_pre;
			input clk, reset_memo;
			input[msb_ctrl_memo:0] ctrl;
			input[msb_j:0] j;
			
			output[msb_phi:0] phi_int;
			output[msb_r:0] r_int;
			output[msb:0] out_add;
			output[msb_cnt:0] cnt_int;
			output eq_179;
			
			reg[msb:0] M[0:y][0:x];
			reg[msb_phi:0] phi_int;
			reg[msb_r:0] r_int;
			reg[msb:0] cnt_int;
			
			wire wR_int, wPhi_int, wCnt_int, we;
			wire[msb:0] in_add_A, in_add_B, out_add;
			wire[msb_phi:0] in_Phi_int;
			wire[msb_r:0] in_R_int;
			wire[3:0] s_add_A;
		    wire[3:0] s_add_B;
			wire[msb:0] out_memo;
			wire[msb:0] round_UQ12_4;
			wire ov_r_pre, ctrl_adder, j_sign;
			wire[msb_j-1:0] j_read;
			
			adder16_sub_add  add_memo(.A(in_add_A), .B(in_add_B), .O(out_add), .ctrl_adder(ctrl_adder & j_sign));
			equal_179       md_eq_179(.phi_int(phi_int), .eq_179(eq_179));
			
			assign in_add_A = (s_add_A[3]) ? (r_pre ^ {msb+1{ov_r_pre}}): (s_add_A[2]) ? phi_degree : (s_add_A[1]) ? out_memo : (s_add_A[0]) ?{{msb_adder-(msb_j-1){1'b0}}, j_read} : {msb+1{1'bz}};
			assign in_add_B = (s_add_B[3]) ? round_UQ12_4 : (s_add_B[2]) ? round_UQ8_8 : (s_add_B[1]) ? 16'h0001 : (s_add_B[0]) ? denta_j : {msb+1{1'bz}};
			assign in_R_int[msb_r:0] = out_add[15:4];
			assign in_Phi_int[msb_phi:0] = out_add[15:8];	
			assign {s_add_A[3:0], s_add_B[3:0], wR_int, wPhi_int, wCnt_int, we, ctrl_adder} = ctrl[msb_ctrl_memo:0];
			assign out_memo[msb:0] = M[r_int][phi_int];
			assign round_UQ12_4 = (ov_r_pre) ? round_UQ12_4_1 : round_UQ12_4_0;
			assign ov_r_pre = r_pre[msb];
			assign j_sign = j[msb_j];
			assign j_read[msb_j-1:0] = j[msb_j-1:0];
			
			integer i, jj;
			always @(posedge clk) begin
				if(reset_memo) begin
						for(i = 0; i<=y; i = i+1) begin
								for(jj = 0; jj<=x; jj=jj+1) begin
								    M[i][jj] = {msb+1{1'b0}};
								end
						end
						r_int <= {msb_r+1{1'bz}};
						phi_int <= {msb_phi+1{1'bz}};
						cnt_int <= {msb_cnt+1{1'bz}};
				end 
				else begin
						if(wR_int) r_int <= in_R_int;
						if(wPhi_int) phi_int <= in_Phi_int;
						if(wCnt_int) cnt_int <= out_add;
				end
			end
			
			always @(we) begin
					if(we) begin
							M[r_int][phi_int] <= cnt_int;
					end
			end
endmodule

