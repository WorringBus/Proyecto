module EX_MEM (
    input clk,
    input reset,

    input [31:0] ALU_Result_in,
    input [31:0] Write_Data_in,
	
    input [4:0] WriteRegister_in,
    
    input Branch_in, MemRead_in, MemWrite_in, MemtoReg_in, RegWrite_in,
    
    output reg [31:0] ALU_Result_out,
    output reg [31:0] Write_Data_out,
    
    output reg [4:0] WriteRegister_out,
    
    output reg Branch_out, MemRead_out, MemWrite_out, MemtoReg_out, RegWrite_out
);

    always @(posedge clk) begin
        if (reset) begin
            ALU_Result_out <= 32'd0;
            Write_Data_out <= 32'd0;
            WriteRegister_out <= 5'd0;
            
            Branch_out <= 1'b0; MemRead_out <= 1'b0; MemWrite_out <= 1'b0; 
            MemtoReg_out <= 1'b0; RegWrite_out <= 1'b0;
        end
        else begin
            ALU_Result_out <= ALU_Result_in;
            Write_Data_out <= Write_Data_in;
            WriteRegister_out <= WriteRegister_in;
            
            Branch_out <= Branch_in; 
            MemRead_out <= MemRead_in; 
            MemWrite_out <= MemWrite_in; 
            MemtoReg_out <= MemtoReg_in; 
            RegWrite_out <= RegWrite_in;
        end
    end
    
endmodule