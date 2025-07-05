`timescale 1ns / 1ps


module top#(parameter WIDTH=16, ARRAY_LENGTH=80)(
input [WIDTH*ARRAY_LENGTH-1:0] array,
input rst,
input clk,
output [WIDTH-1:0] decision
    );
localparam init=0 , get_feats=1, get_decision=2;   
reg rst_for_feature;
reg [WIDTH-1:0] zcr;
reg [WIDTH-1:0] entropy_avg;
reg [WIDTH-1:0] entropy_rms;
reg done;
reg [2:0] state;
//reg rst_for_DT;
feature_maker uut1(
.array(array) ,
.clk(clk),
.rst(rst_for_feature),
.zcr(zcr),
.entropy_avg(entropy_avg),
.entropy_rms(entropy_rms),
.done(done)
    ); 
    
 decision_tree uut2(
 .zcr(zcr),
.entropy_avg(entropy_avg),
.entropy_rms(entropy_rms),
.clk(clk),
.decision(decision)
 );  

always @(posedge clk) begin
if(!rst) begin
rst_for_feature=0;
end

else begin
case (state) 
init: begin
    rst_for_feature=1;
    state=get_feats;
end

get_feats:  begin
if(done==1) begin
state=get_decision;
end
end

get_decision:begin
//we got decision
end


endcase
end


end
  
endmodule
