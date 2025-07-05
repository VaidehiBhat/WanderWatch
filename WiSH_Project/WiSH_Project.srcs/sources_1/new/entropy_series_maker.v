`timescale 1ns / 1ps


module entropy_series_maker #(parameter WIDTH=16, parameter ARRAY_LENGTH=80)(
input  [WIDTH*ARRAY_LENGTH-1:0] entire_array,
input clk,
input rst,
output reg [ARRAY_LENGTH-1:0]entropy_arr,
output reg done_sig

    );
    reg [ARRAY_LENGTH-1:0] unpacked_arr[WIDTH-1:0];
    reg [2:0] state;
    localparam get_window=0, get_entropy=1, done=2;
    
  //variables for entropy series uut
    reg [WIDTH*8-1:0] array_window;
    reg [WIDTH*8-1:0] temp_arr;
    reg [WIDTH*8-1:0] sub_array;
    reg rst_for_entropy;
    wire [2*WIDTH -1 : 0] entropy_val;
    integer  i;
    reg [4:0]counter;
    wire entropy_done;
    integer start_bit, end_bit;
    entropy_series uut
    ( .array_flat(array_window),
        .rst(rst_for_entropy),
        .clk(clk),
        .entropy_val(entropy_val),
        .entropy_done(entropy_done)
         );
    always @(posedge clk) begin
    if (!rst) begin
        state=get_window;
        rst_for_entropy=0;
        i=0;
        //temp_arr=entire_array[0:15];
        counter<=0;
        done_sig=0;
    end
    else begin
    case (state)
    get_window: begin
    rst_for_entropy=1;
    array_window=entire_array[counter*WIDTH*8 +: WIDTH*8];
    if (entropy_done) begin state=get_entropy;
    end
    end
    get_entropy :  begin
    entropy_arr[counter]=entropy_val;
    state=done;
    end
    
    done: begin
    done_sig=1;
    end
    endcase
    end
    end
endmodule
