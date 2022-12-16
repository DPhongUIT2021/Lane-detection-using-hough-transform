



module block_find_max(clk, reset, r_int, phi_int, cnt_int, ctrl, M1_phi, M1_r, M2_phi, M2_r, cnt_tmp);
				parameter msb_M = 35, msb_phi = 7, msb_r = 11, msb_cnt = 15, msb_ctrl = 16, msb_compa = 19;
				input[msb_phi:0] phi_int;
				input[msb_cnt:0] cnt_int, cnt_tmp;
				input[msb_r:0] r_int;
				input[msb_ctrl:0] ctrl;
				input clk, reset;
				output[msb_phi:0] M1_phi, M2_phi;
				output[msb_r:0] M1_r, M2_r;
				
				reg[msb_M:0] M1, M2, Tmp;
				reg eq_M1;
				
				wire[msb_M:0] in_M2, M3, M4, in_M1;
				wire wM1, wM2, wTmp;
				wire[1:0] wM1_ex, wM2_ex;
				wire[2:0] sA;
				wire[1:0] sM2;
				wire[1:0] sM1;
				wire[3:0] sB;
				wire[msb_compa:0] in_a, in_b;
				wire gt, lt;
				wire[msb_r:0] M1_r, M2_r;
				wire[msb_phi:0] M1_phi, M2_phi;
				wire[msb_cnt:0] M1_cnt, M2_cnt;
				wire wEq_M1;
				
				comparator20 c20(.a(in_a), .b(in_b), .gt(gt), .lt(lt));
				
				assign in_a[msb_compa:0] = (sA[2]) ? {r_int, phi_int} : (sA[1]) ? {{msb_compa-msb_cnt{1'b0}}, cnt_int} 
				: (sA[0]) ? {{msb_compa-msb_cnt{1'b0}}, M1_cnt} : {msb_compa+1{1'bz}};
				assign in_b[msb_compa:0] = (sB[3]) ? {M1_r, M1_phi} : (sB[2]) ?  {{msb_compa-msb_cnt{1'b0}}, M1_cnt} 
				: (sB[1]) ? {M2_r, M2_phi} : (sB[0]) ? {{msb_compa-msb_cnt{1'b0}}, M2_cnt} : {msb_compa+1{1'bz}};
				assign in_M2[msb_M:0] = (sM2[1]) ? M3 : (sM2[0]) ? Tmp : {msb_M+1{1'bz}};
				assign in_M1[msb_M:0] = (sM1[1]) ? M4 : (sM1[0]) ? M2 : {msb_M+1{1'bz}};
				assign M1_cnt[msb_cnt:0] = M1[msb_cnt:0];
				assign M1_phi[msb_phi:0] = M1[msb_cnt+1+msb_phi:msb_cnt+1];
				assign M1_r[msb_r:0] = M1[msb_M:msb_cnt+1+msb_phi+1];
				
				assign M2_cnt[msb_cnt:0] = M2[msb_cnt:0];
				assign M2_phi[msb_phi:0] = M2[msb_cnt+1+msb_phi:msb_cnt+1];
				assign M2_r[msb_r:0] = M2[msb_M:msb_cnt+1+msb_phi+1];
				
				assign M3[msb_M:0] = {r_int, phi_int, cnt_int};
				assign M4[msb_M:0] = {r_int, phi_int, cnt_tmp};
		
				
				
				assign wM1 = (~wM1_ex[1] & ~wM1_ex[0] & ~lt & ~gt) | (wM1_ex[1] & wM1_ex[0] & lt & ~gt);
				assign wM2 = (~wM2_ex[1] & wM2_ex[0] & ~lt & ~gt & ~eq_M1) | (wM2_ex[1] & ~wM2_ex[0] & ~lt & gt & ~eq_M1) 
										| (wM2_ex[1] & wM2_ex[0] & lt & ~gt);
				assign {sA[2:0], sB[3:0], sM1[1:0], sM2[1:0], wM1_ex[1:0], wM2_ex[1:0], wTmp, wEq_M1} = ctrl[msb_ctrl:0];
				
				
				
				always @(posedge clk) begin
						if(reset) begin
								M1 <= 0;
								M2 <= 0;
						end
						else begin
								if(wM1) M1 <= in_M1;
								if(wM2) M2 <= in_M2;
								if(wTmp) Tmp <= M1;
								if(wEq_M1) eq_M1 = (~gt & ~lt);
						end
				end


endmodule


