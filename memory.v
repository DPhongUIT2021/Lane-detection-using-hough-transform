




module memory(reset, r, phi, clk, phi_buf, r_buf, cnt_buf, ctrl_memo);
			parameter msb_phi = 7, msb_r = 11, x = 179, y = 1023
						, msb_data = 15, msb_ctrl_memo = 3;
			input[msb_phi:0] phi;
			input[msb_r:0] r;
			input reset, clk;
			input[msb_ctrl_memo:0] ctrl_memo;
			output[msb_phi:0] phi_buf;
			output[msb_r:0] r_buf;
			output[msb_data:0] cnt_buf;
			
			reg[msb_data:0] M[0:y][0:x];
			reg[msb_phi:0] phi_buf;
			reg[msb_r:0] r_buf;
			reg[msb_data:0] cnt_buf;
			wire wR_buf, wPhi_buf, wCnt_buf, we;
			wire[msb_data:0] out_cnt, out_add_inc1;
			
			adder16 add_inc1(.A(out_cnt), .B(16'h0001), .O(out_add_inc1), .carry_out());
			integer i, j;

			always @(posedge clk) begin
				if(reset) begin
						for(i = 0; i<=y; i = i+1) begin
								for(j = 0; j<=x; j=j+1) begin
								    M[i][j] = {msb_data+1{1'b0}};
								end
						end
				end 
				else begin
						if(wR_buf) r_buf <= r;
						if(wPhi_buf) phi_buf <= phi;
						if(wCnt_buf) cnt_buf <= out_add_inc1;
				end
			end
			
			always @(we) begin
					if(we) begin
							M[r_buf][phi_buf] <= cnt_buf;
					end
			end
			
			assign out_cnt = M[r_buf][phi_buf];	
			assign {wR_buf, wPhi_buf, wCnt_buf, we} = ctrl_memo[msb_ctrl_memo:0];

endmodule




