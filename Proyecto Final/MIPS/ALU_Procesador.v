module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] SEL,       
    output reg [31:0] C,
    output Zero
);

    always @* begin
        case (SEL)
            3'b000: C <= A + B;
            3'b001: C <= A - B;
            3'b010: C <= A & B;
            3'b011: C <= A | B;
            3'b100: C <= A ^ B;
            3'b111: C <= ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; 
            default: C <= 32'd0;
        endcase
    end
    
    assign Zero = (C == 32'd0) ? 1'b1 : 1'b0;

endmodule