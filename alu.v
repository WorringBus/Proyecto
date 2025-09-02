module ALU (
    input  [3:0] A,     
    input  [3:0] B,     
    input  sel,   
  output reg [3:0] R
);

always @* begin
    case (sel)
        1'b0: R = A + B;   
        1'b1: R = A & B;   
    endcase
end

endmodule
