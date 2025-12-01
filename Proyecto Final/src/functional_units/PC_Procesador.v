module PC(
    input clk,
    input reset,
    input [31:0] next,
    output reg [31:0] Iactual  
);

always @(posedge clk) begin
    if (reset) begin
        Iactual <= 32'd0;
    end
    else begin
        Iactual <= next;
    end
end

endmodule