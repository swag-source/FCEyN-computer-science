"""Presentación: tabla de derivación, mapa de bytes y bloque EQU.

Toma las estructuras de `layout.py` y las convierte en texto. El vocabulario
sigue el de la guía de la cátedra (`guia-ASM/src/3 - Alineación y Estructuras`):
*contrato de datos*, *padding*, *requisito de alineación*.
"""

from __future__ import annotations

import os
import sys

from layout import Agregado, Derivacion

# Mismos códigos que parciales/primer-parcial/test_utils/diff.py, para que el
# drill y el corrector real se vean como la misma herramienta.
ROJO = "\x1b[31m"
VERDE = "\x1b[32m"
AMARILLO = "\x1b[33m"
CIAN = "\x1b[36m"
GRIS = "\x1b[90m"
RESET = "\x1b[0m"


def _color_activo() -> bool:
    if os.environ.get("NO_COLOR") is not None:
        return False
    return sys.stdout.isatty()


COLOR = _color_activo()


def c(texto: str, codigo: str) -> str:
    return f"{codigo}{texto}{RESET}" if COLOR else texto


# ---------------------------------------------------------------------------
# Tabla de derivación
# ---------------------------------------------------------------------------


def tabla_derivacion(d: Derivacion, ascii_only: bool = False) -> str:
    flecha = "->" if ascii_only else "→"
    lineas: list[str] = []

    cab = f"{d.tag}   ({'packed' if d.packed else 'sin packed'}"
    if d.clase == "union":
        cab += ", union"
    cab += ")"
    lineas.append(c(cab, CIAN))
    lineas.append("")

    filas: list[tuple[str, ...]] = [
        ("#", "campo", "tipo", "cursor", "align", "padding", "offset", "tam", flecha)
    ]
    for p in d.pasos:
        pad_txt = (
            f"+{p.padding} ({p.cursor_antes}{flecha}{p.offset})" if p.padding else "0"
        )
        filas.append(
            (
                str(p.indice),
                p.campo,
                p.ctype,
                str(p.cursor_antes),
                str(p.align),
                pad_txt,
                str(p.offset),
                str(p.size),
                str(p.cursor_despues),
            )
        )

    anchos = [max(len(f[i]) for f in filas) for i in range(len(filas[0]))]
    just = [False, False, False, True, True, False, True, True, True]

    for n, fila in enumerate(filas):
        celdas = []
        for i, v in enumerate(fila):
            celdas.append(v.rjust(anchos[i]) if just[i] else v.ljust(anchos[i]))
        linea = "  " + "  ".join(celdas).rstrip()
        lineas.append(c(linea, GRIS) if n == 0 else linea)

    lineas.append("")

    # Cierre: alineación del agregado y tail padding.
    lineas.append(f"  align({d.tag}) = {d.struct_align_razon}")
    if d.tail_padding:
        lineas.append(
            f"  size({d.tag})  = redondear({d.fin_crudo}, {d.struct_align}) = {d.size}"
            f"   {flecha} +{d.tail_padding} de tail padding"
        )
    else:
        lineas.append(
            f"  size({d.tag})  = {d.size}   (sin tail padding: {d.fin_crudo} ya es"
            f" múltiplo de {d.struct_align})"
        )

    # La trampa del arreglo merece señalarse explícitamente.
    for p in d.pasos:
        if "ELEMENTO" in p.align_razon:
            lineas.append(f"  {c('ojo:', AMARILLO)} {p.campo}: {p.align_razon}")

    return "\n".join(lineas)


# ---------------------------------------------------------------------------
# Mapa de bytes
# ---------------------------------------------------------------------------

_LETRAS = "abcdefghijklmnopqrstuvwxyz"
_LIMITE_GRILLA = 64


def mapa_bytes(d: Derivacion, ascii_only: bool = False) -> str:
    """Grilla byte a byte si entra; si no, lista de rangos."""
    if d.clase == "union":
        return _mapa_union(d)
    if d.size > _LIMITE_GRILLA:
        return _mapa_rangos(d)
    return _mapa_grilla(d, ascii_only)


def _mapa_grilla(d: Derivacion, ascii_only: bool) -> str:
    pad_ch = "." if ascii_only else "·"
    celdas = [pad_ch] * d.size
    leyenda: list[str] = []
    for i, p in enumerate(d.pasos):
        letra = _LETRAS[i % len(_LETRAS)]
        for b in range(p.offset, min(p.offset + p.size, d.size)):
            celdas[b] = letra
        leyenda.append(f"{letra} = {p.campo}")

    lineas = ["  mapa de bytes   " + c(f"({pad_ch} = padding)", GRIS)]
    for fila in range(0, d.size, 8):
        trozo = celdas[fila : fila + 8]
        regla = f"{fila:>5}"
        lineas.append(f"  {regla} |{''.join(trozo)}|")
    lineas.append("        " + c("  ".join(leyenda), GRIS))
    return "\n".join(lineas)


def _mapa_rangos(d: Derivacion) -> str:
    lineas = ["  rangos de bytes"]
    cursor = 0
    for p in d.pasos:
        if p.padding:
            lineas.append(
                c(f"    {'(padding)':<16} [{cursor:>4} ..{p.offset - 1:>5}]"
                  f"  {p.padding} B", GRIS)
            )
        lineas.append(
            f"    {p.campo:<16} [{p.offset:>4} ..{p.offset + p.size - 1:>5}]"
            f"  {p.size} B   {p.ctype}"
        )
        cursor = p.offset + p.size
    if d.tail_padding:
        lineas.append(
            c(f"    {'(tail padding)':<16} [{cursor:>4} ..{d.size - 1:>5}]"
              f"  {d.tail_padding} B", GRIS)
        )
    return "\n".join(lineas)


def _mapa_union(d: Derivacion) -> str:
    lineas = ["  todos los miembros arrancan en 0"]
    for p in d.pasos:
        lineas.append(f"    {p.campo:<16} [   0 ..{p.size - 1:>5}]  {p.size} B   {p.ctype}")
    lineas.append(f"    size = redondear(max = {d.fin_crudo}, align = {d.struct_align}) = {d.size}")
    return "\n".join(lineas)


# ---------------------------------------------------------------------------
# Bloque EQU listo para pegar
# ---------------------------------------------------------------------------


def base_equ(tag: str) -> str:
    """`tuit_t` -> `TUIT`. Ojo con rstrip('_T'), que se come de más."""
    return (tag[:-2] if tag.endswith("_t") else tag).upper()


def bloque_equ(a: Agregado, d: Derivacion) -> str:
    filas: list[tuple[str, int]] = []
    base = base_equ(a.tag)
    for campo, paso in zip(a.campos, d.pasos):
        nombre = campo.equ or f"{base}_{campo.nombre.upper()}_OFFSET"
        filas.append((nombre, paso.offset))
    nombre_size = a.equ_size or f"{base}_SIZE"
    filas.append((nombre_size, d.size))

    ancho = max(len(n) for n, _ in filas)
    return "\n".join(f"{n:<{ancho}} EQU {v}" for n, v in filas)


def naive_vs_real(d: Derivacion) -> str:
    """La respuesta 'ingenua' (sumar tamaños, ignorar alineación)."""
    difs = [
        f"{p.campo}={d.naive_offsets[p.campo]}"
        for p in d.pasos
        if d.naive_offsets[p.campo] != p.offset
    ]
    if d.naive_size != d.size:
        difs.append(f"size={d.naive_size}")
    if not difs:
        return ""
    return c("  sin alinear daría: " + ", ".join(difs), GRIS)
