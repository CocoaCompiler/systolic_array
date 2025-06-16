module activation_unit (
    input wire signed [7:0] q1, q2, q3, q4,
    output reg signed [7:0] a1, a2, a3, a4
);

    always @(*) begin
        a1 = (q1 < 0) ? 8'sd0 : q1;
        a2 = (q2 < 0) ? 8'sd0 : q2;
        a3 = (q3 < 0) ? 8'sd0 : q3;
        a4 = (q4 < 0) ? 8'sd0 : q4;
    end

endmodule
