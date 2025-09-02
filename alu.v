module ALU (
    input  [3:0] A,     
    input  [3:0] B,     
    input  [1:0] sel,   
    output reg [4:0] R  
);

always @(*) begin
    case (sel)
        2'b00: R = A + B;   
        2'b01: R = A & B;   
        default: R = 5'b00000; 
    endcase
end

endmodule
