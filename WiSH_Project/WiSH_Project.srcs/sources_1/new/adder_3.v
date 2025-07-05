`timescale 1ns / 1ps

module adder_3 #(parameter WIDTH=32)(
input signed [WIDTH-1:0] a,
input signed [WIDTH-1:0] b,
input signed [WIDTH-1:0] c,
output signed [WIDTH:0] addition
);
assign addition=a+b+c;

endmodule