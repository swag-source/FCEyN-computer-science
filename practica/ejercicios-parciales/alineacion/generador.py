"""Generación de problemas y construcción del banco.

Generar campos al azar de forma independiente produce sobre todo structs
degenerados donde todo cae alineado solo y no se aprende nada. Acá se sesga
la generación con una cadena de Markov sobre clases de alineación, y después
se filtra por "interesante": un problema sirve si resolverlo **exige** aplicar
las reglas, es decir si la respuesta ingenua (sumar tamaños) difiere de la real
en al menos dos cantidades.
"""

from __future__ import annotations

import json
import random
from dataclasses import dataclass

from layout import (
    Agregado,
    Arreglo,
    Campo,
    Derivacion,
    Escalar,
    Puntero,
    Ref,
    nombre_display,
    render_agregado,
    serializar_agregado,
)
from oracle import Problema, verificar_lote
from render import base_equ, mapa_bytes, tabla_derivacion

# ---------------------------------------------------------------------------
# Vocabulario: exactamente el de los parciales
# ---------------------------------------------------------------------------

POR_CLASE = {
    1: ["uint8_t", "int8_t", "char", "bool"],
    2: ["uint16_t", "int16_t"],
    4: ["uint32_t", "int32_t"],
    8: ["uint64_t", "int64_t"],
}

APUNTADOS = ["usuario_t", "nodo_t", "item_t", "uint32_t", "char", "void", "producto_t"]

# TAGS y TAGS_INT deben ser disjuntos: dos agregados con el mismo tag dentro
# de un problema generan C que no compila.
TAGS = [
    "item_t", "nodo_t", "catalogo_t", "producto_t", "registro_t", "paquete_t",
    "celda_t", "entrada_t", "bloque_t", "unidad_t", "ficha_t",
]
TAGS_INT = ["cabecera_t", "meta_t", "clave_t", "marca_t", "rango_t"]
assert not (set(TAGS) & set(TAGS_INT)), "TAGS y TAGS_INT se pisan"

CAMPOS = [
    "id", "nombre", "cantidad", "next", "nivel", "precio", "estado", "categoria",
    "durabilidad", "fuerza", "peso", "flags", "tam", "clave", "valor", "offset",
    "tipo", "color", "hash", "edad", "codigo", "stock", "indice", "prioridad",
]

# Los headers de los parciales nombran por significado: `char nombre[25]`,
# `publicacion_t *next`, `uint8_t nivel`. Nombrar al azar delata que el
# problema es sintético y distrae.
NOMBRES_POR_TIPO = {
    "texto": ["nombre", "categoria", "clase", "titulo", "codigo", "descripcion", "mensaje"],
    "puntero": ["next", "prev", "value", "head", "usuario", "datos", "first", "dueno"],
    "chico": ["nivel", "estado", "flags", "tipo", "color", "prioridad", "edad",
              "durabilidad", "activo"],
    "grande": ["id", "cantidad", "precio", "peso", "hash", "tam", "offset", "stock",
               "indice", "fuerza", "total"],
    "agregado": ["cab", "meta", "info", "clave", "rango", "marca", "resumen"],
}


def _familia(t) -> str:
    if isinstance(t, Ref):
        return "agregado"
    if isinstance(t, Puntero):
        return "puntero"
    if isinstance(t, Arreglo):
        if isinstance(t.elem, Ref):
            return "agregado"
        if isinstance(t.elem, Escalar) and t.elem.nombre == "char":
            return "texto"
        return "grande"
    if isinstance(t, Escalar):
        from layout import PRIMITIVOS

        return "chico" if PRIMITIVOS[t.nombre][0] <= 2 else "grande"
    return "grande"


def nombrar(rng: random.Random, tipos: list) -> list[str]:
    """Un nombre plausible para cada tipo, sin repetir."""
    usados: set[str] = set()
    out: list[str] = []
    for t in tipos:
        pool = [n for n in NOMBRES_POR_TIPO[_familia(t)] if n not in usados]
        if not pool:
            pool = [n for n in CAMPOS if n not in usados]
        elegido = rng.choice(pool)
        usados.add(elegido)
        out.append(elegido)
    return out

# Largos con sabor a parcial: impares y molestos, incluidos los reales.
LARGOS_CHAR = [3, 5, 7, 9, 11, 13, 18, 21, 25]
LARGOS_CHAR_GRANDE = LARGOS_CHAR + [140]


@dataclass
class Nivel:
    clave: str
    titulo: str
    arreglos: bool = False
    anidados: bool = False
    packed: bool = False
    uniones: bool = False
    n_campos: tuple[int, int] = (3, 6)
    # Rasgos de los que al menos uno debe estar presente.
    firma: tuple[str, ...] = ()


NIVELES: dict[str, Nivel] = {
    "1": Nivel("1", "escalares y punteros", firma=("hueco:interno", "hueco:tail")),
    "2": Nivel("2", "arreglos y char[n]", arreglos=True,
               firma=("align:del-arreglo", "hueco:interno")),
    "3": Nivel("3", "structs anidados", arreglos=True, anidados=True,
               firma=("anidado:no-aplana", "anidado:tail-padding-importa")),
    "4": Nivel("4", "packed", arreglos=True, anidados=True, packed=True,
               firma=("packed:sin-padding", "packed:no-se-propaga",
                      "packed:interno-conserva-hueco", "packed:stride-arreglo")),
    "5": Nivel("5", "uniones", arreglos=True, anidados=True, uniones=True,
               firma=("union:size-no-es-el-mayor", "union:align-manda")),
}


# ---------------------------------------------------------------------------
# Muestreo sesgado
# ---------------------------------------------------------------------------


def _escalar(rng: random.Random, clase: int) -> Escalar:
    return Escalar(rng.choice(POR_CLASE[clase]))


def _siguiente_clase(rng: random.Random, actual: int | None) -> int:
    """Cadena de Markov: preferí subir de clase, que es lo que genera huecos."""
    clases = [1, 2, 4, 8]
    if actual is None:
        return rng.choice(clases)
    mayores = [c for c in clases if c > actual]
    menores = [c for c in clases if c < actual]
    r = rng.random()
    if r < 0.55 and mayores:
        return rng.choice(mayores)
    if r < 0.85 or not menores:
        return actual
    return rng.choice(menores)


def _campo_al_azar(
    rng: random.Random, nivel: Nivel, clase: int, internos: list[Agregado], grande: bool
):
    """Devuelve (tipo, clase_de_align_efectiva)."""
    opciones: list[str] = ["escalar"]
    if clase == 8:
        opciones.append("puntero")
    if nivel.arreglos:
        opciones += ["arreglo_char", "arreglo_escalar"]
    if nivel.anidados and internos:
        opciones += ["anidado", "anidado"]
        if nivel.packed:
            opciones.append("arreglo_anidado")

    tipo_elegido = rng.choice(opciones)

    if tipo_elegido == "puntero":
        return Puntero(rng.choice(APUNTADOS), rng.choice([1, 1, 1, 2])), 8
    if tipo_elegido == "arreglo_char":
        largos = LARGOS_CHAR_GRANDE if grande else LARGOS_CHAR
        return Arreglo(Escalar("char"), rng.choice(largos)), 1
    if tipo_elegido == "arreglo_escalar":
        base = _escalar(rng, clase)
        return Arreglo(base, rng.randint(2, 5)), clase
    if tipo_elegido in ("anidado", "arreglo_anidado"):
        interno = rng.choice(internos)
        if tipo_elegido == "arreglo_anidado":
            return Arreglo(Ref(interno.tag), rng.randint(2, 3)), None
        return Ref(interno.tag), None
    return _escalar(rng, clase), clase


def generar_problema(rng: random.Random, nivel: Nivel, idx: int) -> Problema:
    tags = rng.sample(TAGS, 1)
    internos: list[Agregado] = []

    if nivel.anidados:
        tag_int = rng.choice(TAGS_INT)
        n = rng.randint(2, 3)
        tipos_int = []
        clase = None
        for _ in range(n):
            clase = _siguiente_clase(rng, clase)
            t, _ = _campo_al_azar(rng, Nivel("i", "", arreglos=nivel.arreglos), clase, [], False)
            tipos_int.append(t)
        campos_int = [Campo(nm, t) for nm, t in zip(nombrar(rng, tipos_int), tipos_int)]
        internos.append(
            Agregado(tag_int, "struct", packed=nivel.packed and rng.random() < 0.4,
                     campos=campos_int)
        )

    if nivel.uniones and rng.random() < 0.7:
        tag_u = rng.choice(TAGS_INT)
        while any(a.tag == tag_u for a in internos):
            tag_u = rng.choice(TAGS_INT)
        tipos_u = []
        for _ in range(rng.randint(2, 3)):
            clase = rng.choice([1, 2, 4, 8])
            t, _ = _campo_al_azar(rng, Nivel("u", "", arreglos=True), clase, [], False)
            tipos_u.append(t)
        campos_u = [Campo(nm, t) for nm, t in zip(nombrar(rng, tipos_u), tipos_u)]
        internos.append(Agregado(tag_u, "union", False, campos_u))

    n = rng.randint(*nivel.n_campos)
    campos: list[Campo] = []
    clase = None
    usa_grande = rng.random() < 0.12
    for i in range(n):
        clase = _siguiente_clase(rng, clase)
        disponibles = internos if internos else []
        t, ce = _campo_al_azar(rng, nivel, clase, disponibles, usa_grande and i == 0)
        if ce is not None:
            clase = ce
        campos.append(Campo(f"_{i}", t))

    # Empujar hacia tail padding: si el último campo ya alinea al máximo, no hay
    # cola, y la cola es justo lo que más se olvida.
    if rng.random() < 0.6:
        campos[-1] = Campo(campos[-1].nombre, _escalar(rng, rng.choice([1, 1, 2])))

    # Si el nivel es de anidamiento pero no quedó ninguna referencia al interno,
    # el problema no ejercita nada. Forzar una.
    if nivel.anidados and internos and not any(any(_refs(c.tipo)) for c in campos):
        interno = rng.choice(internos)
        pos = rng.randrange(max(1, len(campos) - 1))
        if nivel.packed and interno.packed and rng.random() < 0.45:
            t = Arreglo(Ref(interno.tag), rng.randint(2, 3))  # stride sin relleno
        else:
            t = Ref(interno.tag)
        campos[pos] = Campo(campos[pos].nombre, t)

    # Recién ahora los tipos son definitivos: nombrar en función de ellos.
    tipos_finales = [x.tipo for x in campos]
    campos = [Campo(nm, t) for nm, t in zip(nombrar(rng, tipos_finales), tipos_finales)]

    packed = nivel.packed and rng.random() < 0.55
    principal = Agregado(tags[0], "struct", packed=packed, campos=campos)

    # Sólo dejamos los internos que efectivamente se usan.
    usados = {t.tag for c in campos for t in _refs(c.tipo)}
    agregados = [a for a in internos if a.tag in usados] + [principal]

    base = base_equ(principal.tag)
    for c in principal.campos:
        c.equ = f"{base}_{c.nombre.upper()}_OFFSET"
    principal.equ_size = f"{base}_SIZE"

    return Problema(id=f"n{nivel.clave}-{idx:04d}", nivel=nivel.clave,
                    seed=rng.randint(0, 2**31), agregados=agregados)


def _refs(t):
    if isinstance(t, Ref):
        yield t
    elif isinstance(t, Arreglo):
        yield from _refs(t.elem)


# ---------------------------------------------------------------------------
# Rasgos e interés
# ---------------------------------------------------------------------------


def clasificar(p: Problema, derivs: dict[str, Derivacion]) -> set[str]:
    rasgos: set[str] = set()
    a = p.principal
    d = derivs[a.tag]
    internos = {x.tag: x for x in p.agregados[:-1]}

    if any(paso.padding for paso in d.pasos):
        rasgos.add("hueco:interno")
    if d.tail_padding:
        rasgos.add("hueco:tail")

    if d.clase == "union":
        if d.size > max(paso.size for paso in d.pasos):
            rasgos.add("union:size-no-es-el-mayor")

    for campo, paso in zip(a.campos, d.pasos):
        if isinstance(campo.tipo, Arreglo):
            mayor = max(x.size for x in d.pasos)
            if paso.size == mayor and paso.align < d.struct_align:
                rasgos.add("align:del-arreglo")
            if isinstance(campo.tipo.elem, Ref):
                interno = internos.get(campo.tipo.elem.tag)
                if interno is not None and interno.packed:
                    rasgos.add("packed:stride-arreglo")
        if isinstance(campo.tipo, Ref):
            interno = internos.get(campo.tipo.tag)
            if interno is None:
                continue
            di = derivs[interno.tag]
            if di.struct_align == d.struct_align and di.struct_align > 1:
                rasgos.add("align:del-anidado")
            if di.tail_padding:
                rasgos.add("anidado:tail-padding-importa")
            if di.clase == "union":
                if di.struct_align >= d.struct_align:
                    rasgos.add("union:align-manda")
                # La union redondea hacia arriba: su size no es el del miembro
                # más grande. Se detecta acá, en la interna, que es donde importa.
                if di.size > max(x.size for x in di.pasos):
                    rasgos.add("union:size-no-es-el-mayor")
            if a.packed and not interno.packed and any(x.padding for x in di.pasos):
                rasgos.add("packed:interno-conserva-hueco")
            if not a.packed and interno.packed:
                rasgos.add("packed:no-se-propaga")
            # Aplanar el interno en el padre cambiaría la disposición.
            if di.tail_padding or any(x.padding for x in di.pasos):
                rasgos.add("anidado:no-aplana")

    if a.packed:
        rasgos.add("packed:sin-padding")

    if any(paso.offset >= 100 for paso in d.pasos):
        rasgos.add("offset:grande")

    return rasgos


def cuantas_ingenuas_fallan(d: Derivacion) -> int:
    n = sum(1 for p in d.pasos if d.naive_offsets[p.campo] != p.offset)
    if d.naive_size != d.size:
        n += 1
    return n


def layout_sin_packed(p: Problema) -> Derivacion:
    """La misma estructura pero sin `packed`, para poder contrastar."""
    from copy import deepcopy

    from layout import calcular_todos as _ct

    copia = deepcopy(p.agregados)
    copia[-1].packed = False
    return _ct(copia)[copia[-1].tag]


def cuantas_cambian_sin_packed(p: Problema, d: Derivacion) -> tuple[int, Derivacion]:
    """En un struct packed la suma ingenua ES la respuesta, así que el contraste
    útil no es contra la suma sino contra la versión sin packed."""
    alt = layout_sin_packed(p)
    n = sum(1 for a, b in zip(d.pasos, alt.pasos) if a.offset != b.offset)
    if d.size != alt.size:
        n += 1
    return n, alt


def es_interesante(
    p: Problema, derivs: dict[str, Derivacion], nivel: Nivel, rasgos: set[str], stats: dict
) -> tuple[bool, str]:
    d = derivs[p.principal.tag]

    if d.size > 512:
        return False, "demasiado grande"

    # La definición operativa de "interesante": resolverlo tiene que EXIGIR
    # aplicar las reglas. En un struct packed la suma ingenua acierta siempre,
    # así que ahí el contraste es contra la versión sin packed.
    if p.principal.packed:
        n_dif, _ = cuantas_cambian_sin_packed(p, d)
        if n_dif < 2:
            return False, "packed casi no cambia nada"
    else:
        if cuantas_ingenuas_fallan(d) < 2:
            return False, "la respuesta ingenua casi acierta"

    padding_total = sum(x.padding for x in d.pasos) + d.tail_padding
    if padding_total == 0 and not p.principal.packed:
        # Cupo del 15%: alguno sin padding, como trampa al revés.
        cupo = stats["total"] * 0.15
        if stats["sin_padding"] >= cupo:
            return False, "cupo de problemas sin padding agotado"

    if nivel.firma and not (set(nivel.firma) & rasgos):
        return False, f"no ejercita el nivel ({'/'.join(nivel.firma)})"

    tam = {x.size for x in d.pasos}
    if len(tam) == 1 and len(d.pasos) > 2:
        return False, "todos los campos del mismo tamaño"

    firma_layout = (
        tuple((x.size, x.align) for x in d.pasos), d.packed, d.clase
    )
    if stats["firmas"].get(firma_layout, 0) >= 2:
        return False, "disposición repetida"

    return True, "ok"


# ---------------------------------------------------------------------------
# Banco
# ---------------------------------------------------------------------------


def _preguntas(p: Problema, d: Derivacion) -> list[dict]:
    a = p.principal
    qs = []
    for campo, paso in zip(a.campos, d.pasos):
        qs.append({
            "q": campo.equ,
            "kind": "offset",
            "campo": campo.nombre,
            "respuesta": paso.offset,
            "naive": d.naive_offsets[campo.nombre],
        })
    qs.append({
        "q": a.equ_size, "kind": "size", "campo": None,
        "respuesta": d.size, "naive": d.naive_size,
    })
    qs.append({
        "q": f"align({a.tag})", "kind": "align", "campo": None,
        "respuesta": d.struct_align, "naive": 1,
    })
    return qs


def _a_json(p: Problema, derivs: dict[str, Derivacion], rasgos: set[str]) -> dict:
    d = derivs[p.principal.tag]
    fuente = "\n\n".join(render_agregado(a) for a in p.agregados)
    return {
        "id": p.id,
        "nivel": p.nivel,
        "seed": p.seed,
        "rasgos": sorted(rasgos),
        "c_source": fuente,
        "modelo": [serializar_agregado(a) for a in p.agregados],
        "tag": p.principal.tag,
        "packed": p.principal.packed,
        "size": d.size,
        "align": d.struct_align,
        "campos": [
            {"nombre": x.campo, "ctype": x.ctype, "offset": x.offset,
             "size": x.size, "align": x.align, "padding": x.padding,
             "cursor_antes": x.cursor_antes, "align_razon": x.align_razon}
            for x in d.pasos
        ],
        "preguntas": _preguntas(p, d),
        "sin_packed": (
            {"size": _alt.size, "offsets": [x.offset for x in _alt.pasos]}
            if p.principal.packed and (_alt := layout_sin_packed(p)) else None
        ),
        "derivacion": {
            "struct_align_razon": d.struct_align_razon,
            "fin_crudo": d.fin_crudo,
            "tail_padding": d.tail_padding,
            "texto": tabla_derivacion(d, ascii_only=True),
            "mapa": mapa_bytes(d, ascii_only=True),
        },
        "verificado": True,
    }


def construir_banco(
    por_nivel: int = 100, seed: int = 20260915, cc: str = "gcc", verbose: bool = True
) -> dict:
    rng = random.Random(seed)
    problemas_json: list[dict] = []
    rechazos: dict[str, int] = {}

    for clave, nivel in NIVELES.items():
        stats = {"total": 0, "sin_padding": 0, "firmas": {}}
        aceptados = 0
        intentos = 0
        pendientes: list[Problema] = []

        while aceptados < por_nivel and intentos < por_nivel * 60:
            while len(pendientes) < 40 and intentos < por_nivel * 60:
                intentos += 1
                pendientes.append(generar_problema(rng, nivel, intentos))

            verificados = verificar_lote(pendientes, cc)
            pendientes = []

            for p, derivs, _ in verificados:
                if aceptados >= por_nivel:
                    break
                rasgos = clasificar(p, derivs)
                ok, motivo = es_interesante(p, derivs, nivel, rasgos, stats)
                if not ok:
                    rechazos[motivo] = rechazos.get(motivo, 0) + 1
                    continue
                d = derivs[p.principal.tag]
                stats["total"] += 1
                if sum(x.padding for x in d.pasos) + d.tail_padding == 0:
                    stats["sin_padding"] += 1
                firma = (tuple((x.size, x.align) for x in d.pasos), d.packed, d.clase)
                stats["firmas"][firma] = stats["firmas"].get(firma, 0) + 1
                problemas_json.append(_a_json(p, derivs, rasgos))
                aceptados += 1

        if verbose:
            print(f"  nivel {clave} ({nivel.titulo}): {aceptados} problemas"
                  f" en {intentos} intentos")

    from oracle import _PREFLIGHT

    return {
        "schema": "orga2-alineacion/1",
        "oracle": {"cc": cc, **(_PREFLIGHT or {}), "flags": ["-std=gnu11", "-m64", "-O0"]},
        "generador": {"seed": seed, "por_nivel": por_nivel},
        "rechazos": rechazos,
        "problemas": problemas_json,
    }
