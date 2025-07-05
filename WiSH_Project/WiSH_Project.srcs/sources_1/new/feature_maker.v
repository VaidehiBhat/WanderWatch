`timescale 1ns / 1ps

module feature_maker #(parameter WIDTH=16 , parameter ARRAY_LENGTH=80)(
input [WIDTH*ARRAY_LENGTH-1:0] array ,
input clk,
input rst,
output wire [WIDTH-1:0] zcr,
output reg [WIDTH-1:0] entropy_avg,
output reg [WIDTH-1:0] entropy_rms,
output done
    );
    localparam initialize=0 , get_zcr=1 , get_entropy_arr=2 , get_avg_entropy=3, square_series_entropy=4, get_addition=5, divide_by_n=6 , get_rms=7; 
    reg [WIDTH-1:0] divisor;
    reg [WIDTH-1:0] dividend;
    reg rst_for_divide;
    wire [WIDTH-1:0] div_result;
    wire divdone;
    reg rst_for_zcr;
    //reg [WIDTH-1:0] zcr;
    wire done_for_zcr;
    reg [WIDTH-1:0] s;
    reg rst_for_sqrt;
    reg [WIDTH-1:0] sqrt_out;
    wire sqrt_done;
    reg [WIDTH-1:0] sum;
    reg rst_for_entropy_series_maker;
    reg [ARRAY_LENGTH-1:0]entropy_arr;
    wire done_for_entropy;
    reg [WIDTH-1:0] square_arr;
    reg [WIDTH-1:0] to_sqr;
    cordic_div uut1(
    .x(divisor), //divisor
    .y(dividend), //dividend
      .rst(rst_for_divide),
        .clk(clk),
        .result(div_result),
    .divdone(divdone)
);
    zero_crossing_rate uut2(
    .flattened_array(array),
    .clk(clk),
     .rst(rst_for_zcr),
     .zero_crossing_rate(zcr),
      .done_signal(done_for_zcr)
    );
    
    newton_raphson_for_sqrt uut3(
    .s(s),
    .clk(clk),
     .rst(rst_for_sqrt),
      .result(sqrt_out),
        .sqrt_done(sqrt_done)
    );
    
    entropy_series_maker uut4 (
    .entire_array(array),
    .clk(clk),
    .rst(rst_for_entropy_series_maker),
    .entropy_arr(entropy_arr),
    .done_sig(done_for_entropy)
    );
    reg [4:0] state;
    integer i;
    always @(posedge clk) begin
    if(!rst) begin
    rst_for_divide=0;
    rst_for_zcr=0;
    rst_for_sqrt=0;
    rst_for_entropy_series_maker=0;
    state=initialize;
    end
    
    else begin
    case(state) 
    initialize : begin
        rst_for_zcr=1;
        state=get_zcr;
    end
    
    get_zcr :  begin
        if (done_for_zcr==1) begin
        rst_for_entropy_series_maker=1;
        state=get_entropy_arr;
        sum=0;
        end
    end
   
    get_entropy_arr: begin
        if (done_for_entropy==1) begin
            for (i=0 ; i<10 ; i=i+1) begin
                sum=sum+entropy_arr[i];
            end
            state=get_avg_entropy;
            rst_for_divide=1;
 
        end
    end
    
    get_avg_entropy: begin
    dividend=sum;
    divisor=ARRAY_LENGTH;
    
    if (divdone==1) begin
        entropy_avg=div_result;
        state=square_series_entropy;
    end
    end
    
    square_series_entropy : begin
    for (i=0 ; i<10 ; i=i+1) begin
        square_arr[i]=entropy_arr[i]*entropy_arr[i];
    end
    if (i==10) begin
    rst_for_divide=0;
    state=get_addition;
    sum=0;
    end
    end
    
    
    get_addition: begin
    for (i=0 ; i<10 ; i=i+1) begin
        sum=sum+square_arr[i];
    end
    if (i==10) begin
    rst_for_divide=1;
    state=divide_by_n;
    end
    end
    
    divide_by_n: begin
    divisor=ARRAY_LENGTH;
    dividend=sum;
    if (divdone==1) begin
        to_sqr=div_result;
        state=get_rms;
        rst_for_sqrt=1;
    end
    end
    
    get_rms: begin
    s=to_sqr;
    if (sqrt_done==1) begin
        entropy_rms=sqrt_out;
    end
    
    
    end
    
    endcase
    end
end
endmodule
