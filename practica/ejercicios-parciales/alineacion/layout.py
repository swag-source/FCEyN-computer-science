"""Modelo de tipos de C y motor de disposición en memoria.

Este módulo calcula offsets, tamaños y alineaciones **por su cuenta**, sin
consultar al compilador. Es la "segunda opinión" que `oracle.py` contrasta
contra gcc: si alguna vez discrepan, es un bug acá y se reporta a los gritos.

Nunca importar gcc desde este archivo. Esa separación es lo que hace que el
contraste sirva de algo.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Union

# ---------------------------------------------------------------------------
# Tabla de primitivos. Es la ÚNICA tabla de números del proyecto.
# ---------------------------------------------------------------------------

PRIMITIVOS: dict[str, tuple[int, int]] = {
    "char": (1, 1),
    "bool": (1, 1),
    "uint8_t": (1, 1),
    "int8_t": (1, 1),
    "uint16_t": (2, 2),
    "int16_t": (2, 2),
    "uint32_t": (4, 4),
    "int32_t": (4, 4),
    "uint64_t": (8, 8),
    "int64_t": (8, 8),
}

PUNTERO = (8, 8)

# Tipos excluidos a propósito, con el motivo. No generar ninguno de estos.
#   long double  -> 16/16 en x86-64 pero sólo 10 bytes significativos; enseña
#                   que "sizeof dice cuántos bytes importan", que es falso.
#   long/int/short sin ancho fijo -> dependen de la ABI; los parciales usan
#                   siempre <stdint.h>.
#   bitfields    -> empaquetado parcialmente definido por la implementación.
#   arreglos de longitud 0 y flexible array members -> fuera del programa.
PROHIBIDOS = frozenset({"long double", "long", "int", "short", "unsigned", "float", "double"})


# ---------------------------------------------------------------------------
# Modelo de tipos
# ---------------------------------------------------------------------------


@dataclass(frozen=True)
class Escalar:
    nombre: str

    def __post_init__(self) -> None:
        if self.nombre not in PRIMITIVOS:
            raise ValueError(f"tipo escalar desconocido: {self.nombre!r}")


@dataclass(frozen=True)
class Puntero:
    """Puntero. `apunta_a` es sólo para mostrar; todo puntero mide 8/8."""

    apunta_a: str = "void"
    niveles: int = 1


@dataclass(frozen=True)
class Arreglo:
    elem: "Tipo"
    n: int


@dataclass(frozen=True)
class Ref:
    """Agregado embebido por valor (no puntero)."""

    tag: str


Tipo = Union[Escalar, Puntero, Arreglo, Ref]


@dataclass
class Campo:
    nombre: str
    tipo: Tipo
    equ: str | None = None


@dataclass
class Agregado:
    tag: str
    clase: str  # "struct" | "union"
    packed: bool = False
    campos: list[Campo] = field(default_factory=list)
    equ_size: str | None = None

    @property
    def es_union(self) -> bool:
        return self.clase == "union"


# ---------------------------------------------------------------------------
# Renderizado a C
# ---------------------------------------------------------------------------


def render_declarador(t: Tipo, nombre: str) -> str:
    """Recursión estándar de declaradores de C.

    Sirve para las líneas de campo, para los typedef sonda del oráculo y para
    los nombres que se muestran en el quiz. Una sola primitiva, tres usos.
    """
    if isinstance(t, Escalar):
        return f"{t.nombre} {nombre}".rstrip()
    if isinstance(t, Puntero):
        estrellas = "*" * t.niveles
        base = t.apunta_a
        return f"{base} {estrellas}{nombre}".rstrip()
    if isinstance(t, Arreglo):
        return render_declarador(t.elem, f"{nombre}[{t.n}]")
    if isinstance(t, Ref):
        return f"{t.tag} {nombre}".rstrip()
    raise TypeError(f"tipo no soportado: {t!r}")


def nombre_display(t: Tipo) -> str:
    """Nombre corto del tipo, sin nombre de variable: `char[18]`, `usuario_t **`."""
    s = render_declarador(t, "")
    return s.replace(" [", "[")


def render_agregado(a: Agregado, con_equ: bool = False) -> str:
    """El agregado tal como aparecería en un header del parcial."""
    attr = " __attribute__((__packed__))" if a.packed else ""
    lineas = [f"typedef {a.clase}{attr} {{"]
    ancho = max((len(render_declarador(c.tipo, c.nombre)) for c in a.campos), default=0)
    for c in a.campos:
        decl = render_declarador(c.tipo, c.nombre)
        if con_equ and c.equ:
            lineas.append(f"  {decl:<{ancho}}; // asmdef_offset:{c.equ}")
        else:
            lineas.append(f"  {decl};")
    cierre = f"}} {a.tag};"
    if con_equ and a.equ_size:
        cierre += f" // asmdef_size:{a.equ_size}"
    lineas.append(cierre)
    return "\n".join(lineas)


# ---------------------------------------------------------------------------
# Motor de disposición
# ---------------------------------------------------------------------------


@dataclass
class Paso:
    indice: int
    campo: str
    ctype: str
    cursor_antes: int
    align: int
    align_razon: str
    padding: int
    offset: int
    size: int
    cursor_despues: int


@dataclass
class Derivacion:
    tag: str
    clase: str
    packed: bool
    pasos: list[Paso]
    struct_align: int
    struct_align_razon: str
    fin_crudo: int
    tail_padding: int
    size: int
    naive_offsets: dict[str, int]
    naive_size: int


def redondear(x: int, a: int) -> int:
    if a <= 1:
        return x
    return ((x + a - 1) // a) * a


def medidas(t: Tipo, tabla: dict[str, tuple[int, int]]) -> tuple[int, int]:
    """(size, align) del tipo, con `tabla` resolviendo agregados ya calculados."""
    if isinstance(t, Escalar):
        return PRIMITIVOS[t.nombre]
    if isinstance(t, Puntero):
        return PUNTERO
    if isinstance(t, Arreglo):
        es, ea = medidas(t.elem, tabla)
        # size = n * size del elemento, SIN redondear. Es lo que hace que
        # sizeof(packed[3]) == 27 y no 32.
        return es * t.n, ea
    if isinstance(t, Ref):
        if t.tag not in tabla:
            raise KeyError(f"agregado {t.tag!r} usado antes de calcularse")
        return tabla[t.tag]
    raise TypeError(f"tipo no soportado: {t!r}")


def _razon_align(t: Tipo, align_tipo: int, packed: bool) -> str:
    if packed:
        return f"packed → 1 (el align del tipo es {align_tipo}, se ignora)"
    if isinstance(t, Arreglo):
        base = t.elem
        nb = nombre_display(base)
        return f"{nombre_display(t)} → align del ELEMENTO ({nb}) = {align_tipo}, no {t.n}"
    if isinstance(t, Ref):
        return f"{t.tag} → align del agregado interno = {align_tipo}"
    return f"{nombre_display(t)} → {align_tipo}"


def calcular(a: Agregado, tabla: dict[str, tuple[int, int]]) -> Derivacion:
    """Calcula la disposición de `a`. `tabla` ya debe tener sus dependencias."""
    if not a.campos:
        raise ValueError(f"{a.tag}: agregado sin campos")

    pasos: list[Paso] = []
    naive_offsets: dict[str, int] = {}

    if a.es_union:
        max_size = 0
        max_align = 1
        naive_max = 0
        for i, c in enumerate(a.campos, 1):
            s, al = medidas(c.tipo, tabla)
            al_ef = 1 if a.packed else al
            pasos.append(
                Paso(
                    indice=i,
                    campo=c.nombre,
                    ctype=nombre_display(c.tipo),
                    cursor_antes=0,
                    align=al_ef,
                    align_razon=_razon_align(c.tipo, al, a.packed),
                    padding=0,
                    offset=0,
                    size=s,
                    cursor_despues=s,
                )
            )
            naive_offsets[c.nombre] = 0
            max_size = max(max_size, s)
            max_align = max(max_align, al_ef)
            naive_max = max(naive_max, s)

        struct_align = 1 if a.packed else max_align
        size = redondear(max_size, struct_align)
        razon = (
            "packed → align 1"
            if a.packed
            else f"max de los align de los miembros = {struct_align}"
        )
        return Derivacion(
            tag=a.tag,
            clase=a.clase,
            packed=a.packed,
            pasos=pasos,
            struct_align=struct_align,
            struct_align_razon=razon,
            fin_crudo=max_size,
            tail_padding=size - max_size,
            size=size,
            naive_offsets=naive_offsets,
            naive_size=naive_max,
        )

    cursor = 0
    max_align = 1
    naive_cursor = 0
    aligns: list[int] = []

    for i, c in enumerate(a.campos, 1):
        s, al = medidas(c.tipo, tabla)
        al_ef = 1 if a.packed else al
        off = redondear(cursor, al_ef)
        pad = off - cursor
        pasos.append(
            Paso(
                indice=i,
                campo=c.nombre,
                ctype=nombre_display(c.tipo),
                cursor_antes=cursor,
                align=al_ef,
                align_razon=_razon_align(c.tipo, al, a.packed),
                padding=pad,
                offset=off,
                size=s,
                cursor_despues=off + s,
            )
        )
        naive_offsets[c.nombre] = naive_cursor
        naive_cursor += s
        cursor = off + s
        max_align = max(max_align, al_ef)
        aligns.append(al_ef)

    struct_align = 1 if a.packed else max_align
    size = redondear(cursor, struct_align)
    if a.packed:
        razon = "packed → align 1"
    else:
        razon = f"max({', '.join(str(x) for x in aligns)}) = {struct_align}"

    return Derivacion(
        tag=a.tag,
        clase=a.clase,
        packed=a.packed,
        pasos=pasos,
        struct_align=struct_align,
        struct_align_razon=razon,
        fin_crudo=cursor,
        tail_padding=size - cursor,
        size=size,
        naive_offsets=naive_offsets,
        naive_size=naive_cursor,
    )


def calcular_todos(agregados: list[Agregado]) -> dict[str, Derivacion]:
    """Calcula en orden de dependencia (la lista ya debe venir ordenada)."""
    tabla: dict[str, tuple[int, int]] = {}
    out: dict[str, Derivacion] = {}
    for a in agregados:
        d = calcular(a, tabla)
        tabla[a.tag] = (d.size, d.struct_align)
        out[a.tag] = d
    return out


# ---------------------------------------------------------------------------
# Serialización (para que el banco se pueda revalidar contra gcc más adelante)
# ---------------------------------------------------------------------------


def serializar_tipo(t: Tipo) -> dict:
    if isinstance(t, Escalar):
        return {"k": "esc", "n": t.nombre}
    if isinstance(t, Puntero):
        return {"k": "ptr", "a": t.apunta_a, "niv": t.niveles}
    if isinstance(t, Arreglo):
        return {"k": "arr", "e": serializar_tipo(t.elem), "n": t.n}
    if isinstance(t, Ref):
        return {"k": "ref", "tag": t.tag}
    raise TypeError(t)


def deserializar_tipo(d: dict) -> Tipo:
    k = d["k"]
    if k == "esc":
        return Escalar(d["n"])
    if k == "ptr":
        return Puntero(d["a"], d["niv"])
    if k == "arr":
        return Arreglo(deserializar_tipo(d["e"]), d["n"])
    if k == "ref":
        return Ref(d["tag"])
    raise ValueError(k)


def serializar_agregado(a: Agregado) -> dict:
    return {
        "tag": a.tag,
        "clase": a.clase,
        "packed": a.packed,
        "equ_size": a.equ_size,
        "campos": [
            {"nombre": c.nombre, "tipo": serializar_tipo(c.tipo), "equ": c.equ}
            for c in a.campos
        ],
    }


def deserializar_agregado(d: dict) -> Agregado:
    return Agregado(
        tag=d["tag"],
        clase=d["clase"],
        packed=d["packed"],
        equ_size=d.get("equ_size"),
        campos=[
            Campo(c["nombre"], deserializar_tipo(c["tipo"]), c.get("equ"))
            for c in d["campos"]
        ],
    )
