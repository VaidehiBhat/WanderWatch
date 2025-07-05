`timescale 1ns / 1ps

module zero_crossing_tb;

parameter WIDTH = 16;
parameter ARRAY_LENGTH = 10;

reg clk;
reg rst;
reg [WIDTH*ARRAY_LENGTH-1:0] flattened_array;
wire [WIDTH-1:0] zero_crossing_rate;
wire done_signal;

// Instantiate the DUT (Device Under Test)
zero_crossing_rate #(WIDTH, ARRAY_LENGTH) dut (
    .flattened_array(flattened_array),
    .clk(clk),
    .rst(rst),
    .zero_crossing_rate(zero_crossing_rate),
    .done_signal(done_signal)
);

// Clock generation
initial clk = 0;
always #5 clk = ~clk;  // 100MHz clock

// Test logic
initial begin
    // Initialize input
    rst = 0;
    flattened_array = 0;
    #10;

    // Provide flattened_array of 10 signed 16-bit values
// Values: [-1.0, 1.0, -2.0, 2.0, -3.0, 3.0, -4.0, 4.0, -5.0, 5.0]
flattened_array = {
    16'h1400, //  5.0
    16'hEC00, // -5.0
    16'h1000, //  4.0
    16'hF000, // -4.0
    16'h0C00, //  3.0
    16'hF400, // -3.0
    16'h0800, //  2.0
    16'hF800, // -2.0
    16'h0400, //  1.0
    16'hFC00  // -1.0
};
    rst = 1;  // Apply reset (active high)
    #100;

    // Wait for done
    wait(done_signal);
    $display("Zero Crossing Rate = %d", zero_crossing_rate);

    #20;
    $finish;
end

endmodule
