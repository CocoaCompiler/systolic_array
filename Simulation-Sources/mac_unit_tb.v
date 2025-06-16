`timescale 1ns / 1ps
module mac_unit_tb;
    reg clk;
    reg L;
    reg signed [7:0] wi, ai;
    reg signed [17:0] psi;
    wire signed [17:0] pso;
    wire signed [7:0] ao, wo;
    // Instantiate the MAC unit
    mac_unit uut (
        .clk(clk),
        .L(L),
        .wi(wi),
        .psi(psi),
        .ai(ai),
        .ao(ao),
        .wo(wo),
        .pso(pso)
    );
    always #5 clk = ~clk; // 10ns period clock
    initial begin
        clk = 0;  
        wi = 8'sd2; psi = 18'sd3; ai = 8'sd1; L = 1;
        #10 wi = 8'd4; psi = 18'd5; ai = 8'd2; L = 1;
        #10 wi = 8'd6; psi = 18'd7; ai = 8'd3; L = 1;
        #20 $finish;
    end
    initial begin
        $monitor("Time=%0t | L=%b | wi=%d | psi=%d | ai=%d | ao=%d | wo=%d | pso=%d",
                  $time, L, wi, psi, ai, ao, wo, pso);
    end
endmodule
