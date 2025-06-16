`timescale 1ns / 1ps

module tb_activation_unit;

    // Inputs
    reg signed [7:0] q1, q2, q3, q4;

    // Outputs
    wire signed [7:0] a1, a2, a3, a4;

    // Instantiate the Unit Under Test (UUT)
    activation_unit uut (
        .q1(q1), .q2(q2), .q3(q3), .q4(q4),
        .a1(a1), .a2(a2), .a3(a3), .a4(a4)
    );

    initial begin
        $display("Time\tq1\tq2\tq3\tq4\t|\ta1\ta2\ta3\ta4\t(Expected)");

        // Test 1: All positive
        q1 = 8'sd10; q2 = 8'sd50; q3 = 8'sd127; q4 = 8'sd1;
        #10 $display("%0t\t%d\t%d\t%d\t%d\t|\t%d\t%d\t%d\t%d\t(10, 50, 127, 1)", $time, q1, q2, q3, q4, a1, a2, a3, a4);

        // Test 2: Mixed
        q1 = -8'sd5; q2 = 8'sd0; q3 = -8'sd127; q4 = 8'sd100;
        #10 $display("%0t\t%d\t%d\t%d\t%d\t|\t%d\t%d\t%d\t%d\t(0, 0, 0, 100)", $time, q1, q2, q3, q4, a1, a2, a3, a4);

        // Test 3: All negative
        q1 = -8'sd1; q2 = -8'sd20; q3 = -8'sd100; q4 = -8'sd128;
        #10 $display("%0t\t%d\t%d\t%d\t%d\t|\t%d\t%d\t%d\t%d\t(0, 0, 0, 0)", $time, q1, q2, q3, q4, a1, a2, a3, a4);

        // Test 4: Zeros
        q1 = 8'sd0; q2 = 8'sd0; q3 = 8'sd0; q4 = 8'sd0;
        #10 $display("%0t\t%d\t%d\t%d\t%d\t|\t%d\t%d\t%d\t%d\t(0, 0, 0, 0)", $time, q1, q2, q3, q4, a1, a2, a3, a4);

        $finish;
    end

endmodule
