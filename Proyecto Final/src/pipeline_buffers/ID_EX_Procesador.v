module ID_EX (
    input clk,
    input reset,
    
    input [31:0] PC_plus_4_in,
    input [31:0] ReadData1_in,
    input [31:0] ReadData2_in,
    input [31:0] SignExtImm_in,
    
    input [4:0] Rt_in,
    input [4:0] Rd_in,
    
    input RegDst_in, ALUSrc_in, Branch_in, MemRead_in, MemWrite_in, MemtoReg_in, RegWrite_in,
    input [1:0] ALUOp_in,
    
    output reg [31:0] PC_plus_4_out,
    output reg [31:0] ReadData1_out,
    output reg [31:0] ReadData2_out,
    output reg [31:0] SignExtImm_out,
    
    output reg [4:0] Rt_out, 
    output reg [4:0] Rd_out, 
    
    output reg RegDst_out, ALUSrc_out, Branch_out, MemRead_out, MemWrite_out, MemtoReg_out, RegWrite_out,
    output reg [1:0] ALUOp_out
);

    always @(posedge clk) begin
        if (reset) begin
            PC_plus_4_out <= 32'd0;
            ReadData1_out <= 32'd0;
            ReadData2_out <= 32'd0;
            SignExtImm_out <= 32'd0;
            Rt_out <= 5'd0;
            Rd_out <= 5'd0;
            
            RegDst_out <= 1'b0; ALUSrc_out <= 1'b0; Branch_out <= 1'b0; MemRead_out <= 1'b0; 
            MemWrite_out <= 1'b0; MemtoReg_out <= 1'b0; RegWrite_out <= 1'b0;
            ALUOp_out <= 2'b00;
        end
        else begin
            PC_plus_4_out <= PC_plus_4_in;
            ReadData1_out <= ReadData1_in;
            ReadData2_out <= ReadData2_in;
            SignExtImm_out <= SignExtImm_in;
            
            Rt_out <= Rt_in;
            Rd_out <= Rd_in;

            RegDst_out <= RegDst_in; 
            ALUSrc_out <= ALUSrc_in; 
            Branch_out <= Branch_in; 
            MemRead_out <= MemRead_in; 
            MemWrite_out <= MemWrite_in; 
            MemtoReg_out <= MemtoReg_in; 
            RegWrite_out <= RegWrite_in;
            ALUOp_out <= ALUOp_in;
        end
    end
    
endmodule