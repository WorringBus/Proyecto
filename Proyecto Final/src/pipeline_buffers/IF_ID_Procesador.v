module IF_ID (
    input clk,
    input reset,
    
    input [31:0] PC_plus_4_in,
    input [31:0] Instruction_in,
    
    output reg [31:0] PC_plus_4_out,
    output reg [31:0] Instruction_out
);
    
    always @(posedge clk) begin
        if (reset) begin
            PC_plus_4_out <= 32'd0;
            Instruction_out <= 32'd0;
        end
        else begin
            PC_plus_4_out <= PC_plus_4_in;
            Instruction_out <= Instruction_in;
        end
    end
    
endmodule