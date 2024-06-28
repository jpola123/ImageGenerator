`timescale 1ms/100us

module tb_pixel_updater();
    localparam CLK_PERIOD = 100;
    logic tb_checking_outputs;
    integer tb_test_num;
    string tb_test_case;

    logic init_cycle, en_update, tb_clk, nrst, cmd_done, wr, dcx;
    logic [3:0] x, y;
    logic [2:0] obj_code, mode_o;
    logic [7:0] D;

    task reset_dut;
    @(negedge tb_clk);
    nrst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    nrst = 1'b1;
    @(posedge tb_clk);
    endtask

    always @(cmd_done) begin
        init_cycle = 1'b0;
        en_update = 1'b0;
    end

    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    pixel_updater DUT(.init_cycle(init_cycle), .en_update(en_update), .clk(tb_clk), .nrst(nrst), .x(x), .y(y), .obj_code(obj_code), .wr(wr), .cmd_done(cmd_done), .dcx(dcx), .D(D), .mode_o(mode_o));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars();
        init_cycle = 1'b0;
        en_update = 1'b0;
        nrst = 1'b1;
        x = 4'b0;
        y = 4'b0;
        obj_code = 3'b0;
        tb_checking_outputs = 1'b0;
        tb_test_num = -1;
        tb_test_case = "Initializing";

        /*
        Test Case 0: Power on Reset
        */
        tb_test_num += 1;
        tb_test_case = "Power on Reset";
        $display("\n\n%s", tb_test_case);

        reset_dut();

        /*
        Test Case 1: Test if correct commands are being fed to initialize display
        */
        tb_test_num += 1;
        tb_test_case = "Initialize Display";
        $display("\n\n%s", tb_test_case);

        reset_dut();

        init_cycle = 1'b1;
        #(CLK_PERIOD * 200000);

        $finish;
    
    end

endmodule