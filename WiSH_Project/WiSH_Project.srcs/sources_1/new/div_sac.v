`timescale 1ns / 1ps


module div_sac #(parameter WIDTH=16)(
input [WIDTH-1:0] x,//divisor
input [WIDTH-1:0] y, //dividend
input clk,
input rst,
output reg [WIDTH-1:0] result
    );
reg [WIDTH-1:0] temp_y;
reg [WIDTH-1:0] itercount;
reg complete;
always @(posedge clk) begin
    if(!rst) begin
        temp_y=y;
        itercount=0;
        complete=0;
    end
    else begin
        if (temp_y>=x & complete==0) begin
            temp_y<=temp_y-x;
            itercount<=itercount+1;
          end
          else begin
            result=itercount;
            complete=1;    
          end
    end

end
     
endmodule
