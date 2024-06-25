typedef enum logic [2:0] {  
    blank = 0, snake_head = 1, snake_body = 2, apple_c = 3, border_c = 4
} obj_code_t;

module frame_tracker (
    input logic body, head, apple, border, enable, clk, nrst,
    output logic [2:0] obj_code,
    output logic [3:0] x, y,
    output logic diff
);

logic [15:0][11:0][2:0] frame, next_frame;
logic [3:0] current_X, next_X, current_Y, next_Y;
logic next_d, d;

/* generate 
    for(genvar i = 0; i < 16; i = i + 1) begin
        for(genvar j = 0; j < 12; j = j + 1) begin
            always_ff @(posedge clk, negedge nrst) begin
                if(~nrst) begin
                    frame[i][j] <= 3'b000;
                end
                else begin
                    frame[i][j] <= next_frame;
                end
            end
        end
    end
endgenerate */

always_ff @(posedge clk, negedge nrst) begin
    if(~nrst) begin
        frame <= {16{12{3'b0}}};
    end
    else begin
        frame <= next_frame;
    end
end


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
    next_X = current_X;
    next_Y = current_Y;
    diff = 1'b0;
    next_frame = frame;

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

    case(frame[current_X][current_Y])
    3'b000: begin
        if(border) begin
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
            diff = 1'b1;
        end
        else if(head) begin
            next_frame[current_X][current_Y] = 3'b001;
            obj_code = 3'b001;
            diff = 1'b1;
        end
        else if(body) begin
            next_frame[current_X][current_Y] = 3'b010;
            obj_code = 3'b010;
            diff = 1'b1;
        end
        else if(apple) begin
            next_frame[current_X][current_Y] = 3'b011;
            obj_code = 3'b011;
            diff = 1'b1;
        end
        else begin
            next_frame[current_X][current_Y] = 3'b000;
            obj_code = 3'b000;
            diff = 1'b0;
        end
    end
    3'b001: begin
        if(border) begin
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
            diff = 1'b1;
        end
        else if(head) begin
            next_frame[current_X][current_Y] = 3'b001;
            obj_code = 3'b001;
            diff = 1'b0;
        end
        else if(body) begin
            next_frame[current_X][current_Y] = 3'b010;
            obj_code = 3'b010;
            diff = 1'b1;
        end
        else if(apple) begin
            next_frame[current_X][current_Y] = 3'b011;
            obj_code = 3'b011;
            diff = 1'b1;
        end
        else begin
            next_frame[current_X][current_Y] = 3'b000;
            obj_code = 3'b000;
            diff = 1'b1;
        end
    end
    3'b010: begin
        if(border) begin
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
            diff = 1'b1;
        end
        else if(head) begin
            next_frame[current_X][current_Y] = 3'b001;
            obj_code = 3'b001;
            diff = 1'b1;
        end
        else if(body) begin
            next_frame[current_X][current_Y] = 3'b010;
            obj_code = 3'b010;
            diff = 1'b0;
        end
        else if(apple) begin
            next_frame[current_X][current_Y] = 3'b011;
            obj_code = 3'b011;
            diff = 1'b1;
        end
        else begin
            next_frame[current_X][current_Y] = 3'b000;
            obj_code = 3'b000;
            diff = 1'b1;
        end
    end
    3'b011: begin
        if(border) begin
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
            diff = 1'b1;
        end
        else if(head) begin
            next_frame[current_X][current_Y] = 3'b001;
            obj_code = 3'b001;
            diff = 1'b1;
        end
        else if(body) begin
            next_frame[current_X][current_Y] = 3'b010;
            obj_code = 3'b010;
            diff = 1'b1;
        end
        else if(apple) begin
            next_frame[current_X][current_Y] = 3'b011;
            obj_code = 3'b011;
            diff = 1'b0;
        end
        else begin
            next_frame[current_X][current_Y] = 3'b000;
            obj_code = 3'b000;
            diff = 1'b1;
        end
    end        
    3'b100: begin
        if(border) begin
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
            diff = 1'b0;
        end
        else if(head) begin
            next_frame[current_X][current_Y] = 3'b001;
            obj_code = 3'b001;
            diff = 1'b1;
        end
        else if(body) begin
            next_frame[current_X][current_Y] = 3'b010;
            obj_code = 3'b010;
            diff = 1'b1;
        end
        else if(apple) begin
            next_frame[current_X][current_Y] = 3'b011;
            obj_code = 3'b011;
            diff = 1'b1;
        end
        else begin
            next_frame[current_X][current_Y] = 3'b000;
            obj_code = 3'b000;
            diff = 1'b1;
        end
    end
    default: begin
        next_frame[current_X][current_Y] = 3'b000;
        obj_code = 3'b000;
        diff = 1'b0;  
    end
    endcase

/* 
    if((current_X == 4'd0) || (current_X == 4'd15) || (current_Y == 4'd0) || (current_Y == 4'd11)) begin
        if((frame[current_X][current_Y] != 3'b100) && (border)) begin
            next_d = 1'b1;
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
        end
        else begin
            next_d = 1'b0;
            next_frame[current_X][current_Y] = frame[current_X][current_Y];
            obj_code = frame[current_X][current_Y];
        end
    end
    else if((body) && (frame[current_X][current_Y] != 3'b010)) begin
        next_d = 1'b1;
        next_frame[current_X][current_Y] = 3'b010;
        obj_code = 3'b010;
    end
    else if((head) && (frame[current_X][current_Y] != 3'b001)) begin
        next_d = 1'b1;
        next_frame[current_X][current_Y] = 3'b001;
        obj_code = 3'b001;
    end
    else if((apple) && (frame[current_X][current_Y] != 3'b011)) begin
        next_d = 1'b1;
        next_frame[current_X][current_Y] = 3'b011;
        obj_code = 3'b011;
    end
    else if(~(apple || head || body || border) && (frame[current_X][current_Y] != 3'b000)) begin
        next_d = 1'b1;
        next_frame[current_X][current_Y] = 3'b000;
        obj_code = 3'b000;
    end
    else begin
        next_d = 1'b0;
        next_frame[current_X][current_Y] = frame[current_X][current_Y];
        obj_code = frame[current_X][current_Y];
    end */
end

assign x = current_X;
assign y = current_Y;

endmodule
