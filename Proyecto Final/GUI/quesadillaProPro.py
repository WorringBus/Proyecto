import tkinter as tk
from tkinter import messagebox, filedialog
import os
import re
from typing import Optional, Tuple, List, Dict

instrucciones = {
    "ADD": {"opcode": "000000", "funct": "100000"},
    "SUB": {"opcode": "000000", "funct": "100010"},
    "AND": {"opcode": "000000", "funct": "100100"},
    "OR":  {"opcode": "000000", "funct": "100101"},
    "SLT": {"opcode": "000000", "funct": "101010"},
    "NOP": {"opcode": "000000", "funct": "000000"},
}

instrucciones_I = {
    "ADDI": {"opcode": "001000", "signed_imm": True},
    "ANDI": {"opcode": "001100", "signed_imm": False},
    "ORI":  {"opcode": "001101", "signed_imm": False},
    "XORI": {"opcode": "001110", "signed_imm": False},
    "SLTI": {"opcode": "001010", "signed_imm": True},
    "BEQ":  {"opcode": "000100", "signed_imm": True, "branch": True},
    "BNE":  {"opcode": "000101", "signed_imm": True, "branch": True},
    "BGTZ": {"opcode": "000111", "signed_imm": True, "special_rs_only": True},
    "LW":   {"opcode": "100011", "signed_imm": True},
    "SW":   {"opcode": "101011", "signed_imm": True},
}

instrucciones_J = {
    "J":  {"opcode": "000010"},
}

REG_ALIAS = {
    "$zero": 0, "$0": 0,
    "$at": 1,
    "$v0": 2, "$v1": 3,
    "$a0": 4, "$a1": 5, "$a2": 6, "$a3": 7,
    "$t0": 8, "$t1": 9, "$t2": 10, "$t3": 11, "$t4": 12, "$t5": 13, "$t6": 14, "$t7": 15,
    "$s0": 16, "$s1": 17, "$s2": 18, "$s3": 19, "$s4": 20, "$s5": 21, "$s6": 22, "$s7": 23,
    "$t8": 24, "$t9": 25,
    "$k0": 26, "$k1": 27,
    "$gp": 28, "$sp": 29, "$fp": 30, "$ra": 31
}

def reg_a_binario(reg: str) -> str:
    if not isinstance(reg, str):
        raise ValueError(f"Registro inválido: {reg}")
    r = reg.strip().lower()
    if r in REG_ALIAS:
        num = REG_ALIAS[r]
    else:
        m = re.fullmatch(r"\$(\d{1,2})", reg.strip())
        if not m:
            raise ValueError(f"Formato de registro inválido: '{reg}' (use $n o alias como $t0).")
        num = int(m.group(1))
    if not (0 <= num <= 31):
        raise ValueError(f"Registro fuera de rango: '{reg}' (debe ser 0..31).")
    return format(num, '05b')

def int_a_bin_signed(value: int, bits: int) -> str:
    min_val = - (1 << (bits - 1))
    max_val = (1 << (bits - 1)) - 1
    if not (min_val <= value <= max_val):
        raise ValueError(f"Valor con signo fuera de rango para {bits} bits: {value}")
    if value < 0:
        value = (1 << bits) + value
    return format(value & ((1 << bits) - 1), f'0{bits}b')

def uint_a_bin(value: int, bits: int) -> str:
    if value < 0 or value >= (1 << bits):
        raise ValueError(f"Valor sin signo fuera de rango para {bits} bits: {value}")
    return format(value, f'0{bits}b')

def parse_immediate(token: str) -> int:
    token = token.strip()
    if token.lower().startswith('0x'):
        return int(token, 16)
    return int(token, 10)

def tipo_instruccion(op: str) -> Optional[str]:
    op = op.upper()
    if op in instrucciones:
        return "R"
    if op in instrucciones_I:
        return "I"
    if op in instrucciones_J:
        return "J"
    return None

def preprocesar_lineas(texto: str) -> Tuple[List[Tuple[int,str]], Dict[str,int]]:
    raw_lines = texto.splitlines()
    processed = []
    labels = {}
    instr_index = 0
    for i, raw in enumerate(raw_lines, start=1):
        line = raw.strip()
        line = re.split(r'#|//', line)[0].strip()
        if not line:
            continue
        while True:
            m = re.match(r'^([A-Za-z_]\w*):', line)
            if not m:
                break
            label = m.group(1)
            if label in labels:
                raise ValueError(f"L{i}: etiqueta duplicada '{label}'")
            labels[label] = instr_index 
            line = line[m.end():].strip() 
        if not line:
            continue
        processed.append((i, line))
        instr_index += 1
    return processed, labels

def ensamblar_lineas(processed_lines: List[Tuple[int,str]], labels: Dict[str,int], tipo_forzado: Optional[str]=None) -> List[str]:
    bin_lines = []
    for idx, (line_num, linea) in enumerate(processed_lines):
        partes = re.split(r'[\s,]+', linea.strip())
        partes = [p for p in partes if p != ""]
        if len(partes) == 0:
            continue
        op = partes[0].upper()
        tipo_detectado = tipo_instruccion(op)
        if tipo_detectado is None:
            raise ValueError(f"L{line_num}: instrucción no reconocida '{op}'")
        if tipo_forzado and tipo_forzado != tipo_detectado:
            raise ValueError(f"L{line_num}: instrucción {op} es tipo {tipo_detectado}, mientras la selección es {tipo_forzado}")

        if tipo_detectado == "R":
            if op == "NOP":
                bin_lines.append("0"*32)
                continue
            if len(partes) != 4:
                raise ValueError(f"L{line_num}: Formato incorrecto para R ({op}). Esperado: {op} $rd $rs $rt")
            _, rd_t, rs_t, rt_t = partes
            rs_bin = reg_a_binario(rs_t)
            rt_bin = reg_a_binario(rt_t)
            rd_bin = reg_a_binario(rd_t)
            shamt = "00000"
            funct = instrucciones[op]["funct"]
            opcode = instrucciones[op]["opcode"]
            bin32 = f"{opcode}{rs_bin}{rt_bin}{rd_bin}{shamt}{funct}"
            bin_lines.append(bin32)
            continue

        if tipo_detectado == "I":
            meta = instrucciones_I[op]
            opcode = meta["opcode"]
            if op == "BGTZ":
                if len(partes) != 3:
                    raise ValueError(f"L{line_num}: Formato: BGTZ $rs label_or_imm")
                _, rs_t, imm_token = partes
                rs_bin = reg_a_binario(rs_t)
                rt_bin = "00000"
                imm_val = None
                if re.fullmatch(r'[A-Za-z_]\w*', imm_token):
                    if imm_token not in labels:
                        raise ValueError(f"L{line_num}: etiqueta no encontrada: {imm_token}")
                    target_index = labels[imm_token]
                    offset = target_index - (idx + 1)
                    imm_val = offset
                else:
                    imm_val = parse_immediate(imm_token)
                imm_bin = int_a_bin_signed(imm_val, 16)
                bin32 = f"{opcode}{rs_bin}{rt_bin}{imm_bin}"
                bin_lines.append(bin32)
                continue

            if 'branch' in meta and meta['branch']:
                if len(partes) != 4:
                    raise ValueError(f"L{line_num}: Formato incorrecto para {op}. Esperado: {op} $rs $rt label_or_imm")
                _, p1, p2, imm_token = partes
                rs_t, rt_t = p1, p2
                rs_bin = reg_a_binario(rs_t)
                rt_bin = reg_a_binario(rt_t)
                if re.fullmatch(r'[A-Za-z_]\w*', imm_token):
                    if imm_token not in labels:
                        raise ValueError(f"L{line_num}: etiqueta no encontrada: {imm_token}")
                    target_index = labels[imm_token]
                    offset = target_index - (idx + 1)
                    imm_val = offset
                else:
                    imm_val = parse_immediate(imm_token)
                imm_bin = int_a_bin_signed(imm_val, 16)
                bin32 = f"{opcode}{rs_bin}{rt_bin}{imm_bin}"
                bin_lines.append(bin32)
                continue

            if op in ("LW", "SW"):
                if len(partes) == 2:
                    raise ValueError(f"L{line_num}: Formato incorrecto para {op}. Esperado: {op} $rt, offset($rs) o {op} $rt $rs imm")
                if len(partes) == 3:
                    _, rt_t, third = partes
                    m = re.fullmatch(r'(-?\d+|\-?0x[0-9a-fA-F]+)\((\$[A-Za-z0-9_]+)\)', third.strip())
                    if m:
                        imm_tok, rs_tok = m.group(1), m.group(2)
                        imm_val = parse_immediate(imm_tok)
                        rs_bin = reg_a_binario(rs_tok)
                        rt_bin = reg_a_binario(rt_t)
                        imm_bin = int_a_bin_signed(imm_val, 16)
                        bin32 = f"{opcode}{rs_bin}{rt_bin}{imm_bin}"
                        bin_lines.append(bin32)
                        continue
                    else:
                        raise ValueError(f"L{line_num}: Formato incorrecto para {op}. Use: {op} $rt, offset($rs) o {op} $rt $rs imm")
                if len(partes) == 4:
                    _, rt_t, rs_t, imm_token = partes
                    rs_bin = reg_a_binario(rs_t)
                    rt_bin = reg_a_binario(rt_t)
                    imm_val = parse_immediate(imm_token)
                    imm_bin = int_a_bin_signed(imm_val, 16)
                    bin32 = f"{opcode}{rs_bin}{rt_bin}{imm_bin}"
                    bin_lines.append(bin32)
                    continue

            if len(partes) != 4:
                raise ValueError(f"L{line_num}: Formato incorrecto para instrucción I ({op}). Esperado: {op} $rt $rs imm")
            _, rt_t, rs_t, imm_token = partes
            rs_bin = reg_a_binario(rs_t)
            rt_bin = reg_a_binario(rt_t)
            imm_val = None
            if re.fullmatch(r'[A-Za-z_]\w*', imm_token):
                if imm_token not in labels:
                    raise ValueError(f"L{line_num}: etiqueta no encontrada: {imm_token}")
                imm_val = labels[imm_token]
            else:
                imm_val = parse_immediate(imm_token)
            if meta.get("signed_imm", True):
                imm_bin = int_a_bin_signed(int(imm_val), 16)
            else:
                imm_bin = uint_a_bin(int(imm_val) & 0xFFFF, 16)
            bin32 = f"{opcode}{rs_bin}{rt_bin}{imm_bin}"
            bin_lines.append(bin32)
            continue

        if tipo_detectado == "J":
            if len(partes) != 2:
                raise ValueError(f"L{line_num}: Formato incorrecto para J. Esperado: J label_or_address")
            _, addr_token = partes
            if re.fullmatch(r'[A-Za-z_]\w*', addr_token):
                if addr_token not in labels:
                    raise ValueError(f"L{line_num}: etiqueta no encontrada: {addr_token}")
                addr_index = labels[addr_token]
                addr_val = addr_index  # asumir direccion relativa al inicio (PC = 0)
            else:
                addr_val = parse_immediate(addr_token)
            addr_bin = uint_a_bin(int(addr_val), 26)
            opcode = instrucciones_J[op]["opcode"]
            bin32 = f"{opcode}{addr_bin}"
            bin_lines.append(bin32)
            continue

        raise ValueError(f"L{line_num}: Tipo no soportado para instrucción: {op}")

    return bin_lines

def formato_a_bytes_de_palabra(bin32: str) -> list:
    if len(bin32) != 32:
        raise ValueError("Longitud inválida, se esperaba 32 bits.")
    return [bin32[i:i+8] for i in range(0, 32, 8)]

def formato_palabra_visible(bin32: str) -> str:
    return bin32

def decodificar_binario(data: bytes) -> str:
    bits = ''.join(format(byte, '08b') for byte in data)
    instrucciones_asm = []
    for i in range(0, len(bits), 32):
        bloque = bits[i:i+32]
        if len(bloque) < 32:
            break
        opcode = bloque[0:6]
        rs = int(bloque[6:11], 2)
        rt = int(bloque[11:16], 2)
        rd = int(bloque[16:21], 2)
        shamt = bloque[21:26]
        funct = bloque[26:32]

        nombre = None

        if opcode == "000000":
            for instr, info in instrucciones.items():
                if info.get("funct") == funct:
                    nombre = instr
                    if instr == "NOP":
                        instrucciones_asm.append("NOP")
                    else:
                        instrucciones_asm.append(f"{instr} ${rd}, ${rs}, ${rt}")
                    break

        if nombre is None:
            for instr, info in instrucciones_I.items():
                if info.get("opcode") == opcode:
                    nombre = instr
                    imm_bits = bloque[16:32]
                    imm_signed = int(imm_bits, 2)
                    if imm_signed & (1 << 15):
                        imm_signed = imm_signed - (1 << 16)
                    instrucciones_asm.append(f"{instr} ${rt}, ${rs}, {imm_signed}")
                    break

        if nombre is None:
            for instr, info in instrucciones_J.items():
                if info.get("opcode") == opcode:
                    nombre = instr
                    addr = int(bloque[6:32], 2)
                    instrucciones_asm.append(f"{instr} {addr}")
                    break

        if nombre is None:
            instrucciones_asm.append(f"DESCONOCIDO (opcode={opcode})")

    return "\n".join(instrucciones_asm)

def convertir():
    asm_texto = entrada_texto.get("1.0", "end").strip()
    if not asm_texto:
        messagebox.showwarning("Aviso", "No hay instrucciones para convertir.")
        return

    salida_texto.delete("1.0", "end")
    errores = []
    tipo = tipo_seleccionado.get()
    try:
        processed, labels = preprocesar_lineas(asm_texto)

        if tipo == "AUTO":
            tipo_forzado = None
        else:
            tipo_forzado = tipo

        bin_list = ensamblar_lineas(processed, labels, tipo_forzado=tipo_forzado)

        for bin32 in bin_list:
            if vista_bytes.get():
                bytes_list = formato_a_bytes_de_palabra(bin32)
                salida_texto.insert("end", "\n".join(bytes_list) + "\n")
            else:
                salida_texto.insert("end", formato_palabra_visible(bin32) + "\n")

    except Exception as e:
        messagebox.showerror("Error ensamblando", str(e))
        salida_texto.insert("end", f"ERROR: {e}\n")

def limpiar():
    entrada_texto.delete("1.0", "end")
    salida_texto.delete("1.0", "end")

def cargar_archivo():
    ruta = filedialog.askopenfilename(
        title="Selecciona un archivo con instrucciones",
        filetypes=[
            ("Archivos ASM", "*.asm"),
            ("Archivos de texto", "*.txt"),
            ("Archivos binarios", "*.bin")
        ]
    )
    
    if not ruta:
        return

    ext = os.path.splitext(ruta)[1].lower()

    try:
        if ext in (".txt", ".asm"):
            with open(ruta, "r", encoding="utf-8") as f:
                contenido = f.read()
            entrada_texto.delete("1.0", "end")
            entrada_texto.insert("1.0", contenido)
            messagebox.showinfo("Archivo cargado", f"Se cargó el archivo: {ruta}")

        elif ext == ".bin":
            with open(ruta, "rb") as f:
                data = f.read()
            contenido = decodificar_binario(data)
            entrada_texto.delete("1.0", "end")
            entrada_texto.insert("1.0", contenido)
            messagebox.showinfo("Archivo binario decodificado", f"Se cargó y decodificó: {ruta}")

        else:
            messagebox.showwarning("Tipo no soportado", "Solo .asm, .txt o .bin son soportados.")

    except Exception as e:
        messagebox.showerror("Error al cargar", str(e))

def guardar_archivo():
    resultado = salida_texto.get("1.0", "end").strip()
    if not resultado:
        messagebox.showwarning("Aviso", "No hay resultado para guardar.")
        return

    ruta = filedialog.asksaveasfilename(
        title="Guardar binario como...",
        defaultextension=".txt",
        filetypes=[("Archivo de texto", "*.txt"), ("Archivo binario", "*.bin")]
    )
    if not ruta:
        return

    try:
        if ruta.lower().endswith(".bin"):
            líneas = [l.strip() for l in resultado.splitlines() if l.strip()]
            bytes_to_write = []
            for linea in líneas:
                if " " in linea:
                    partes = linea.split()
                    for p in partes:
                        if len(p) != 8:
                            raise ValueError(f"Byte con longitud incorrecta: '{p}'")
                        bytes_to_write.append(int(p, 2))
                else:
                    if len(linea) != 32:
                        raise ValueError(f"Línea debe tener 32 bits si no contiene espacios: '{linea}'")
                    for b in formato_a_bytes_de_palabra(linea):
                        bytes_to_write.append(int(b, 2))

            with open(ruta, "wb") as f:
                for b in bytes_to_write:
                    f.write(b.to_bytes(1, byteorder="big"))  # big-endian por byte
            messagebox.showinfo("Guardado", f"Archivo binario guardado en:\n{ruta}")

        else:
            with open(ruta, "w", encoding="utf-8") as f:
                f.write(resultado)
            messagebox.showinfo("Guardado", f"Archivo de texto guardado en:\n{ruta}")

    except Exception as e:
        messagebox.showerror("Error al guardar", str(e))

ventana = tk.Tk()
ventana.title("ASM -> MIPS32 (convertidor) - Versión completada")
ventana.geometry("780x640")

tipo_seleccionado = tk.StringVar(value="AUTO")
vista_bytes = tk.BooleanVar(value=False)

tk.Label(ventana, text="Tipo de instrucción (selección para validación, o dejar R/I/J según prefieras):").pack(anchor="w", padx=8, pady=(8,0))
menu_tipos = tk.OptionMenu(ventana, tipo_seleccionado, "AUTO", "R", "I", "J")
menu_tipos.pack(anchor="w", padx=8)

tk.Checkbutton(ventana, text="Mostrar por bytes (en salida)", variable=vista_bytes).pack(anchor="w", padx=8, pady=(0,8))

tk.Label(ventana, text="Instrucciones (ASM):").pack(anchor="w", padx=8)
frame_entrada = tk.Frame(ventana)
frame_entrada.pack(padx=8)

scroll_in = tk.Scrollbar(frame_entrada)
scroll_in.pack(side="right", fill="y")
entrada_texto = tk.Text(frame_entrada, height=10, width=98, yscrollcommand=scroll_in.set)
entrada_texto.pack(side="left", fill="both")
scroll_in.config(command=entrada_texto.yview)

frame_botones = tk.Frame(ventana)
frame_botones.pack(pady=8)
tk.Button(frame_botones, text="Cargar archivo", command=cargar_archivo).grid(row=0, column=0, padx=6)
tk.Button(frame_botones, text="Convertir", command=convertir).grid(row=0, column=1, padx=6)
tk.Button(frame_botones, text="Guardar resultado", command=guardar_archivo).grid(row=0, column=2, padx=6)
tk.Button(frame_botones, text="Limpiar", command=limpiar).grid(row=0, column=3, padx=6)

tk.Label(ventana, text="Resultado (binario):").pack(anchor="w", padx=8, pady=(8,0))
frame_salida = tk.Frame(ventana)
frame_salida.pack(padx=8)
scroll_out = tk.Scrollbar(frame_salida)
scroll_out.pack(side="right", fill="y")
salida_texto = tk.Text(frame_salida, height=14, width=98, yscrollcommand=scroll_out.set)
salida_texto.pack(side="left", fill="both")
scroll_out.config(command=salida_texto.yview)

ventana.mainloop()