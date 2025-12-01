module Control(
    input [5:0] OpCode,     
    output reg RegDst,      
    output reg ALUSrc,      
    output reg MemtoReg,    
    output reg RegWrite,    
    output reg MemRead,     
    output reg MemWrite,    
    output reg Branch,      
    output reg Jump,        
    output reg [1:0] ALUOp  
);

always @* begin
    RegDst = 1'b0;
    ALUSrc = 1'b0;
    MemtoReg = 1'b0;
    RegWrite = 1'b0;
    MemRead = 1'b0;
    MemWrite = 1'b0;
    Branch = 1'b0;
    Jump = 1'b0;
    ALUOp = 2'b00;

    case (OpCode)
        // R-TYPE: ADD, SUB, AND, OR, SLT
        6'b000000: begin
            RegDst = 1'b1;
            RegWrite = 1'b1;
            ALUSrc = 1'b0;
            ALUOp = 2'b10;
        end
        
        // J (Jump)
        6'b000010: begin
            Jump = 1'b1;
        end
        
        // BEQ (Branch on Equal)
        6'b000100: begin
            Branch = 1'b1;
            ALUSrc = 1'b0;
            ALUOp = 2'b01;
        end
        
        // LW (Load Word)
        6'b100011: begin
            MemtoReg = 1'b1;
            RegWrite = 1'b1;
            ALUSrc = 1'b1;
            MemRead = 1'b1;
            ALUOp = 2'b00;
            RegDst = 1'b0; 
        end
        
        // SW (Store Word)
        6'b101011: begin
            ALUSrc = 1'b1;
            MemWrite = 1'b1;
            ALUOp = 2'b00;
        end
		
		// ADDI (Add Immediate)
        6'b001000: begin
            RegDst = 1'b0; 
            RegWrite = 1'b1;
            ALUSrc = 1'b1;
            ALUOp = 2'b00; // ADD
        end
        
        // SLTI (Set Less Than Immediate)
        6'b001010: begin
            RegDst = 1'b0; 
            RegWrite = 1'b1;
            ALUSrc = 1'b1;
            ALUOp = 2'b11;
        end

        // ANDI (AND Immediate)
        6'b001100: begin
            RegDst = 1'b0; 
            RegWrite = 1'b1;
            ALUSrc = 1'b1;
            ALUOp = 2'b11;
        end
        
        // ORI (OR Immediate)
        6'b001101: begin
            RegDst = 1'b0; 
            RegWrite = 1'b1;
            ALUSrc = 1'b1;
            ALUOp = 2'b11;
        end
        
        // XORI (XOR Immediate)
        6'b001110: begin
            RegDst = 1'b0; 
            RegWrite = 1'b1;
            ALUSrc = 1'b1;
            ALUOp = 2'b11;
        end
        
        default: begin
            // Por defecto, todas las señales son 0 (definidas al inicio del always @*)
        end
    endcase
end

endmodule