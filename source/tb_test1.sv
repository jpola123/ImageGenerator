`timescale 1ms/100us

module tb_test1();
    localparam CLK_PERIOD = 10;
    localparam CLK2_PERIOD = 100;
    logic tb_checking_outputs;
    integer tb_test_num;
    string tb_test_case;
    
    logic snakeBody, snakeHead, apple, border, mode_pb, GameOver, tb_clk, tb_clk2, nrst, cmd_done, enable_loop, diff, init_cycle, en_update, sync_reset;
    logic [3:0] x, y, map;
    logic [2:0] obj_code;
    logic [16:0][12:0][2:0] map1;
    logic [16:0][12:0][2:0] map2;
    logic [16:0][12:0][2:0] map3;

    task reset_dut;
    @(negedge tb_clk);
    nrst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    nrst = 1'b1;
    @(posedge tb_clk);
    endtask

    task toggle_body;
    @(negedge tb_clk);
    snakeBody = 1'b1;
    @(negedge tb_clk);
    snakeBody = 1'b0;   
    endtask


    task toggle_head;
    @(negedge tb_clk);
    snakeHead = 1'b1;
    @(negedge tb_clk);
    snakeHead = 1'b0;   
    endtask


    task toggle_apple;
    @(negedge tb_clk);
    apple = 1'b1;
    @(negedge tb_clk);
    apple = 1'b0;   
    endtask


    task toggle_border;
    @(negedge tb_clk);
    border = 1'b1;
    @(negedge tb_clk);
    border = 1'b0;   
    endtask

    task check_diff;
        input logic expected;
    begin
        tb_checking_outputs = 1'b1;
        if(expected == diff)
            $info("diff is correct.");
        else
            $error("diff is incorrect.");
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    task check_obj_code;
        input [2:0] expected;
    begin
        @(posedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(expected == obj_code)
            $info("Object code is correct.");
        else
            $error("Object code is incorrect");
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    task check_loop;
        input logic expected;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(expected == enable_loop)
            $info("Enable Loop is functioning as expected.");
        else
            $error("Enable Loop is not functioning as expected.");
        #(1);
        tb_checking_outputs = 1'b0; 
    end
    endtask


    task check_update;
        input logic expected;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(expected == en_update)
            $info("Enable Update is functioning as expected.");
        else
            $error("Enable Update is not functioning as expected.");
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask


    task check_init;
        input logic expected;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(expected == init_cycle)
            $info("Initial Cycle is functioning as expected.");
        else
            $error("Initial Cycle is not functioning as expected.");
        #(1);
        tb_checking_outputs = 1'b0; 
    end
    endtask


    task check_reset;
        input logic expected;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(expected == sync_reset)
            $info("Over is functioning as expected.");
        else
            $error("Over is not functioning as expected.");
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    task mode_pb_press;
    begin
        @(negedge tb_clk);
        mode_pb = 1'b1; 
        @(negedge tb_clk);
        mode_pb = 1'b0; 
    end
    endtask

    task toggle_cmd_done;
    begin
        @(negedge tb_clk);
        cmd_done = 1'b1; 
        @(posedge tb_clk);
        cmd_done = 1'b0; 
    end
    endtask

    task check_coordinates;
        input logic [7:0] expected;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b0;
        if(expected == {x,y})
            $info("X and Y coordinates are correct: %0d, %0d", x, y);
        else
            $error("X and Y Coordinates are incorrect: E: %0d, %0d. A: %0d, %0d", expected[7:4], expected[3:0], x, y);
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    always begin
        tb_clk2 = 1'b0; 
        #(CLK2_PERIOD / 2.0);
        tb_clk2 = 1'b1; 
        #(CLK2_PERIOD / 2.0); 
    end

    always @(x, y) begin
        if((x == 0) && (y == 0))
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

    test1 DUT(.snakeBody(snakeBody), .snakeHead(snakeHead), .apple(apple), .border(border), .mode_pb(mode_pb), .GameOver(GameOver), .clk(tb_clk), 
              .clk2(tb_clk), .nrst(nrst), .cmd_done(cmd_done),
              .enable_loop(enable_loop), .diff(diff), .init_cycle(init_cycle), .en_update(en_update), .sync_reset(sync_reset),
              .x(x), .y(y), .obj_code(obj_code));

    initial begin
        snakeBody = 1'b0;
        snakeHead = 1'b0;
        apple = 1'b0;
        border = 1'b0;
        mode_pb = 1'b0;
        GameOver = 1'b0;
        nrst = 1'b1;
        cmd_done = 1'b0;
        map = 3'b0;
        

        /*
        Test Case 0: Power On Reset of DUT
        */

        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power on Reset of DUT";
        $display("\n\n%s", tb_test_case);
        
        reset_dut;
        #(50);
        check_coordinates(8'h00);
        check_init(1'b1);

        /*
        Test Case 1: Flash map 1 and see if it stops when there's an update.
        */
        tb_test_num += 1;
        tb_test_case = "Test Case 1: Flash a basic map and see if all the signals are right";
        $display("\n\n%s", tb_test_case);

        reset_dut;
        @(negedge tb_clk);
        cmd_done = 1'b1;
        @(negedge tb_clk);
        cmd_done = 1'b0;
        
        for(integer i = 0; i < 1000; i++) begin
            #(CLK_PERIOD);
            if(diff) begin
                #(CLK_PERIOD * 5);
                toggle_cmd_done();
            end
        end;
        
        $finish;
    
    end

endmodule