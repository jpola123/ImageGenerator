// FPGA Top Level

`default_nettype none

module top (
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);
  logic [5:0] time_o;
  logic [2:0] mode_o;
  logic [7:0] converted_s;
  logic [7:0] converted_m, converted_h;
  logic [5:0] minutes, hours;
  stop_watch stopwatch(.clk(hz100), .nRst_i(~pb[19]), .button_i(pb[0]), .time_o(time_o), .mode_o(mode_o), .minutes(minutes), .hours(hours));
  bcd convert_s(.raw(time_o), .converted(converted_s));
  bcd convert_m(.raw(minutes), .converted(converted_m));
  bcd convert_h(.raw(hours), .converted(converted_h));
  assign left[2:0] = mode_o;
  ssdec s0(.in(converted_s[3:0]), .enable(1'b1), .out(ss0[6:0]));
  ssdec s1(.in(converted_s[7:4]), .enable(1'b1), .out(ss1[6:0]));
  assign ss2[7] = 1;
  assign ss5[7] = 1;
  ssdec s3(.in(converted_m[3:0]), .enable(1'b1), .out(ss3[6:0]));
  ssdec s4(.in(converted_m[7:4]), .enable(1'b1), .out(ss4[6:0]));
  ssdec s6(.in(converted_h[3:0]), .enable(1'b1), .out(ss6[6:0]));
  ssdec s7(.in(converted_h[7:4]), .enable(1'b1), .out(ss7[6:0]));
endmodule
