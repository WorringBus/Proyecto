module ram_sync (clk, MemWrite, dato_e, direccion, dato_s);
    input clk;
	input MemWrite; //en
    input [31:0] dato_e;
	input [31:0] direccion;
	
	output [31:0] dato_s;

	reg [31:0] RAM [0:255]; 
	wire [7:0] index;
	
	assign index = direccion[9:2];
	
	initial begin
		$readmemb("datos.txt", RAM);
	end
	
	always @ (posedge clk) begin
		if(MemWrite) begin
			RAM[index] <= dato_e;
		end
	end
	
	assign dato_s = RAM[index];

endmodule