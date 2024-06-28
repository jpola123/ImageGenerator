typedef enum logic [2:0] { 
    IDLE = 0, SET_I = 1, SET = 2, SEND_I = 3, SEND = 4, DONE = 5
} update_t;

module update_controller #(localparam init_length = 40, localparam pix_len = 811)(
    input logic init_cycle, en_update, clk, nrst, cmd_finished,
    output logic enable, cmd_done, wr,
    output update_t mode;
);

update_t current, next;
logic [8:0] count, next_count;

always_ff @(posedge clk, negedge nrst) begin
    if(nrst)
        current <= IDLE;
    else
        current <= next;
end

always_comb begin
    wr = 1'b0;
    next_count = count;
    cmd_done = 1'b0;
    enable = 1'b0;
    case(current)
    IDLE: begin
        if(init_cycle)
            next = SET_I;
        else if(en_update)
            next = SET;
        else
            next = IDLE;
    end
    SET_I, SET: begin
        next = SEND;
        enable = 1'b1;
    end
    SEND_I: begin
        wr = 1'b1;
        if(cmd_finished) begin
            next = DONE; 
        end
        else begin
            next = SET_I;
        end
    end
    SEND: begin
        wr = 1'b1;
        if(cmd_finished) begin
            next = DONE;
        end
        else begin
            next = SET;
        end
    end
    DONE: begin
        next = IDLE;
        cmd_done = 1'b1;
    end
    default:
        next = IDLE;
    endcase
end

assign mode = current;




endmodule