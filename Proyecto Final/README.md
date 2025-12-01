# Simulador de Pipeline MIPS 32-bit (5 Etapas)

## Universidad de Guadalajara - Centro Universitario de Ciencias Exactas e Ingenierías

**Materia:** Arquitectura de Computadoras

-----

## Descripción del Proyecto

Este proyecto consiste en la implementación completa de un **Procesador MIPS de 32 bits** con arquitectura **Pipeline de 5 etapas (IF, ID, EX, MEM, WB)**, desarrollado en lenguaje **Verilog HDL**.

El proyecto se complementa con una **Herramienta Decodificadora** con interfaz gráfica (**GUI**) desarrollada en **Python**. Esta herramienta es fundamental, ya que permite a los usuarios traducir código ensamblador MIPS a su representación binaria, formateada en **Big Endian**, para la **precarga exclusiva de la Memoria de Instrucciones** del procesador.

El objetivo principal es demostrar la funcionalidad de un *datapath* segmentado, incluyendo la lógica de control, unidades funcionales y registros de pipeline.

-----

## Características Principales

### 1\. Pipeline MIPS 32-bit en Verilog

  * **5 Etapas Clásicas:** `Instruction Fetch (IF)`, `Instruction Decode (ID)`, `Execute (EX)`, `Memory (MEM)`, `Write Back (WB)`.
  * **Componentes Modulares:** Incluye módulos separados para todas las unidades funcionales: PC, ALU, Control Unit, Banco de Registros (BR), Memorias y *Buffers* de Pipeline.
  * **Memoria de Instrucciones Precargada:** El Decodificador genera el archivo `instrucciones.txt`. **La Memoria de Datos (`datos.txt`) se carga manualmente** por el usuario para la simulación de pruebas.
  * **Diseño Síncrono:** La lógica del procesador está sincronizada con una señal de reloj (`clk`).

### 2\. Conjunto de Instrucciones Soportadas

El diseño es compatible con una selección de instrucciones comunes en la arquitectura MIPS-I:

| Tipo | Instrucciones (Ejemplos) |
| :--- | :--- |
| **R-Type** | `ADD`, `SUB`, `AND`, `OR`, `SLT` |
| **I-Type (Aritméticas/Lógicas)** | `ADDI`, `ANDI`, `ORI`, `XORI`, `SLTI` |
| **I-Type (Control/Memoria)** | `LW`, `SW`, `BEQ` |
| **J-Type** | `J` |

### 3\. Decodificador Gráfico (Python GUI)

  * **Ensamblador a Binario:** Transforma instrucciones MIPS en formato de 32 bits binario.
  * **Formato Big Endian:** Genera el binario en formato Big Endian (byte más significativo primero).
  * **Generación de Archivos:** Produce el archivo `instrucciones.txt` listo para ser utilizado por el simulador Verilog.

-----

## Estructura de Archivos

El repositorio está organizado de la siguiente manera:

```
.
├── src/                                # Contiene todos los módulos Verilog del procesador
│   ├── datapath/
│   │   ├── PROCESADOR.v                # Módulo Top-Level (Datapath principal)
│   ├── control_unit/
│   │   ├── Control_Procesador.v        # Unidad de Control principal
│   │   └── ALU_Control_Procesador.v    # Lógica de control de la ALU
│   ├── functional_units/
│   │   ├── ALU_Procesador.v            # Unidad Aritmético Lógica (ALU)
│   │   ├── ADD.v, AND.v                # Módulos aritméticos/lógicos auxiliares
│   │   ├── PC_Procesador.v             # Registro de Contador de Programa (PC)
│   │   ├── Shift_Left_2_Procesador.v   # Lógica de salto y ramificación
│   │   ├── Sign-Extend_Procesador.v    # Extensión de Signo
│   │   ├── MUX_Procesador.v            # Multiplexor de 32 bits
│   │   └── MUX_5bit_Procesador.v       # Multiplexor de 5 bits (destino de registro)
│   ├── memories_registers/
│   │   ├── BR_Procesador.v             # Banco de Registros (Register File)
│   │   ├── MemInstrucciones_Procesador.v # Memoria de Instrucciones
│   │   └── ram_sync_Procesador.v       # Memoria de Datos (ram_sync)
│   └── pipeline_buffers/
│       ├── IF_ID_Procesador.v          # Buffer de etapa Fetch/Decode
│       ├── ID_EX_Procesador.v          # Buffer de etapa Decode/Execute
│       ├── EX_MEM_Procesador.v         # Buffer de etapa Execute/Memory
│       └── MEM_WB_Procesador.v         # Buffer de etapa Memory/Write Back
├── decoder/                            # Herramienta de traducción Ensamblador-Binario
│   └── GUI_Decodificador.py            # Interfaz gráfica en Python
├── test_files/                         # Archivos de prueba y datos precargados
│   ├── Ensamblador_Test.asm            # Código fuente en ensamblador MIPS de prueba
│   ├── instrucciones.txt               # Contenido binario Big Endian (Generado por Python)
│   └── datos.txt                       # Contenido inicial de la Memoria de Datos (Manual)
└── PROCESADOR_TB.v                     # Testbench principal para simulación en Verilog
```

-----

## Uso y Simulación

### 1\. Preparación de Instrucciones (Python)

1.  Ejecuta la herramienta decodificadora:

    ```bash
    python decoder/GUI_Decodificador.py
    ```

2.  Utiliza la GUI para cargar tu archivo `.asm` o ingresa el código ensamblador.

3.  Genera el archivo **`instrucciones.txt`**.

4.  **Verifica y ajusta el archivo `datos.txt`** con los valores iniciales de la memoria requeridos por tu programa de prueba.

      * **Configuración:** Asegúrate de que los archivos `instrucciones.txt` y `datos.txt` estén accesibles para los módulos de memoria en Verilog (usualmente en el mismo directorio que el Testbench).

### 2\. Simulación en ModelSim

El proyecto está optimizado para la simulación con **ModelSim (Mentor Graphics/Siemens EDA)**.

1.  **Creación del Proyecto:** Crea un nuevo proyecto en ModelSim e importa todos los archivos Verilog (`.v`).
2.  **Compilación:** Compila todos los módulos.
3.  **Simulación:** Inicia la simulación haciendo referencia al módulo **`procesador_tb`**.
4.  **Visualización de Señales:** Una vez iniciada la simulación, añade las señales clave (PC, registros del Banco de Registros, datos de entrada/salida de los *buffers* del pipeline) a la ventana **Wave** (Waveform Viewer) para el análisis.
5.  **Análisis:** Ejecuta la simulación por pasos (`run -all` o `run X ns`) y utiliza el *waveform* para verificar la propagación de instrucciones a través de las 5 etapas del pipeline.

-----

## Contribuciones y Autores

Este proyecto fue desarrollado por el siguiente equipo de estudiantes de Ingeniería Informática de la Universidad de Guadalajara:

| Nombre del Integrante | Rol Principal |
| :--- | :--- |
| **Edgar Andrés Basulto Silva** | **Desarrollo de Módulos Verilog**, Corrección de errores finales y Testeo del **TB del Datapath** completo. |
| **Juan José Bugarin Salvatierra** | Desarrollo completo de la **GUI Decodificadora en Python** y elaboración de la **Documentación** (Reporte y README). |
| **María Fernanda Lavadores Morgado** | Desarrollo y Simulación de los **Testbench Modulares**, y Creación de los **Programas en Ensamblador** para pruebas finales. |

-----

**© 2024 Proyecto de Arquitectura de Computadoras - UDG**
