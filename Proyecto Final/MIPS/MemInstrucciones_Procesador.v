module MemInstrucciones(
    input [31:0] Dir,
    output reg [31:0] InstActual
);

    reg [7:0] MI [0:255];  

    
    initial begin
        $readmemb("instrucciones.txt", MI);
    end

    always @* begin
        InstActual = {MI[Dir[7:0]], MI[Dir[7:0] + 1], MI[Dir[7:0] + 2], MI[Dir[7:0] + 3]};
    end

endmodule