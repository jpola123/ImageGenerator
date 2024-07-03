`timescale 1ms/100us

module tb_complete();
    localparam CLK_PERIOD = 10;
    logic tb_checking_outputs;
    integer tb_test_num;
    string tb_test_case;

    logic tb_clk, reset, left, right, up, down, mode_pb, KeyEnc, dcx, wr;
    logic [7:0] D;
    logic [5:0] sound_out;

    task reset_dut;
    @(negedge tb_clk);
    reset = 1'b1; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    reset = 1'b0;
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

    complete DUT(.hwclk(tb_clk), .reset(reset), .left(left), .right(right), .up(up), .down(down), .mode_pb(mode_pb), .KeyEnc(KeyEnc), .dcx(dcx), .wr(wr), .D(D), .sound_out(sound_out));
    initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    reset = 1'b0;
    left = 1'b0;
    right = 1'b0;
    down = 1'b0;
    up = 1'b0;
    mode_pb = 1'b0;
    KeyEnc = 1'b0;
    reset_dut();
    #(CLK_PERIOD * 750000);
    right_button_press();
    #(CLK_PERIOD * 2500000);
    left_button_press();
    #(CLK_PERIOD * 2500000);
    $finish;
    end

endmodule   