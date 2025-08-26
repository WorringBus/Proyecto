module HA (input A, input B, output S, output AS);
assign S = A^B;
assign AS = A&B;
endmodule
