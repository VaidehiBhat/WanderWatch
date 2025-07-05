`timescale 1ns / 1ps


module decision_tree#(parameter WIDTH=16 , parameter zcr_threshold=10, parameter avg=10, parameter rms=10)(
input [WIDTH-1:0] zcr,
input [WIDTH-1:0] entropy_avg,
input [WIDTH-1:0] entropy_rms,
input clk,
output reg  [WIDTH-1:0] decision
    );
always @(posedge clk) begin
if(zcr>zcr_threshold) begin
    decision=1;
    end
    else begin
    if (entropy_avg<avg) begin
    decision=1;
    end
    else begin
    if (entropy_rms<rms) begin
    decision=0;
    end
    else begin
    decision=0;
    
    
    end
    
    
    end


end
end
endmodule
