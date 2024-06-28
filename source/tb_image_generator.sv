`timescale 1ms/100us

module tb_image_generator();
    localparam CLK_PERIOD = 10;
    logic tb_checking_outputs;
    integer tb_test_num;
    string tb_test_case;
    
    logic snakeBody, snakeHead, apple, border, mode_pb, GameOver, tb_clk, nrst, sync, dcx, wr;
    logic [3:0] x, y, map;
    logic [7:0] D;

    task reset_dut;
    @(negedge tb_clk);
    nrst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    nrst = 1'b1;
    @(posedge tb_clk);
    endtask

    task mode_pb_press;
    begin
        @(negedge tb_clk);
        mode_pb = 1'b1; 
        @(negedge tb_clk);
        mode_pb = 1'b0; 
    end
    endtask

    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    always @(x, y, mode_pb) begin
        if(mode_pb)
            map = map + 3'b1;
        if(map == 3'd1) begin
            if((x == 4'd0) || (x == 4'd15) || (y == 4'd0) || (y == 4'd11)) begin
                border = 1'b1;
            end
            else
                border = 1'b0;
            if((x == 4'd4) && (y == 4'd4)) begin
                snakeHead = 1'b1;
            end
            else
                snakeHead = 1'b0;
            if((x == 4'd7) && (y == 4'd4)) begin
                apple = 1'b1;
            end
            else
                apple = 1'b0;
        end
        else if(map == 3'd2) begin
            if((x == 4'd0) || (x == 4'd15) || (y == 4'd0) || (y == 4'd11)) begin
                border = 1'b1;
            end
            else
                border = 1'b0;
            if((x == 4'd5) && (y == 4'd4)) begin
                snakeHead = 1'b1;
            end
            else
                snakeHead = 1'b0;
            if((x == 4'd4) && (y == 4'd4)) begin
                snakeBody = 1'b1;
            end
            else
                snakeBody = 1'b0;
            if((x == 4'd7) && (y == 4'd4)) begin
                apple = 1'b1;
            end
            else
                apple = 1'b0;
        end
        else if (map == 3'd3) begin
            if((x == 4'd0) || (x == 4'd15) || (y == 4'd0) || (y == 4'd11)) begin
                border = 1'b1;
            end
            else
                border = 1'b0;
            if((x == 4'd5) && (y == 4'd4)) begin
                snakeBody = 1'b1;
            end
            else
                snakeBody = 1'b0;
            if((x == 4'd6) && (y == 4'd4)) begin
                snakeHead = 1'b1;
            end
            else
                snakeHead = 1'b0;
            if((x == 4'd7) && (y == 4'd4)) begin
                apple = 1'b1;
            end
            else
                apple = 1'b0;
        end
        else if (map == 3'd4) begin
            if((x == 4'd0) || (x == 4'd15) || (y == 4'd0) || (y == 4'd11)) begin
                border = 1'b1;
            end
            else
                border = 1'b0;
            if((x == 4'd5) && (y == 4'd4)) begin
                snakeBody = 1'b1;
            end
            else if((x == 4'd6) && (y == 4'd4)) begin
                snakeBody = 1'b1;
            end
            else
                snakeBody = 1'b0;
            if((x == 4'd7) && (y == 4'd4)) begin
                snakeHead = 1'b1;
            end
            else
                snakeHead = 1'b0;
            if((x == 4'd13) && (y == 4'd7)) begin
                apple = 1'b1;
            end
            else
                apple = 1'b0;
        end
        else begin
            if((x == 4'd0) || (x == 4'd15) || (y == 4'd0) || (y == 4'd11)) begin
                border = 1'b1;
            end
            else
                border = 1'b0;
            if((x == 4'd6) && (y == 4'd4)) begin
                snakeBody = 1'b1;
            end
            else if((x == 4'd7) && (y == 4'd4)) begin
                snakeBody = 1'b1;
            end
            else
                snakeBody = 1'b0;
            if((x == 4'd7) && (y == 4'd5)) begin
                snakeHead = 1'b1;
            end
            else
                snakeHead = 1'b0;
            if((x == 4'd13) && (y == 4'd7)) begin
                apple = 1'b1;
            end
            else
                apple = 1'b0;
        end
    
    end

    image_generator DUT(.snakeBody(snakeBody), .snakeHead(snakeHead), .apple(apple), .border(border), .KeyEnc(mode_pb), .GameOver(GameOver), .clk(tb_clk), .nrst(nrst),
                        .sync(sync), .dcx(dcx), .wr(wr), .D(D), .x(x), .y(y));
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars();
        nrst = 1'b1;
        snakeHead = 1'b0;
        snakeBody = 1'b0;
        apple = 1'b0;
        border = 1'b0;
        mode_pb = 1'b0;
        GameOver = 1'b0;
        tb_checking_outputs = 1'b0;
        tb_test_case = "Initializing";
        tb_test_num = -1;
        map = 3'b0;

        /*
        Test Case 0: Power on Reset
        */

        tb_test_num += 1;
        tb_test_case = "Power on reset";
        $display("\n\n%s", tb_test_case);

        reset_dut();
        #(CLK_PERIOD * 10);

        /*
        Test Case 1: Map stuff + initialization
        */
        tb_test_num += 1;
        tb_test_case = "Map Stuff + Initialization";
        $display("\n\n%s", tb_test_case);

        reset_dut();
        #(CLK_PERIOD * 10030);
        mode_pb_press();
        #(CLK_PERIOD * 326400);
        mode_pb_press();
        #(CLK_PERIOD * 326400);

        $finish;


    end


endmodule