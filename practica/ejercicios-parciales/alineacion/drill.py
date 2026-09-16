#!/usr/bin/env python3
"""Drill de alineación de structs.

    python3 drill.py                       # 10 problemas mezclados
    python3 drill.py --nivel 3 --n 15
    python3 drill.py --examen 10           # sin feedback hasta el final
    python3 drill.py --repaso              # insiste donde más fallás
    python3 drill.py --generar-banco 100   # regenera banco.json (necesita gcc)
    python3 drill.py --verificar-banco     # revalida el banco contra gcc
    python3 drill.py --stats

Se contesta campo por campo. Cada respuesta se corrige contra gcc, y cuando
errás se muestra la derivación paso a paso. El objetivo es que el procedimiento
se vuelva automático, no que sepas la respuesta de memoria.
"""

from __future__ import annotations

import argparse
import json
import random
import sys
import time
from collections import Counter
from pathlib import Path

from render import AMARILLO, CIAN, GRIS, RESET, ROJO, VERDE, c

AQUI = Path(__file__).resolve().parent
BANCO = AQUI / "banco.json"
ESTADO = AQUI / "estado"
RESPUESTAS = ESTADO / "respuestas.jsonl"
ERRORES = AQUI / "errores.md"


# ---------------------------------------------------------------------------
# Banco
# ---------------------------------------------------------------------------


def cargar_banco() -> dict:
    if not BANCO.exists():
        sys.exit(
            f"no existe {BANCO.name}. Generalo con:\n"
            f"    python3 drill.py --generar-banco 100"
        )
    b = json.loads(BANCO.read_text(encoding="utf-8"))
    malos = [p["id"] for p in b["problemas"] if not p.get("verificado")]
    if malos:
        sys.exit(f"el banco tiene problemas sin verificar: {malos[:5]}")
    return b


# ---------------------------------------------------------------------------
# Diagnóstico de errores
# ---------------------------------------------------------------------------


def diagnosticar(prob: dict, preg: dict, dado: int) -> str | None:
    """¿Qué tendría que haber pensado el alumno para dar ESE número?"""
    campos = prob["campos"]
    d = prob["derivacion"]
    sinp = prob.get("sin_packed")

    if preg["kind"] == "offset":
        i = next(k for k, x in enumerate(campos) if x["nombre"] == preg["campo"])
        campo = campos[i]
        if dado == campo["cursor_antes"] and campo["padding"]:
            return "err:olvidó-padding-interno"
        if dado == preg["naive"]:
            return "err:no-alineó"
        if sinp and i < len(sinp["offsets"]) and dado == sinp["offsets"][i]:
            return "err:ignoró-packed"
        if "ELEMENTO" in campo["align_razon"]:
            return "err:align-del-arreglo"
        return None

    if preg["kind"] == "size":
        if dado == d["fin_crudo"] and d["tail_padding"]:
            return "err:olvidó-tail-padding"
        if sinp and dado == sinp["size"]:
            return "err:ignoró-packed"
        if dado == preg["naive"]:
            return "err:no-alineó"
        return None

    if preg["kind"] == "align":
        if dado == prob["size"]:
            return "err:confundió-size-con-align"
        mayor = max(x["size"] for x in campos)
        if dado == mayor:
            return "err:align-del-tipo-más-grande"
        return None
    return None


EXPLICACION = {
    "err:olvidó-padding-interno": "el campo anterior termina ahí, pero este necesita alinearse",
    "err:no-alineó": "sumaste los tamaños sin insertar padding",
    "err:olvidó-tail-padding": "falta redondear el tamaño al align del struct",
    "err:ignoró-packed": "ésa es la disposición SIN packed",
    "err:align-del-arreglo": "un arreglo alinea como su ELEMENTO, no como su largo",
    "err:confundió-size-con-align": "size y requisito de alineación son cosas distintas",
    "err:align-del-tipo-más-grande": "es el mayor de los ALIGN, no el del tipo más grande",
}


# ---------------------------------------------------------------------------
# Entrada
# ---------------------------------------------------------------------------


class Abandonar(Exception):
    pass


def pedir_numero(prompt: str, pista: str) -> int | None:
    while True:
        try:
            crudo = input(prompt).strip()
        except (EOFError, KeyboardInterrupt):
            raise Abandonar
        if crudo in ("q", "salir"):
            raise Abandonar
        if crudo == "":
            return None
        if crudo == "?":
            print(f"      {c('pista:', AMARILLO)} {pista}")
            continue
        try:
            return int(crudo, 0)
        except ValueError:
            print(f"      {c('numerito, por favor (o Enter para saltear, q para salir)', GRIS)}")


# ---------------------------------------------------------------------------
# Una ronda
# ---------------------------------------------------------------------------


def mostrar_enunciado(prob: dict) -> None:
    print()
    print(c("─" * 72, GRIS))
    print(c(f"  {prob['id']}   nivel {prob['nivel']}", GRIS))
    print()
    for linea in prob["c_source"].splitlines():
        print("    " + linea)
    print()


def jugar_problema(prob: dict, examen: bool, cronometro: bool) -> list[dict]:
    mostrar_enunciado(prob)
    campos = {x["nombre"]: x for x in prob["campos"]}
    registros: list[dict] = []
    ancho = max(len(p["q"]) for p in prob["preguntas"])

    for preg in prob["preguntas"]:
        if preg["kind"] == "offset":
            campo = campos[preg["campo"]]
            pista = f"{campo['ctype']} → align {campo['align']}"
        elif preg["kind"] == "size":
            pista = f"el align del struct es {prob['align']}"
        else:
            pista = "el mayor de los align de los campos"

        t0 = time.monotonic()
        dado = pedir_numero(f"    {preg['q']:<{ancho}} = ", pista)
        dt = time.monotonic() - t0

        ok = dado == preg["respuesta"]
        diag = None if ok or dado is None else diagnosticar(prob, preg, dado)
        registros.append({
            "problema": prob["id"], "nivel": prob["nivel"], "rasgos": prob["rasgos"],
            "pregunta": preg["q"], "kind": preg["kind"], "dado": dado,
            "esperado": preg["respuesta"], "ok": ok, "seg": round(dt, 1), "diag": diag,
        })

        if not examen:
            if dado is None:
                print(f"      {c('(salteada)', GRIS)}  era {preg['respuesta']}")
            elif ok:
                extra = f"  {c(f'{dt:.0f}s', GRIS)}" if cronometro and dt > 12 else ""
                print(f"      {c('ok', VERDE)}{extra}")
            else:
                msg = f"      {c('✗', ROJO)} era {preg['respuesta']}"
                if diag:
                    msg += f"   {c(EXPLICACION[diag], AMARILLO)}"
                print(msg)

    return registros


def mostrar_derivacion(prob: dict) -> None:
    print()
    for linea in prob["derivacion"]["texto"].splitlines():
        print("  " + linea)
    print()
    for linea in prob["derivacion"]["mapa"].splitlines():
        print("  " + linea)
    if prob.get("sin_packed"):
        print()
        print("  " + c(f"sin packed sería: size={prob['sin_packed']['size']}, "
                       f"offsets={prob['sin_packed']['offsets']}", GRIS))
    print()


# ---------------------------------------------------------------------------
# Persistencia
# ---------------------------------------------------------------------------


def guardar(registros: list[dict]) -> None:
    ESTADO.mkdir(exist_ok=True)
    with RESPUESTAS.open("a", encoding="utf-8") as f:
        for r in registros:
            f.write(json.dumps({**r, "ts": time.time()}, ensure_ascii=False) + "\n")


def anotar_errores(registros: list[dict]) -> None:
    """Bitácora, con el formato del protocolo de parciales-modelo."""
    malos = [r for r in registros if not r["ok"] and r["dado"] is not None]
    if not malos:
        return
    nuevo = not ERRORES.exists()
    with ERRORES.open("a", encoding="utf-8") as f:
        if nuevo:
            f.write("# Bitácora de errores — alineación\n\n"
                    "Una línea por error: qué salió mal → por qué → la idea correcta.\n\n")
        f.write(f"\n## {time.strftime('%Y-%m-%d %H:%M')}\n\n")
        for r in malos:
            razon = EXPLICACION.get(r["diag"] or "", "revisar la derivación")
            f.write(f"- `{r['problema']}` {r['pregunta']}: puse {r['dado']}, era "
                    f"{r['esperado']} → {razon}\n")


def leer_respuestas() -> list[dict]:
    if not RESPUESTAS.exists():
        return []
    out = []
    for linea in RESPUESTAS.read_text(encoding="utf-8").splitlines():
        if linea.strip():
            out.append(json.loads(linea))
    return out


# ---------------------------------------------------------------------------
# Informes
# ---------------------------------------------------------------------------


def informe(registros: list[dict], titulo: str = "resultado") -> None:
    total = len(registros)
    bien = sum(1 for r in registros if r["ok"])
    print()
    print(c("═" * 72, GRIS))
    pct = 100 * bien / total if total else 0
    col = VERDE if pct >= 90 else (AMARILLO if pct >= 70 else ROJO)
    print(f"  {titulo}: {c(f'{bien}/{total}', col)}  ({pct:.0f}%)")

    diags = Counter(r["diag"] for r in registros if r["diag"])
    if diags:
        print()
        print("  diagnósticos:")
        for d, n in diags.most_common():
            print(f"    {n:>3}  {d:<32} {c(EXPLICACION[d], GRIS)}")

    tiempos = [r["seg"] for r in registros if r["seg"] is not None]
    if tiempos:
        tiempos.sort()
        print(f"\n  mediana por campo: {tiempos[len(tiempos)//2]:.1f}s")


def stats_globales() -> None:
    rs = leer_respuestas()
    if not rs:
        sys.exit("todavía no hay respuestas registradas")
    print(f"\n  {len(rs)} respuestas registradas\n")

    por_rasgo: dict[str, list[int]] = {}
    for r in rs:
        for rasgo in r.get("rasgos", []):
            por_rasgo.setdefault(rasgo, []).append(1 if r["ok"] else 0)

    print("  por rasgo (peor primero)")
    filas = [(k, sum(v), len(v)) for k, v in por_rasgo.items() if len(v) >= 3]
    filas.sort(key=lambda x: x[1] / x[2])
    for k, bien, tot in filas:
        pct = 100 * bien / tot
        col = VERDE if pct >= 90 else (AMARILLO if pct >= 70 else ROJO)
        print(f"    {k:<34} {c(f'{bien:>3}/{tot:<3}', col)} {pct:>3.0f}%")

    diags = Counter(r["diag"] for r in rs if r.get("diag"))
    if diags:
        print("\n  diagnóstico más frecuente:")
        for d, n in diags.most_common(3):
            print(f"    {n:>3}  {d}")

    if filas:
        peor = filas[0][0]
        print(f"\n  → python3 drill.py --repaso   {c(f'(insiste en {peor})', GRIS)}")
    print()


# ---------------------------------------------------------------------------
# Selección
# ---------------------------------------------------------------------------


def elegir(banco: dict, nivel: str | None, n: int, repaso: bool) -> list[dict]:
    probs = banco["problemas"]
    if nivel:
        probs = [p for p in probs if p["nivel"] == nivel]
        if not probs:
            sys.exit(f"no hay problemas de nivel {nivel}")

    if repaso:
        rs = leer_respuestas()
        if not rs:
            sys.exit("no hay historial todavía; jugá una ronda normal primero")
        falla: dict[str, list[int]] = {}
        for r in rs:
            for rasgo in r.get("rasgos", []):
                falla.setdefault(rasgo, []).append(0 if r["ok"] else 1)
        ranking = sorted(
            ((k, sum(v) / len(v)) for k, v in falla.items() if len(v) >= 3),
            key=lambda x: -x[1],
        )
        if not ranking:
            sys.exit("todavía no hay suficientes datos para un repaso dirigido")
        objetivo = {k for k, _ in ranking[:3]}
        print(c(f"  repaso dirigido: {', '.join(sorted(objetivo))}\n", CIAN))
        probs = [p for p in probs if objetivo & set(p["rasgos"])] or probs

    random.shuffle(probs)
    return probs[:n]


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--nivel", choices=["1", "2", "3", "4", "5"])
    ap.add_argument("--n", type=int, default=10)
    ap.add_argument("--examen", type=int, metavar="N",
                    help="modo examen: N problemas, sin feedback hasta el final")
    ap.add_argument("--cronometro", action="store_true")
    ap.add_argument("--repaso", action="store_true")
    ap.add_argument("--stats", action="store_true")
    ap.add_argument("--generar-banco", type=int, metavar="N")
    ap.add_argument("--verificar-banco", action="store_true")
    ap.add_argument("--banco-web", type=int, metavar="N", default=None,
                    help="exporta N problemas por nivel a banco-web.json (para el artifact)")
    ap.add_argument("--seed", type=int, default=20260915)
    ap.add_argument("--cc", default="gcc")
    args = ap.parse_args()

    if args.stats:
        stats_globales()
        return

    if args.generar_banco:
        import generador

        print(f"generando {args.generar_banco} problemas por nivel (gcc verifica cada uno)...")
        banco = generador.construir_banco(args.generar_banco, args.seed, args.cc)
        BANCO.write_text(json.dumps(banco, ensure_ascii=False, indent=1), encoding="utf-8")
        n = len(banco["problemas"])
        kb = BANCO.stat().st_size / 1024
        print(f"\n{c('ok', VERDE)}: {n} problemas en {BANCO.name} ({kb:.0f} KB)")
        return

    if args.verificar_banco:
        verificar_banco(args.cc)
        return

    if args.banco_web is not None:
        exportar_web(args.banco_web)
        return

    banco = cargar_banco()
    examen = args.examen is not None
    n = args.examen if examen else args.n
    elegidos = elegir(banco, args.nivel, n, args.repaso)

    if examen:
        print(c("\n  modo examen: sin correcciones hasta el final.\n", AMARILLO))

    todos: list[dict] = []
    try:
        for prob in elegidos:
            regs = jugar_problema(prob, examen, args.cronometro)
            todos += regs
            if not examen and any(not r["ok"] for r in regs):
                mostrar_derivacion(prob)
    except Abandonar:
        print(c("\n  cortado.\n", GRIS))

    if not todos:
        return

    if examen:
        for prob in elegidos:
            regs = [r for r in todos if r["problema"] == prob["id"]]
            if regs and any(not r["ok"] for r in regs):
                mostrar_enunciado(prob)
                for r in regs:
                    if not r["ok"]:
                        marca = c("✗", ROJO)
                        print(f"    {marca} {r['pregunta']}: pusiste {r['dado']},"
                              f" era {r['esperado']}")
                mostrar_derivacion(prob)

    informe(todos, "examen" if examen else "ronda")
    guardar(todos)
    anotar_errores(todos)


def exportar_web(por_nivel: int) -> None:
    """Subconjunto liviano para el artifact: sin el modelo serializado ni los
    textos ya renderizados, que la página arma sola."""
    import collections

    banco = cargar_banco()
    campos_ok = ("nombre", "ctype", "offset", "size", "align", "padding",
                 "cursor_antes", "align_razon")
    preg_ok = ("q", "kind", "campo", "respuesta", "naive")

    def podar(p: dict) -> dict:
        return {
            "id": p["id"], "nivel": p["nivel"], "rasgos": p["rasgos"],
            "src": p["c_source"], "tag": p["tag"], "packed": p["packed"],
            "size": p["size"], "align": p["align"],
            "campos": [{k: x[k] for k in campos_ok} for x in p["campos"]],
            "preguntas": [{k: q[k] for k in preg_ok} for q in p["preguntas"]],
            "cierre": {"razon": p["derivacion"]["struct_align_razon"],
                       "fin_crudo": p["derivacion"]["fin_crudo"],
                       "tail": p["derivacion"]["tail_padding"]},
            "sin_packed": p.get("sin_packed"),
        }

    por: dict[str, list] = collections.defaultdict(list)
    for p in banco["problemas"]:
        por[p["nivel"]].append(p)

    sub = []
    for _, ps in sorted(por.items()):
        # Los que traen más rasgos primero: así ninguno queda sin cubrir.
        ps = sorted(ps, key=lambda p: -len(p["rasgos"]))
        sub += [podar(p) for p in ps[:por_nivel]]

    salida = AQUI / "banco-web.json"
    js = json.dumps({"schema": "orga2-alineacion-web/1", "problemas": sub},
                    ensure_ascii=False, separators=(",", ":"))
    salida.write_text(js, encoding="utf-8")

    rasgos = collections.Counter(x for p in sub for x in p["rasgos"])
    print(f"{c('ok', VERDE)}: {len(sub)} problemas, {len(js.encode())/1024:.0f} KB"
          f", {len(rasgos)} rasgos cubiertos → {salida.name}")
    print(c("  para el artifact:  { printf 'window.BANCO='; cat banco-web.json; "
            "printf ';'; } > banco.js", GRIS))


def verificar_banco(cc: str) -> None:
    """Revalida el banco entero contra gcc en ESTA máquina.

    Reconstruye los agregados desde el modelo serializado, se los pasa al
    oráculo y compara las respuestas guardadas contra lo que dice gcc ahora.
    """
    from layout import deserializar_agregado
    from oracle import OracleError, Problema, preflight, verificar_lote

    banco = cargar_banco()
    info = banco.get("oracle", {})
    ahora = preflight(cc)
    print(f"  banco generado con gcc {info.get('version', '?')} ({info.get('target', '?')})")
    print(f"  compilador actual:     gcc {ahora['version']} ({ahora['target']})")

    problemas = []
    for p in banco["problemas"]:
        if "modelo" not in p:
            sys.exit(c("  el banco es viejo (sin `modelo`); regeneralo.", ROJO))
        problemas.append(Problema(
            id=p["id"], nivel=p["nivel"], seed=p["seed"],
            agregados=[deserializar_agregado(a) for a in p["modelo"]],
        ))

    print(f"\n  revalidando {len(problemas)} problemas contra gcc...")
    try:
        resultado = verificar_lote(problemas, cc)
    except OracleError as e:
        print(c("\n  el motor y gcc NO coinciden:\n", ROJO))
        print("\n".join(str(e).splitlines()[:20]))
        sys.exit(1)

    # Además del contraste motor/gcc, revisar que las respuestas guardadas en
    # el banco sigan siendo las mismas.
    difs = 0
    for (p, derivs, _), guardado in zip(resultado, banco["problemas"]):
        d = derivs[p.principal.tag]
        actual = {x["q"]: x["respuesta"] for x in guardado["preguntas"]}
        for campo, paso in zip(p.principal.campos, d.pasos):
            if actual.get(campo.equ) != paso.offset:
                print(c(f"  {p.id}: {campo.equ} guardado={actual.get(campo.equ)}"
                        f" ahora={paso.offset}", ROJO))
                difs += 1
        if actual.get(p.principal.equ_size) != d.size:
            print(c(f"  {p.id}: {p.principal.equ_size} cambió", ROJO))
            difs += 1

    if difs:
        print(c(f"\n  {difs} respuestas cambiaron. Regenerá el banco.", ROJO))
        sys.exit(1)
    print(c(f"  ok: los {len(problemas)} problemas siguen dando lo mismo.", VERDE))


if __name__ == "__main__":
    main()
