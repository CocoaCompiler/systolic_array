`timescale 1ns / 1ps

module tb_memory_loader;

    reg clk;
    reg rst;
    reg startSignal;
    reg result_toggle;
    wire signed [7:0] led;
    wire process_done;

    // Instantiate the memory_loader module
    memory_loader uut (
        .clk(clk),
        .rst(rst),
        .startSignal(startSignal),
        .result_toggle(result_toggle),
        .led(led),
        .process_done(process_done)
    );

    // Clock generation: 20ns period (50MHz)
    always #10 clk = ~clk;

    integer i;

    initial begin
        // === Initialization ===
        //i=0;
        clk = 0;
        rst = 1;
        startSignal = 0;
        result_toggle = 0;

        #200 rst = 0;           // Deassert reset after 200ns
        #200 startSignal = 1;   // Begin matrix processing after another 200ns

        // === Wait for process_done ===
        if (!process_done)
            @(posedge process_done);


        // Buffer time after completion
        #1000;

        // === Simulate human-like toggles ===
        for (i = 0; i < 16; i = i + 1) begin
            // Simulate button press duration (e.g., 100ms)
            result_toggle = 1;
            #100_000_000; // 100 ms

            result_toggle = 0;
            #200_000_000; // 200 ms between presses

            $display("LED Output at index %0d: %d", i, $signed(led));
        end

        #100_000_000 $finish;
    end
endmodule
