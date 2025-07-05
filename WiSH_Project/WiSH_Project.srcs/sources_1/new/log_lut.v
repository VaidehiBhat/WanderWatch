module log_lut (
    input  wire [3:0] index,        // 4-bit input (0 to 8)
    output reg signed [15:0] log2_out     // S5.10 fixed-point
);

always @(*) begin
    case (index)
    4'd0: log2_out = 16'b0000000000000000; // log2(0) = 0 (design decision)
    4'd1: log2_out = 16'b1111010000000000; // log2(1/8) = -3.0
    4'd2: log2_out = 16'b1111100000000000; // log2(2/8) = -2.0
    4'd3: log2_out = 16'b1111101001010111; // log2(3/8) ? -1.415
    4'd4: log2_out = 16'b1111110000000000; // log2(4/8) = -1.0
    4'd5: log2_out = 16'b1111110101001010; // log2(5/8) ? -0.678
    4'd6: log2_out = 16'b1111111001010111; // log2(6/8) ? -0.415
    4'd7: log2_out = 16'b1111111100111011; // log2(7/8) ? -0.193
    4'd8: log2_out = 16'b0000000000000000; // log2(8/8) = 0.0

    endcase
end

endmodule
