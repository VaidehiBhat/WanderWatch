`timescale 1ns / 1ps


module newtons_1byx#(parameter WIDTH=16)(
input signed [WIDTH-1:0] x,
input clk,
input rst,
output reg signed [WIDTH-1:0] result,
output reg signed [WIDTH-1:0] y,
output reg [4:0] itercount,
output reg done,
output reg temp
    );

always @(posedge clk) begin
    if(!rst) begin
        y<=16'b0000000011001100;
        itercount<=1'b0;   
        done<=1'b0;    
    end
    else begin
        if(itercount<6 & done==0) begin
            y<=y*(2-x*y);
            itercount<=itercount+1;
        end
        else if (itercount==6) begin
            result<=y;
            done<=1'b1;
        end
    
    end

end
endmodule
