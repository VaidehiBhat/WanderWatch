`timescale 1ns/1ps

module tb_scale_within_one;

  parameter WIDTH = 16;

  reg clk;
  reg rst;
  reg signed [WIDTH-1:0] x; // divisor
  wire signed [WIDTH-1:0] result;
  wire  [WIDTH-1:0] scaling_factor;
  wire sign_bit;
  wire [14:0] rest_of_num;
  wire [5:0] numerical_part;
  wire [9:0] fractional_part;
  // Instantiate the divider
  scale_within_one #(WIDTH) uut (
    .x(x),
    .clk(clk),
    .rst(rst),
    .result(result),
    .scaling_factor(scaling_factor),
    .sign_bit(sign_bit),
    .rest_of_num(rest_of_num),
    .numerical_part(numerical_part),
    .fractional_part(fractional_part)
  );

  // Clock generation: 10ns period
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    rst = 0;
    x = 16'b1111111000000000;
    #40 rst=1;
    
    /*#20;
    rst = 0;
    #20 rst=1;
    x=16'b0001010000000000;
    #20;
    rst = 0;
    #20 rst=1;
    x=16'b1101010000000000;
    #20;
    rst = 0;
    #20 rst=1;
    x=16'b1111111000000000;*/
    // Wait some time to let division complete
    #40;

    // Display result
   // $display("Division result of %d / %d = %d", x, result);

    // Finish simulation
    #10 $finish;
  end

endmodule
