`timescale 1ns/1ns

module ALU_tb;
    reg [3:0] A_tb;
    reg [3:0] B_tb;
    reg sel_tb;
    wire [3:0] R_tb;
    wire flag_tb;

    ALU uut (
        .A(A_tb),
        .B(B_tb),
        .sel(sel_tb),
        .R(R_tb),
        .flag(flag_tb)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, ALU_tb);

    A_tb = 4'd3; 
    B_tb = 4'd2; 
    sel_tb = 3'b000;
    #100;
    A_tb = 4'd7; 
    B_tb = 4'd5; 
    sel_tb = 3'b001; 
    #100;
    A_tb = 4'b1010; 
    B_tb = 4'b1100; 
    sel_tb = 3'b010; 
    #100;
    A_tb = 4'b1010; 
    B_tb = 4'b1100; 
    sel_tb = 3'b011; 
    #100;
    A_tb = 4'b1010; 
    B_tb = 4'b1100; 
    sel_tb = 3'b100; 
    #100;
    A_tb = 4'd5; 
    B_tb = 4'd5; 
    sel_tb = 3'b101; 
    #100;
    A_tb = 4'b0011; 
    B_tb = 4'b0000; 
    sel_tb = 3'b110; 
    #100;
    A_tb = 4'b1000; 
    B_tb = 4'b0000; 
    sel_tb = 3'b111; 
    #100;

    $finish;
    end
endmodule
