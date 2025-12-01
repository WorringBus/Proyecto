module ADD(
	input [31:0]op1,
	input [31:0]op2,
	output [31:0]Resultado
	);
	
assign Resultado = op1 + op2;

endmodule