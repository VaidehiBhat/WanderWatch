`timescale 1ns / 1ps

module sqrt #(parameter WIDTH = 32, parameter HALF_WIDTH = WIDTH >> 1)(
    input wire [WIDTH-1:0] a,
    output reg [HALF_WIDTH-1:0] sqrt
);

    integer i;
    reg [WIDTH-1:0] remainder;
    reg [HALF_WIDTH:0] root;  // One extra bit to avoid overflow

    always @(*) begin
        remainder = 0;
        root = 0;

        // Start from MSB down to LSB
        for (i = HALF_WIDTH - 1; i >= 0; i = i - 1) begin
            root = root << 1;
            remainder = (remainder << 2) | (a >> (2*i)) & 2'b11;

            if (remainder >= ((root << 1) | 1)) begin
                remainder = remainder - ((root << 1) | 1);
                root = root | 1;
            end
        end

        sqrt = root[HALF_WIDTH-1:0];
    end

endmodule
