"""gcc como fuente de verdad, y contraste contra el motor propio.

`layout.py` calcula la disposición por su cuenta. Acá se le pregunta a gcc la
misma cosa y se comparan **todas** las cantidades. Si discrepan, el problema se
descarta y se reporta a los gritos: un drill que enseña una regla falsa es peor
que no tener drill.

Truco central: cada sonda de tamaño/alineación se hace sobre un *nombre de
tipo*, no sobre una expresión, definiendo un typedef por campo. Así `_Alignof`
(C11) alcanza para todo, incluidos `char[18]` y punteros, sin casos especiales.

Los punteros se emiten como `void *`: en x86-64 todo puntero mide 8/8, así que
la disposición es idéntica y no hace falta declarar tags hacia adelante.
"""

from __future__ import annotations

import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from pathlib import Path

from layout import (
    Agregado,
    Arreglo,
    Derivacion,
    Escalar,
    Puntero,
    Ref,
    Tipo,
    calcular_todos,
    render_declarador,
)

CC_FLAGS = ["-std=gnu11", "-m64", "-O0", "-Wall", "-Wextra", "-Wno-unused-local-typedefs"]
LOTE = 50


class OracleError(RuntimeError):
    pass


@dataclass
class Problema:
    id: str
    nivel: str
    seed: int
    agregados: list[Agregado]  # en orden de dependencia; el último es el que se pregunta

    @property
    def principal(self) -> Agregado:
        return self.agregados[-1]


@dataclass
class HechosCampo:
    offset: int
    type_size: int
    type_align: int
    member_align: int


@dataclass
class HechosAgregado:
    size: int
    align: int
    campos: dict[str, HechosCampo] = field(default_factory=dict)


@dataclass
class Hechos:
    agregados: dict[str, HechosAgregado] = field(default_factory=dict)
    cc_version: str = ""
    cc_target: str = ""


@dataclass
class Discrepancia:
    clase: str
    tag: str
    campo: str | None
    modelo: int
    gcc: int

    def __str__(self) -> str:
        donde = f"{self.tag}.{self.campo}" if self.campo else self.tag
        return f"{self.clase:<12} {donde:<28} modelo={self.modelo:<6} gcc={self.gcc}"


# ---------------------------------------------------------------------------
# Emisión
# ---------------------------------------------------------------------------


def _tipo_para_emitir(t: Tipo, ren: dict[str, str]) -> Tipo:
    """Reemplaza tags por sus nombres namespaced y punteros por `void *`."""
    if isinstance(t, Puntero):
        return Puntero("void", t.niveles)
    if isinstance(t, Arreglo):
        return Arreglo(_tipo_para_emitir(t.elem, ren), t.n)
    if isinstance(t, Ref):
        return Ref(ren.get(t.tag, t.tag))
    return t


def emitir_tu(problemas: list[Problema]) -> tuple[str, dict[str, tuple[str, str]]]:
    """Devuelve (fuente C, mapa tag_emitido -> (id_problema, tag_original))."""
    cab = [
        "#include <stdint.h>",
        "#include <stddef.h>",
        "#include <stdbool.h>",
        "#include <stdio.h>",
        "",
        '_Static_assert(sizeof(void *) == 8, "ABI: se esperaba x86-64 (puntero de 8 bytes)");',
        '_Static_assert(sizeof(uint64_t) == 8, "ABI rota");',
        "",
    ]
    cuerpo: list[str] = []
    sondas: list[str] = []
    mapa: dict[str, tuple[str, str]] = {}

    for i, p in enumerate(problemas):
        tags = [a.tag for a in p.agregados]
        if len(set(tags)) != len(tags):
            raise OracleError(
                f"{p.id}: tags repetidos dentro del problema ({tags}); "
                "el C emitido no compilaría"
            )
        ren = {a.tag: f"p{i:03d}_{a.tag}" for a in p.agregados}
        for a in p.agregados:
            emit_tag = ren[a.tag]
            mapa[emit_tag] = (p.id, a.tag)

            attr = " __attribute__((__packed__))" if a.packed else ""
            cuerpo.append(f"typedef {a.clase}{attr} {{")
            for camp in a.campos:
                te = _tipo_para_emitir(camp.tipo, ren)
                cuerpo.append(f"  {render_declarador(te, camp.nombre)};")
            cuerpo.append(f"}} {emit_tag};")

            # Un typedef por campo: convierte cada sonda en una sonda de tipo.
            for camp in a.campos:
                te = _tipo_para_emitir(camp.tipo, ren)
                ft = f"ft_{emit_tag}__{camp.nombre}"
                cuerpo.append(f"typedef {render_declarador(te, ft)};")
            cuerpo.append("")

            for camp in a.campos:
                ft = f"ft_{emit_tag}__{camp.nombre}"
                n = camp.nombre
                sondas.append(
                    f'  printf("#OFF\\t{emit_tag}\\t{n}\\t%zu\\n",'
                    f" (size_t)offsetof({emit_tag}, {n}));"
                )
                sondas.append(
                    f'  printf("#FSZ\\t{emit_tag}\\t{n}\\t%zu\\n", (size_t)sizeof({ft}));'
                )
                sondas.append(
                    f'  printf("#FAL\\t{emit_tag}\\t{n}\\t%zu\\n", (size_t)_Alignof({ft}));'
                )
                sondas.append(
                    f'  printf("#MAL\\t{emit_tag}\\t{n}\\t%zu\\n",'
                    f" (size_t)__alignof__((({emit_tag} *)0)->{n}));"
                )
            sondas.append(
                f'  printf("#SZ\\t{emit_tag}\\t-\\t%zu\\n", (size_t)sizeof({emit_tag}));'
            )
            sondas.append(
                f'  printf("#AL\\t{emit_tag}\\t-\\t%zu\\n", (size_t)_Alignof({emit_tag}));'
            )

    src = "\n".join(cab + cuerpo + ["int main(void) {"] + sondas + ["  return 0;", "}", ""])
    return src, mapa


# ---------------------------------------------------------------------------
# Ejecución
# ---------------------------------------------------------------------------

_PREFLIGHT: dict[str, str] | None = None


def preflight(cc: str = "gcc") -> dict[str, str]:
    global _PREFLIGHT
    if _PREFLIGHT is not None:
        return _PREFLIGHT
    if shutil.which(cc) is None:
        raise OracleError(f"no encuentro {cc!r} en el PATH")
    ver = subprocess.run([cc, "-dumpversion"], capture_output=True, text=True).stdout.strip()
    tgt = subprocess.run([cc, "-dumpmachine"], capture_output=True, text=True).stdout.strip()
    if not re.match(r"^x86_64-.*linux", tgt):
        raise OracleError(
            f"{cc} apunta a {tgt!r}; este drill asume x86-64 Linux. "
            "Usá --cc para elegir otro compilador."
        )
    _PREFLIGHT = {"version": ver, "target": tgt}
    return _PREFLIGHT


def parsear_salida(texto: str, mapa: dict[str, tuple[str, str]]) -> dict[str, HechosAgregado]:
    out: dict[str, HechosAgregado] = {}
    for linea in texto.splitlines():
        if not linea.startswith("#"):
            continue
        clase, tag, campo, valor = linea.split("\t")
        v = int(valor)
        ag = out.setdefault(tag, HechosAgregado(size=-1, align=-1))
        if clase == "#SZ":
            ag.size = v
        elif clase == "#AL":
            ag.align = v
        else:
            fc = ag.campos.setdefault(campo, HechosCampo(-1, -1, -1, -1))
            if clase == "#OFF":
                fc.offset = v
            elif clase == "#FSZ":
                fc.type_size = v
            elif clase == "#FAL":
                fc.type_align = v
            elif clase == "#MAL":
                fc.member_align = v
    return out


def consultar(problemas: list[Problema], cc: str = "gcc") -> Hechos:
    """Compila y ejecuta las sondas. Devuelve los hechos indexados por tag emitido."""
    info = preflight(cc)
    src, mapa = emitir_tu(problemas)

    with tempfile.TemporaryDirectory(prefix="alineacion-") as tmp:
        d = Path(tmp)
        c_path = d / "sonda.c"
        bin_path = d / "sonda"
        c_path.write_text(src, encoding="utf-8")

        comp = subprocess.run(
            [cc, *CC_FLAGS, "-o", str(bin_path), str(c_path)],
            capture_output=True,
            text=True,
        )
        if comp.returncode != 0:
            raise OracleError(
                "gcc no pudo compilar las sondas:\n"
                + comp.stderr
                + "\n--- fuente ---\n"
                + src
            )
        # Si gcc ignora `packed`, todo el nivel packed enseñaría una mentira.
        if re.search(r"ignor\w*\s+attribute|attribute\s+ignored", comp.stderr, re.I):
            raise OracleError(
                "gcc está ignorando un atributo (probablemente `packed`):\n" + comp.stderr
            )

        run = subprocess.run([str(bin_path)], capture_output=True, text=True, timeout=20)
        if run.returncode != 0:
            raise OracleError(f"la sonda falló al ejecutar:\n{run.stderr}")

    hechos = Hechos(cc_version=info["version"], cc_target=info["target"])
    hechos.agregados = parsear_salida(run.stdout, mapa)
    hechos._mapa = mapa  # type: ignore[attr-defined]
    return hechos


# ---------------------------------------------------------------------------
# Contraste
# ---------------------------------------------------------------------------


def verificar(
    problema: Problema, indice: int, hechos: Hechos
) -> tuple[dict[str, Derivacion], list[Discrepancia]]:
    """Compara el motor propio contra gcc para un problema. Compara TODO."""
    derivs = calcular_todos(problema.agregados)
    difs: list[Discrepancia] = []

    for a in problema.agregados:
        emit_tag = f"p{indice:03d}_{a.tag}"
        d = derivs[a.tag]
        h = hechos.agregados.get(emit_tag)
        if h is None:
            raise OracleError(f"gcc no reportó nada para {emit_tag}")

        if d.size != h.size:
            difs.append(Discrepancia("size", a.tag, None, d.size, h.size))
        if d.struct_align != h.align:
            difs.append(Discrepancia("align", a.tag, None, d.struct_align, h.align))

        for paso in d.pasos:
            hc = h.campos.get(paso.campo)
            if hc is None:
                raise OracleError(f"gcc no reportó el campo {a.tag}.{paso.campo}")
            if paso.offset != hc.offset:
                difs.append(Discrepancia("offset", a.tag, paso.campo, paso.offset, hc.offset))
            if paso.size != hc.type_size:
                difs.append(
                    Discrepancia("tam campo", a.tag, paso.campo, paso.size, hc.type_size)
                )
            # El align que mostramos es el del TIPO (la regla que enseña la
            # cátedra). El member_align de gcc es 1 en packed y se usa sólo
            # para narrar ese caso, así que no se contrasta acá.
            if not a.packed and paso.align != hc.type_align:
                difs.append(
                    Discrepancia("align campo", a.tag, paso.campo, paso.align, hc.type_align)
                )

    return derivs, difs


def reportar_discrepancias(problema: Problema, difs: list[Discrepancia], src: str = "") -> str:
    lineas = [
        "",
        "‼ BUG EN EL MOTOR DE DERIVACIÓN — no confíes en esta explicación",
        f"  problema: {problema.id}   nivel: {problema.nivel}   seed: {problema.seed}",
        "",
    ]
    lineas += [f"  {d}" for d in difs]
    if src:
        lineas += ["", "--- fuente de la sonda ---", src]
    info = _PREFLIGHT or {}
    lineas += ["", f"  gcc {info.get('version', '?')} ({info.get('target', '?')})", ""]
    return "\n".join(lineas)


def verificar_lote(problemas: list[Problema], cc: str = "gcc") -> list[tuple[Problema, dict[str, Derivacion], Hechos]]:
    """Verifica en lotes. Aborta al primer desacuerdo modelo/gcc."""
    resultado = []
    for inicio in range(0, len(problemas), LOTE):
        trozo = problemas[inicio : inicio + LOTE]
        hechos = consultar(trozo, cc)
        for i, p in enumerate(trozo):
            derivs, difs = verificar(p, i, hechos)
            if difs:
                src, _ = emitir_tu([p])
                raise OracleError(reportar_discrepancias(p, difs, src))
            resultado.append((p, derivs, hechos))
    return resultado
