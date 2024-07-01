// FPGA Top Level

`default_nettype none

module complete (
  // I/O ports
  input logic hwclk, nrst, left, right, up, down, mode_pb, KeyEnc,
  output logic dcx, wr,
  output logic [7:0] D
);

  logic snakeBody, snakeHead, apple, border, GameOver, goodColl;
  logic [3:0] x, y, randX, randY;
  logic sync;
  logic [6:0] curr_length, dispScore;
  logic [3:0] bcd_ones, bcd_tens;
  logic isGameComplete;
  logic [139:0][7:0] body;

  image_generator img_gen(.snakeBody(snakeBody), .snakeHead(snakeHead), .apple(apple), .border(border), .KeyEnc(KeyEnc), .GameOver(GameOver), .clk(hwclk), .nrst(nrst),
                          .sync(sync), .wr(wr), .dcx(dcx), .D(D), .x(x), .y(y));
  //curr_length_increment increase(.button(pb[1]), .clk(hwclk), .nrst(~reset), .sync(sync), .curr_length(curr_length));
  snake_body_controller control(.direction_pb({up, down, left, right}), .x(x), .y(y), .clk(hwclk), .pb_mode(pb[9]), .nrst(~reset), .sync(sync), .curr_length(curr_length), .body(body), .snakeHead(snakeHead), .snakeBody(snakeBody));
  random rand123(.clk(hwclk), .nRst(nrst), .randX(randX), .randY(randY));
  applegenerator2 ag2(.x(x), .y(y), .randX(randX), .randY(randY), .goodColl(goodColl), .clk(hwclk), .reset(nrst), .s_reset(sync), .body(body), .apple(apple));
  collision coll(.clk(hwclk), .nRst(nrst), .snakeHead(snakeHead), .snakeBody(snakeBody), .border(border), .apple(apple), .goodColl(goodColl), .badColl(GameOver));
  score_tracker track(.clk(hwclk), .nRst(nrst), .goodColl(goodColl), .badColl(GameOver), .current_score(curr_length), .dispScore(dispScore), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .isGameComplete(isGameComplete));

  always_comb begin
    if((x == 4'd0) || (x == 4'd15) || (y == 4'd0) || (y == 4'd11)) begin
      border = 1'b1;
    end
    else
      border = 1'b0;
    end
endmodule
