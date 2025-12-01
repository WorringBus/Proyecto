module SignExtend(
    input [15:0] Immediate,
    output [31:0] Extended
    );

    assign Extended = {{16{Immediate[15]}}, Immediate};

endmodule