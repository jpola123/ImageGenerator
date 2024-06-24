`timescale 1ms/100us

module tb_frame_tracker();

localparam CLK_PERIOD = 10;
logic tb_checking_outputs;
integer tb_test_num;
string tb_test_case;

//DUT Ports
logic tb_body, tb_head, tb_apple, tb_border, tb_enable, tb_clk, tb_nrst, tb_sync, diff;
obj_code_t obj_code;
logic [3:0] x, y;
logic diff;

task reset_dut;
        @(negedge tb_clk);
        tb_nrst = 1'b0; 
        @(negedge tb_clk);
        @(negedge tb_clk);
        tb_nrst = 1'b1;
        @(posedge tb_clk);
endtask

    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end



endmodule