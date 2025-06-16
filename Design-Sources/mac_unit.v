module mac_unit(
    input wire rst,
    input wire clk,         
    input wire L,           
    input signed [7:0] wi,    
    input signed [17:0] psi,  
    input signed [7:0] ai,    
    output reg signed [7:0] wo,   // Pass Down  
    output reg signed [7:0] ao,   // Pass Right
    output reg signed [17:0] pso  // Pass Down
);
  
   
    always @(posedge clk) begin
        if (rst) begin
            ao <= 0; 
            wo <= 0;
            pso <= 0;
        end
        // Latch activation and weight
        ao <= ai;   
        if (L) begin
            wo <= wi;  // Register wi when L is high
        end else begin
            wo <= wo;  // Retain previous value if L is low
        end
        // Perform the multiply-accumulate operation
        pso <= (wo * ao) + psi; 
    end
endmodule
