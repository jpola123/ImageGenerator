module apple_sprite(
    input logic [9:0] count, // 10-bit input to cover the range of indices (0 to 799)
    output logic apple_rgb // 1-bit output to represent the value at the index
);

    always_comb begin
        if ((count <= 1) || 
            (count >= 4 && count <= 17) ||
            (count >= 30 && count <= 63) ||
            (count >= 66 && count <= 95) ||
            (count >= 128 && count <= 129) ||
            (count >= 160 && count <= 191) ||
            (count >= 224 && count <= 225) ||
            (count >= 256 && count <= 319) ||
            (count >= 368 && count <= 383) ||
            (count >= 432 && count <= 495) ||
            (count >= 560 && count <= 591) ||
            (count >= 656 && count <= 719) ||
            (count >= 784 && count <= 799)) begin
            apple_rgb = 0;
        end else begin
            apple_rgb = 1;
        end
    end

endmodule
