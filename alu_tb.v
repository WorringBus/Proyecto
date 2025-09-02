`timescale 1ns/1ns

module ALU_tb();
  reg [3:0] A_tb;
  reg [3:0] B_tb;
  reg sel_tb;
  wire [3:0] R_tb;

ALU uut (
    .A(A_tb),
    .B(B_tb),
    .sel(sel_tb),
    .R(R_tb)
);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, ALU_tb);
    A_tb = 4'b0011; 
  	B_tb = 4'b0010; 
  	sel_tb = 1'b0; 
  	#100;
    A_tb = 4'b0011; 
  	B_tb = 4'b0010; 
  	sel_tb = 1'b1; 
  	#100;
    A_tb = 4'b1111; 
  	B_tb = 4'b1111; 
  	sel_tb = 1'b0; 
  	#100;
    A_tb = 4'b1111; 
  	B_tb = 4'b0000; 
  	sel_tb = 1'b1; 
  	#100;
    A_tb = 4'b0101; 
  	B_tb = 4'b0011; 
  	sel_tb = 1'b0; 
  	#100;
    $finish;
end
endmodule
