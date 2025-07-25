// sqrt_cordic.v
// Module to instantiate the Xilinx CORDIC IP for Square Root
// Based on the provided IP symbol and common AXI Stream conventions.

module sqrt_cordic
    #(
        parameter INPUT_WIDTH  = 8,  // Input Width for num_in (matches CORDIC IP configuration)
        parameter OUTPUT_WIDTH = 8   // Output Width for sq_root (matches CORDIC IP configuration)
    )
    (
        // System Signals
        input wire clk,       // Clock for the CORDIC IP (corresponds to 'aclk')
        input wire reset_n,   // Active-low asynchronous reset (corresponds to 'aresetn')
        input wire clk_en,    // Clock enable (corresponds to 'aclken')

        // User Input (number for which to find the square root)
        input wire [INPUT_WIDTH-1:0] num_in,
        input wire                   num_in_valid, // Assert high when num_in is valid
        output wire                  num_in_ready, // Goes high when the IP is ready to accept num_in

        // User Output (calculated square root)
        output wire [OUTPUT_WIDTH-1:0] sq_root,
        output wire                    sq_root_valid, // Goes high when sq_root is valid
        input wire                     sq_root_ready  // Assert high when you are ready to consume sq_root
    );

    // Internal wires for connecting to the CORDIC IP
    // These match the expected port names from your CORDIC IP instance
    // (based on common AXI Stream naming conventions).
    wire [INPUT_WIDTH-1:0] cordic_s_axis_cartesian_tdata;
    wire                   cordic_s_axis_cartesian_tvalid;
    wire                   cordic_s_axis_cartesian_tready; // Expected AXI Stream signal

    // For Square Root function, s_axis_phase is typically tied to 0 or unused.
    // Given it's an 'UnsignedFraction' format and the function is Square Root,
    // we'll tie its data to 0 and valid to the Cartesian input's valid.
    wire [INPUT_WIDTH-1:0] cordic_s_axis_phase_tdata;
    wire                   cordic_s_axis_phase_tvalid;
    wire                   cordic_s_axis_phase_tready; // Expected AXI Stream signal


    wire [OUTPUT_WIDTH-1:0] cordic_m_axis_dout_tdata;
    wire                   cordic_m_axis_dout_tvalid;
    wire                   cordic_m_axis_dout_tready; // Expected AXI Stream signal


    // Connect top-level module ports to internal CORDIC IP ports

    // Input s_axis_cartesian connection
    assign cordic_s_axis_cartesian_tdata  = num_in;
    assign cordic_s_axis_cartesian_tvalid = num_in_valid;
    assign num_in_ready                   = cordic_s_axis_cartesian_tready; // This is crucial for backpressure

    // Input s_axis_phase connection (tied for Square Root)
    // For UnsignedFraction, ensure this 0 matches the format.
    assign cordic_s_axis_phase_tdata  = {INPUT_WIDTH{1'b0}}; // Tie to 0
    assign cordic_s_axis_phase_tvalid = num_in_valid;       // Valid when cartesian is valid
    // Assuming phase_tready is handled similarly to cartesian_tready by the IP.
    // If cordic_s_axis_cartesian_tready is low, both inputs should pause.
    // For simplicity, we can assume this will be ready if cartesian is ready.
    // In a real scenario, you might need to OR the tready signals for the source.

    // Output m_axis_dout connection
    assign sq_root                        = cordic_m_axis_dout_tdata;
    assign sq_root_valid                  = cordic_m_axis_dout_tvalid;
    assign cordic_m_axis_dout_tready      = sq_root_ready; // This is crucial for backpressure


    // Instantiate the CORDIC IP
    // The component name is 'cordic_0'.
    // IMPORTANT: Make sure 'cordic_0' is correctly generated by Vivado and
    // its definition is accessible in your project for synthesis/simulation.
    cordic_0
    i_cordic_0 (
        .aclk                      (clk),
        .aresetn                   (reset_n),    // Connect the active-low reset
        .aclken                    (clk_en),     // Connect the clock enable

        // AXI Stream for s_axis_cartesian
        .s_axis_cartesian_tdata    (cordic_s_axis_cartesian_tdata),
        .s_axis_cartesian_tvalid   (cordic_s_axis_cartesian_tvalid),
        .s_axis_cartesian_tready   (cordic_s_axis_cartesian_tready), // Must connect if exists

        // AXI Stream for s_axis_phase
        .s_axis_phase_tdata        (cordic_s_axis_phase_tdata),
        .s_axis_phase_tvalid       (cordic_s_axis_phase_tvalid),
        .s_axis_phase_tready       (cordic_s_axis_phase_tready), // Must connect if exists

        // AXI Stream for m_axis_dout
        .m_axis_dout_tdata         (cordic_m_axis_dout_tdata),
        .m_axis_dout_tvalid        (cordic_m_axis_dout_tvalid),
        .m_axis_dout_tready        (cordic_m_axis_dout_tready)   // Must connect if exists
    );

endmodule