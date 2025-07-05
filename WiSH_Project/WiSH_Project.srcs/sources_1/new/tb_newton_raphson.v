`timescale 1ns / 1ps

module tb_newton_raphson;

  // Parameters
  parameter WIDTH = 16;
  
  // Inputs
  reg signed [WIDTH-1:0] s;
  reg clk;
  reg rst;

  // Outputs
  wire signed [WIDTH-1:0] result;
  wire sqrt_done;
  // Instantiate the Unit Under Test (UUT)
  newton_raphson_for_sqrt #(WIDTH) uut (
    .s(s),
    .clk(clk),
    .rst(rst),
    .result(result),
    .sqrt_done(sqrt_done)
    
  );

  // Clock generation: 10ns period (100MHz)
  always #5 clk = ~clk;

  initial begin
    // Initialize Inputs
    clk = 0;
    rst = 0;
    s = 16'b0000001000000000;  // 0.5 in Q1.15

    // Apply reset
    #20;
    rst = 1;

    // Run long enough for all iterations
    #800;

    // Finish simulation
    $display("Final result (Q1.15): %0d", result);
    $display("Final result (float): %f", $itor(result) / 32768.0);
    $stop;
  end

endmodule
