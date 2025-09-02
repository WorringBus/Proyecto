`timescale 1ns/1ps

module ALU_tb;

reg [3:0] A;
reg [3:0] B;
reg [1:0] sel;

wire [4:0] R;

ALU uut (
    .A(A),
    .B(B),
    .sel(sel),
    .R(R)
);

initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, ALU_tb);

    $display("Tiempo | A    | B    | sel | Resultado");
    $monitor("%4dns | %b | %b |  %b  | %b", $time, A, B, sel, R);

    A = 4'b0011; B = 4'b0010; sel = 2'b00; #10;

    A = 4'b0011; B = 4'b0010; sel = 2'b01; #10;

    A = 4'b1111; B = 4'b1111; sel = 2'b00; #10;

    A = 4'b1111; B = 4'b0000; sel = 2'b01; #10;

    A = 4'b0101; B = 4'b0011; sel = 2'b10; #10;

    $finish;
end

endmodule
