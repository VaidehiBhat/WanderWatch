`timescale 1ns / 1ps


module cordic_tb;
parameter WIDTH=16;
reg signed [WIDTH-1:0] x; //divisor
reg signed [WIDTH-1:0] y; //dividend
reg rst;
reg clk;
wire  [WIDTH-1:0] result;
wire signed [WIDTH-1:0] temp_y;
wire signed [WIDTH-1:0] temp_z;
wire [3:0] itercount;
wire signed [1:0] d;
wire signed [1:0] d_temp;
wire signed [WIDTH-1 :0 ] temp;

cordic_div #(WIDTH) uut (
    .x(x),
    .y(y),
    .clk(clk),
    .rst(rst),
    .result(result),
    .temp_y(temp_y),
    .temp_z(temp_z),
    .itercount(itercount),
    .d(d),
    .d_temp(d_temp),
    .temp(temp)
  );
initial clk = 0;
always #5 clk = ~clk;



  initial begin
    // Initialize inputs
    rst = 0;
    x = 16'b0000001001100110;
    y = 16'b1111111000000000;
    
    // Apply reset
    #10 rst = 1;

    // Wait some time to let division complete
    #200;

    // Display result
   // $display("Division result of %d / %d = %d", x, result);

    // Finish simulation
    #10 $finish;
    end
endmodule
