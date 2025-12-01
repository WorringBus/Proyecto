module MEM_WB (
    input clk,
    input reset,
    
    input [31:0] Mem_ReadData_in,
    input [31:0] ALU_Result_in,
    
    input [4:0] WriteRegister_in,
    
    input MemtoReg_in, RegWrite_in,
    
    output reg [31:0] Mem_ReadData_out,
    output reg [31:0] ALU_Result_out,
    
    output reg [4:0] WriteRegister_out,
    
    output reg MemtoReg_out, RegWrite_out
);

    always @(posedge clk) begin
        if (reset) begin
            Mem_ReadData_out <= 32'd0;
            ALU_Result_out <= 32'd0;
            WriteRegister_out <= 5'd0;
            
            MemtoReg_out <= 1'b0; 
            RegWrite_out <= 1'b0;
        end
        else begin
            Mem_ReadData_out <= Mem_ReadData_in;
            ALU_Result_out <= ALU_Result_in;
            WriteRegister_out <= WriteRegister_in;
            
            MemtoReg_out <= MemtoReg_in; 
            RegWrite_out <= RegWrite_in;
        end
    end
    
endmodule