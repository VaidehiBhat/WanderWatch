`timescale 1ns / 1ps

module get_amplitude_tb;
    parameter WIDTH = 16;

    reg clk;
    reg signed [WIDTH-1:0] x, y, z;
    reg rst;
    wire signed [WIDTH-1:0] amplitude;
    
    // Instantiate the DUT (Device Under Test)
    get_amplitude #(WIDTH) dut (
        .x(x),
        .y(y),
        .z(z),
        .clk(clk),
        .rst(rst),
        .amplitude(amplitude)
    );

    // Generate clock
    always #5 clk = ~clk; // 10ns period

    initial begin
        
        // Initialize
        clk = 0;
        rst=0;
        x = 16'sd512; // 0.5 in Q5.10
        y = 16'sd0;
        z = 16'sd0;
        
        #40 rst=1;
        
        // Wait enough time for FSM to run (up to state 3)
        #10000;

        $display("Amplitude Output = %d (Q5.10)", amplitude);
        $display("Amplitude Output (as float) = %f", amplitude / 1024.0);

        $finish;
    end

endmodule
