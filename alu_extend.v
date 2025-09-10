module ALU (
    input  [3:0] A,     
    input  [3:0] B,     
    input  sel,   
    output reg [3:0] R, 
    output reg flag
);

always @* begin
    case (sel)
        3'b000: R = A + B;        
        3'b001: R = A - B;        
        3'b010: R = A & B;        
        3'b011: R = A | B;        
        3'b100: R = A ^ B;        
        3'b101: R = (A == B);     
        3'b110: R = A << 1;       
        3'b111: R = A >> 1;     
    endcase

    flag = (A > B);
end

endmodule
