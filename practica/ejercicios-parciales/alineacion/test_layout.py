"""Casos fijos con respuesta conocida, y contraste masivo contra gcc.

    python3 test_layout.py

Los valores esperados salen de los headers reales del repo y de sondas
compiladas a mano. Si alguno de estos falla, el motor de `layout.py` está mal.
"""

from __future__ import annotations

import unittest

from layout import (
    Agregado,
    Arreglo,
    Campo,
    Escalar,
    Puntero,
    Ref,
    calcular_todos,
)
from oracle import Problema, verificar_lote

U8, U16, U32, U64 = (Escalar(x) for x in ("uint8_t", "uint16_t", "uint32_t", "uint64_t"))
CHAR = Escalar("char")


def ag(tag, *campos, packed=False, clase="struct"):
    return Agregado(
        tag=tag,
        clase=clase,
        packed=packed,
        campos=[Campo(n, t) for n, t in campos],
    )


# (nombre, [agregados en orden de dependencia], {tag: (offsets..., size, align)})
CASOS = [
    (
        "item_t (2c2024-p1 — el header dice 0/4/8 size 16, y está mal)",
        [ag("item_t", ("nombre", Arreglo(CHAR, 18)), ("fuerza", U32), ("durabilidad", U16))],
        {"item_t": ([0, 20, 24], 28, 4)},
    ),
    (
        "tuit_t (2c2025-p1)",
        [ag("tuit_t", ("mensaje", Arreglo(CHAR, 140)), ("favoritos", U16),
            ("retuits", U16), ("id_autor", U32))],
        {"tuit_t": ([0, 140, 142, 144], 148, 4)},
    ),
    (
        "usuario_t (2c2025-p1) — dos huecos de 4",
        [ag("usuario_t",
            ("feed", Puntero("feed_t")), ("seguidores", Puntero("usuario_t", 2)),
            ("cantSeguidores", U32), ("seguidos", Puntero("usuario_t", 2)),
            ("cantSeguidos", U32), ("bloqueados", Puntero("usuario_t", 2)),
            ("cantBloqueados", U32), ("id", U32))],
        {"usuario_t": ([0, 8, 16, 24, 32, 40, 48, 52], 56, 8)},
    ),
    (
        "producto_t (2c2025-p1-b) — char[9] y char[25]",
        [ag("producto_t",
            ("usuario", Puntero("usuario_t")), ("categoria", Arreglo(CHAR, 9)),
            ("nombre", Arreglo(CHAR, 25)), ("estado", U16),
            ("precio", U32), ("id", U32))],
        {"producto_t": ([0, 8, 17, 42, 44, 48], 56, 8)},
    ),
    (
        "nodo_t (guia-ASM) — el header dice SIZE 28, y son 32",
        [ag("nodo_t",
            ("next", Puntero("struct nodo_s")), ("categoria", U8),
            ("arreglo", Puntero("uint32_t")), ("longitud", U32))],
        {"nodo_t": ([0, 8, 16, 24], 32, 8)},
    ),
    (
        "packed_nodo_t (guia-ASM) — estos comentarios sí están bien",
        [ag("packed_nodo_t",
            ("next", Puntero("struct packed_nodo_s")), ("categoria", U8),
            ("arreglo", Puntero("uint32_t")), ("longitud", U32), packed=True)],
        {"packed_nodo_t": ([0, 8, 9, 17], 21, 1)},
    ),
    (
        "packed adentro de NO packed — packed no se propaga hacia afuera",
        [ag("pk_t", ("x", U8), ("y", U64), packed=True),
         ag("hostpk_t", ("z", U8), ("p", Ref("pk_t")), ("w", U32))],
        {"pk_t": ([0, 1], 9, 1), "hostpk_t": ([0, 1, 12], 16, 4)},
    ),
    (
        "NO packed adentro de packed — el interno conserva SU hueco",
        [ag("inner_t", ("a", U8), ("b", U32)),
         ag("po_t", ("x", U8), ("i", Ref("inner_t")), ("y", U8), packed=True)],
        {"inner_t": ([0, 4], 8, 4), "po_t": ([0, 1, 9], 10, 1)},
    ),
    (
        "arreglo de structs packed — stride 9, sin relleno",
        [ag("pk_t", ("x", U8), ("y", U64), packed=True),
         ag("tres_t", ("v", Arreglo(Ref("pk_t"), 3)), ("tag", U8))],
        {"tres_t": ([0, 27], 28, 1)},
    ),
    (
        "union — size 16, no 12",
        [Agregado("u_t", "union", False,
                  [Campo("a", U8), Campo("b", Arreglo(U32, 3)), Campo("c", U64)])],
        {"u_t": ([0, 0, 0], 16, 8)},
    ),
    (
        "union adentro de struct — el align de la union manda",
        [Agregado("u_t", "union", False,
                  [Campo("a", U8), Campo("b", U64)]),
         ag("conu_t", ("flag", U8), ("u", Ref("u_t")), ("n", U16))],
        {"conu_t": ([0, 8, 16], 24, 8)},
    ),
]


class TestCasosConocidos(unittest.TestCase):
    def test_modelo(self):
        for nombre, agregados, esperado in CASOS:
            with self.subTest(nombre):
                derivs = calcular_todos(agregados)
                for tag, (offs, size, align) in esperado.items():
                    d = derivs[tag]
                    self.assertEqual([p.offset for p in d.pasos], offs, f"{tag}: offsets")
                    self.assertEqual(d.size, size, f"{tag}: size")
                    self.assertEqual(d.struct_align, align, f"{tag}: align")

    def test_contra_gcc(self):
        problemas = [
            Problema(id=f"fijo-{i:02d}", nivel="fijo", seed=0, agregados=agregados)
            for i, (_, agregados, _) in enumerate(CASOS)
        ]
        # verificar_lote levanta OracleError ante cualquier desacuerdo.
        resultado = verificar_lote(problemas)
        self.assertEqual(len(resultado), len(CASOS))


if __name__ == "__main__":
    unittest.main(verbosity=2)
