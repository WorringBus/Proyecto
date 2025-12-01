module Procesador_MIPS(
    input clk,
    input reset
);

    wire [31:0] PCActual, PC_plus_4, PCNext;
    wire [31:0] Instruccion;
    wire [5:0] OpCode, Funct;
    wire [4:0] Rs, Rt, Rd;
    
    // Control Wires
    wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;
    wire [1:0] ALUOp;
    
    // ALU Wires
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] ALUB, ALUResult;
    wire ALUZero;
    wire [2:0] ALUSel;
    
    // Immediate and Branch Wires
    wire [31:0] SignExtImm;
    wire [31:0] BranchTarget, ShiftLeft2Imm;
    wire BranchAndZero;
    
    // Jump Wires
    wire [31:0] JumpTarget;
	wire [31:0] JumpAddress;
    
    // Write Back Wires
    wire [4:0] WriteRegister;
    wire [31:0] MemReadData, WriteBackData;
    
    // Descomposicion de la Instruccion
    assign OpCode = Instruccion[31:26];
    assign Rs     = Instruccion[25:21];
    assign Rt     = Instruccion[20:16];
    assign Rd     = Instruccion[15:11];
    assign Funct  = Instruccion[5:0];

    // Muxes de Control
    // MUX1: Selecciona el registro de destino (Rd para R-Type, Rt para I-Type)
    MUX_5bit Mux_RegDst (
        .Data0(Rt),
        .Data1(Rd),
        .Select(RegDst),
        .Output(WriteRegister)
    );
    
    // MUX2: Selecciona el segundo operando de la ALU (ReadData2 o SignExtImm)
    MUX Mux_ALUSrc (
        .Data0(ReadData2),
        .Data1(SignExtImm),
        .Select(ALUSrc),
        .Output(ALUB)
    );
    
    // MUX3: Selecciona el dato a escribir en el Banco de Registros (ALUResult o MemReadData)
    MUX Mux_MemtoReg (
        .Data0(ALUResult),
        .Data1(MemReadData),
        .Select(MemtoReg),
        .Output(WriteBackData)
    );
    
    // Logica de PC (Program Counter)
    
    // ADDER 1: PC + 4
    ADD Add_PC_Plus_4 (
        .op1(PCActual),
        .op2(32'd4),
        .Resultado(PC_plus_4)
    );
    
    // Sign Extend
    SignExtend SE (
        .Immediate(Instruccion[15:0]),
        .Extended(SignExtImm)
    );
    
    // Logica de Branch (BEQ)
    
    // Shift Left 2 para Branch
    ShiftLeft2 SL2_Branch (
        .Input(SignExtImm),
        .Output(ShiftLeft2Imm)
    );
    
    // ADDER 2: PC_plus_4 + ShiftLeft2Imm (Branch Target)
    ADD Add_Branch_Target (
        .op1(PC_plus_4),
        .op2(ShiftLeft2Imm),
        .Resultado(BranchTarget)
    );
    
    // Compuerta AND para Branch (Branch AND Zero)
    AND And_Branch (
        .A(Branch),
        .B(ALUZero),
        .C(BranchAndZero)
    );
    
    // MUX4: Selecciona entre (PC+4) y (Branch Target)
    MUX Mux_Branch (
        .Data0(PC_plus_4),
        .Data1(BranchTarget),
        .Select(BranchAndZero),
        .Output(JumpTarget) // Salida temporal, sera entrada del Mux de Jump
    );
    
    // Logica de Jump (J)
    
    // Jump Address
    assign JumpAddress = {PC_plus_4[31:28], Instruccion[25:0], 2'b00};
    
    // MUX5: Selecciona entre (Branch/PC+4) y (Jump Target)
    MUX Mux_Jump (
        .Data0(JumpTarget),
        .Data1(JumpAddress),
        .Select(Jump),
        .Output(PCNext)
    );
	
	// Modulo PC
	PC Mod_PC (
		.clk(clk),
		.reset(reset),
		.next(PCNext),
		.Iactual(PCActual)
	);
	
    // Memoria de Instrucciones
    MemInstrucciones MI (
        .Dir(PCActual),
        .InstActual(Instruccion)
    );
    
    // Unidad de Control
    Control Mod_Control (
        .OpCode(OpCode),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );
    
    // ALU Control
    ALU_Control Mod_ALU_Control (
        .ALUOp(ALUOp),
        .Funct(Funct),
        .OpCode(OpCode),
        .ALUSel(ALUSel)
    );
    
    // Banco de Registros
    BR Mod_BR (
        .clk(clk),
        .RW(RegWrite),
        .RR1(Rs),
        .RR2(Rt),
        .WR(WriteRegister),
        .WD(WriteBackData),
        .RD1(ReadData1),
        .RD2(ReadData2)
    );

    // ALU
    ALU Mod_ALU (
        .A(ReadData1),
        .B(ALUB),
        .SEL(ALUSel),
        .C(ALUResult),
        .Zero(ALUZero)
    );
    
    // Memoria de Datos (RAM Sincrona)
    // Nota: El MemRead de la unidad de control se conecta, pero el ram_sync no lo usa para leer, solo para escribir.
    ram_sync Mod_Mem_Datos (
        .clk(clk),
        .MemWrite(MemWrite),
        .dato_e(ReadData2), // Dato a escribir es ReadData2
        .direccion(ALUResult), // Dirección es el resultado de la ALU (base + offset)
        .dato_s(MemReadData) // Dato leído de la memoria
    );

endmodule