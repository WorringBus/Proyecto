module ShiftLeft2(
    input [31:0] Input,
    output [31:0] Output
    );

    assign Output = Input << 2;

endmodule