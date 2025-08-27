module cl_ (input i_bit1, input i_bit2, output o_and, output o_nand, output o_or, output o_nor, output o_xor, output o_xnor, output o_not);
assign o_and = i_bit1 & i_bit2;
assign o_nand = i_bit1 ~& i_bit2;
assign o_or = i_bit1 | i_bit2;
assign o_nor = i_bit1 ~| i_bit2;
assign o_xor = i_bit1 ^ i_bit2;
assign o_xnor = i_bit1 ~^ i_bit2;
assign o_not = ~i_bit1 | ~i_bit2;
endmodule
