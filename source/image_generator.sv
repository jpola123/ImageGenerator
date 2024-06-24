typedef enum logic [2:0] {  
    blank = 0, snake_head = 1, snake_body = 2, apple_c = 3, border_c = 4
} obj_code_t;


module image_generator (
    input logic snakeBody, snakeHead, apple, border, KeyEnc, GameOver, clk, nrst,
    output logic sync, n_cs, dc, wr, sn_rst
    output logic [7:0] D,
    output logic [3:0] x, y
);

endmodule;