# Proyecto Final – Arquitectura de Computadoras
# Pipeline MIPS de 5 etapas + Decodificador de Instrucciones en Python

Equipo: 
-Juan Jose Bugarin Salvatierra
-Edgar Andres Basulto Silva
-Maria Fernanda Lavadores Morgado

Profesor: Ernesto López Arce
Materia: Arquitectura de Computadoras
Institución: Universidad de Guadalajara – CUCEI

---------------------------------------------------------------------

Descripción General

Este proyecto implementa un procesador MIPS con pipeline de 5 etapas, desarrollado en Verilog, junto con un decodificador de instrucciones en Python capaz de traducir mnemónicos MIPS al formato binario MIPS32. El binario generado se utiliza para precargar la memoria de instrucciones del procesador y ejecutar un programa ensamblador diseñado para este trabajo.

El objetivo principal es comprender el flujo completo desde la escritura del programa ensamblador hasta su ejecución en hardware digital.

---------------------------------------------------------------------

Componentes del Proyecto

1. Decodificador en Python

- Lee instrucciones ensamblador (.txt).
- Valida sintaxis, registros y tipos.
- Soporta instrucciones:

  R-TYPE: ADD, SUB, AND, OR, SLT  
  I-TYPE: ADDI, ANDI, ORI, XORI, SLTI, BEQ, LW, SW  
  J-TYPE: J

- Genera binario de 32 bits en formato MIPS32.
- Exporta el binario a archivo .txt o .bin.
- Manejo de errores y opción automática para instrucciones no estándar.

---------------------------------------------------------------------

2. Pipeline MIPS (Verilog)

Incluye las cinco etapas clásicas:
IF – Instruction Fetch
ID – Instruction Decode
EX – Execute
MEM – Memory Access
WB – Write Back

Módulos implementados:

PC  
Instruction Memory  
Data Memory  
Register File  
ALU  
ALU Control  
Control Unit  
Sign Extend  
Shift Left 2  
Adders  
Multiplexores (MUX)  
Buffers IF/ID, ID/EX, EX/MEM, MEM/WB

---------------------------------------------------------------------

Cómo simular el Pipeline

1. Abrir ModelSim.
2. Crear un nuevo proyecto.
3. Importar todos los módulos Verilog dentro de la carpeta mips_pipeline/.
4. Compilar la carpeta completa.
5. Cargar pipeline_top.v como módulo principal de simulación.
6. Ejecutar el programa ensamblador y observar los waveforms.

---------------------------------------------------------------------

Programa en Ensamblador

El proyecto incluye un archivo programa.asm que implementa un algoritmo no trivial que utiliza:

- Instrucciones aritméticas y lógicas
- Acceso a memoria (LW y SW)
- Comparaciones (SLT)
- Saltos condicionales (BEQ)
- Salto incondicional (J)

---------------------------------------------------------------------

Simulaciones

Las simulaciones fueron realizadas en ModelSim. Incluyen:

- Waveforms
- Estados finales del banco de registros
- Evidencia de flujo entre las etapas del pipeline

Los archivos se encuentran dentro de la carpeta /simulaciones.

---------------------------------------------------------------------

Resultados Esperados

- Ejecución correcta del programa ensamblador.
- Flujo adecuado entre todas las etapas del pipeline.
- Escritura correcta en registros y memoria.
- Identificación del avance de cada instrucción en las simulaciones.

---------------------------------------------------------------------

Referencias

Material académico proporcionado en clase y en la plataforma virtual.
