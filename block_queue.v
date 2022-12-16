


module block_queue(clk, reset, M1_r, M1_phi, M2_r, M2_phi, ctrl_queue, r_out, phi_out, queue_empty);
			parameter msb_r = 11, msb_phi = 7, msb_ctrl_queue = 3;
			
			output[msb_r:0] r_out;
			output[msb_phi:0] phi_out;
			output queue_empty;
			
			input[msb_r:0] M1_r, M2_r;
			input[msb_phi:0] M1_phi, M2_phi;
			input clk, reset;
			input[msb_ctrl_queue:0] ctrl_queue;
			
			
			wire[msb_r:0] r_in;
			wire[msb_phi:0] phi_in;
			wire[1:0] sel_M;
			wire en, rw;
			
			queue bk_queue(.reset(reset), .clk(clk), .r_in(r_in), .phi_in(phi_in), .rw(rw), .en(en), .r_out(r_out), .phi_out(phi_out), .queue_empty(queue_empty));

			assign r_in[msb_r:0] = (sel_M[1]) ? M1_r : (sel_M[0]) ? M2_r : {msb_r+1{1'bz}};
			assign phi_in[msb_phi:0] = (sel_M[1]) ? M1_phi : (sel_M[0]) ? M2_phi : {msb_phi+1{1'bz}};
			assign {en, rw, sel_M[1:0]} = ctrl_queue[msb_ctrl_queue:0];
endmodule
