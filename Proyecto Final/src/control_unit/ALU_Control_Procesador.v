module ALU_Control(
    input [1:0] ALUOp,      
    input [5:0] Funct,
    input [5:0] OpCode,
    
    output reg [2:0] ALUSel
);

always @* begin
    ALUSel = 3'b000; 

    case (ALUOp)
        
        2'b00: ALUSel = 3'b000;
        
        2'b01: ALUSel = 3'b001;
        
        2'b10: begin
            case (Funct)
                6'b100000: ALUSel = 3'b000;  // R-Type: ADD
                6'b100010: ALUSel = 3'b001;  // R-Type: SUB
                6'b100100: ALUSel = 3'b010;  // R-Type: AND
                6'b100101: ALUSel = 3'b011;  // R-Type: OR
                6'b101010: ALUSel = 3'b111;  // R-Type: SLT (Set Less Than)
                default: ALUSel = 3'b000;    // Fallback R-Type: ADD
            endcase
        end
        
        2'b11: begin
            case (OpCode)
                6'b001010: ALUSel = 3'b111;  // I-Type: SLTI
                6'b001100: ALUSel = 3'b010;  // I-Type: ANDI
                6'b001101: ALUSel = 3'b011;  // I-Type: ORI
                6'b001110: ALUSel = 3'b100;  // I-Type: XORI
                default: ALUSel = 3'b000;    // Fallback I-Type: ADD
            endcase
        end

        default: ALUSel = 3'b000;
    endcase
end

endmodule