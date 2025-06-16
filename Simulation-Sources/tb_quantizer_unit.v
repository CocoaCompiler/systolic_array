`timescale 1ns / 1ps

module tb_quantizer_unit;

    // Inputs
    reg signed [17:0] pso1, pso2, pso3, pso4;

    // Outputs
    wire signed [7:0] q1, q2, q3, q4;

    // Instantiate the Unit Under Test (UUT)
    quantizer_unit uut (
        .pso1(pso1), .pso2(pso2), .pso3(pso3), .pso4(pso4),
        .q1(q1), .q2(q2), .q3(q3), .q4(q4)
    );

    initial begin
        $display("Time\t\tpso1\tpso2\tpso3\tpso4\t|\tq1\tq2\tq3\tq4\t(Expected)");
    
        // Test 1
        pso1 = 18'sd100; pso2 = -18'sd50; pso3 = 18'sd0; pso4 = 18'sd127;
        #10 $display("%0t\t%d\t%d\t%d\t%d\t|\t%d\t%d\t%d\t%d\t(100, -50, 0, 127)", 
                     $time, pso1, pso2, pso3, pso4, q1, q2, q3, q4);
    
        // Test 2
        pso1 = -18'sd128; pso2 = -18'sd129; pso3 = 18'sd127; pso4 = 18'sd128;
        #10 $display("%0t\t%d\t%d\t%d\t%d\t|\t%d\t%d\t%d\t%d\t(-128, 0, 127, 0)", 
                     $time, pso1, pso2, pso3, pso4, q1, q2, q3, q4);
    
        // Test 3
        pso1 = 18'sd300; pso2 = -18'sd300; pso3 = 18'sd200; pso4 = -18'sd200;
        #10 $display("%0t\t%d\t%d\t%d\t%d\t|\t%d\t%d\t%d\t%d\t(0, 0, 0, 0)", 
                     $time, pso1, pso2, pso3, pso4, q1, q2, q3, q4);
    
        // Test 4
        pso1 = 18'sd0; pso2 = 18'sd0; pso3 = 18'sd0; pso4 = 18'sd0;
        #10 $display("%0t\t%d\t%d\t%d\t%d\t|\t%d\t%d\t%d\t%d\t(0, 0, 0, 0)", 
                     $time, pso1, pso2, pso3, pso4, q1, q2, q3, q4);
    
        $finish;
end


endmodule
