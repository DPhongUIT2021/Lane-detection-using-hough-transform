`timescale 1ns / 1ps

//=========== testbench for systemverilog (function - pineline no have voting right) ===================
 //`include "monitor.sv"
 //`include "generator.sv"
 //`include "C:/UIT_THESIS/RTL_src/testbench_pineline/para.sv"

// module testbench
// #(parameter  h_fpga = 150, w_fpga = 450,
// msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
// msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
// thresh_gradien_add = 10,
// thresh_gradien_sqrt = 16, //10*1.646760258121
// dx_min = 5, dx_max = 50,
// msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
// phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
// rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
// msb_number_vote = 7,
// msb_sin = 9, msb_cos = 9,
// DEPTH = 16, W = 450,
// parameter T = 3.4);

// reg clk, reset;
// initial begin
//     reset = 1;
//     clk = 0;
//     //#(T/2) reset = 0; // Error if delay (T/2) cause lifo_xyphi/cnt not reset so not write new data
//     #(T*30) reset = 0;
// end
// always #(T/2) clk = ~clk;

// initial begin
//     //#(T*10) $stop(2);
//     //#(T*(w_fpga*15)) $stop(2);
//     #(T*(h_fpga*w_fpga)) $display("done simulation");
//     $stop(2);
//     //#(T*(h_fpga*w_fpga)) $finish(); // syntem call finish will kill module sim
//     //#(T*1) $finish;
// end

// wire[7:0] in_new_pixel; wire[msb_x:0] in_x_nms; wire[msb_y:0] in_y_nms; wire in_end_one_row; wire[msb_address_camera:0] v_count;
// wire in_xy_valid;

// wire[msb_rho-3:0] out_ht_rho_pick;
// wire[msb_phi:0] out_ht_phi_pick;

// TOP dut(.clk(clk), .reset(reset), .in_xy_valid(in_xy_valid), .in_new_pixel(in_new_pixel), .in_x_nms(in_x_nms), .in_y_nms(in_y_nms), .in_end_one_row(in_end_one_row), 
// .out_ht_rho_pick(out_ht_rho_pick), .out_ht_phi_pick(out_ht_phi_pick));
// gen_pattern mdgen(.clk(clk), .reset(reset), .x_camera(in_x_nms), .y_camera(in_y_nms), 
// .new_pixel(in_new_pixel), .eq_width_roi(in_end_one_row), .v_count(v_count), .xy_valid(in_xy_valid));

// // monitor_ht_rho_phi_vote m0;
// // initial begin
// //   m0 = new();
// //   m0.vif = dut.inf;
// //   //#(T)
// //   m0.write_file_init();
// //   fork
// //       m0.run_write_file();
// //   join_any
// // end

// endmodule

/////////======== testbench for verilog no voting==============
module testbench
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
T = 2.6
)
; // system verilog must have Semicolon
// #(parameter  h_fpga = 480, w_fpga = 640,
// msb_x = 9, msb_y = 8, msb_address_camera = 18, // x_max = 450, y_max = 150
// msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
// thresh_gradien_add = 10,
// thresh_gradien_sqrt = 16, //10*1.646760258121
// dx_min = 5, dx_max = 50,
// // msb_rho = 8,                    // msb_rho = 8 because sqrt(450^2+150^2) = 474 
// msb_rho = 8,                    // msb_rho = 8 because sqrt(h_fpga^2+(w_fpga/2)^2) = 576
// phi_min = 5, phi_max = 80, phi_min_ram = 0, phi_max_ram = phi_max,
// rho_min = 0, rho_max = 72, rho_min_ram = 0, rho_max_ram = rho_max,
// msb_number_vote = 7,
// msb_sin = 9, msb_cos = 9,
// DEPTH = 16, Width_image_div_2 = (w_fpga/2),
// msb_address_bkram = ((msb_rho+1) + (msb_phi+1) - 1), msb_depth_ram = 32768, // (rho 9 bit * phi 7 bit = 16 bit -> 2^15 = 32768)
// parameter T = 3.4
// )
// ;
reg clk, reset;
string frame;
// initial begin
//    reset = 1;
//    clk = 0;
//    #(T*30) reset = 0;
// end
// always #(T/2) clk = ~clk;
initial begin
   reset = 1;
   clk = 0;
   #(T*31) reset = 0;
   frame = "test8_night_3237_h150_w450_left";
   #(T*(h_fpga*w_fpga)) $display("########################## DONE SIMULATION Frame 0 TIMING ########################################");
   reset = 1;
   #(T) reset = 0;
   frame = "test8_night_4507_h150_w450_left";
   #(T*(h_fpga*w_fpga)) $display("########################## DONE SIMULATION Frame 0 TIMING ########################################");
   reset = 1;
   #(T) reset = 0;
   frame = "test0_normal_4372_h150_w450_left";
   #(T*(h_fpga*w_fpga)) $display("########################## DONE SIMULATION Frame 1  TIMING ########################################");
   $stop(2);
end
always #(T/2) clk = ~clk;

wire[7:0] in_new_pixel; wire[msb_x:0] in_x_nms; wire[msb_y:0] in_y_nms; wire in_end_one_row; wire[msb_address_camera:0] v_count;
wire in_xy_valid;

wire[msb_rho-3:0] out_ht_rho_pick;
wire[msb_phi:0] out_ht_phi_pick;

TOP dut(.clk(clk), .reset(reset), .in_xy_valid(in_xy_valid), .in_new_pixel(in_new_pixel), .in_x_nms(in_x_nms), 
.in_y_nms(in_y_nms), .in_end_one_row(in_end_one_row), 
.out_ht_rho_pick(out_ht_rho_pick), .out_ht_phi_pick(out_ht_phi_pick));

gen_pattern mdgen(.clk(clk), .reset(reset), .x_camera(in_x_nms), .y_camera(in_y_nms), 
.new_pixel(in_new_pixel), .eq_width_roi(in_end_one_row), .v_count(v_count), .xy_valid(in_xy_valid));
endmodule

// === module testbench have 2 block ram voting left, right======
// module testbench
// #(parameter  h_fpga = 150, w_fpga = 450,
// msb_x = 8, msb_y = 7, msb_address_camera = 16, // x_max = 450, y_max = 150
// msb_gradien = 9, msb_phi = 6, msb_cordic_phi = 15,
// thresh_gradien_add = 10,
// thresh_gradien_sqrt = 16, //10*1.646760258121
// dx_min = 5, dx_max = 50,
// msb_rho = 8,                    // sqrt(450^2+150^2) = 474 
// phi_min = 5, phi_max = 75, phi_min_ram = 0, phi_max_ram = phi_max,
// rho_min = 12, rho_max = 60, rho_min_ram = 0, rho_max_ram = rho_max,
// msb_number_vote = 7,
// msb_sin = 9, msb_cos = 9,
// DEPTH = 16, W = 450, Width_image_div_2 = (W/2),
// parameter T = 3.4
// )

// reg clk, reset;
// initial begin
//     reset = 1;
//     clk = 0;
//     //#(T/2) reset = 0; // Error if delay (T/2) cause lifo_xyphi/cnt not reset so not write new data
//     #(T*30) reset = 0;
// end
// always #(T/2) clk = ~clk;

// initial begin
//     //#(T*10) $stop(2);
//     //#(T*(w_fpga*15)) $stop(2);
//     #(T*(h_fpga*w_fpga)) $display("done simulation");
//     $stop(2);
//     //#(T*(h_fpga*w_fpga)) $finish(); // syntem call finish will kill module sim
//     //#(T*1) $finish;
// end

// wire[7:0] in_new_pixel; wire[msb_x:0] in_x_nms; wire[msb_y:0] in_y_nms; wire in_end_one_row; wire[msb_address_camera:0] v_count;
// wire in_xy_valid;

// wire[msb_rho-3:0] out_ht_rho_pick_left, out_ht_rho_pick_right;
// wire[msb_phi:0] out_ht_phi_pick_left, out_ht_phi_pick_right;

// TOP dut(.clk(clk), .reset(reset), .in_xy_valid(in_xy_valid), .in_new_pixel(in_new_pixel), .in_x_nms(in_x_nms), .in_y_nms(in_y_nms), .in_end_one_row(in_end_one_row), 
// .out_ht_rho_pick_left(out_ht_rho_pick_left), .out_ht_phi_pick_left(out_ht_phi_pick_left),
// .out_ht_rho_pick_right(out_ht_rho_pick_right), .out_ht_phi_pick_right(out_ht_phi_pick_right));

// gen_pattern mdgen(.clk(clk), .reset(reset), .x_camera(in_x_nms), .y_camera(in_y_nms), 
// .new_pixel(in_new_pixel), .eq_width_roi(in_end_one_row), .v_count(v_count), .xy_valid(in_xy_valid));

// // monitor_ht_rho_phi_vote m0;
// // initial begin
// //   m0 = new();
// //   m0.vif = dut.inf;
// //   //#(T)
// //   m0.write_file_init();
// //   fork
// //       m0.run_write_file();
// //   join_any
// // end

// endmodule

