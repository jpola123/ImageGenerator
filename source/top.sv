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

  logic snakeBody, snakeHead, apple, border, GameOver;
  logic [3:0] x, y;

  image_generator img_gen(.snakeBody(snakeBody), .snakeHead(snakeHead), .apple(apple), .border(border), .KeyEnc(pb[0]), .GameOver(GameOver), .clk(hwclk), .nrst(~reset),
                          .sync(left[2]), .wr(left[0]), .dcx(left[1]), .D(right[7:0]), .x(x), .y(y));
  ssdec s0(.in(y), .enable(1'b1), .out(ss0));
  ssdec s1(.in(x), .enable(1'b1), .out(ss1));
  always_comb begin
    GameOver = 1'b0;
    if((x == 4'd0) || (x == 4'd15) || (y == 4'd0) || (y == 4'd11)) begin
      border = 1'b0;
    end
    else
      border = 1'b0;
    if((x == 4'd10) && (y == 4'd4)) begin
      snakeHead = 1'b1;
    end
    else
      snakeHead = 1'b0;
    if((x == 4'd7) && (y == 4'd4)) begin
      apple = 1'b0;
    end
    else
      apple = 1'b0;
  end


endmodule
