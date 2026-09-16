# Alineación de structs — drill

Calcular offsets y tamaños de structs **sin pensar**, para llegar al parcial con
el procedimiento automatizado. En el parcial el esqueleto `.asm` viene con todos
los offsets en `EQU 0` y hay que completarlos; uno mal rompe todo en silencio.

```bash
python3 drill.py                      # 10 problemas mezclados
python3 drill.py --nivel 3 --n 15     # sólo structs anidados
python3 drill.py --examen 10          # sin feedback hasta el final
python3 drill.py --repaso             # insiste donde más fallás
python3 drill.py --stats              # informe por rasgo
```

Sólo stdlib. El banco ya viene generado, así que `drill.py` arranca al instante
y **no necesita gcc** para jugar.

---

## El contrato de datos, con las dos correcciones que importan

La guía de la cátedra (`guia-ASM/src/3 - Alineación y Estructuras`) enuncia tres
reglas. La segunda está escrita de una forma que funciona para escalares y falla
para todo lo demás. Estas son las reglas como hay que aplicarlas:

1. **Cada atributo va en el primer offset ≥ el cursor que sea múltiplo de su
   alineación.** Lo que sobra es padding.
2. **La alineación del struct es el máximo de las *alineaciones* de sus
   atributos** — no el tamaño del atributo más grande. La guía dice *"se alineará
   al tamaño del tipo más grande"*, y eso se rompe en cuanto hay un `char[21]`:
   es el atributo más grande (21 bytes) pero alinea a 1.
3. **El tamaño se redondea hacia arriba al múltiplo de la alineación del
   struct.** Ese es el *tail padding*, y es lo que más se olvida.

Y los cuatro casos que no son obvios:

| Caso | Regla |
|---|---|
| `T campo[n]` | align = **el del elemento**; size = `n × sizeof(T)`, sin redondear |
| `interno_t campo` | align y size **del struct interno**, incluido su tail padding |
| `__attribute__((packed))` | todas las alineaciones pasan a 1. **No se propaga** ni hacia afuera ni hacia adentro |
| `union` | todos los miembros en 0; size = el mayor, redondeado al mayor align |

Los dos casos de packed, que son los más finos:

```c
typedef struct { uint8_t a; uint32_t b; } inner_t;          // size 8, align 4

typedef struct __attribute__((packed)) {
    uint8_t  x;      // 0
    inner_t  i;      // 1   ← el interno conserva SU hueco: sigue midiendo 8
    uint8_t  y;      // 9
} po_t;              // size 10, NO 7

typedef struct __attribute__((packed)) { uint8_t x; uint64_t y; } pk_t;  // size 9

typedef struct {
    uint8_t  z;      // 0
    pk_t     p;      // 1   ← packed no se propaga: el padre sí alinea
    uint32_t w;      // 12
} hostpk_t;          // size 16
```

---

## Por qué se puede confiar en las respuestas

Dos cálculos independientes que tienen que coincidir:

- `layout.py` calcula la disposición **por su cuenta**, en Python, y produce la
  derivación paso a paso. Nunca ve lo que dice gcc.
- `oracle.py` emite un `.c` real con `offsetof` / `sizeof` / `_Alignof`, lo
  compila con `gcc -std=gnu11 -m64` y lo ejecuta.

Si discrepan, el problema **se descarta y se reporta a los gritos**. No hay
fallback silencioso: un drill que enseña una regla falsa es peor que no tener
drill. Cada problema del banco pasó ese contraste.

```bash
python3 test_layout.py          # casos fijos + contraste contra gcc
python3 drill.py --verificar-banco   # revalida el banco entero en esta máquina
python3 drill.py --generar-banco 100 # regenera (necesita gcc)
```

---

## Niveles

| Nivel | Qué agrega |
|---|---|
| 1 | escalares y punteros mezclados |
| 2 | `char[n]` y arreglos de escalares — la trampa del align del elemento |
| 3 | structs anidados y arreglos de structs |
| 4 | `packed`, en las dos direcciones de anidamiento |
| 5 | uniones |

Los problemas se filtran por "interesante": sirven sólo si resolverlos **exige**
aplicar las reglas, es decir si la respuesta ingenua (sumar tamaños) falla en al
menos dos cantidades. En los packed el contraste es contra la versión sin packed,
porque ahí la suma ingenua acierta siempre — que es justamente lo que hay que
notar.

---

## Protocolo

Mismo que el de `parciales-modelo`:

1. Una ronda de una sentada, sin mirar la tabla de reglas.
2. Autocorregir con dureza. Saltear una pregunta cuenta como error.
3. Cada error deja una línea en `errores.md` (el drill la escribe solo).
4. Antes de la ronda siguiente, releer `errores.md` entero.
5. Cuando `--stats` muestre un rasgo por debajo del 90%, `--repaso`.

Estás listo cuando hacés 10 problemas de nivel 4 sin errores y sin dudar.

---

## Esto no es hipotético: tres comentarios mal en este repo

Verificados contra gcc:

| Archivo | Dice | Es |
|---|---|---|
| `parciales/primer-parcial/2c2024-p1/ej1/ej1.h` | `ITEM_FUERZA_OFFSET = 4`, `ITEM_T_SIZE = 16` | **20**, **28** |
| `parciales/primer-parcial/2c2024-p1/ej1/ej1.asm` | los mismos valores, ya como `EQU` | idem (definidos pero sin usar) |
| `guia-ASM/src/3 - Alineación y Estructuras/structs.h` | `NODO_SIZE = 28 BYTES` | **32** |

En `item_t`, el `char nombre[18]` empuja el `uint32_t` a 20, y 26 se redondea a
28. En `nodo_t`, el align es 8 por los punteros y 28 no es múltiplo de 8 — el
propio archivo anota `longitud ... (+ 4 PADDING)`, que contradice su total.
