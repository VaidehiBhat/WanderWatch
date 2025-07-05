`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2025 01:42:52
// Design Name: 
// Module Name: multiply_2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multiply_2 #(parameter WIDTH=16)(
    input signed [WIDTH-1:0] a,
    input signed [WIDTH-1:0] b,
    output signed [(2*WIDTH)-1:0] product
    );
    assign product= a*b;
endmodule
