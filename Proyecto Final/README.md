Proyecto Final – Arquitectura de Computadoras
Pipeline MIPS de 5 etapas + Decodificador de Instrucciones en Python
Alumno: Juan Jose Bugarin Salvatierra
Profesor: Ernesto López Arce
Materia: Arquitectura de Computadoras
Institución: Universidad de Guadalajara – CUCEI

Descripción General
Este proyecto implementa un procesador MIPS con pipeline de 5 etapas, desarrollado en Verilog, junto con un decodificador de instrucciones en Python capaz de traducir mnemónicos MIPS al formato binario MIPS32. El binario generado se utiliza para precargar la memoria de instrucciones del procesador y ejecutar un programa ensamblador diseñado para este trabajo.
El objetivo principal es comprender el flujo completo desde la escritura del programa ensamblador hasta su ejecución en hardware digital.

Componentes del Proyecto
1. Decodificador en Python
    Lee instrucciones ensamblador (.txt).
    Valida sintaxis, registros y tipos.
    Soporta instrucciones:

      R-TYPE: ADD, SUB, AND, OR, SLT

      I-TYPE: ADDI, ANDI, ORI, XORI, SLTI, BEQ, LW, SW

      J-TYPE: J

    Genera binario de 32 bits en formato MIPS32.
    Exporta el binario a archivo .txt o .bin para carga en memoria.
    Manejo de errores y opción automática para instrucciones no estándar.

2. Pipeline MIPS (Verilog)
   Incluye las cinco etapas clásicas:
   IF – Instruction Fetch
   ID – Instruction Decode
   EX – Execute
   MEM – Memory Access
   WB – Write Back

   Módulos implementados

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

   Buffers: IF/ID, ID/EX, EX/MEM, MEM/WB

Cómo simular el Pipeline

  Abrir ModelSim.

  Crear un nuevo proyecto.

  Importar todos los módulos Verilog en mips_pipeline/.

  Compilar la carpeta completa.

  Cargar pipeline_top.v como módulo de simulación.

  Ejecutar el programa ensamblador y observar los waveforms.

Programa en Ensamblador

  El proyecto incluye un archivo programa.asm que implementa un algoritmo no trivial que utiliza:

  Aritmética y lógica

  Acceso a memoria (LW y SW)

  Comparaciones (SLT)

  Saltos condicionales (BEQ)

  Salto incondicional (J)

Simulaciones

Las simulaciones fueron realizadas en ModelSim.
Incluyen:

  Waveforms

  Registros al finalizar la ejecución

  Evidencia de pasos del pipeline

  Los archivos se encuentran en la carpeta /simulaciones.

Resultados Esperados

  Ejecución correcta del programa ensamblador.

  Flujo adecuado entre todas las etapas del pipeline.

  Modificación adecuada de los registros y memoria.

  Identificación visual del avance de cada instrucción.

Referencias

Material académico proporcionado en clase y dentro de plataforma virtual.
