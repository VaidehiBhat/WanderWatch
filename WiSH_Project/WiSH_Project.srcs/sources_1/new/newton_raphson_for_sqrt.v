`timescale 1ns / 1ps

module newton_raphson_for_sqrt #(parameter WIDTH=16)(
input signed [WIDTH-1:0] s,
input clk,
input rst,
output reg signed [WIDTH-1:0] result,
output reg sqrt_done

    );
    

    localparam IDLE = 0, DIV_WAIT = 1, NEWT_ITER = 2, DONE = 3;

//we assume that everything is already scaled, we'll either scale everything at inception of the data or see how to handle it later
  reg signed [WIDTH-1:0] xn;
   reg [4:0] itercount;
  reg [2:0] state;
    //for divisionzz
 reg signed [WIDTH-1:0] divisor;
 reg signed [WIDTH-1:0] dividend;
 reg rst_for_div;
 wire [WIDTH-1:0] div_result;
 wire divdone ;

    
    cordic_div divider (
    .x(divisor),
    .y(dividend),
    .clk(clk),
    .rst(rst_for_div),
    .result(div_result),
    .divdone(divdone)
    );

    always@(posedge clk) begin
    if (!rst) begin
    xn<=16'b0000010000000000;
    itercount<=5'b00000;
    rst_for_div<=0;
    dividend<=s;
    divisor<=xn;
    state<=IDLE;
    sqrt_done<=0;
    $display("child reset active");
    end
    
    else 
    begin
    case(state)
    IDLE: begin
    rst_for_div <= 0; 
    divisor<=xn; 
    state <= DIV_WAIT;
    $display("inside IDLE state");
    end
    
    DIV_WAIT: begin
    rst_for_div<=1;
    if (divdone) begin
        rst_for_div<=0;
        state<=NEWT_ITER;
            end
    $display("div wait state");
    end
            
    NEWT_ITER: begin
    xn<=((xn + div_result)>> 1);
    itercount<=itercount+1;
    if (itercount<5) state <=IDLE;
    else if (itercount==5) state <=DONE;
    $display("inside newt iter");
    end
    
    DONE : begin
    result<=xn;
    sqrt_done<=1;
    $display("inside done");
    end

    endcase
    end

    end
endmodule
