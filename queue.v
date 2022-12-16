

module queue(reset, clk, r_in, phi_in, rw, en, r_out, phi_out, queue_empty);
			parameter msb_data = 19, msb_phi = 7, msb_r = 11, msb_cnt = 2;
			input clk, reset, rw, en;
			input[msb_r:0] r_in;
			input[msb_phi:0] phi_in;
			output[msb_r:0] r_out;
			output[msb_phi:0] phi_out;
			output queue_empty;
			
			wire S, up_down;
			wire[msb_data:0] data_in, data_out;
			wire[msb_cnt:0] cnt;
			
			shift_right shift_row[19:0](.clk(clk), .reset(reset), .S(S), .IR(data_in[msb_data:0]), .out(data_out[msb_data:0]), .sel_out(cnt));
			counter md_cnt(.clk(clk), .reset(reset), .up_down(up_down), .en(en), .out(cnt));

			assign data_in[msb_data:0] = {r_in[msb_r:0], phi_in[msb_phi:0]};
			assign {r_out[msb_r:0], phi_out[msb_phi:0]} = data_out[msb_data:0];
			assign S = en & rw;
			assign up_down = ~rw;
			assign queue_empty = (cnt == 3'b111) ? 1 : 0;
			
endmodule

