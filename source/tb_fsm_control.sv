`timescale 1ms/100us

module tb_fsm_control();

localparam CLK_PERIOD = 10;
logic tb_checking_outputs;
integer tb_test_num;
string tb_test_case;

logic tb_GameOver, tb_cmd_done, tb_diff, tb_clk, tb_nrst, tb_mode_pb, enable_loop, init_cycle, en_update, sync_reset;

task reset_dut;
    @(negedge tb_clk);
    tb_nrst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nrst = 1'b1;
    @(posedge tb_clk);
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
    tb_mode_pb = 1'b1; 
    @(negedge tb_clk);
    tb_mode_pb = 1'b0; 
    @(posedge tb_clk);  // Task ends in rising edge of clock: remember this!
end
endtask

always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end

fsm_control DUT(.GameOver(tb_GameOver),
                .cmd_done(tb_cmd_done),
                .diff(tb_diff),
                .clk(tb_clk),
                .nrst(tb_nrst),
                .mode_pb(tb_mode_pb),
                .enable_loop(enable_loop),
                .init_cycle(init_cycle),
                .en_update(en_update),
                .sync_reset(sync_reset));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars();

    tb_nrst = 1'b0;
    tb_GameOver = 1'b0;
    tb_cmd_done = 1'b0;
    tb_diff = 1'b0;
    tb_mode_pb = 1'b0;
    tb_test_num = -1;
    tb_test_case = "Initializing";
    
    #(0.1);

    /*
    Test Case 0: Power on Reset
    */
    tb_test_num += 1;
    tb_test_case = "Power on Reset of DUT";
    $display("\n\n%s", tb_test_case);

    reset_dut;
    check_init(1'b1);
    check_update(1'b0);
    check_loop(1'b0);
    check_reset(1'b0);

    $finish;
end

endmodule