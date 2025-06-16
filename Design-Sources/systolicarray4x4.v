module systolicarray4x4 (
    input wire rst,
    input wire clk,
    input wire L,  
    input signed [7:0]  ai0, ai1, ai2, ai3,
    input signed [7:0]  wi0, wi1, wi2, wi3,
    output signed [17:0] pso0, pso1, pso2,pso3
);
  
    wire signed [7:0] wo00, wo10, wo20, wo30; 
    wire signed [7:0] wo01, wo11, wo21, wo31; 
    wire signed [7:0] wo02, wo12, wo22, wo32; 
    wire signed [7:0] wo03, wo13, wo23, wo33; 

    wire signed [7:0] ao00, ao10, ao20, ao30; 
    wire signed [7:0] ao01, ao11, ao21, ao31; 
    wire signed [7:0] ao02, ao12, ao22, ao32; 
    wire signed [7:0] ao03, ao13, ao23, ao33; 
    
    wire signed [17:0] pso00, pso10, pso20;
    wire signed [17:0] pso01, pso11, pso21;
    wire signed [17:0] pso02, pso12, pso22;
    wire signed [17:0] pso03, pso13, pso23;

    // 4x4 Systolic Array
    //mac_unit m (rst, clk, L, wi, psi, ai, ao, wo, pso)
    
    // Col 1
    mac_unit w11 (.rst(rst), .clk(clk), .L(L), .wi(wi0), .psi(18'b0),.ai(ai0), .wo(wo00), .ao(ao00), .pso(pso00)); 
    mac_unit w12 (.rst(rst), .clk(clk), .L(L), .wi(wo00), .psi(pso00), .ai(ai1), .wo(wo10), .ao(ao10), .pso(pso10)); 
    mac_unit w13 (.rst(rst), .clk(clk), .L(L), .wi(wo10), .psi(pso10), .ai(ai2), .wo(wo20), .ao(ao20), .pso(pso20)); 
    mac_unit w14 (.rst(rst), .clk(clk), .L(L), .wi(wo20), .psi(pso20), .ai(ai3), .wo(wo30), .ao(ao30), .pso(pso0)); 
    // Col 2
    mac_unit w21 (.rst(rst), .clk(clk), .L(L), .wi(wi1), .psi(18'b0),.ai(ao00), .wo(wo01), .ao(ao01), .pso(pso01)); 
    mac_unit w22 (.rst(rst), .clk(clk), .L(L), .wi(wo01), .psi(pso01), .ai(ao10), .wo(wo11), .ao(ao11), .pso(pso11)); 
    mac_unit w23 (.rst(rst), .clk(clk), .L(L), .wi(wo11), .psi(pso11), .ai(ao20), .wo(wo21), .ao(ao21), .pso(pso21)); 
    mac_unit w24 (.rst(rst), .clk(clk), .L(L), .wi(wo21), .psi(pso21), .ai(ao30), .wo(wo31), .ao(ao31), .pso(pso1)); 
    // Col 3
    mac_unit w31 (.rst(rst), .clk(clk), .L(L), .wi(wi2), .psi(18'b0),.ai(ao01), .wo(wo02), .ao(ao02), .pso(pso02)); 
    mac_unit w32 (.rst(rst), .clk(clk), .L(L), .wi(wo02), .psi(pso02), .ai(ao11), .wo(wo12), .ao(ao12), .pso(pso12));
    mac_unit w33 (.rst(rst), .clk(clk), .L(L), .wi(wo12), .psi(pso12), .ai(ao21), .wo(wo22), .ao(ao22), .pso(pso22)); 
    mac_unit w34 (.rst(rst), .clk(clk), .L(L), .wi(wo22), .psi(pso22), .ai(ao31), .wo(wo32), .ao(ao32), .pso(pso2)); 
    // Col 4
    mac_unit w41 (.rst(rst), .clk(clk), .L(L), .wi(wi3), .psi(18'b0), .ai(ao02), .wo(wo03), .ao(ao03), .pso(pso03)); 
    mac_unit w42 (.rst(rst), .clk(clk), .L(L), .wi(wo03), .psi(pso03), .ai(ao12), .wo(wo13), .ao(ao13), .pso(pso13)); 
    mac_unit w43 (.rst(rst), .clk(clk), .L(L), .wi(wo13), .psi(pso13), .ai(ao22), .wo(wo23), .ao(ao23), .pso(pso23)); 
    mac_unit w44 (.rst(rst), .clk(clk), .L(L), .wi(wo23), .psi(pso23), .ai(ao32), .wo(wo33), .ao(ao33), .pso(pso3)); 
    
//    always @(posedge clk) begin
//        if (!rst) begin
//            $display(" %d, %d, %d, %d", 
//                     pso0, pso1, pso2, pso3);
//        end
//    end
    
endmodule
