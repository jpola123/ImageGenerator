`timescale 1ms/100us

module tb_complete();
    localparam CLK_PERIOD = 10;
    logic tb_checking_outputs;
    integer tb_test_num;
    string tb_test_case;

    logic tb_clk, nrst, left, right, up, down, mode_pb, KeyEnc, dcx, wr;
    logic [7:0] D;

    task reset_dut;
    @(negedge tb_clk);
    nrst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    nrst = 1'b1;
    @(posedge tb_clk);
    endtask

    task left_button_press;
    begin
        @(negedge tb_clk);
        left = 1'b1;
        @(negedge tb_clk)
        left = 1'b0;
        @(posedge tb_clk);
    end
    endtask

    task right_button_press;
    begin
        @(negedge tb_clk);
        right = 1'b1;
        @(negedge tb_clk)
        right = 1'b0;
        @(posedge tb_clk);
    end
    endtask

    task down_button_press;
    begin
        @(negedge tb_clk);
        down = 1'b1;
        @(negedge tb_clk)
        down = 1'b0;
        @(posedge tb_clk);
    end
    endtask

    task up_button_press;
    begin
        @(negedge tb_clk);
        up = 1'b1;
        @(negedge tb_clk)
        up = 1'b0;
        @(posedge tb_clk);
    end
    endtask

    always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
    end

    complete DUT(.hwclk(tb_clk), .nrst(nrst), .left(left), .right(right), .up(up), .down(down), .mode_pb(mode_pb), .KeyEnc(KeyEnc), .dcx(dcx), .wr(wr), .D(D));
    initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    nrst = 1'b1;
    left = 1'b0;
    right = 1'b0;
    down = 1'b0;
    mode_pb = 1'b0;
    KeyEnc = 1'b0;
    #(CLK_PERIOD * 500000);
    right_button_press();
    #(CLK_PERIOD * 1000000);
    up_button_press();
    left_button_press();
    #(CLK_PERIOD * 1000000);
    $finish;
    end

endmodule   