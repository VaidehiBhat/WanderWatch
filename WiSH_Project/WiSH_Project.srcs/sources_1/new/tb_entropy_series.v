`timescale 1ns / 1ps

module tb_entropy_series;

parameter WIDTH = 16;

    reg clk;
    reg rst;
    reg [WIDTH*8-1:0] array_flat;  
    wire signed [2*WIDTH-1:0] entropy_val;

       

    entropy_series #(WIDTH) dut (
        .array_flat(array_flat),
        .rst(rst),
        .clk(clk),
        .entropy_val(entropy_val)
        
    );

    always #5 clk = ~clk;

    initial begin
        $display("Starting entropy_series test...");

        clk = 0;
        rst = 0;

        #5;

        array_flat = {
            16'h0F99, // 3.9
            16'h06F4, // 1.78
            16'h1199, // 4.3
            16'h1ACC, // 6.7
            16'h1200, // 4.5
            16'h0634, // 1.56
            16'h1499, // 5.3
            16'h04F4  // 1.24
        };

        #10 rst = 1;

        #100000;

        $display("Entropy Output = %d", entropy_val);
        $stop;
    end

endmodule
