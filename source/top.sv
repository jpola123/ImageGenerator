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

  logic snakeBody, snakeHead, apple, border, GameOver, badColl, goodColl;
  logic [3:0] x, y, map, next_map, randX, randY;
  logic next_map_i, next_map_a;
  logic sync;
  logic [7:0] curr_length, dispScore;
  logic [3:0] bcd_ones, bcd_tens;
  logic isGameComplete;
  logic [139:0][7:0] body;

  image_generator img_gen(.snakeBody(snakeBody), .snakeHead(snakeHead), .apple(apple), .border(border), .KeyEnc(pb[0]), .GameOver(isGameComplete), .clk(hwclk), .nrst(~reset),
                          .sync(sync), .wr(left[0]), .dcx(left[1]), .D(right[7:0]), .x(x), .y(y));
  ssdec s0(.in(y), .enable(1'b1), .out(ss0));
  ssdec s1(.in(x), .enable(1'b1), .out(ss1));
  //curr_length_increment increase(.button(pb[1]), .clk(hwclk), .nrst(~reset), .sync(sync), .curr_length(curr_length));
  assign GameOver = badColl;
  synchronizer synch(.button(pb[2]), .clk(hwclk), .nrst(~reset), .signal(next_map_i));
  edge_detect detect(.signal(next_map_i), .clk(hwclk), .nrst(~reset), .change_state(next_map_a));
  snake_body_controller #(.MAX_LENGTH(140)) control(.direction_pb({pb[10], pb[6], pb[5], pb[7]}), .x(x), .y(y), .clk(hwclk), .pb_mode(pb[9]), .nrst(~reset), .sync(sync), .curr_length(curr_length), .body(body), .snakeHead(snakeHead), .snakeBody(snakeBody));
  random rand123(.clk(hwclk), .nRst(~reset), .randX(randX), .randY(randY));
  applegenerator2 #(.MAX_LENGTH(140)) ag2(.x(x), .y(y), .randX(randX), .randY(randY), .goodColl(goodColl), .clk(hwclk), .reset(~reset), .s_reset(sync), .body(body), .apple(apple));
  collision coll(.clk(hwclk), .nRst(~reset), .snakeHead(snakeHead), .snakeBody(snakeBody), .border(border), .apple(apple), .goodColl(goodColl), .badColl(GameOver));
  score_tracker2 track(.clk(hwclk), .nRst(~reset), .goodColl(goodColl), .badColl(badColl), .current_score(curr_length), .dispScore(dispScore), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .isGameComplete(isGameComplete));
  assign left[3] = goodColl;
  assign left[2] = GameOver;
  always @(posedge next_map_a, posedge reset) begin
    if(reset)
      map <= 0;
    else
      map <= map + 4'd1;
  
  end

  always_comb begin
    if((x == 4'd0) || (x == 4'd15) || (y == 4'd0) || (y == 4'd11)) begin
      border = 1'b1;
    end
    else
      border = 1'b0;
    end
endmodule
