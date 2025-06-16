module quantizer_unit (
    input wire signed [17:0] pso1,
    input wire signed [17:0] pso2,
    input wire signed [17:0] pso3,
    input wire signed [17:0] pso4,
    output reg signed [7:0] q1,
    output reg signed [7:0] q2,
    output reg signed [7:0] q3,
    output reg signed [7:0] q4);
    always @(*) begin
        // Quantize pso1
        if (pso1 > 127 || pso1 < -128)
            q1 = 8'sd0;
        else
            q1 = pso1[7:0];
        // Quantize pso2
        if (pso2 > 127 || pso2 < -128)
            q2 = 8'sd0;
        else
            q2 = pso2[7:0];
        // Quantize pso3
        if (pso3 > 127 || pso3 < -128)
            q3 = 8'sd0;
        else
            q3 = pso3[7:0];
        // Quantize pso4
        if (pso4 > 127 || pso4 < -128)
            q4 = 8'sd0;
        else
            q4 = pso4[7:0];
    end
endmodule
