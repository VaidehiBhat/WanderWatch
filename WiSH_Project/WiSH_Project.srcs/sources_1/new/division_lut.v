module division_lut (
    input  wire [3:0] index,        // 4-bit index (0 to 8)
    output reg  [15:0] value_out    // S5.10 fixed-point
);

always @(*) begin
    case (index)
    4'd0: value_out = 16'b0000000000000000; // 0.000
    4'd1: value_out = 16'b0000000010000000; // 0.125 * 1024 = 128
    4'd2: value_out = 16'b0000000100000000; // 0.25 * 1024 = 256
    4'd3: value_out = 16'b0000000110000000; // 0.375 * 1024 = 384
    4'd4: value_out = 16'b0000001000000000; // 0.5 * 1024 = 512
    4'd5: value_out = 16'b0000001010000000; // 0.625 * 1024 = 640
    4'd6: value_out = 16'b0000001100000000; // 0.75 * 1024 = 768
    4'd7: value_out = 16'b0000001110000000; // 0.875 * 1024 = 896
    4'd8: value_out = 16'b0000010000000000; // 1.0 * 1024 = 1024
    default: value_out = 16'b0000000000000000;

    endcase
end

endmodule
