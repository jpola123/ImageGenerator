// FPGA Top Level

`default_nettype none

module top (
  // I/O ports
  input  logic hwclk, reset,
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

  logic snakeBody, snakeHead, apple, border, badColl, goodColl;
  logic [3:0] x, y, map, next_map, randX, randY;
  logic next_map_i, next_map_a;
  logic sync;
  logic [7:0] curr_length, dispScore;
  logic [3:0] bcd_ones, bcd_tens, bcd_hundreds, displayOut;
  logic isGameComplete;
  logic [139:0][7:0] body;
  logic [1:0] blinkToggle;
  logic [1:0] junk;

  image_generator img_gen(.snakeBody(snakeBody), .snakeHead(snakeHead), .apple(apple), .border(border), .KeyEnc(pb[0]), .GameOver(isGameComplete), .clk(hwclk), .nrst(~reset),
                          .sync(sync), .wr(left[0]), .dcx(left[1]), .D(right[7:0]), .x(x), .y(y));
  //curr_length_increment increase(.button(pb[1]), .clk(hwclk), .nrst(~reset), .sync(sync), .curr_length(curr_length));
  //hello
  synchronizer synch(.button(pb[2]), .clk(hwclk), .nrst(~reset), .signal(next_map_i));
  edge_detect detect(.signal(next_map_i), .clk(hwclk), .nrst(~reset), .change_state(next_map_a));
  snake_body_controller #(.MAX_LENGTH(140)) control(.direction_pb({pb[10], pb[6], pb[5], pb[7]}), .x(x), .y(y), .clk(hwclk), .pb_mode(pb[9]), .nrst(~reset), .sync(sync), .curr_length(curr_length), .body(body), .snakeHead(snakeHead), .snakeBody(snakeBody));
  random rand123(.clk(hwclk), .nRst(~reset), .randX(randX), .randY(randY));
  applegenerator2 #(.MAX_LENGTH(140)) ag2(.x(x), .y(y), .randX(randX), .randY(randY), .goodColl(goodColl), .clk(hwclk), .reset(~reset), .s_reset(sync), .body(body), .apple(apple));
  collision coll(.clk(hwclk), .nRst(~reset), .snakeHead(snakeHead), .snakeBody(snakeBody), .border(border), .apple(apple), .goodColl(goodColl), .badColl(badColl));
  //score_tracker2 track(.clk(hwclk), .nRst(~reset), .goodColl(goodColl), .badColl(badColl), .current_score(curr_length), .dispScore(dispScore), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .isGameComplete(isGameComplete));
  score_tracker3 track(.clk(hwclk), .nRst(~reset), .goodColl(goodColl), .current_score(curr_length), .badColl(badColl), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .bcd_hundreds(bcd_hundreds), .dispScore(dispScore), .isGameComplete(isGameComplete));
  toggle_screen toggle1(.displayOut(displayOut), .blinkToggle(blinkToggle), .clk(hwclk), .rst(~reset), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .bcd_hundreds(bcd_hundreds));
  ssdec ssdec1(.in(displayOut), .enable(blinkToggle == 1), .out(ss0[6:0]));
  ssdec ssdec2(.in(displayOut), .enable(blinkToggle == 2), .out(ss1[6:0]));
  ssdec ssdec3(.in(displayOut), .enable(blinkToggle == 0), .out(ss2[6:0]));
  border_generator border_gen(.x(x), .y(y), .isBorder(border));
  //sound_generator sound_gen(.clk(hwclk), .rst(reset), .goodColl_i(goodColl), .badColl_i(badColl), .button_i(1'b1), .direction_i({pb[10], pb[6], pb[5], pb[7]}), .soundOut({left[7:2], junk}));
endmodule