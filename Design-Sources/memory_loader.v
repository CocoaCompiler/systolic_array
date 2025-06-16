module memory_loader(
    output reg signed [7:0] led,
    output reg process_done,
    input clk,
    input rst,
    input startSignal,
    input result_toggle
    );
    reg [3:0] display_index = 0;          // Index to cycle through result_matrix (0-15)
    reg [19:0] stable_counter = 0; // Enough bits to count up to at least 50
    reg toggle_state = 0;         // Last stable state of result_toggle


    reg [4:0] cycle_count;
    
    reg signed [7:0] Weight_Memory [0:15];
    reg signed [7:0] Feature_Memory [0:15];
    
    reg signed [7:0] ai0, ai1, ai2, ai3; // systolic array input features
    reg signed [7:0] wi0, wi1, wi2, wi3; // systolic array input weights
    wire signed [17:0] pso0, pso1, pso2, pso3; // systolic array output
    wire signed [7:0] q1, q2, q3, q4; // quantizer output 
    wire signed [7:0] a0, a1, a2, a3; // activation outputs
    
    reg signed [17:0] result_matrix [0:15]; // final result matrix (of 2 input matrices only)
    
    reg L = 0; 
    
    
    // Instantiate the UUT
    systolicarray4x4 uut (
        .rst(rst),
        .clk(clk),
        .L(L),
        .ai0(ai0), .ai1(ai1), .ai2(ai2), .ai3(ai3),
        .wi0(wi0), .wi1(wi1), .wi2(wi2), .wi3(wi3),
        .pso0(pso0), .pso1(pso1), .pso2(pso2), .pso3(pso3)
    );

    quantizer_unit q_unit (
        .pso1(pso0), .pso2(pso1), .pso3(pso2), .pso4(pso3),
        .q1(q1), .q2(q2), .q3(q3), .q4(q4)
    );
    
    activation_unit a_unit (
        .q1(q1), .q2(q2), .q3(q3), .q4(q4),
        .a1(a0), .a2(a1), .a3(a2), .a4(a3)
    );


    always @(posedge clk) begin
    // add rst functionality
        if(rst) begin
            L <= 0; 
            cycle_count <= 0; 
            display_index <= 0;
            led <= 8'd0;
            process_done <= 0;
            stable_counter <= 20'b0;
            toggle_state <= 0;
            
            ai0 = 8'sd0; ai1 = 8'sd0; ai2 = 8'sd0; ai3= 8'sd0;
            wi0 = 8'sd0; wi1 = 8'sd0; wi2 = 8'sd0; wi3= 8'sd0;
            {Feature_Memory[0], Feature_Memory[1], Feature_Memory[2], Feature_Memory[3],
            Feature_Memory[4], Feature_Memory[5], Feature_Memory[6], Feature_Memory[7],
            Feature_Memory[8], Feature_Memory[9], Feature_Memory[10], Feature_Memory[11],
            Feature_Memory[12], Feature_Memory[13], Feature_Memory[14], Feature_Memory[15]}
            <= {8'sd4, 8'sd0, 8'sd2, 8'sd1,
                8'sd4, 8'sd3, 8'sd2, 8'sd1,
                8'sd4, 8'sd3, 8'sd0, 8'sd1,
                8'sd4, 8'sd3, 8'sd2, 8'sd1};
            
            {Weight_Memory[0], Weight_Memory[1], Weight_Memory[2], Weight_Memory[3],
            Weight_Memory[4], Weight_Memory[5], Weight_Memory[6], Weight_Memory[7],
            Weight_Memory[8], Weight_Memory[9], Weight_Memory[10], Weight_Memory[11],
            Weight_Memory[12], Weight_Memory[13], Weight_Memory[14], Weight_Memory[15]}
            <= {-8'sd1, 8'sd2, -8'sd3, 8'sd4,
                8'sd1, -8'sd2, 8'sd3, -8'sd4,
                8'sd1, -8'sd2, -8'sd3, 8'sd4,
                8'sd1, 8'sd2, 8'sd3, 8'sd4};
                
        end
        else if(startSignal && cycle_count <=16 ) begin
            case(cycle_count)
            0: begin L <= 1; wi0 = Weight_Memory[3]; wi1 = Weight_Memory[7]; wi2 = Weight_Memory[11]; wi3 = Weight_Memory[15]; end // 3rd col
            1: begin L <= 1; wi0 = Weight_Memory[2]; wi1 = Weight_Memory[6]; wi2 = Weight_Memory[10]; wi3 = Weight_Memory[14]; end // 2nd col
            2: begin L <= 1; wi0 = Weight_Memory[1]; wi1 = Weight_Memory[5]; wi2 = Weight_Memory[9]; wi3 = Weight_Memory[13]; end // 1st col
            3: begin L <= 1; wi0 = Weight_Memory[0]; wi1 = Weight_Memory[4]; wi2 = Weight_Memory[8]; wi3 = Weight_Memory[12]; end // 0th col
            
            4: begin L <= 0; ai0 = Feature_Memory[0]; ai1 = 8'sd0; ai2 = 8'sd0; ai3 = 8'sd0; end // 4 0 0 0 
            5: begin ai0 = Feature_Memory[1]; ai1 = Feature_Memory[4]; ai2 = 8'sd0; ai3 = 8'sd0; end // 0 4 0 0 
            6: begin ai0 = Feature_Memory[2]; ai1 = Feature_Memory[5]; ai2 = Feature_Memory[8]; ai3 = 8'sd0; end // 2 3 4 0 
            7: begin ai0 = Feature_Memory[3]; ai1 = Feature_Memory[6]; ai2 = Feature_Memory[9]; ai3 = Feature_Memory[12]; end // 1 2 3 4  
            8: begin ai0 = 8'sd0; ai1 = Feature_Memory[7]; ai2 = Feature_Memory[10]; ai3 = Feature_Memory[13]; end // 0 1 0 3
            9: begin ai0 = 8'sd0; ai1 = 8'sd0; ai2 = Feature_Memory[11]; ai3 = Feature_Memory[14]; end // 0 0 1 2
            10: begin ai0 = 8'sd0; ai1 = 8'sd0; ai2 = 8'sd0; ai3 = Feature_Memory[15]; // 0 0 0 1
                   Feature_Memory[0] = a0;
                   $display(" %d, %d, %d, %d", 
                     pso0, pso1, pso2, pso3);
                   //$display("result_matrix[0] <= %d", pso0);
            end 
            11: begin 
                  Feature_Memory[1] = a0; Feature_Memory[4] = a1; 
                  $display(" %d, %d, %d, %d", 
                     pso0, pso1, pso2, pso3);
            end  
            12: begin
                Feature_Memory[2] = a0; Feature_Memory[5] = a1; Feature_Memory[8] = a2; 
                $display(" %d, %d, %d, %d", 
                     pso0, pso1, pso2, pso3);
            end
            13: begin
                Feature_Memory[3] = a0;  Feature_Memory[6] = a1; Feature_Memory[9] = a2; Feature_Memory[12] = a3;
                $display(" %d, %d, %d, %d", 
                     pso0, pso1, pso2, pso3);
            end
            14: begin
                Feature_Memory[7] = a1; Feature_Memory[10] = a2; Feature_Memory[13] = a3;
                $display(" %d, %d, %d, %d", 
                     pso0, pso1, pso2, pso3);
            end
            15: begin
                Feature_Memory[11] = a2; Feature_Memory[14] = a3;
                $display(" %d, %d, %d, %d", 
                     pso0, pso1, pso2, pso3);
            end
            16: begin
                Feature_Memory[15] = a3;
                process_done <= 1; 
                $display(" %d, %d, %d, %d", 
                     pso0, pso1, pso2, pso3);
                
            end
            
            default: ;
            endcase
            cycle_count <= cycle_count + 1;    
        end    
        else if (process_done) begin
            if (result_toggle != toggle_state) begin
                // If toggle changed, start counting stability time
                stable_counter <= stable_counter + 1;
                
                // If toggle remains changed for 50 cycles, accept it
                if (stable_counter >= 50) begin
                    toggle_state <= result_toggle;  // Update stable state
        
                    // Move to next index with wrap around
                    if (display_index == 16)
                        display_index <= 0;
                    else 
                        display_index <= display_index + 1;
        
                    stable_counter <= 0; // Reset counter after valid toggle
                end
            end else begin
                stable_counter <= 0; // Reset if signal returns to previous state
            end 

            // Show current result on LED
            led <= Feature_Memory[display_index][7:0];
        end

    end
endmodule
