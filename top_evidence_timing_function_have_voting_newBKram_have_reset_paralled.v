`timescale 1ns / 1ps
module line_buffer1
#(parameter  h_fpga = 150, w_fpga = 450,
msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
thresh_gradien_add = 10,
thresh_gradien_sqrt = 16, //10*1.646760258121
dx_min = 5, dx_max = 50,
msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
msb_number_vote = 8,
msb_address_bkram = ((msb_rho-3+1) + (msb_phi+1) - 1),
msb_depth_ram = 8192, // (rho (9-3) bit * phi 7 bit = 13 bit -> 2^13 = 8192)
msb_sin = 9, msb_cos = 9,
DEPTH = 16, W = 450,
T = 2.2
)
(clk, new_pixel, gray3x3_out);
input[7:0] new_pixel;
input clk;
output[71:0] gray3x3_out;
integer i;
reg[7:0] fifo_0[0:W-1], fifo_1[0:W-1];
reg[7:0] g1, g2, g3;
wire[7:0] g4, g5, g6, g7, g8, g9;
always @(posedge clk) begin
    fifo_0[0] <= new_pixel;
    fifo_1[0] <= fifo_0[W-1];
    for(i = 1; i < W; i = i +1) begin
        fifo_0[i] <= fifo_0[i-1];
        fifo_1[i] <= fifo_1[i-1];
    end      
end
always @(posedge clk) begin    
    g3 <= fifo_1[W-1];
    g2 <= g3;
    g1 <= g2;
end
assign g9 = fifo_0[0], g8 = fifo_0[1], g7 = fifo_0[2];
assign g6 = fifo_1[0], g5 = fifo_1[1], g4 = fifo_1[2];
assign gray3x3_out= {g1,g2,g3,g4,g5,g6,g7,g8,g9};
endmodule // endmodule line_buffer1

`timescale 1ns / 1ps
module gaussian(clk, gray3x3_in, gray_after_filter);
input clk;
input[71:0] gray3x3_in;
output[7:0] gray_after_filter;
wire[7:0] g1,g2,g3,g4,g5,g6,g7,g8,g9;
reg[7:0] pl_a5, pl_a6, pl_g5;
assign {g1,g2,g3,g4,g5,g6,g7,g8,g9} = gray3x3_in;
assign gray_after_filter = pl_a5 + pl_g5 + pl_a6;
always @(posedge clk) begin
    pl_a5 <= ((g1>>4) + (g3>>4)) + ((g7>>4) + (g9>>4));
    pl_a6 <= ((g2>>3) + (g4>>3)) + ((g6>>3) + (g8>>3));
    pl_g5 <= (g5>>2);
end
endmodule //endmodule gaussian

`timescale 1ns / 1ps
module line_buffer2
#(parameter  h_fpga = 150, w_fpga = 450,
msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
thresh_gradien_add = 10,
thresh_gradien_sqrt = 16, //10*1.646760258121
dx_min = 5, dx_max = 50,
msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
msb_number_vote = 8,
msb_address_bkram = ((msb_rho-3+1) + (msb_phi+1) - 1),
msb_depth_ram = 8192, // (rho (9-3) bit * phi 7 bit = 13 bit -> 2^13 = 8192)
msb_sin = 9, msb_cos = 9,
DEPTH = 16, W = 450,
T = 2.2
)
(clk, gray_after_filter, gray3x3_out);
input[7:0] gray_after_filter;
input clk;
output[71:0] gray3x3_out;
integer i;
reg[7:0] fifo_0[0:W-1], fifo_1[0:W-1];
reg[7:0] g1, g2, g3;
wire[7:0] g4, g5, g6, g7, g8, g9;
always @(posedge clk) begin
    fifo_0[0] <= gray_after_filter;
    fifo_1[0] <= fifo_0[W-1];
    for(i = 1; i < W; i = i +1) begin
        fifo_0[i] <= fifo_0[i-1];
        fifo_1[i] <= fifo_1[i-1];
    end      
end
always @(posedge clk) begin    
    g3 <= fifo_1[W-1];
    g2 <= g3;
    g1 <= g2;
end
assign g9 = fifo_0[0], g8 = fifo_0[1], g7 = fifo_0[2];
assign g6 = fifo_1[0], g5 = fifo_1[1], g4 = fifo_1[2];
assign gray3x3_out= {g1,g2,g3,g4,g5,g6,g7,g8,g9};
endmodule //endmodule line_buffer2

`timescale 1ns / 1ps
module lifo_xyphi
#(parameter  h_fpga = 150, w_fpga = 450,
msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
thresh_gradien_add = 10,
thresh_gradien_sqrt = 16, //10*1.646760258121
dx_min = 5, dx_max = 50,
msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
msb_number_vote = 8,
msb_address_bkram = ((msb_rho-3+1) + (msb_phi+1) - 1),
msb_depth_ram = 8192, // (rho (9-3) bit * phi 7 bit = 13 bit -> 2^13 = 8192)
msb_sin = 9, msb_cos = 9,
DEPTH = 16, W = 450,
T = 2.2
)
(clk, reset, x_in, phi_in, y_in, we, re, empty, full, x_out, phi_out, y_out);
input clk, we, re, reset;
input[msb_x:0] x_in;
input[msb_phi:0] phi_in;
input[msb_y:0] y_in;
output empty, full;
output[msb_x:0] x_out;
output[msb_phi:0] phi_out;
output[msb_y:0] y_out;

reg[msb_x:0] fifo_x[0:DEPTH-1];
reg[msb_phi:0] fifo_phi[0:DEPTH-1];
reg[msb_y:0] fifo_y[0:DEPTH-1];
reg[4:0] cnt;
reg empty, full;

wire we_real;
wire re_real;
wire re_and_we_same_time;
wire empty_interal, full_interal;
assign we_real = we & ~re & ~full_interal;
assign re_real = ~we & re & ~empty_interal;
assign re_and_we_same_time = we & re;
always @(posedge clk) begin
    if(reset) cnt <= 0;
    else begin
        if(we_real) cnt <= cnt + 1;
        else if(re_real) cnt <= cnt - 1;
        else cnt <= cnt;
    end
end
always @(posedge clk) begin
    if(we_real) begin
        fifo_x[cnt] <= x_in;
        fifo_phi[cnt] <= phi_in;
        fifo_y[cnt] <= y_in;
    end
end
// add by nvphong 17/6/24 adjust pineline signal empty and full to correct with lifo_x, lifo_y and lifo_phi
always @(posedge clk) begin
    empty <= empty_interal;
    full <= full_interal;
end
assign full_interal = (cnt == DEPTH);
assign empty_interal = (cnt == 0);
// assign x_out = (re_and_we_same_time) ? x_in : fifo_x[cnt-1];
// assign y_out = (re_and_we_same_time) ? y_in : fifo_y[cnt-1];
// assign phi_out = (re_and_we_same_time) ? phi_in : fifo_phi[cnt-1];
reg[msb_x:0] x_out;
reg[msb_phi:0] phi_out;
reg[msb_y:0] y_out;
always @(posedge clk) begin
    x_out <= (re_and_we_same_time) ? x_in : fifo_x[cnt-1];
    y_out <= (re_and_we_same_time) ? y_in : fifo_y[cnt-1];
    phi_out <= (re_and_we_same_time) ? phi_in : fifo_phi[cnt-1];
end
endmodule 

`timescale 1ns / 1ps
module ht_rho_phi_vote
#(parameter  h_fpga = 150, w_fpga = 450,
msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
thresh_gradien_add = 10,
thresh_gradien_sqrt = 16, //10*1.646760258121
dx_min = 5, dx_max = 50,
msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
msb_number_vote = 8,
msb_address_bkram = ((msb_rho-3+1) + (msb_phi+1) - 1),
msb_depth_ram = 8192, // (rho (9-3) bit * phi 7 bit = 13 bit -> 2^13 = 8192)
msb_sin = 9, msb_cos = 9,
DEPTH = 16, W = 450,
T = 2.2
)
(clk, reset, x_in, y_in, phi_in, lifo_empty, load_new_point, ht_rho_vote, ht_phi_vote, ht_valid_rho_phi_vote);
input clk, reset;
input[msb_x:0] x_in;
input[msb_y:0] y_in;
input[msb_phi:0] phi_in;
input lifo_empty;
output load_new_point;
output[msb_rho-3:0] ht_rho_vote;
output[msb_phi:0] ht_phi_vote;
output ht_valid_rho_phi_vote;

// condition load new point(x, y, phi) from module lifo_xyphi
reg[2:0] ht_denta_x; // mo rong toa do (x-2,y), (x-1,y), (x,y), (x+1,y), (x+2,y) tang accuracy
reg[3:0] ht_denta_phi; // xoay goc phi theo idea hought transform
reg ht_free;
wire reset_denta_x, reset_denta_phi;
wire done_loop_xphi, phi_eq_10;
wire set_ht_free, rst_ht_free;
//wire valid_gen_xyphi; add pineline signal valid_gen_xyphi (3/7/2024)
wire load_new_point;

assign phi_eq_10 = (ht_denta_phi == 10);
assign done_loop_xphi = (ht_denta_x == 4) & phi_eq_10;
assign load_new_point = (ht_free | done_loop_xphi) & (~lifo_empty);
assign reset_denta_x = load_new_point;
assign reset_denta_phi = load_new_point | phi_eq_10;
assign set_ht_free = (done_loop_xphi & lifo_empty) | reset;
assign rst_ht_free = load_new_point;
//assign valid_gen_xyphi = ~ht_free;
always @(posedge clk) begin
    if(set_ht_free) begin
        ht_free <= 1;
    end else begin
        if(rst_ht_free) ht_free <= 0;
    end
end
always @(posedge clk) begin
    //if(load_new_point) ht_denta_x <= 0;
    // add by nvphong: add reset to signal done_loop_xphi don't have x
    if(load_new_point | reset) ht_denta_x <= 0;
    else ht_denta_x <= ht_denta_x + phi_eq_10;
end
always @(posedge clk) begin
    //if(load_new_point | phi_eq_10) ht_denta_phi <= 0;
    // add by nvphong: add reset to signal phi_eq_10 don't have x
    if(load_new_point | phi_eq_10 | reset) ht_denta_phi <= 0;
    else ht_denta_phi <= ht_denta_phi + 1;
end
reg[msb_x:0] ht_x_tmp;
reg[msb_phi:0] ht_phi_tmp;
reg[msb_y:0] ht_y1, ht_y2, ht_y3;
always @(posedge clk) begin
    if(load_new_point) begin
        ht_x_tmp <= x_in - 2;
        ht_phi_tmp <= phi_in - 5;
        ht_y1 <= y_in;
    end
    //ht_y2 <= y_tmp;
end
// after load new point and loop [x-denta_x,y: x+denta_x:y] with [phi-denta_phi:phi+denta_phi] 
//wire ht_rho_in_roi;
wire[msb_sin:0] ht_sin_fxp;
wire[msb_cos:0] ht_cos_fxp;
reg[msb_phi:0] ht_phi_loop;
reg[msb_x:0] ht_x_loop, ht_x_loop_1;
reg[msb_x:0] ht_m1_x;
reg[msb_phi:0] ht_phi1, ht_phi2, ht_phi3, ht_phi4;
reg[msb_y:0] ht_m2_y;
reg[msb_sin:0] ht_m2_sin;
reg[msb_cos:0] ht_m1_cos;
always @(posedge clk) begin
    ht_phi_loop <= ht_phi_tmp + ht_denta_phi;
    //ht_phi_in_lut_sin <= phi_tmp + denta_phi;
    //ht_phi_in_lut_cos <= phi_tmp + denta_phi;
end
lut_sin md_lut_sin(.clk(clk), .phi_in(ht_phi_loop), .sin(ht_sin_fxp));
lut_cos md_lut_cos(.clk(clk), .phi_in(ht_phi_loop), .cos(ht_cos_fxp));
always @(posedge clk) begin
    ht_x_loop <= ht_x_tmp + ht_denta_x;
    ht_x_loop_1 <= ht_x_loop;
    ht_y2 <= ht_y1;
    ht_y3 <= ht_y2;
end
always @(posedge clk) begin
    ht_m1_x <= ht_x_loop_1;
    ht_m2_y <= ht_y3;
    ht_m1_cos <= ht_cos_fxp;
    ht_m2_sin <= ht_sin_fxp;
end
reg[(msb_rho*2+1):0] ht_m1, ht_m2;
reg[msb_rho-3:0] ht_rho;
always @(posedge clk) begin
    ht_m1 <= ht_m1_cos * {1'b0, ht_m1_x};
    ht_m2 <= ht_m2_sin * {2'b0, ht_m2_y};
    ht_rho <= ((ht_m1[(msb_rho*2+1):10] + ht_m2[(msb_rho*2+1):10]) >> 3);
    // ht_rho khong chia 8
    //ht_rho <= ((ht_m1[(msb_rho*2+1):10] + ht_m2[(msb_rho*2+1):10]));
end
always @(posedge clk) begin
    ht_phi1 <= ht_phi_loop;
    ht_phi2 <= ht_phi1;
    ht_phi3 <= ht_phi2;
    ht_phi4 <= ht_phi3;
end

reg ht_valid_gen_xyphi1, ht_valid_gen_xyphi2, ht_valid_gen_xyphi3, ht_valid_gen_xyphi4, ht_valid_gen_xyphi5;
always @(posedge clk) begin
    ht_valid_gen_xyphi1 <= ~ht_free;
    ht_valid_gen_xyphi2 <= ht_valid_gen_xyphi1;
    ht_valid_gen_xyphi3 <= ht_valid_gen_xyphi2;
    ht_valid_gen_xyphi4 <= ht_valid_gen_xyphi3;
    ht_valid_gen_xyphi5 <= ht_valid_gen_xyphi4;
end

// don't constraint ht_rho_vote; check rho_max/min để module voting check
//assign ht_rho_in_roi = (ht_rho >= rho_min) & (ht_rho <= rho_max);
assign ht_rho_vote = ht_rho;
assign ht_phi_vote = ht_phi4;
//assign ht_valid_rho_phi_vote = valid_gen_xyphi & ht_rho_in_roi;
assign ht_valid_rho_phi_vote = ht_valid_gen_xyphi5; // add pineline for signal valid_gen_xyphi
endmodule //endmodule rho_phi_vote & ht_rho_phi

`timescale 1ns / 1ps
module lut_sin
#(parameter  h_fpga = 150, w_fpga = 450,
msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
thresh_gradien_add = 10,
thresh_gradien_sqrt = 16, //10*1.646760258121
dx_min = 5, dx_max = 50,
msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
msb_number_vote = 8,
msb_address_bkram = ((msb_rho-3+1) + (msb_phi+1) - 1),
msb_depth_ram = 8192, // (rho (9-3) bit * phi 7 bit = 13 bit -> 2^13 = 8192)
msb_sin = 9, msb_cos = 9,
DEPTH = 16, W = 450,
T = 2.2
)
(clk, phi_in, sin);
input clk;
input[msb_phi:0] phi_in;
output[msb_sin:0] sin;

reg[msb_sin:0] lut_sin[0:phi_max];
//(* rom_style = "distributed" *) reg [msb_sin-1:0] lut_sin[0:(phi_max - phi_min)];
//reg[msb_phi:0] phi_in_q;
reg[msb_sin:0] sin_q;
// always @(posedge clk) begin
//     phi_in_q <= phi_in;
// end
always @(posedge clk) begin
    sin_q <= lut_sin[phi_in];
end
// always @(*) begin
//     sin_q <= lut_sin[phi_in_q];
// end
assign sin = sin_q;

initial begin
lut_sin[0] = 10'b0000000000; // hex=0x000 ht_sin_fxp[0]=0.0  phi=0
lut_sin[1] = 10'b0000010001; // hex=0x011 ht_sin_fxp[1]=0.0166015625  phi=1
lut_sin[2] = 10'b0000100011; // hex=0x023 ht_sin_fxp[2]=0.0341796875  phi=2
lut_sin[3] = 10'b0000110101; // hex=0x035 ht_sin_fxp[3]=0.0517578125  phi=3
lut_sin[4] = 10'b0001000111; // hex=0x047 ht_sin_fxp[4]=0.0693359375  phi=4
lut_sin[5] = 10'b0001011001; // hex=0x059 ht_sin_fxp[5]=0.0869140625  phi=5
lut_sin[6] = 10'b0001101011; // hex=0x06B ht_sin_fxp[6]=0.1044921875  phi=6
lut_sin[7] = 10'b0001111100; // hex=0x07C ht_sin_fxp[7]=0.12109375  phi=7
lut_sin[8] = 10'b0010001110; // hex=0x08E ht_sin_fxp[8]=0.138671875  phi=8
lut_sin[9] = 10'b0010100000; // hex=0x0A0 ht_sin_fxp[9]=0.15625  phi=9
lut_sin[10] = 10'b0010110001; // hex=0x0B1 ht_sin_fxp[10]=0.1728515625  phi=10
lut_sin[11] = 10'b0011000011; // hex=0x0C3 ht_sin_fxp[11]=0.1904296875  phi=11
lut_sin[12] = 10'b0011010100; // hex=0x0D4 ht_sin_fxp[12]=0.20703125  phi=12
lut_sin[13] = 10'b0011100110; // hex=0x0E6 ht_sin_fxp[13]=0.224609375  phi=13
lut_sin[14] = 10'b0011110111; // hex=0x0F7 ht_sin_fxp[14]=0.2412109375  phi=14
lut_sin[15] = 10'b0100001001; // hex=0x109 ht_sin_fxp[15]=0.2587890625  phi=15
lut_sin[16] = 10'b0100011010; // hex=0x11A ht_sin_fxp[16]=0.275390625  phi=16
lut_sin[17] = 10'b0100101011; // hex=0x12B ht_sin_fxp[17]=0.2919921875  phi=17
lut_sin[18] = 10'b0100111100; // hex=0x13C ht_sin_fxp[18]=0.30859375  phi=18
lut_sin[19] = 10'b0101001101; // hex=0x14D ht_sin_fxp[19]=0.3251953125  phi=19
lut_sin[20] = 10'b0101011110; // hex=0x15E ht_sin_fxp[20]=0.341796875  phi=20
lut_sin[21] = 10'b0101101110; // hex=0x16E ht_sin_fxp[21]=0.357421875  phi=21
lut_sin[22] = 10'b0101111111; // hex=0x17F ht_sin_fxp[22]=0.3740234375  phi=22
lut_sin[23] = 10'b0110010000; // hex=0x190 ht_sin_fxp[23]=0.390625  phi=23
lut_sin[24] = 10'b0110100000; // hex=0x1A0 ht_sin_fxp[24]=0.40625  phi=24
lut_sin[25] = 10'b0110110000; // hex=0x1B0 ht_sin_fxp[25]=0.421875  phi=25
lut_sin[26] = 10'b0111000000; // hex=0x1C0 ht_sin_fxp[26]=0.4375  phi=26
lut_sin[27] = 10'b0111010000; // hex=0x1D0 ht_sin_fxp[27]=0.453125  phi=27
lut_sin[28] = 10'b0111100000; // hex=0x1E0 ht_sin_fxp[28]=0.46875  phi=28
lut_sin[29] = 10'b0111110000; // hex=0x1F0 ht_sin_fxp[29]=0.484375  phi=29
lut_sin[30] = 10'b0111111111; // hex=0x1FF ht_sin_fxp[30]=0.4990234375  phi=30
lut_sin[31] = 10'b1000001111; // hex=0x20F ht_sin_fxp[31]=0.5146484375  phi=31
lut_sin[32] = 10'b1000011110; // hex=0x21E ht_sin_fxp[32]=0.529296875  phi=32
lut_sin[33] = 10'b1000101101; // hex=0x22D ht_sin_fxp[33]=0.5439453125  phi=33
lut_sin[34] = 10'b1000111100; // hex=0x23C ht_sin_fxp[34]=0.55859375  phi=34
lut_sin[35] = 10'b1001001011; // hex=0x24B ht_sin_fxp[35]=0.5732421875  phi=35
lut_sin[36] = 10'b1001011001; // hex=0x259 ht_sin_fxp[36]=0.5869140625  phi=36
lut_sin[37] = 10'b1001101000; // hex=0x268 ht_sin_fxp[37]=0.6015625  phi=37
lut_sin[38] = 10'b1001110110; // hex=0x276 ht_sin_fxp[38]=0.615234375  phi=38
lut_sin[39] = 10'b1010000100; // hex=0x284 ht_sin_fxp[39]=0.62890625  phi=39
lut_sin[40] = 10'b1010010010; // hex=0x292 ht_sin_fxp[40]=0.642578125  phi=40
lut_sin[41] = 10'b1010011111; // hex=0x29F ht_sin_fxp[41]=0.6552734375  phi=41
lut_sin[42] = 10'b1010101101; // hex=0x2AD ht_sin_fxp[42]=0.6689453125  phi=42
lut_sin[43] = 10'b1010111010; // hex=0x2BA ht_sin_fxp[43]=0.681640625  phi=43
lut_sin[44] = 10'b1011000111; // hex=0x2C7 ht_sin_fxp[44]=0.6943359375  phi=44
lut_sin[45] = 10'b1011010100; // hex=0x2D4 ht_sin_fxp[45]=0.70703125  phi=45
lut_sin[46] = 10'b1011100000; // hex=0x2E0 ht_sin_fxp[46]=0.71875  phi=46
lut_sin[47] = 10'b1011101100; // hex=0x2EC ht_sin_fxp[47]=0.73046875  phi=47
lut_sin[48] = 10'b1011111000; // hex=0x2F8 ht_sin_fxp[48]=0.7421875  phi=48
lut_sin[49] = 10'b1100000100; // hex=0x304 ht_sin_fxp[49]=0.75390625  phi=49
lut_sin[50] = 10'b1100010000; // hex=0x310 ht_sin_fxp[50]=0.765625  phi=50
lut_sin[51] = 10'b1100011011; // hex=0x31B ht_sin_fxp[51]=0.7763671875  phi=51
lut_sin[52] = 10'b1100100110; // hex=0x326 ht_sin_fxp[52]=0.787109375  phi=52
lut_sin[53] = 10'b1100110001; // hex=0x331 ht_sin_fxp[53]=0.7978515625  phi=53
lut_sin[54] = 10'b1100111100; // hex=0x33C ht_sin_fxp[54]=0.80859375  phi=54
lut_sin[55] = 10'b1101000110; // hex=0x346 ht_sin_fxp[55]=0.818359375  phi=55
lut_sin[56] = 10'b1101010000; // hex=0x350 ht_sin_fxp[56]=0.828125  phi=56
lut_sin[57] = 10'b1101011010; // hex=0x35A ht_sin_fxp[57]=0.837890625  phi=57
lut_sin[58] = 10'b1101100100; // hex=0x364 ht_sin_fxp[58]=0.84765625  phi=58
lut_sin[59] = 10'b1101101101; // hex=0x36D ht_sin_fxp[59]=0.8564453125  phi=59
lut_sin[60] = 10'b1101110110; // hex=0x376 ht_sin_fxp[60]=0.865234375  phi=60
lut_sin[61] = 10'b1101111111; // hex=0x37F ht_sin_fxp[61]=0.8740234375  phi=61
lut_sin[62] = 10'b1110001000; // hex=0x388 ht_sin_fxp[62]=0.8828125  phi=62
lut_sin[63] = 10'b1110010000; // hex=0x390 ht_sin_fxp[63]=0.890625  phi=63
lut_sin[64] = 10'b1110011000; // hex=0x398 ht_sin_fxp[64]=0.8984375  phi=64
lut_sin[65] = 10'b1110100000; // hex=0x3A0 ht_sin_fxp[65]=0.90625  phi=65
lut_sin[66] = 10'b1110100111; // hex=0x3A7 ht_sin_fxp[66]=0.9130859375  phi=66
lut_sin[67] = 10'b1110101110; // hex=0x3AE ht_sin_fxp[67]=0.919921875  phi=67
lut_sin[68] = 10'b1110110101; // hex=0x3B5 ht_sin_fxp[68]=0.9267578125  phi=68
lut_sin[69] = 10'b1110111011; // hex=0x3BB ht_sin_fxp[69]=0.9326171875  phi=69
lut_sin[70] = 10'b1111000010; // hex=0x3C2 ht_sin_fxp[70]=0.939453125  phi=70
lut_sin[71] = 10'b1111001000; // hex=0x3C8 ht_sin_fxp[71]=0.9453125  phi=71
lut_sin[72] = 10'b1111001101; // hex=0x3CD ht_sin_fxp[72]=0.9501953125  phi=72
lut_sin[73] = 10'b1111010011; // hex=0x3D3 ht_sin_fxp[73]=0.9560546875  phi=73
lut_sin[74] = 10'b1111011000; // hex=0x3D8 ht_sin_fxp[74]=0.9609375  phi=74
lut_sin[75] = 10'b1111011101; // hex=0x3DD ht_sin_fxp[75]=0.9658203125  phi=75
end
endmodule //endmodule lut_sin_cos

`timescale 1ns / 1ps
module lut_cos
#(parameter  h_fpga = 150, w_fpga = 450,
msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
thresh_gradien_add = 10,
thresh_gradien_sqrt = 16, //10*1.646760258121
dx_min = 5, dx_max = 50,
msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
msb_number_vote = 8,
msb_address_bkram = ((msb_rho-3+1) + (msb_phi+1) - 1),
msb_depth_ram = 8192, // (rho (9-3) bit * phi 7 bit = 13 bit -> 2^13 = 8192)
msb_sin = 9, msb_cos = 9,
DEPTH = 16, W = 450,
T = 2.2
)
(clk, phi_in, cos);
input clk;
input[msb_phi:0] phi_in;
output[msb_cos:0] cos;

reg[msb_cos:0] lut_cos[0:phi_max];
//(* rom_style = "distributed" *) reg [msb_cos-1:0] lut_cos[0:(phi_max - phi_min)];
//reg[msb_phi:0] phi_in_q;
reg[msb_cos:0] cos_q;
// always @(posedge clk) begin
//     phi_in_q <= phi_in;
// end
always @(posedge clk) begin
    cos_q <= lut_cos[phi_in];
end
// always @(*) begin
//     cos_q <= lut_cos[phi_in_q];
// end
assign cos = cos_q;
initial begin
lut_cos[0] = 10'b1111111111; // hex=0x3FF ht_cos_fxp[0]=0.9990234375 phi=0
lut_cos[1] = 10'b1111111111; // hex=0x3FF ht_cos_fxp[1]=0.9990234375 phi=1
lut_cos[2] = 10'b1111111111; // hex=0x3FF ht_cos_fxp[2]=0.9990234375 phi=2
lut_cos[3] = 10'b1111111110; // hex=0x3FE ht_cos_fxp[3]=0.998046875 phi=3
lut_cos[4] = 10'b1111111101; // hex=0x3FD ht_cos_fxp[4]=0.9970703125 phi=4
lut_cos[5] = 10'b1111111100; // hex=0x3FC ht_cos_fxp[5]=0.99609375 phi=5
lut_cos[6] = 10'b1111111010; // hex=0x3FA ht_cos_fxp[6]=0.994140625 phi=6
lut_cos[7] = 10'b1111111000; // hex=0x3F8 ht_cos_fxp[7]=0.9921875 phi=7
lut_cos[8] = 10'b1111110110; // hex=0x3F6 ht_cos_fxp[8]=0.990234375 phi=8
lut_cos[9] = 10'b1111110011; // hex=0x3F3 ht_cos_fxp[9]=0.9873046875 phi=9
lut_cos[10] = 10'b1111110000; // hex=0x3F0 ht_cos_fxp[10]=0.984375 phi=10
lut_cos[11] = 10'b1111101101; // hex=0x3ED ht_cos_fxp[11]=0.9814453125 phi=11
lut_cos[12] = 10'b1111101001; // hex=0x3E9 ht_cos_fxp[12]=0.9775390625 phi=12
lut_cos[13] = 10'b1111100101; // hex=0x3E5 ht_cos_fxp[13]=0.9736328125 phi=13
lut_cos[14] = 10'b1111100001; // hex=0x3E1 ht_cos_fxp[14]=0.9697265625 phi=14
lut_cos[15] = 10'b1111011101; // hex=0x3DD ht_cos_fxp[15]=0.9658203125 phi=15
lut_cos[16] = 10'b1111011000; // hex=0x3D8 ht_cos_fxp[16]=0.9609375 phi=16
lut_cos[17] = 10'b1111010011; // hex=0x3D3 ht_cos_fxp[17]=0.9560546875 phi=17
lut_cos[18] = 10'b1111001101; // hex=0x3CD ht_cos_fxp[18]=0.9501953125 phi=18
lut_cos[19] = 10'b1111001000; // hex=0x3C8 ht_cos_fxp[19]=0.9453125 phi=19
lut_cos[20] = 10'b1111000010; // hex=0x3C2 ht_cos_fxp[20]=0.939453125 phi=20
lut_cos[21] = 10'b1110111011; // hex=0x3BB ht_cos_fxp[21]=0.9326171875 phi=21
lut_cos[22] = 10'b1110110101; // hex=0x3B5 ht_cos_fxp[22]=0.9267578125 phi=22
lut_cos[23] = 10'b1110101110; // hex=0x3AE ht_cos_fxp[23]=0.919921875 phi=23
lut_cos[24] = 10'b1110100111; // hex=0x3A7 ht_cos_fxp[24]=0.9130859375 phi=24
lut_cos[25] = 10'b1110100000; // hex=0x3A0 ht_cos_fxp[25]=0.90625 phi=25
lut_cos[26] = 10'b1110011000; // hex=0x398 ht_cos_fxp[26]=0.8984375 phi=26
lut_cos[27] = 10'b1110010000; // hex=0x390 ht_cos_fxp[27]=0.890625 phi=27
lut_cos[28] = 10'b1110001000; // hex=0x388 ht_cos_fxp[28]=0.8828125 phi=28
lut_cos[29] = 10'b1101111111; // hex=0x37F ht_cos_fxp[29]=0.8740234375 phi=29
lut_cos[30] = 10'b1101110110; // hex=0x376 ht_cos_fxp[30]=0.865234375 phi=30
lut_cos[31] = 10'b1101101101; // hex=0x36D ht_cos_fxp[31]=0.8564453125 phi=31
lut_cos[32] = 10'b1101100100; // hex=0x364 ht_cos_fxp[32]=0.84765625 phi=32
lut_cos[33] = 10'b1101011010; // hex=0x35A ht_cos_fxp[33]=0.837890625 phi=33
lut_cos[34] = 10'b1101010000; // hex=0x350 ht_cos_fxp[34]=0.828125 phi=34
lut_cos[35] = 10'b1101000110; // hex=0x346 ht_cos_fxp[35]=0.818359375 phi=35
lut_cos[36] = 10'b1100111100; // hex=0x33C ht_cos_fxp[36]=0.80859375 phi=36
lut_cos[37] = 10'b1100110001; // hex=0x331 ht_cos_fxp[37]=0.7978515625 phi=37
lut_cos[38] = 10'b1100100110; // hex=0x326 ht_cos_fxp[38]=0.787109375 phi=38
lut_cos[39] = 10'b1100011011; // hex=0x31B ht_cos_fxp[39]=0.7763671875 phi=39
lut_cos[40] = 10'b1100010000; // hex=0x310 ht_cos_fxp[40]=0.765625 phi=40
lut_cos[41] = 10'b1100000100; // hex=0x304 ht_cos_fxp[41]=0.75390625 phi=41
lut_cos[42] = 10'b1011111000; // hex=0x2F8 ht_cos_fxp[42]=0.7421875 phi=42
lut_cos[43] = 10'b1011101100; // hex=0x2EC ht_cos_fxp[43]=0.73046875 phi=43
lut_cos[44] = 10'b1011100000; // hex=0x2E0 ht_cos_fxp[44]=0.71875 phi=44
lut_cos[45] = 10'b1011010100; // hex=0x2D4 ht_cos_fxp[45]=0.70703125 phi=45
lut_cos[46] = 10'b1011000111; // hex=0x2C7 ht_cos_fxp[46]=0.6943359375 phi=46
lut_cos[47] = 10'b1010111010; // hex=0x2BA ht_cos_fxp[47]=0.681640625 phi=47
lut_cos[48] = 10'b1010101101; // hex=0x2AD ht_cos_fxp[48]=0.6689453125 phi=48
lut_cos[49] = 10'b1010011111; // hex=0x29F ht_cos_fxp[49]=0.6552734375 phi=49
lut_cos[50] = 10'b1010010010; // hex=0x292 ht_cos_fxp[50]=0.642578125 phi=50
lut_cos[51] = 10'b1010000100; // hex=0x284 ht_cos_fxp[51]=0.62890625 phi=51
lut_cos[52] = 10'b1001110110; // hex=0x276 ht_cos_fxp[52]=0.615234375 phi=52
lut_cos[53] = 10'b1001101000; // hex=0x268 ht_cos_fxp[53]=0.6015625 phi=53
lut_cos[54] = 10'b1001011001; // hex=0x259 ht_cos_fxp[54]=0.5869140625 phi=54
lut_cos[55] = 10'b1001001011; // hex=0x24B ht_cos_fxp[55]=0.5732421875 phi=55
lut_cos[56] = 10'b1000111100; // hex=0x23C ht_cos_fxp[56]=0.55859375 phi=56
lut_cos[57] = 10'b1000101101; // hex=0x22D ht_cos_fxp[57]=0.5439453125 phi=57
lut_cos[58] = 10'b1000011110; // hex=0x21E ht_cos_fxp[58]=0.529296875 phi=58
lut_cos[59] = 10'b1000001111; // hex=0x20F ht_cos_fxp[59]=0.5146484375 phi=59
lut_cos[60] = 10'b1000000000; // hex=0x200 ht_cos_fxp[60]=0.5 phi=60
lut_cos[61] = 10'b0111110000; // hex=0x1F0 ht_cos_fxp[61]=0.484375 phi=61
lut_cos[62] = 10'b0111100000; // hex=0x1E0 ht_cos_fxp[62]=0.46875 phi=62
lut_cos[63] = 10'b0111010000; // hex=0x1D0 ht_cos_fxp[63]=0.453125 phi=63
lut_cos[64] = 10'b0111000000; // hex=0x1C0 ht_cos_fxp[64]=0.4375 phi=64
lut_cos[65] = 10'b0110110000; // hex=0x1B0 ht_cos_fxp[65]=0.421875 phi=65
lut_cos[66] = 10'b0110100000; // hex=0x1A0 ht_cos_fxp[66]=0.40625 phi=66
lut_cos[67] = 10'b0110010000; // hex=0x190 ht_cos_fxp[67]=0.390625 phi=67
lut_cos[68] = 10'b0101111111; // hex=0x17F ht_cos_fxp[68]=0.3740234375 phi=68
lut_cos[69] = 10'b0101101110; // hex=0x16E ht_cos_fxp[69]=0.357421875 phi=69
lut_cos[70] = 10'b0101011110; // hex=0x15E ht_cos_fxp[70]=0.341796875 phi=70
lut_cos[71] = 10'b0101001101; // hex=0x14D ht_cos_fxp[71]=0.3251953125 phi=71
lut_cos[72] = 10'b0100111100; // hex=0x13C ht_cos_fxp[72]=0.30859375 phi=72
lut_cos[73] = 10'b0100101011; // hex=0x12B ht_cos_fxp[73]=0.2919921875 phi=73
lut_cos[74] = 10'b0100011010; // hex=0x11A ht_cos_fxp[74]=0.275390625 phi=74
lut_cos[75] = 10'b0100001001; // hex=0x109 ht_cos_fxp[75]=0.2587890625 phi=75
end
endmodule //endmodule lut_cos

// Simple Dual-Port Block RAM with One Clock
module bkram
#(parameter  h_fpga = 150, w_fpga = 450,
msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
thresh_gradien_add = 10,
thresh_gradien_sqrt = 16, //10*1.646760258121
dx_min = 5, dx_max = 50,
msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
msb_number_vote = 8,
msb_address_bkram = ((msb_rho-3+1) + (msb_phi+1) - 1),
msb_depth_ram = 8192, // (rho (9-3) bit * phi 7 bit = 13 bit -> 2^13 = 8192)
msb_sin = 9, msb_cos = 9,
DEPTH = 16, W = 450,
T = 2.2
)
(clk, read_address, read_en, read_out, write_address, write_en, write_in);
input clk,read_en,write_en;
input [msb_address_bkram:0] write_address,read_address;
input [msb_number_vote:0] write_in;
output [msb_number_vote:0] read_out;
reg [msb_number_vote:0] ram [msb_depth_ram:0];
reg [msb_number_vote:0] read_out;
always @(posedge clk) begin
    if (write_en) begin
        ram[write_address] <= write_in;
    end
end
always @(posedge clk) begin
    if (read_en) begin
        read_out <= ram[read_address];
    end
end
integer i;
initial begin
    for(i = 0; i <= msb_depth_ram; i = i + 1) begin
        ram[i] <= 0;
    end
end
endmodule

module ht_voting
#(parameter  h_fpga = 150, w_fpga = 450,
msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
thresh_gradien_add = 10,
thresh_gradien_sqrt = 16, //10*1.646760258121
dx_min = 5, dx_max = 50,
msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
msb_number_vote = 8,
msb_address_bkram = ((msb_rho-3+1) + (msb_phi+1) - 1), 
msb_depth_ram = 8192, // (rho (9-3) bit * phi 7 bit = 13 bit -> 2^13 = 8192)
msb_sin = 9, msb_cos = 9,
DEPTH = 16, W = 450,
T = 3.4
)
(clk, reset, rho_vote, phi_vote, valid_rho_phi_vote, number_vote);

input clk, reset;
input[(msb_rho-3):0] rho_vote;
input[msb_phi:0] phi_vote;
input valid_rho_phi_vote;
output[msb_number_vote:0] number_vote;

reg[msb_number_vote:0] number_vote;
reg vt_read_en, vt_write_en;
reg[msb_address_bkram:0] vt_read_address, vt_write_address;
wire[msb_number_vote:0] vt_read_out;
//reg[msb_number_vote:0] vt_write_in; don't use signal, instead of use bk_vt_write_en

reg bk_vt_write_en;
reg[msb_address_bkram:0] bk_vt_write_address;
reg[msb_number_vote:0] bk_vt_write_in;

reg fv_read_en, fv_write_en;
reg[msb_address_bkram:0] fv_read_address, fv_write_address;
wire[msb_number_vote:0] fv_read_out;
reg[msb_number_vote:0] fv_write_in;

reg[msb_address_bkram:0] fv_rst_cnt; // frame voting reset parallel 
reg fv_done_rst_mode, fv_ff, fv_fd; // frame voting reset parallel

always @(posedge clk) begin
    vt_read_en <= valid_rho_phi_vote;
    vt_read_address <= rho_vote * phi_vote;
    vt_write_address <= vt_read_address;
    vt_write_en <= vt_read_en;
end
always @(*) begin
    bk_vt_write_address <= (vt_write_en) ? vt_write_address : fv_rst_cnt;
    bk_vt_write_in <= (vt_write_en) ? (fv_fd ? 1 : (vt_read_out + 1)) : 0;
    bk_vt_write_en <= (vt_write_en) ? vt_write_en : (~fv_done_rst_mode);
    number_vote <= vt_read_out;
end
bkram md_bkram_vt(.clk(clk), .read_address(vt_read_address), .read_en(vt_read_en), .read_out(vt_read_out),
.write_address(bk_vt_write_address), .write_en(bk_vt_write_en), .write_in(bk_vt_write_in));

always @(*) begin
    fv_read_address <= vt_read_address;
    fv_read_en <= vt_read_en;
    fv_write_address <= fv_rst_cnt;
    fv_write_en <= ~fv_done_rst_mode;
    fv_write_in <= fv_ff;
end
bkram md_bkram_fv(.clk(clk), .read_address(fv_read_address), .read_en(fv_read_en), .read_out(fv_read_out),
.write_address(fv_write_address), .write_en(fv_write_en), .write_in(fv_write_in));

always @(*) begin
    fv_fd <= fv_read_out ^ fv_ff;
    fv_done_rst_mode <= (fv_rst_cnt == msb_depth_ram);
end
always @(posedge clk) begin
    if(reset) begin
        fv_rst_cnt <= 0;
    end
    else begin 
        if (vt_write_en | fv_done_rst_mode) begin
            fv_rst_cnt <= fv_rst_cnt;
        end
        else begin
            fv_rst_cnt <= fv_rst_cnt + 1;
        end
    end
end
initial begin
    fv_ff <= 0;
end
always @(posedge clk) begin
    if(reset) fv_ff <= ~fv_ff;
    else fv_ff <= fv_ff;
end
endmodule

module ht_pick_max
#(parameter  h_fpga = 150, w_fpga = 450,
msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
thresh_gradien_add = 10,
thresh_gradien_sqrt = 16, //10*1.646760258121
dx_min = 5, dx_max = 50,
msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
msb_number_vote = 8,
msb_address_bkram = ((msb_rho-3+1) + (msb_phi+1) - 1),
msb_depth_ram = 8192, // (rho (9-3) bit * phi 7 bit = 13 bit -> 2^13 = 8192)
msb_sin = 9, msb_cos = 9,
DEPTH = 16, W = 450,
T = 2.2
)
(clk, reset, rho_vote, phi_vote, valid_rho_phi_vote, number_vote, rho_pick, phi_pick);

input clk, reset;
input[(msb_rho-3):0] rho_vote;
input[msb_phi:0] phi_vote;
input valid_rho_phi_vote;
input[msb_number_vote:0] number_vote;

output[(msb_rho-3):0] rho_pick;
output[msb_phi:0] phi_pick;

reg[(msb_rho-3):0] rho_pick;
reg[msb_phi:0] phi_pick;
reg[msb_number_vote:0] number_vote_pick;

wire switch;
wire n_vote_lt;
wire[msb_number_vote:0] a1;

reg[(msb_rho-3):0] rho_vote_1, rho_vote_2, rho_vote_3;
reg[msb_phi:0] phi_vote_1, phi_vote_2, phi_vote_3;
reg valid_rho_phi_vote_1, valid_rho_phi_vote_2, valid_rho_phi_vote_3;
reg[msb_number_vote:0] number_vote_inc1;

always @(posedge clk) begin
    rho_vote_1 <= rho_vote;
    rho_vote_2 <= rho_vote_1;
    rho_vote_3 <= rho_vote_2;

    phi_vote_1 <= phi_vote;
    phi_vote_2 <= phi_vote_1;
    phi_vote_3 <= phi_vote_2;
    
    valid_rho_phi_vote_1 <= valid_rho_phi_vote;
    valid_rho_phi_vote_2 <= valid_rho_phi_vote_1;
    valid_rho_phi_vote_3 <= valid_rho_phi_vote_2;
    number_vote_inc1 <= number_vote + 1;
end

assign {n_vote_lt, a1} = number_vote_pick - number_vote_inc1;
assign switch = valid_rho_phi_vote_3 & n_vote_lt;

always @(posedge clk) begin
    if(reset) begin
        rho_pick <= 0;
        phi_pick <= 0;
        number_vote_pick <= 0;
    end else begin
        if(switch) begin
            rho_pick <= rho_vote_3;
            phi_pick <= phi_vote_3;
            number_vote_pick <= number_vote_inc1;
        end
    end
end
endmodule

`timescale 1ns / 1ps
module TOP
#(parameter  h_fpga = 150, w_fpga = 450,
msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
thresh_gradien_add = 10,
thresh_gradien_sqrt = 16, //10*1.646760258121
dx_min = 5, dx_max = 50,
msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
msb_number_vote = 8,
msb_address_bkram = ((msb_rho-3+1) + (msb_phi+1) - 1),
msb_depth_ram = 8192, // (rho (9-3) bit * phi 7 bit = 13 bit -> 2^13 = 8192)
msb_sin = 9, msb_cos = 9,
DEPTH = 16, W = 450,
T = 2.2
)
(clk, reset, in_xy_valid, in_new_pixel, in_x_nms, in_y_nms, in_end_one_row, out_ht_rho_pick, out_ht_phi_pick);
input clk, reset;
input[7:0] in_new_pixel;
input[msb_x:0] in_x_nms;
input[msb_y:0] in_y_nms;
input in_xy_valid;
input in_end_one_row;
output[(msb_rho-3):0] out_ht_rho_pick;
output[msb_phi:0] out_ht_phi_pick;

//=======Define all signal=======================
reg[7:0] new_pixel;
reg end_one_row;
// === pineline x,y coordinntes and signal end_one_row* ==========
reg[msb_x:0] x_nms1, x_nms2, x_nms3, x_nms4, x_nms5, x_nms6, x_nms7, x_nms8, x_nms9, x_nms10, x_nms11;
reg[msb_y:0] y_nms1, y_nms2, y_nms3, y_nms4, y_nms5, y_nms6, y_nms7, y_nms8, y_nms9, y_nms10, y_nms11, y_nms12, y_nms13;
reg end_one_row1, end_one_row2, end_one_row3, end_one_row4, end_one_row5, end_one_row6, end_one_row7, end_one_row8, end_one_row9, end_one_row10, end_one_row11; 
reg xy_valid1, xy_valid2, xy_valid3, xy_valid4, xy_valid5, xy_valid6, xy_valid7, xy_valid8, xy_valid9, xy_valid10, xy_valid11, xy_valid12;
//==============MODULE line_buffer1 -> gaussian -> line_buffer2==================
wire[8*9-1:0] w3x3_first, w3x3_second;
wire[7:0] gray_after_filter;
//=============MODULE sobel_x and sobel_y=========================
reg[7:0] g1,g2,g3,g4,g5,g6,g7,g8,g9;
reg[msb_gradien:0] sbx_a1, sbx_a2, sbx_a3, sbx_a4, sbx_a5, sbx_a6;
reg sbx_sign_gx;
reg[msb_gradien:0] sbx_mux1;
reg[msb_gradien:0] sby_a1, sby_a2, sby_a3, sby_a4, sby_a5, sby_a6;
reg sby_sign_gy;
reg[msb_gradien:0] sby_mux1;
//=====================MODULE cordic===================================
reg[msb_gradien:0] cd_y1, cd_y2, cd_y3, cd_y4, cd_y5, cd_y6;
reg[msb_gradien:0] cd_x1, cd_x2, cd_x3, cd_x4, cd_x5, cd_x6, cd_x7;
reg[msb_cordic_phi:0] cd_phi2, cd_phi3, cd_phi4, cd_phi5, cd_phi6;
reg[msb_phi:0] cd_phi7, cd_phi8;
reg cd_signy1, cd_signy2, cd_signy3, cd_signy4, cd_signy5, cd_signy6;
// ===============MODULE check angle left and rigth==============================
wire flag_left; 
reg ck_angle_left;
reg ck_angle_right;
reg ck_angle_in_roi_1;
reg ck_angle_in_roi_2;
reg ck_angle_in_roi_3;
reg ck_angle_in_roi_4;
reg ck_angle_in_roi_5;
reg ck_angle_in_roi_6;
reg ck_angle_in_roi_7;
// =====check gradien add=============
reg ck_gadd_1;
reg ck_gadd_2;
reg ck_gadd_3;
reg ck_gadd_4;
reg ck_gadd_5;
reg ck_gadd_6;
// ===========check (gradien_add > thresh & gradien_sqrt > thresh & phi in roi)============
reg ck_g_phi;
reg nms_ckgphi_g4;
reg nms_ckgphi_g5;
reg nms_ckgphi_g456;
// =============MODULE nms [gradien add (G1 + G2)]================
reg[msb_gradien:0] nms_gadd_g4;
reg nms_gadd_sign_g54;
reg nms_gadd_g456_1;
reg nms_gadd_g456_2;
reg nms_gadd_g456_3;
reg nms_gadd_g456_4;
reg nms_gadd_g456_5;
reg nms_gadd_g456_6;
reg[msb_gradien:0] nms_gadd_g5_sub_g4;
reg nms_all;
// ==========MODULE phiavg=========================
reg[msb_phi:0] phiavg_1, phiavg_2, phiavg_3;
// ===========MODULE rising falling============================
reg[7:0] rf_g4_sub_g5;
reg[7:0] rf_g5_sub_g6;
reg rf_g45_eq0, rf_g45_sign;
reg rf_g56_eq0, rf_g56_sign;
reg rf_flag_rise_1, rf_flag_rise_2, rf_flag_rise_3, rf_flag_rise_4, rf_flag_rise_5, rf_flag_rise_6, rf_flag_rise_7, rf_flag_rise_8, rf_flag_rise_9;  
reg rf_flag_fall_1, rf_flag_fall_2, rf_flag_fall_3, rf_flag_fall_4, rf_flag_fall_5, rf_flag_fall_6, rf_flag_fall_7, rf_flag_fall_8, rf_flag_fall_9;
reg rf_flag_rise_all;
reg rf_flag_fall_all;
// ===================MODULE lane_point=========================================
reg lp_edge_rise, lp_edge_fall, lp_flag_rised, lp_valid1, lp_valid2;
reg[msb_x:0] lp_x, lp_x_mid, lp_denta_x;
reg[msb_phi:0] lp_phi, lp_phi_mid;
reg lp_check_width;
// =============MODULE lifo============================================
wire lifo_read, lifo_empty, lifo_full;
wire[msb_x:0] lifo_x;
wire[msb_phi:0] lifo_phi;
wire[msb_y:0] lifo_y;
wire[msb_rho-3:0] ht_rho_vote;
wire[msb_phi:0] ht_phi_vote;
wire ht_valid_rho_phi_vote;
wire[msb_number_vote:0] ht_number_vote;
wire[msb_rho-3:0] ht_rho_pick;
wire[msb_phi:0] ht_phi_pick;
reg[msb_rho-3:0] out_ht_rho_pick;
reg[msb_phi:0] out_ht_phi_pick;

always @(posedge clk) begin
    new_pixel <= in_new_pixel;
end
always @(posedge clk) begin
    x_nms1 <= in_x_nms;
    x_nms2 <= x_nms1;
    x_nms3 <= x_nms2;
    x_nms4 <= x_nms3;
    x_nms5 <= x_nms4;
    x_nms6 <= x_nms5;
    x_nms7 <= x_nms6;
    x_nms8 <= x_nms7;
    x_nms9 <= x_nms8;
    x_nms10 <= x_nms9;
    x_nms11 <= x_nms10;
end
always @(posedge clk) begin
    y_nms1 <= in_y_nms;
    y_nms2 <= y_nms1;
    y_nms3 <= y_nms2;
    y_nms4 <= y_nms3;
    y_nms5 <= y_nms4;
    y_nms6 <= y_nms5;
    y_nms7 <= y_nms6;
    y_nms8 <= y_nms7;
    y_nms9 <= y_nms8;
    y_nms10 <= y_nms9;
    y_nms11 <= y_nms10;
    y_nms12 <= y_nms11;
    y_nms13 <= y_nms12;
end
always @(posedge clk) begin
    xy_valid1 <= in_xy_valid;
    xy_valid2 <= xy_valid1;
    xy_valid3 <= xy_valid2;
    xy_valid4 <= xy_valid3;
    xy_valid5 <= xy_valid4;
    xy_valid6 <= xy_valid5;
    xy_valid7 <= xy_valid6;
    xy_valid8 <= xy_valid7;
    xy_valid9 <= xy_valid8;
    xy_valid10 <= xy_valid9;
    xy_valid11 <= xy_valid10;
    xy_valid12 <= xy_valid11;
end
always @(posedge clk) begin
    end_one_row1 <= in_end_one_row;
    end_one_row2 <= end_one_row1;
    end_one_row3 <= end_one_row2;
    end_one_row4 <= end_one_row3;
    end_one_row5 <= end_one_row4;
    end_one_row6 <= end_one_row5;
    end_one_row7 <= end_one_row6;
    end_one_row8 <= end_one_row7;
    end_one_row9 <= end_one_row8;
    end_one_row10 <= end_one_row9;
    end_one_row11 <= end_one_row10;
end
//==============MODULE line_buffer1 -> gaussian -> line_buffer2==================
// wire[8*9-1:0] w3x3_first, w3x3_second;
// wire[7:0] gray_after_filter;
line_buffer1 #(.W(w_fpga)) line_buffer1_md(.clk(clk), .new_pixel(new_pixel), .gray3x3_out(w3x3_first));
gaussian gaussian_md(.clk(clk), .gray3x3_in(w3x3_first), .gray_after_filter(gray_after_filter));
line_buffer2 #(.W(w_fpga)) line_buffer2_md(.clk(clk), .gray_after_filter(gray_after_filter), .gray3x3_out(w3x3_second));
//=============MODULE sobel_x and sobel_y=========================
// reg[7:0] g1,g2,g3,g4,g5,g6,g7,g8,g9;
// reg[msb_gradien:0] sbx_a1, sbx_a2, sbx_a3, sbx_a4, sbx_a5, sbx_a6;
// reg sbx_sign_gx;
// reg[msb_gradien:0] sbx_mux1;
always @(posedge clk) begin
    {g1, g2, g3, g4, g5, g6, g7, g8, g9} <= w3x3_second;
end
always @(posedge clk) begin
    sbx_a2 <= g3 + g9 + (g6 << 1);
    sbx_a4 <= g1 + g7 + (g4 << 1);
end
always @(*) begin
    sbx_a5 <= sbx_a2 - sbx_a4;
    sbx_a6 <= sbx_a4 - sbx_a2;
    sbx_sign_gx <= sbx_a5[msb_gradien];
    sbx_mux1 <= (sbx_sign_gx) ? sbx_a6 : sbx_a5;
end
//reg[msb_gradien:0] sby_a1, sby_a2, sby_a3, sby_a4, sby_a5, sby_a6;
//reg sby_sign_gy;
//reg[msb_gradien:0] sby_mux1;
always @(posedge clk) begin
    sby_a2 <= g7 + g9 + (g8 << 1);
    sby_a4 <= g1 + g3 + (g2 << 1);
end
always @(*) begin
    sby_a5 <= sby_a2 - sby_a4;
    sby_a6 <= sby_a4 - sby_a2;
    sby_sign_gy <= sby_a5[msb_gradien];
    sby_mux1 <= (sby_sign_gy) ? sby_a6 : sby_a5;
end
//=====================MODULE cordic===================================
// hiện cordic này tính góc phi ra sai rất nhiều, cần thời gian nghiên cứu thêm
// cần hiện thực all datapath bằng python, rồi từ đó đánh giá có cần phi_agv hay không

// reg[msb_gradien:0] cd_y1, cd_y2, cd_y3, cd_y4, cd_y5, cd_y6;
// reg[msb_gradien:0] cd_x1, cd_x2, cd_x3, cd_x4, cd_x5, cd_x6, cd_x7;
// reg[msb_cordic_phi:0] cd_phi2, cd_phi3, cd_phi4, cd_phi5, cd_phi6;
// reg[msb_phi:0] cd_phi7;
// wire cd_signy1, cd_signy2, cd_signy3, cd_signy4, cd_signy5, cd_signy6;

always @(*) begin
    cd_signy1 <= cd_y1[msb_gradien];
    cd_signy2 <= cd_y2[msb_gradien];
    cd_signy3 <= cd_y3[msb_gradien];
    cd_signy4 <= cd_y4[msb_gradien];
    cd_signy5 <= cd_y5[msb_gradien];
    cd_signy6 <= cd_y6[msb_gradien];
end
wire[msb_cordic_phi:0] cd_romphi[0:6]; // Fix point 16 bit - 9 bit faction(UQ7.9)
assign cd_romphi[0] = 16'b0101101000000000; // hex=0x5A00 phi_fx[0]=45.0             phi[0]=45.0000000000001 
assign cd_romphi[1] = 16'b0011010100100001; // hex=0x3521 phi_fx[1]=26.564453125             phi[1]=26.56505117707821 
assign cd_romphi[2] = 16'b0001110000010010; // hex=0x1C12 phi_fx[2]=14.03515625             phi[2]=14.03624346792624
assign cd_romphi[3] = 16'b0000111001000000; // hex=0x0E40 phi_fx[3]=7.125             phi[3]=7.125016348901715
assign cd_romphi[4] = 16'b0000011100100111; // hex=0x0727 phi_fx[4]=3.576171875             phi[4]=3.576334374997503
assign cd_romphi[5] = 16'b0000001110010100; // hex=0x0394 phi_fx[5]=1.7890625             phi[5]=1.789910608246168
assign cd_romphi[6] = 16'b0000000111001010; // hex=0x01CA phi_fx[6]=0.89453125             phi[6]=0.8951737102112559
always @(posedge clk) begin
    cd_y1 <= sby_mux1 - sbx_mux1;
    cd_x1 <= sbx_mux1 + sby_mux1;
    
    cd_y2 <= (cd_signy1) ? cd_y1 + (cd_x1 >> 1) : cd_y1 - (cd_x1 >> 1);
    cd_x2 <= (cd_signy1) ? cd_x1 - (cd_y1 >> 1) : cd_x1 + (cd_y1 >> 1);
    cd_phi2 <= (cd_signy1) ? cd_romphi[0] + cd_romphi[1] : cd_romphi[0] - cd_romphi[1];

    cd_y3 <= (cd_signy2) ? cd_y2 + (cd_x2 >> 2) : cd_y2 - (cd_x2 >> 2);
    cd_x3 <= (cd_signy2) ? cd_x2 - (cd_y2 >> 2) : cd_x2 + (cd_y2 >> 2);
    cd_phi3 <= (cd_signy2) ? cd_phi2 + cd_romphi[2] : cd_phi2 - cd_romphi[2];

    cd_y4 <= (cd_signy3) ? cd_y3 + (cd_x3 >> 3) : cd_y3 - (cd_x3 >> 3);
    cd_x4 <= (cd_signy3) ? cd_x3 - (cd_y3 >> 3) : cd_x3 + (cd_y3 >> 3);
    cd_phi4 <= (cd_signy3) ? cd_phi3 + cd_romphi[3] : cd_phi3 - cd_romphi[3];

    cd_y5 <= (cd_signy4) ? cd_y4 + (cd_x4 >> 4) : cd_y4 - (cd_x4 >> 4);
    cd_x5 <= (cd_signy4) ? cd_x4 - (cd_y4 >> 4) : cd_x4 + (cd_y4 >> 4);
    cd_phi5 <= (cd_signy4) ? cd_phi4 + cd_romphi[4] : cd_phi4 - cd_romphi[4];

    cd_y6 <= (cd_signy5) ? cd_y5 + (cd_x5 >> 5) : cd_y5 - (cd_x5 >> 5);
    cd_x6 <= (cd_signy5) ? cd_x5 - (cd_y5 >> 5) : cd_x5 + (cd_y5 >> 5);
    cd_phi6 <= (cd_signy5) ? cd_phi5 + cd_romphi[5] : cd_phi5 - cd_romphi[5];

    cd_x7 <= (cd_signy6) ? (cd_x6 - (cd_y6 >> 6)) : (cd_x6 + (cd_y6 >> 6));
    cd_phi7 <= (cd_signy6) ? (cd_phi6[15:9] + cd_romphi[6][15:9]) : (cd_phi6[15:9] - cd_romphi[6][15:9]);
end
// add cd_phi8 to debug invert cd_phi7
always @(*) begin
    cd_phi8 <= 90 - cd_phi7;
end
// always @(*) begin
//     cd_y2 <= (cd_signy1) ? cd_y1 + (cd_x1 >> 1) : cd_y1 - (cd_x1 >> 1);
//     cd_x2 <= (cd_signy1) ? cd_x1 - (cd_y1 >> 1) : cd_x1 + (cd_y1 >> 1);
//     cd_phi2 <= (cd_signy1) ? cd_romphi[0] + cd_romphi[1] : cd_romphi[0] - cd_romphi[1];

//     cd_y4 <= (cd_signy3) ? cd_y3 + (cd_x3 >> 3) : cd_y3 - (cd_x3 >> 3);
//     cd_x4 <= (cd_signy3) ? cd_x3 - (cd_y3 >> 2) : cd_x3 + (cd_y3 >> 3);
//     cd_phi4 <= (cd_signy3) ? cd_phi3 + cd_romphi[3] : cd_phi3 - cd_romphi[3];

//     cd_y6 <= (cd_signy5) ? cd_y5 + (cd_x5 >> 5) : cd_y5 - (cd_x5 >> 5);
//     cd_x6 <= (cd_signy5) ? cd_x5 - (cd_y5 >> 5) : cd_x5 + (cd_y5 >> 5);
//     cd_phi6 <= (cd_signy5) ? cd_phi5 + cd_romphi[5] : cd_phi5 - cd_romphi[5];
// end
// ===============MODULE check angle left and rigth==============================
// wire flag_left; 
// reg ck_angle_left;
// reg ck_angle_right;
// reg ck_angle_in_roi_1;
// reg ck_angle_in_roi_2;
// reg ck_angle_in_roi_3;
// reg ck_angle_in_roi_4;
// always @(*) begin
//     flag_left <= 1'b1; // if rtl here, flag_left always tied X
// end
assign flag_left = 1'b1;
always @(*) begin
    //ck_angle_left = (sbx_sign_gx & sby_sign_gy) | (~sbx_sign_gx & ~sby_sign_gy);
    // thay đổi reg tương ứng xor
    ck_angle_left = ~(sbx_sign_gx ^ sby_sign_gy);
    ck_angle_right = ~ck_angle_left;
end
always @(posedge clk) begin
    ck_angle_in_roi_1 <= (flag_left) ? ck_angle_left : ck_angle_right;
    ck_angle_in_roi_2 <= ck_angle_in_roi_1;
    ck_angle_in_roi_3 <= ck_angle_in_roi_2;
    ck_angle_in_roi_4 <= ck_angle_in_roi_3;
    ck_angle_in_roi_5 <= ck_angle_in_roi_4;
    ck_angle_in_roi_6 <= ck_angle_in_roi_5;
    ck_angle_in_roi_7 <= ck_angle_in_roi_6;
end
// =====check gradien add=============
// reg ck_gadd_1;
// reg ck_gadd_2;
// reg ck_gadd_3;
always @(posedge clk) begin
    ck_gadd_1 <= (cd_x1 > thresh_gradien_add);
    ck_gadd_2 <= ck_gadd_1;
    ck_gadd_3 <= ck_gadd_2;
    ck_gadd_4 <= ck_gadd_3;
    ck_gadd_5 <= ck_gadd_4;
    ck_gadd_6 <= ck_gadd_5;
end
// ===========check (gradien_add > thresh & gradien_sqrt > thresh & phi in roi)============
// reg ck_g_phi;
// reg nms_ckgphi_g4;
// reg nms_ckgphi_g5;
// reg nms_ckgphi_g456;
always @(*) begin
    // ck_g_phi <= ck_angle_in_roi_7 & ck_gadd_6 & (cd_x7 > thresh_gradien_sqrt) & (cd_phi7 > phi_min) & (cd_phi7 < phi_max);
    // add by nvphong 16/6/24 remove check gradien_sqrt;
    ck_g_phi <= ck_angle_in_roi_7 & ck_gadd_6 & (cd_phi8 > phi_min) & (cd_phi8 < phi_max);
    nms_ckgphi_g456 <= ck_g_phi & nms_ckgphi_g5 & nms_ckgphi_g4;
end
always @(posedge clk) begin
    nms_ckgphi_g5 <= ck_g_phi;
    nms_ckgphi_g4 <= nms_ckgphi_g5;
end
// =============MODULE nms [gradien add (G1 + G2)]================
// reg[msb_gradien:0] nms_gadd_g4;
// reg nms_gadd_sign_g54;
// reg nms_gadd_g456_1;
// reg nms_gadd_g456_2;
// reg nms_gadd_g456_3;
//reg[msb_gradien:0] nms_gadd_g5_sub_g4;
always @(*) begin
    nms_gadd_g5_sub_g4 <= cd_x1 - nms_gadd_g4;
end
always @(posedge clk) begin
    nms_gadd_g4 <= cd_x1; 
    nms_gadd_sign_g54 <= (nms_gadd_g5_sub_g4 == 0) | nms_gadd_g5_sub_g4[msb_gradien];
    nms_gadd_g456_1 <= nms_gadd_g5_sub_g4[msb_gradien] & (~nms_gadd_sign_g54);
    nms_gadd_g456_2 <= nms_gadd_g456_1;
    nms_gadd_g456_3 <= nms_gadd_g456_2;
    nms_gadd_g456_4 <= nms_gadd_g456_3;
    nms_gadd_g456_5 <= nms_gadd_g456_4;
    nms_gadd_g456_6 <= nms_gadd_g456_5;
end
// add by nvphong 16/6/24 remove check along with gradien_sqrt
// ==========MODULE nms [gradien sqrt (sqrt(G1 + G2))]===================
// reg nms_gsqrt_g4;
// reg nms_gsqrt_sign_g54;
// reg[msb_gradien:0] nms_gsqrt_g5_sub_g4;
// reg nms_gsqrt_g456; 
// always @(*) begin
//     nms_gsqrt_g5_sub_g4 <= cd_x7 - nms_gsqrt_g4;   
//     nms_gsqrt_g456 <= nms_gsqrt_g5_sub_g4[msb_gradien] & (~nms_gsqrt_sign_g54);
// end
// always @(posedge clk) begin
//     nms_gsqrt_g4 <= cd_x7;
//     nms_gsqrt_sign_g54 <= nms_gsqrt_g5_sub_g4[msb_gradien] | (nms_gsqrt_g5_sub_g4 == 0);
// end
// ========MODULE nms [signal nms_all]=====================
// reg nms_all;
always @(*) begin
    // nms_all <= nms_gadd_g456_3 & nms_ckgphi_g456 & nms_gsqrt_g456;
    // add by nvphong 16/6/24 remove check with nms_gsqrt_g456
    nms_all <= nms_gadd_g456_6 & nms_ckgphi_g456;
end
// ==========MODULE phiavg=========================
// reg[msb_phi:0] phiavg_1, phiavg_2, phiavg_3;
always @(*) begin
    phiavg_3 <= (cd_phi8 >> 2) + (phiavg_1 >> 1) + (phiavg_2 >> 2);
end
always @(posedge clk) begin
    phiavg_1 <= cd_phi8;
    phiavg_2 <= phiavg_1;
end
// ===========MODULE rising falling============================
// reg[7:0] rf_g4_sub_g5;
// reg[7:0] rf_g5_sub_g6;
// reg rf_g45_eq0, rf_g45_sign;
// reg rf_g56_eq0, rf_g56_sign;
// reg rf_flag_rise_1, rf_flag_rise_2, rf_flag_rise_3, rf_flag_rise_4, rf_flag_rise_5, rf_flag_rise_6;  
// reg rf_flag_fall_1, rf_flag_fall_2, rf_flag_fall_3, rf_flag_fall_4, rf_flag_fall_5, rf_flag_fall_6;
// reg rf_flag_rise_all;
// reg rf_flag_fall_all;
always @(*) begin
    rf_g4_sub_g5 <= g4 - g5;
    rf_g5_sub_g6 <= g5 - g6;
end
always @(posedge clk) begin
    rf_g45_eq0 <= (rf_g4_sub_g5 == 0);
    rf_g45_sign <= rf_g4_sub_g5[7];
    rf_g56_eq0 <= (rf_g5_sub_g6 == 0);
    rf_g56_sign <= rf_g5_sub_g6[7];
end
always @(posedge clk) begin
    rf_flag_rise_1 <= (rf_g45_eq0 | rf_g45_sign) & (rf_g56_eq0 | rf_g56_sign);
    rf_flag_rise_2 <= rf_flag_rise_1;
    rf_flag_rise_3 <= rf_flag_rise_2;
    rf_flag_rise_4 <= rf_flag_rise_3;
    rf_flag_rise_5 <= rf_flag_rise_4;
    rf_flag_rise_6 <= rf_flag_rise_5;
    rf_flag_rise_7 <= rf_flag_rise_6;
    rf_flag_rise_8 <= rf_flag_rise_7;
    rf_flag_rise_9 <= rf_flag_rise_8;
end
always @(posedge clk) begin
    rf_flag_fall_1 <= ~(rf_g45_sign | rf_g56_sign);
    rf_flag_fall_2 <= rf_flag_fall_1;
    rf_flag_fall_3 <= rf_flag_fall_2;
    rf_flag_fall_4 <= rf_flag_fall_3;
    rf_flag_fall_5 <= rf_flag_fall_4;
    rf_flag_fall_6 <= rf_flag_fall_5;
    rf_flag_fall_7 <= rf_flag_fall_6;
    rf_flag_fall_8 <= rf_flag_fall_7;
    rf_flag_fall_9 <= rf_flag_fall_8;
end
always @(*) begin
    rf_flag_rise_all <= rf_flag_rise_7 & rf_flag_rise_8 & rf_flag_rise_9;
    rf_flag_fall_all <= rf_flag_fall_7 & rf_flag_fall_8 & rf_flag_fall_9;
end
// ===================MODULE lane_point=========================================
// reg lp_edge_rise, lp_edge_fall, lp_flag_rised, lp_valid1, lp_valid2;
// reg[msb_x:0] lp_x, lp_x_mid, lp_denta_x;
// reg[msb_phi:0] lp_phi, lp_phi_mid;
// reg lp_check_width;
always @(*) begin
    lp_edge_rise <= nms_all & rf_flag_rise_all;
    lp_edge_fall <= nms_all & rf_flag_fall_all;
    lp_valid1 <= lp_flag_rised & lp_edge_fall;
//    lp_valid2 <= lp_valid1 & lp_check_width;  
//    lp_x_mid <= (lp_x + x_nms) >> 1;
//    lp_phi_mid <= (lp_phi + phiavg_3) >> 1;
    lp_denta_x <= x_nms11 - lp_x;
    lp_check_width <= (lp_denta_x > dx_min) & (lp_denta_x < dx_max);
end
always @(posedge clk) begin
    if(lp_edge_rise) begin
        lp_x <= x_nms11;
        lp_phi <= phiavg_3;
    end 
    lp_flag_rised <= (lp_edge_rise) ? 1'b1 : (lp_edge_fall | end_one_row11) ? 1'b0 : lp_flag_rised;
end
always @(posedge clk) begin
    // cần xây dựng phần mền để tìm ra lp_check_width phù hơp
    lp_valid2 <= lp_valid1 & xy_valid12 & lp_check_width;  
    //lp_x_mid <= (lp_x + x_nms11) >> 1; thay bằng cách chia trước -> giảm tài nguyên, nhưng giảm 1 ít độ chính xác
    lp_x_mid <= (lp_x >> 1) + (x_nms11 >> 1);
    //lp_phi_mid <= (lp_phi + phiavg_3) >> 1;
    lp_phi_mid <= (lp_phi >> 1) + (phiavg_3 >> 1);
end
// =============MODULE lifo============================================
// wire lifo_read, lifo_empty, lifo_full;
// wire[msb_x:0] lifo_x; 
// wire[msb_phi:0] lifo_phi;
// wire[msb_y:0] lifo_y;
lifo_xyphi md_lifo_xyphi(.clk(clk), .reset(reset), .x_in(lp_x_mid), .phi_in(lp_phi_mid), 
.y_in(y_nms13), .we(lp_valid2), .re(lifo_read), .empty(lifo_empty), 
.full(lifo_full), .x_out(lifo_x), .phi_out(lifo_phi), .y_out(lifo_y));
//  =====================MODULE generate_ht_xy_phi & ht_rho_phi================================
// wire[(msb_rho-3):0] ht_rho_vote;
// wire[msb_phi:0] ht_phi_vote;
// wire ht_valid_rho_phi_vote;
//(* DONT_TOUCH = "yes" *) generate_ht_xy_phi md_gen_ht_xy_phi(.clk(clk), .reset(reset), .x_in(lifo_x), 
ht_rho_phi_vote md_ht_rho_phi_vote(.clk(clk), .reset(reset), .x_in(lifo_x), 
.y_in(lifo_y), .phi_in(lifo_phi), .lifo_empty(lifo_empty), .load_new_point(lifo_read), 
.ht_rho_vote(ht_rho_vote), .ht_phi_vote(ht_phi_vote), .ht_valid_rho_phi_vote(ht_valid_rho_phi_vote));

//  =====================MODULE generate_ht_xy_phi & ht_rho_phi================================
// wire[msb_number_vote:0] ht_number_vote;
ht_voting md_ht_voting(.clk(clk), .reset(reset), .rho_vote(ht_rho_vote), .phi_vote(ht_phi_vote), 
.valid_rho_phi_vote(ht_valid_rho_phi_vote), .number_vote(ht_number_vote));

// wire[(msb_rho-3)-3:0] ht_rho_pick;
// wire[msb_phi:0] ht_phi_pick;
ht_pick_max md_ht_pick_max(.clk(clk), .reset(reset), .rho_vote(ht_rho_vote), .phi_vote(ht_phi_vote), 
.valid_rho_phi_vote(ht_valid_rho_phi_vote), .number_vote(ht_number_vote), .rho_pick(ht_rho_pick), .phi_pick(ht_phi_pick));

// reg[(msb_rho-3):0] out_ht_rho_pick;
// reg[msb_phi:0] out_ht_phi_pick;
always @(posedge clk) begin
    out_ht_rho_pick <= ht_rho_pick;
    out_ht_phi_pick <= ht_phi_pick;
end
endmodule //endmodule module TOP