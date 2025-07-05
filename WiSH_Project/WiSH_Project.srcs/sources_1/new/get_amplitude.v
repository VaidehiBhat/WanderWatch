`timescale 1ns / 1ps


module get_amplitude #(parameter WIDTH=16)(
input signed [WIDTH-1:0] x,
input signed [WIDTH-1:0] y,
input signed [WIDTH-1:0] z,
input clk,
input rst,
output reg signed [WIDTH-1:0] amplitude
);
    reg signed [WIDTH-1:0] s;
    reg [1:0] rst_for_sqrt;
    wire signed [WIDTH-1:0] sqrt_result;
    reg [3:0] state;
    reg [2*WIDTH-1:0] temp_s;
    reg sign_bit;
    reg [9:0] fractional_bits;
    reg [4:0] decimal_bits;
    wire sqrt_done;
    newton_raphson_for_sqrt uut(
    .s(s), 
    .clk(clk),
    .rst(rst_for_sqrt),
    .result(sqrt_result),
    .sqrt_done(sqrt_done)
    );
    
    always @(posedge clk) begin
    if(!rst) begin state=0; rst_for_sqrt=0; end
    else begin
    case (state) 
    0: begin
        $display("in state 0");
        rst_for_sqrt=0;
        state=1;
    end
    1: begin
        $display("in state 1");
        rst_for_sqrt=1;
        temp_s= (x*x + y*y + z*z);
        $display("temp_s = %b " , temp_s);
        state=2;
    end
    
    2: begin
        $display("in state 2");
        $display("rst val for sqrt= %d" , rst_for_sqrt);
        sign_bit=temp_s[31];
        decimal_bits=temp_s[24:20];
        fractional_bits=temp_s[19:10]; //works for temp_s is positive, which it is
        s={sign_bit, decimal_bits, fractional_bits};
       $display("s = %b " , s);
       state=3;
       
    end
    3: begin
        $display("entered state 3");
        if (sqrt_done==1) begin
       $display("entered if");
        state=4;
        end
    end
    4: begin
    $display("in state 4");
        amplitude=sqrt_result;
        $display(amplitude);
    end
    
    
    endcase
    end
    end
endmodule
