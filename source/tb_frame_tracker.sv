`timescale 1ms/100us

module tb_frame_tracker();

localparam CLK_PERIOD = 10;
logic tb_checking_outputs;
integer tb_test_num;
string tb_test_case;

//DUT Ports
logic tb_body, tb_head, tb_apple, tb_border, tb_enable, tb_clk, tb_nrst, tb_diff;
logic [2:0] tb_obj_code;
logic [3:0] tb_x, tb_y;

task reset_dut;
    @(negedge tb_clk);
    tb_nrst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nrst = 1'b1;
    @(posedge tb_clk);
endtask

task toggle_body;
    @(negedge tb_clk);
    tb_body = ~tb_body;
    @(posedge tb_clk);   
endtask


task toggle_head;
    @(negedge tb_clk);
    tb_head = ~tb_head;
    @(posedge tb_clk);   
endtask


task toggle_apple;
    @(negedge tb_clk);
    tb_apple = ~tb_apple;
    @(posedge tb_clk);   
endtask


task toggle_border;
    @(negedge tb_clk);
    tb_border = ~tb_border;
    @(posedge tb_clk);   
endtask

task check_diff;
    input logic expected;
begin
    @(negedge tb_clk);
    if(expected == tb_diff)
        $info("diff is correct.");
    else
        $error("diff is incorrect.");
end
endtask

task check_obj_code;
    input [2:0] expected;
begin
    @(negedge tb_clk);
    if(expected == tb_obj_code)
        $info("Object code is correct.");
    else
        $error("Object code is incorrect");
end
endtask

always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end

frame_tracker DUT (.body(tb_body), .head(tb_head), .apple(tb_apple), .border(tb_border), .enable(tb_enable), .clk(tb_clk), .nrst(tb_nrst), .obj_code(tb_obj_code), .diff(tb_diff), .x(tb_x), .y(tb_y));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    tb_nrst = 1'b1;
    tb_body = 1'b0;
    tb_apple = 1'b0;
    tb_border = 1'b0;
    tb_head = 1'b0;
    tb_enable = 1'b1;
    tb_test_num = -1;
    
    #(0.1);

    /*
    Test Case 0: Power on Reset of DUT
    */

    tb_test_num += 1;
    tb_test_case = "Power on Reset of DUT";
    $display("\n\n%s", tb_test_case);

    reset_dut;
    #(CLK_PERIOD * 100);

    check_diff(1'b0);
    check_obj_code(3'b000);

    reset_dut;

    /*
    Test Case 1: Set an initial map, then change it.
    */
    tb_test_num += 1;
    tb_test_case = "Test of Map one";
    $display("\n\n%s", tb_test_case);
    reset_dut;
    for(integer i = 0; i < 15; i = i + 1) begin
        for(integer j = 0; j < 11; j = j + 1) begin
            #(CLK_PERIOD);
            tb_border = 1'b0;
            tb_head = 1'b0;
            tb_apple = 1'b0;
            tb_body = 1'b0; 
             if((i == 15) ||  (i == 0) || (j == 0) || (j == 11)) begin
                tb_border = 1'b1;
                check_obj_code(3'b100);
             end
             else if((i == 4) && (j == 4)) begin
                tb_head = 1'b1;
                check_obj_code(3'b001);
             end
             else if((i == 7) && (j == 4)) begin
                tb_apple = 1'b1;
                check_obj_code(3'b011);
             end
             else begin
                check_obj_code (3'b011);
             end
        end
    end
    
    #(CLK_PERIOD * 191);
    for(integer i = 0; i < 15; i = i + 1) begin
        for(integer j = 0; j < 11; j = j + 1) begin
            #(CLK_PERIOD);
            tb_border = 1'b0;
            tb_head = 1'b0;
            tb_apple = 1'b0;
            tb_body = 1'b0; 
             if((i == 15) ||  (i == 0) || (j == 0) || (j == 11)) begin
                tb_border = 1'b1;
                check_obj_code(3'b100);
                check_diff(1'b0);
             end
             else if((i == 5) && (j == 4)) begin
                tb_head = 1'b1;
                check_obj_code(3'b001);
                check_diff(1'b1);
             end
             else if((i == 7) && (j == 4)) begin
                tb_apple = 1'b1;
                check_obj_code(3'b011);
                check_diff(1'b0);
             end
             else if((i == 4) && (j == 4)) begin
                tb_body = 1'b1;
                check_obj_code(3'b010);
                check_diff(1'b1);
            end
             else begin
                check_obj_code(3'b011);
                check_diff(1'b0);
             end
        end
    end

    $finish;

end


endmodule