`timescale 1ns / 1ps

module scale_within_one # (parameter WIDTH=16)(
input signed [WIDTH-1:0] x,
input clk,
input rst,
output reg signed [WIDTH-1:0] result,
output reg [WIDTH-1:0] scaling_factor

    );
reg sign_bit;
reg  [5:0] numerical_part;
reg [9:0] fractional_part;
reg [14:0] rest_of_num;

always @(posedge clk) begin
    if(!rst) begin
    sign_bit<=x[15];
    if (x[15]==1)begin
    numerical_part<=((~x[15:10])+5'b00001);
    fractional_part<=x[9:0];
    rest_of_num<={numerical_part, fractional_part};    
    end
    else begin numerical_part<=x[15:10];
    fractional_part<=x[9:0];
    rest_of_num<={numerical_part, fractional_part};    
    end

    end
    else begin
     if (rest_of_num<15'b000010000000000) begin
     if (sign_bit==1) result<= {sign_bit, {((~numerical_part)+1), fractional_part}};
     else result <= {sign_bit,rest_of_num};
     scaling_factor<=16'b0000010000000000;
     end
     else if (rest_of_num<15'b001000000000000) begin
     if (sign_bit==1) result<= {sign_bit, {((~numerical_part)+1), fractional_part}>>2};
     else result <= {sign_bit,rest_of_num>>2};
     scaling_factor<=16'b0001000000000000;
     end
     else if (rest_of_num<15'b100000000000000) begin
     if (sign_bit==1) result<= {sign_bit, {((~numerical_part)+1), fractional_part}>>4};
     else result <= {sign_bit,rest_of_num>>4};
     scaling_factor<=16'b0100000000000000;     
     end
     else if (rest_of_num<16'b1000000000000000) begin
     if (sign_bit==1) result<= {sign_bit, {((~numerical_part)+1), fractional_part}>>5};
     else result <= {sign_bit,rest_of_num>>5};
     scaling_factor<=16'b1000000000000000;
    end
 end
end
endmodule
