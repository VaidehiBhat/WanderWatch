`timescale 1ns / 1ps

module cordic_div#(parameter WIDTH=16)(
input signed [WIDTH-1:0] x, //divisor
input signed [WIDTH-1:0] y, //dividend
input rst,
input clk,
output reg [WIDTH-1:0] result,
output reg divdone
);
reg signed [WIDTH+2:0] temp_y;
 reg signed [WIDTH-1:0] temp_z;
 reg signed [4:0] itercount;
 reg signed[1:0]  d;
 reg signed [1:0] d_temp;
 reg signed [WIDTH+2 :0 ] temp;
 reg init;
always @(posedge clk)
begin
if (!rst) begin
    itercount<=5'b00000;
    temp_y<=y;
    temp_z<=1'b0;
    result<=0;
    divdone<=0;
    if (y<0) d<=2'b01;
    else d<=2'b11;

end

else begin

    if (itercount<5) begin
        if(temp_y<0) 
            d=2'b01;
      
        else 
            d=2'b11;
    
        temp<=x*d;
        d_temp<=d;
        temp_y <= temp_y + ((x*d) >>> itercount);
        temp_z <= temp_z -(d*(16'sb0000010000000000>>>itercount));
        itercount<=itercount+1;

    end
    
    else if (itercount==5) begin
        result<=temp_z;
        divdone<=1;
    end
    
end
    


end


endmodule

