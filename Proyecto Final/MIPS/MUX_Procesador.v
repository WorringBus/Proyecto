//Multiplexor 2 a 1

module MUX(
    input [31:0] Data0,
    input [31:0] Data1,
    input Select,
    output [31:0] Output
    );

    assign Output = Select ? Data1 : Data0;

endmodule