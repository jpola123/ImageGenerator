typedef enum logic [1:0] { 
    INIT = 0, LOOP = 1, UPDATE = 2, OVER = 3
} control_state_t;

module test1 (
    input logic snakeBody, snakeHead, apple, border, mode_pb, GameOver, clk, clk2, nrst, cmd_done, 
    output logic enable_loop, diff, init_cycle, en_update, sync_reset,
    output logic [3:0] x, y,
    output logic [1:0] obj_code
);
    frame_tracker tracker(.body(snakeBody), .head(snakeHead), .apple(apple), .border(border), .enable(enable_loop), .clk(clk2), .nrst(nrst), 
                          .diff(diff), .obj_code(obj_code), .x(x), .y(y));
    fsm_control control(.GameOver(GameOver), .cmd_done(cmd_done), .diff(diff), .clk(clk), .nrst(nrst), .mode_pb(mode_pb), 
                        .enable_loop(enable_loop), .init_cycle(init_cycle), .en_update(en_update), .sync_reset(sync_reset));
endmodule;