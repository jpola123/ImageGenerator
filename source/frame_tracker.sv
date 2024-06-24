typedef enum logic [2:0] {  
    blank = 0, snake_head = 1, snake_body = 2, apple_c = 3, border_c = 4
} obj_code_t;

module frame_tracker (
    input logic body, head, apple, border, enable, clk, nrst,
    output obj_code_t obj_code,
    output logic [3:0] x, y,
    output logic diff
);

logic [16:0][12:0][2:0] frame, next_frame;
logic [3:0] current_X, next_X, current_Y, next_Y;

generate 
    for(genvar i = 0; i < 16; i = i + 1) begin
        for(genvar j = 0; j < 12; j = j + 1) begin
            always_ff @(posedge clk, negedge nrst) begin
                if(~nrst) begin
                    frame[i][j] <= blank;
                end
                else begin
                    frame[i][j] <= next_frame;
                end
            end
        end
    end
endgenerate

always_ff @(posedge clk, negedge nrst) begin
    if(~nrst) begin
        current_X <= 4'b0;
        current_Y <= 4'b0;
    end
    else begin
        current_X <= next_X;
        current_Y <= next_Y;
    end

end

always_comb begin
    diff = 1'b0;
    if(enable) begin
        if((current_X == 4'd15) && (current_Y == 4'd11)) begin
            next_X = 4'b0;
            next_Y = 4'b0;
        end
        else if(current_X == 4'd15) begin
            next_X = 4'b0;
            next_Y = current_Y + 4'd1;
        end
        else begin
            next_X = current_X + 4'd1;
            next_Y = current_Y;
        end
    end
    else begin
        next_X = current_X;
        next_Y = current_Y;
    end

    if((current_X == 4'd0) || (current_X == 4'd15) || (current_Y == 4'd0) || (current_Y == 4'd11)) begin
        if(frame[current_X][current_Y] != border_c && border) begin
            diff = 1'b1;
            next_frame[current_X][current_Y] = border_c;
            obj_code = border_c;
        end
        else begin
            diff = 1'b0;
            next_frame[current_X][current_Y] = frame[current_X][current_Y];
            obj_code = frame[current_X][current_Y];
        end
    end
    else if(body && frame[current_X][current_Y] != snake_body) begin
        diff = 1'b1;
        next_frame[current_X][current_Y] = snake_body;
        obj_code = snake_body;
    end
    else if(head && frame[current_X][current_Y] != snake_head) begin
        diff = 1'b1;
        next_frame[current_X][current_Y] = snake_head;
        obj_code = snake_head;
    end
    else if(apple && frame[current_X][current_Y] != apple_c) begin
        diff = 1'b1;
        next_frame[current_X][current_Y] = apple_c;
        obj_code = apple_c;
    end
    else if(~(apple || head || body || border) && frame[current_X][current_Y] != blank) begin
        diff = 1'b1;
        next_frame[current_X][current_Y] = blank;
        obj_code = blank;
    end
    else begin
        diff = 1'b0;
        next_frame[current_X][current_Y] = frame[current_X][current_Y];
        obj_code = frame[current_X][current_Y];
    end
end

assign X = current_X;
assign Y = current_Y;

endmodule
