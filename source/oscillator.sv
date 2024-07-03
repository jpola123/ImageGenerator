/* typedef enum logic {
    OFF = 1'b0,
    ON = 1'b1
} MODE_TYPES; */

module oscillator
#(
    parameter N = 8
)
(
    input logic clk, nRst,
    //input logic [7:0] freq,
    input MODE_TYPES state,
    input logic goodColl, badColl,
    input logic [3:0] direction,
    output logic at_max
);
logic [7:0] freq, freq_nxt;
logic [N - 1:0] count, count_nxt;
logic [23:0] stayCount, stayCount_nxt;
logic at_max_nxt, keepCounting, keepCounting_nxt;
always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        count <= 0;
        at_max <= 0;
        stayCount <= 0;
        keepCounting <= 0;
        freq <= 0;
    end else begin
        count <= count_nxt;
        at_max <= at_max_nxt;
        stayCount <= stayCount_nxt;
        keepCounting <= keepCounting_nxt;
        freq <= freq_nxt;
    end
end

always_comb begin
    at_max_nxt = at_max;
    count_nxt = count;
    keepCounting_nxt = keepCounting;
    stayCount_nxt = stayCount;

    freq_nxt = freq;
    if (goodColl && ~keepCounting) begin
        freq_nxt = 8'd107; // 12M / ((1/440) / 256) - A
    end
    if (badColl && ~keepCounting) begin
        freq_nxt = 8'd151; // 12M / ((1/311) / 256) - D Sharp
    end
    if (|direction && ~keepCounting) begin
        freq_nxt = 8'd179; // 12M / ((1/262) / 256) - C
    end

    if (at_max == 1'b1) begin
        at_max_nxt = 1'b0;
    end
    if (goodColl || badColl) begin
        keepCounting_nxt = 1'b1;
    end
    if (keepCounting_nxt) begin
        if (stayCount < 10000000) begin
            if (count < freq_nxt) begin
                count_nxt = count + 1;
            end else if (count >= freq_nxt) begin 
                at_max_nxt = 1'b1;
                count_nxt = 0;
            end
            stayCount_nxt = stayCount + 1;
        end else begin
            keepCounting_nxt = 1'b0;
            stayCount_nxt = 0;
        end
    end else if (~keepCounting_nxt) begin
        count_nxt = 0;
        at_max_nxt = 1'b0;
    end
end

endmodule
