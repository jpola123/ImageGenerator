module command_lut(
    input update_t mode,
    input logic clk, nrst, 
    input logic [2:0] obj_code,
    input logic [3:0] X, Y,
    output logic cmd_finished,
    output logic [7:0] D,
    output logic dcx, pause
);

logic [15:0] count, next_count, SC, EC, SP, EP, color;
logic [3:0] cmd_num, next_cmd_num;

always_ff @(posedge clk, negedge nrst) begin
    if(~nrst) begin
        count <= 0;
        cmd_num <= 0;
    end
    else begin
        count <= next_count;
        cmd_num <= next_cmd_num;
    end
end

always_comb begin
    next_count = count;
    pause = 1'b0;
    next_cmd_num = cmd_num;
    color = 16'h0;
    SC = 16'b0;
    EC = 16'b0;
    SP = 16'b0;
    EP = 16'b0;
    D = 8'b0;
    dcx = 1'b0;
    if((mode == SET_I) || (mode == SEND_I)) begin
        if(mode == SET_I) begin
            if(cmd_num == 3'd1 || cmd_num == 3'd3) begin
                if(count > 16'd50000) begin
                    next_count = 0;
                    next_cmd_num = cmd_num + 3'd1;
                    pause = 1'b0;
                end
                else begin
                    next_count = count + 16'b1;
                    next_cmd_num = cmd_num;
                    pause = 1'b1;
                end
            end
            else begin
                next_cmd_num = cmd_num + 3'd1;
            end
        end
        else begin
            next_cmd_num = cmd_num;
            pause = 1'b0;
            next_count = 0;
        end
        cmd_finished = 1'b0;
        case(next_cmd_num)
        4'd1: begin
            D = 8'b00000001;
            dcx = 1'b0;
        end
        4'd2: begin
            D = 8'b00101000;
            dcx = 1'b0;
        end
        4'd3: begin
            D = 8'b00010001;
            dcx = 1'b0;
        end
        4'd4: begin
            D = 8'b00101001;
            dcx = 1'b0;
            cmd_finished = 1'b1;
            if(mode == SEND_I) begin
                next_cmd_num = 4'b0;
            end
        end
        default: begin
            D = 8'b00000000;
            dcx = 1'b0;
        end
        endcase
        
    end
    else if((mode == SET) || (mode == SEND)) begin
        if(mode == SET) begin
            if(cmd_num == 4'd11) begin
                next_cmd_num = 4'd13;
                next_count = count;
            end
            else if(count > 400) begin
                next_count = 0;
                next_cmd_num = 4'd14;
            end
            else if(cmd_num == 4'd12) begin
                next_cmd_num = 4'd13;
                next_count = count + 16'b1;
            end
            else if(cmd_num == 4'd13) begin
                next_cmd_num = 4'd12;
                next_count = count;
            end
            else
                next_cmd_num = cmd_num + 4'd1;
        end
        else begin
            next_count = count;
            next_cmd_num = cmd_num;
        end
        SC = X * 20;
        EC = (X + 4'd1) * 20;
        SP = Y * 20;
        EP = (Y + 4'd1) * 20;
        case(obj_code)
        3'b000: begin
            color = 16'hffff;
        end
        3'b001: begin
            color = 16'h901E;
        end
        3'b010: begin
            color = 16'h6815;
        end
        3'b011: begin
            color = 16'hf800;
        end
        3'b100: begin
            color = 16'h0814;
        end
        default: begin
            color = 16'hffff;
        end
        endcase

        cmd_finished = 1'b0;
        case(next_cmd_num)
        4'd1: begin
            D = 8'b00101010;
            dcx = 1'b0;
        end
        4'd2: begin
            D = SC[15:8];
            dcx = 1'b1;
        end
        4'd3: begin
            D = SC[7:0];
            dcx = 1'b1;
        end
        4'd4: begin
            D = EC[15:8];
            dcx = 1'b1;
        end
        4'd5: begin
            D = EC[7:0];
            dcx = 1'b1;
        end
        4'd6: begin
            D = 8'b00101011;
            dcx = 1'b0;
        end
        4'd7: begin
            D = SP[15:8];
            dcx = 1'b1;
        end
        4'd8: begin
            D = SP[7:0];
            dcx = 1'b1;
        end
        4'd9: begin
            D = EP[15:8];
            dcx = 1'b1;
        end
        4'd10: begin
            D = EP[7:0];
            dcx = 1'b1;
        end
        4'd11: begin
            D = 8'b00101100;
            dcx = 1'b0;
        end
        4'd12: begin
            D = color[7:0];
            dcx = 1'b1;
        end
        4'd13: begin
            D = color[15:8];
            dcx = 1'b1;
        end
        4'd14: begin    
            D = 8'b00000000;
            dcx = 1'b0;
            cmd_finished = 1'b1;
            if(mode == SEND) begin
                next_cmd_num = 4'b0;
            end
        end
        default: begin
            D = 8'b0;
            dcx = 1'b0;
        end
        endcase
    end
end

endmodule