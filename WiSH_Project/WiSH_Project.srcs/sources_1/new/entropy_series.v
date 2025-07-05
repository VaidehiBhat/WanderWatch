`timescale 1ns / 1ps

module entropy_series #(parameter WIDTH=16)(
input [WIDTH*8-1:0] array_flat,
input rst,
input clk,
output reg signed [2*WIDTH-1:0] entropy_val,
output reg entropy_done
    );
     localparam ITERATE_ARRAY = 0, PROBABILITY_ARRAY = 1, ENTROPY_ARRAY = 2;
    reg [3:0] index_log;
    wire signed [15:0] log2_out;
    reg [5:0] index_div;
    wire [15:0] value_out;
   
    log_lut uut (
        .index(index_log),
        .log2_out(log2_out)
    );   
    
    division_lut uut1(
     .index(index_div),        
    .value_out(value_out)   
);
    reg [5:0] amplitude_bins [9:0]; 
    reg [5:0] counter [9:0];
    reg signed [WIDTH-1:0] probability_array [9:0];
    reg [2:0] state;
    reg [5:0] floor;
    integer i;
    integer j;
    integer k;
    integer l;
    integer n;
    reg [WIDTH-1:0] array [7:0];
    integer m;
    reg [1:0] internal_state=0;
    integer q=0;
    integer r=0;
    reg [1:0] entropy_state=0;
    reg [5:0] prob_index;

    always @(posedge clk) begin
    if (!rst) begin
         for (i = 0; i < 10; i = i + 1) begin
            counter[i] <= 6'b000000;
            end
         for (m = 0; m < 8; m = m + 1) begin
            array[m]= array_flat[m*WIDTH +: WIDTH];
        $display ("displaying array = %h" , array[m]);
        
        end
        entropy_done=0;
         entropy_val<=0;
         state<=ITERATE_ARRAY;
    end
    
    else begin
    case (state) 
    ITERATE_ARRAY: begin
        $display("Iterate array state");
        for (j=0 ; j<8 ; j=j+1) begin
            counter[array[j][15:10]]=counter[array[j][15:10]]+1;
        end
                $display(j);
        if(j==8) state<=PROBABILITY_ARRAY;
    end
    
    PROBABILITY_ARRAY : begin
        //$display("Probability array STATE");
         //for (n=0 ; n<10 ; n=n+1) 
        //$display("value of n is=%d", n, "counter is =%b" , counter[n]);
        //$display(" q is=%d ", q);
        case (internal_state)
    
      0: begin
             //$display("internal_state=" , internal_state);
            if (q < 10) begin
                index_div = counter[q]; 
                $display("index div is: = %b" , index_div);
                //prob_index = q; 
                internal_state = 1;  
                //internal_state = 0;
            end 
            else internal_state=1;
            end
    1: begin
        
        //$display("value of n is=%d", q, "probability array is =%d" , probability_array[q]);
        //$display(state);
        //$display("internal_state=" , internal_state);
        if (q == 10) begin
            $display("reached q=10, will enter entropy array now");
            state <= ENTROPY_ARRAY;
           //internal_state = 0;
        end else begin
            probability_array[q] = value_out;
            //$display("value output after division is=%b  " , value_out);
            q = q + 1;
            internal_state = 0;
        end
    end
        
    endcase
         
       
        /*for (k=0 ; k<50 ; k=k+1) begin
            index_div=counter[k];
            probability_array[k]<=value_out;
        end
        for (n=0 ; n<50 ; n=n+1) 
        $display("value of n is=%d", n, "probability array is =%d" , probability_array[n]);
        if (k==50) state<=ENTROPY_ARRAY;*/
       
        
    end
    
    ENTROPY_ARRAY : begin
    //$display("inside entropy state");
    //for (n=0 ; n<10 ; n=n+1) 
    //    $display("value of n is=%d", n, "probability array is =%b" , probability_array[n]);
    case (entropy_state) 
    2'b00: begin
        if (r<10) begin
            index_log=counter[r];
            entropy_state=2'b01;
            
        end
    //else entropy_state=2'b01;
    end
    
    2'b01: begin
        entropy_val= (entropy_val+ probability_array[r]*log2_out);
        r<=r+1;
        $display("r is : =%d and entropy_val =%b and probability_array value =%b and log_2=%b" , r , entropy_val, probability_array[r] , log2_out);
        entropy_state=2'b00;
        if (r==9) begin entropy_val=-(entropy_val);
        entropy_done=1;
        end
    end
    endcase
    end
    
        /*for (l=0 ; l<50 ; l=l+1) begin
            index_log=counter[l];
            entropy_val= -(entropy_val+ probability_array[l]*log2_out);
        end
    
    end*/

    endcase
    end
  
    
    end
    
endmodule
