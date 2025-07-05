`timescale 1ns / 1ps


module zero_crossing_rate#(parameter WIDTH=16 , parameter ARRAY_LENGTH=80)(
input [WIDTH*ARRAY_LENGTH-1:0] flattened_array,
input clk,
input rst,
output reg [WIDTH-1:0] zero_crossing_rate,
output reg done_signal
    );
localparam UNPACK=0 , COUNT=1, DONE=2;
reg [WIDTH-1:0] counter;
reg [16:0] i;
reg [2:0] state;
reg [15:0] temp_zcr;
reg [WIDTH-1:0] temp_arr [ARRAY_LENGTH-1:0];

always @(posedge clk) begin
    if (!rst) begin
    counter<=0;
    state=UNPACK;
    done_signal<=0;
    end
    else
    case (state)
    UNPACK: begin
        $display("in state Unpack");
        for(i=0 ; i<ARRAY_LENGTH ; i=i+1) begin
            temp_arr[i] = flattened_array[(i+1)*WIDTH-1 -: WIDTH];
            $display("temp_arr[i] = %h" , temp_arr[i]);
            
        end
        if (i==ARRAY_LENGTH) state<=COUNT;
    end
    
    COUNT: begin
        $display("in state Count");
        for (i=1 ; i<ARRAY_LENGTH ; i=i+1) begin
            if ( temp_arr[i][15]!=temp_arr[i-1][15]) begin
                counter=counter+1;
                $display("i is =%d , counter is %d" , i, counter);
            end
        if (i==ARRAY_LENGTH-1) state<=DONE;   
        end
        end
        
    DONE: begin
    $display("in state done");    
    zero_crossing_rate=counter;
    done_signal=1;
    $display("zero_crossing_rate=%d" , zero_crossing_rate);
    end

    endcase
 
    end


endmodule
