module rainbowRand(
    input logic clk,
    input logic reset,
    output logic [15:0] rainbowRNG
);

    logic feedback;

    always_ff @(posedge clk, negedge reset) begin
        if (~reset) begin
            // Initialize LFSR with a non-zero value
            rainbowRNG <= 16'h5a08;
        end else begin
            // Calculate feedback
            feedback = rainbowRNG[15] ^ rainbowRNG[13] ^ rainbowRNG[12] ^ rainbowRNG[10];
            // Shift left and insert the feedback bit
            rainbowRNG <= {rainbowRNG[14:0], feedback};
        end
    end

endmodule