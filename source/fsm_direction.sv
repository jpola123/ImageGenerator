
module fsm_direction (
    input logic [3:0] direction_a,
    input logic clk, nrst, sync, pulse,
    output logic[2:0] direction
);

    direction_t current, temp, next;

    always_ff @(posedge clk, negedge nrst)
        if(~nrst)
            current <= {STOP, STOP};
        else
            current <= next;
    
    always_comb begin
        if((direction_a == 4'b0001) && (current != RIGHT))
            temp = LEFT;
        else if((direction_a == 4'b0010) && (current != LEFT))
            temp = RIGHT;
        else if((direction_a == 4'b0100) && (current != UP))
            temp = DOWN;
        else if((direction_a == 4'b1000) && (current != DOWN))
            temp = UP;
        else if(sync)
            temp = STOP;
        else
            temp = current;
        
        if(pulse)
            next = temp;
        else
            next = current;
    end

    assign direction = current;

endmodule