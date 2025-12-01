//Banco de registros
module BR(
	input clk,
	input RW, //RegWrite
	input [4:0] RR1, //Read Register 1
	input [4:0] RR2, //Read Register 2
	input [4:0] WR, //WriteRegister
	input [31:0] WD, //WriteData
	
	output [31:0] RD1, //Read Data 1
	output [31:0] RD2 //Read Data 2
	);

	reg [31:0] registers [0:31];
	
	integer i;
	
	initial begin
		for (i = 0; i < 32; i = i + 1) begin
			registers[i] = 32'd0; 
		end
	end
	
	// El registro $zero ($r0) siempre es 0
	assign RD1 = (RR1 == 5'd0) ? 32'd0 : registers[RR1];
    assign RD2 = (RR2 == 5'd0) ? 32'd0 : registers[RR2];
	
	// ESCRITURA SINCRONA (Al flanco de reloj)
	always @(posedge clk) begin
	// Si RegWrite esta activo (RW) Y el registro de destino NO es $r0
		if(RW && (WR != 5'd0)) begin
			registers[WR] <= WD;
		end
	end
	
endmodule