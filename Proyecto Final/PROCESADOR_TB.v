`timescale 1ns / 1ns

module procesador_tb;

    reg clk; 
    reg reset;

    Procesador_MIPS UUT ( 
        .clk(clk),
        .reset(reset)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("procesador.vcd");
        $dumpvars(0, procesador_tb);
    
        clk = 1'b0;
        reset = 1'b1;
        
        #100;
        reset = 1'b0;
        
        #10000; // Tiempo de simulación aumentado de 2000ns a 10000ns
        
        $display("Simulación completada");
        $stop;
    end
    
endmodule