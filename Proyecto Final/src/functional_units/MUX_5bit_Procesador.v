module MUX_5bit(
    input [4:0] Data0,
    input [4:0] Data1,
    input Select,
    output [4:0] Output
);

assign Output = Select ? Data1 : Data0;

endmodule