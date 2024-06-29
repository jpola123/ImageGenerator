module fsm_mode (
    input logic signal, clk, nrst,
    output mode_t mode
);

mode_t current_mode, next_mode;

always_ff @(posedge clk, negedge nrst)
    if(~nrst)
        current_mode <= SLOW;
    else
        current_mode <= next_mode;

always_comb begin
    if(signal) begin
        if (current_mode == SLOW)
            next_mode = FAST;
        else if (current_mode == FAST)
            next_mode = SLOW;
        else
            next_mode = SLOW;
    end
    else
        next_mode = current_mode;
end

assign mode = current_mode;

endmodule

