# Parciales modelo — Parcial 1 (30 de septiembre)

Cuatro modelos de parcial, de dificultad creciente, construidos **a partir de las cinco guías de
`guias/`** y no de un libro de texto. Cada modelo tiene **4 ejercicios** y cubre los cinco temas,
combinándolos donde la propia cátedra los combina.

- [`modelo-a.md`](modelo-a.md) ★ — mecánico · [clave](modelo-a-clave.md)
- [`modelo-b.md`](modelo-b.md) ★★ — parcial pleno · [clave](modelo-b-clave.md)
- [`modelo-c.md`](modelo-c.md) ★★ — temario completo · [clave](modelo-c-clave.md)
- [`modelo-d.md`](modelo-d.md) ★★★ — margen · [clave](modelo-d-clave.md)

---

## 0. Los cinco temas, y una advertencia sobre el material

| | Tema | Guía en `guias/` | Versión |
|---|---|---|---|
| **T1** | Lenguajes | *Práctica 1: Lenguajes* | 28-ago-2024 |
| **T2** | Autómatas finitos | *Práctica 2: Autómatas finitos* | 27-ago-2025 |
| **T3** | Determinización y minimización | *Práctica 3: Determinización y Minimización* | 2°C 2025 |
| **T4** | Lema de bombeo (regulares) | *Práctica 3: Lema de pumping…* | 11-sep-2024 |
| **T5** | Autómatas de pila + bombeo LC | `lf-guia-05.pdf` = *Práctica 6* | 1°C 2025 |

**Dos cosas para verificar con la cátedra antes de confiar en esto:**

1. **La numeración no cierra.** Hay dos guías distintas numeradas «Práctica 3», y la de autómatas de
   pila se llama «Práctica 6» y es del *primer* cuatrimestre de 2025. Las versiones son de tres
   cuatrimestres distintos.
2. **Falta material entre T4 y T5.** No hay guía de **expresiones regulares** ni de **gramáticas
   libres de contexto** en la carpeta, y el salto «Práctica 3 → Práctica 6» sugiere que existen una
   Práctica 4 y una Práctica 5 que no están. Si el parcial las incluye, estos modelos las
   sub-representan.

   **Los modelos no dependen de expresiones regulares ni de gramáticas.** Donde entrarían
   naturalmente está señalado con *(hueco: ER/GLC)*. Si conseguís esas guías, el ejercicio 2 de cada
   modelo es el que hay que ampliar (ER ↔ autómata) y el 4 el que gana un ítem (GLC ↔ AP).

---

## 1. Conceptos y técnicas por tema

### T1 — Lenguajes

$\Sigma^n,\Sigma^*,\Sigma^+$; la tríada $\emptyset \neq \lambda \neq \Lambda$; $|\alpha|$, $\alpha^r$,
concatenación **con sus definiciones recursivas**; operaciones sobre lenguajes
($\cup,\cap,\cdot,{}^n,{}^*,{}^+$, complemento, reverso); $\mathrm{Ini}/\mathrm{Fin}/\mathrm{Sub}$;
definición por comprensión.

Técnicas: inducción sobre cadenas *eligiendo la variable correcta*; doble inclusión; contraejemplo
**exhibiendo la palabra** que separa los dos lados; control de casos borde ($L = \emptyset$,
$\lambda \in L$, $n = 0$).

Ya tenés el set de práctica de este tema en
[`../ejercicios-parciales/01-lenguajes/`](../ejercicios-parciales/01-lenguajes/), que además agrega
tres herramientas que la guía no da y que estos modelos usan: **lema de Levi** (B4),
**cociente $\alpha^{-1}L$** (D7) y **cardinalidad/diagonalización** (Bloque E).

### T2 — Autómatas finitos

AFD, AFND, AFND-$\lambda$; $\widehat\delta$; $L(M)$; la relación $\vdash$ y sus propiedades
(ej. 6, cinco ítems de inducción). Dos familias de ejercicios muy distintas:

- **Construcción desde una descripción**: contadores módulo $k$, ventanas de sufijo/subcadena,
  léxico real (identificadores, constantes enteras/reales/exponenciales — ej. 3).
- **Construcción desde otro autómata**: $L^c, L^*, L^r, \mathrm{Ini}, \mathrm{Fin}, \mathrm{Sub},
  \mathrm{M\acute ax}, \mathrm{M\acute in}, L\Sigma^*$ (ej. 4) y $\cup,\cap,\cdot,\setminus$ (ej. 5).

### T3 — Determinización y minimización

$\lambda$-clausura; construcción de subconjuntos; estados alcanzables; **autómata total** (el estado
trampa); equivalencia de estados; refinamiento de particiones; unicidad del AFD mínimo; palabras
distinguidoras.

### T4 — Lema de bombeo (regulares)

Enunciado **con el orden de los cuantificadores**; elección de $w$; análisis de *todas* las
descomposiciones; bombear hacia arriba **y hacia abajo**; argumentos por clausura (intersección con
un regular, complemento, reverso) como alternativa; y el ejercicio 2 de la guía, dedicado entero a
que **el recíproco es falso**.

### T5 — Autómatas de pila y bombeo LC

AP, aceptación, **determinismo**; patrones de construcción (contador, espejo con y sin marcador
central, «$\neq$» por adivinanza, proporciones tipo $|\alpha|_a = 2|\alpha|_b$); leer un $\delta$
dado y **describir $L$ por comprensión** (ej. 2); lema de bombeo para LC con el análisis por casos
según dónde cae $vwx$; clausura: LC $\cap$ regular es LC, LC **no** cerrados por $\cap$ ni
complemento, LC determinísticos **sí** por complemento.

---

## 2. Tipos de ejercicio que se repiten, y con qué peso

Contando ítems, no enunciados — que es lo que mide de verdad la insistencia de la cátedra:

| # | Tipo | Dónde | Ítems | Dificultad |
|---|---|---|---|---|
| 1 | **Clasificar: ¿regular? Si sí, autómata; si no, demostrarlo** | T4 ej. 1 | **24** | ★–★★★ |
| 2 | **V/F sobre álgebra de lenguajes: demostrar o contraejemplo** | T1 ej. 10, 11 | **21** | ★★ |
| 3 | **Construir un AP; ¿es determinístico?** | T5 ej. 1, 3, 4, 5 | **17** | ★★ |
| 4 | **Dado un AF para $L$, construir uno para $f(L)$** | T2 ej. 4, 5 | **13** | ★★ |
| 5 | **Construir un AF desde una descripción** | T2 ej. 1, 2, 3, 7, 8 | 13 | ★–★★ |
| 6 | **Demostración por inducción sobre cadenas / sobre $\vdash$** | T1 ej. 5, 11; T2 ej. 6 | 12 | ★★ |
| 7 | **Cálculo exacto** ($\Sigma^n$, $\alpha^r$, operaciones) | T1 ej. 1–4, 8, 9 | ~40 | ★ |
| 8 | **Determinizar + minimizar** | T3 ej. 1, 2, 3 | 5 | ★ |
| 9 | **Demostrar que $L$ no es LC** | T5 ej. 6–10 | 5 | ★★ |
| 10 | **Dado $\delta$ de un AP, definir $L$ por comprensión** | T5 ej. 2 | 1 | ★★ |
| 11 | **El recíproco del bombeo / la hipótesis que falta** | T4 ej. 2 | 1 | ★★★ |

Los tipos 7 y 8 son volumen de entrenamiento, no de examen: son rápidos de hacer y rápidos de
corregir, así que aparecen **como un ítem dentro de un ejercicio**, nunca como el ejercicio entero.
Los tipos 1, 2, 3 y 4 son el parcial.

El tipo 11 aparece una sola vez en toda la práctica y **tiene un enunciado entero para él solo**
(T4 ej. 2, con dos ítems). Eso no es relleno: es la cátedra señalando lo que le importa. Está en el
modelo C, ejercicio 3.

---

## 3. Patrones de cómo se evalúa

**(a) Toda construcción viene con una meta-pregunta.** El ej. 4 de T2 lo dice literal:
*«Indicar en cada caso si es necesario que el autómata de entrada sea determinístico, y de qué tipo
es el autómata resultante.»* El eco en T5 es *«¿Es un autómata determinístico?»* (ej. 1, 3, 4).
**Contestar la construcción sin contestar la meta-pregunta es medio ejercicio.** Los cuatro modelos
la incluyen siempre.

**(b) La unión es el amplificador de dificultad estándar.** Cuando la cátedra quiere subir un ítem
de ★ a ★★★, le pega otro lenguaje con $\cup$: T4 ej. 1.s, 1.t, 1.x son exactamente eso. El efecto es
que la palabra ingenua del bombeo cae en la parte regular y el argumento se rompe sin avisar.

**(c) «$\neq$» es el otro amplificador.** $n \neq m$, $\omega \neq \omega^r$,
$|\omega|_a \neq |\omega|_b$: T4 ej. 1.f, 1.r, 1.u y T5 ej. 1.c, 1.g, 1.j, 1.l. Fuerza o bien
no determinismo (en AP) o bien un argumento por clausura (en regulares). Nunca sale por ataque
frontal.

**(d) Hay un ítem «aritmético» por parcial.** Congruencia módulo 5 en binario (T2 1.e), grupos de
repetición de longitud alternada par/impar (T2 ej. 8), $n$ múltiplo de $m$ (T4 1.w),
$a^{2^n}$ (T4 1.p). Se reconocen porque el estado del autómata *es* un residuo.

**(e) Escalada dentro del mismo enunciado.** T4 ej. 1 va de `a`(trivial) a `x`(unión de dos
lenguajes con congruencia). Un parcial no repite el ítem `a`; repite el `q`, el `s`, el `x`.

**(f) Se puntúa la demostración, no la respuesta.** La rúbrica que ya usás en
`../ejercicios-parciales/01-lenguajes/enunciados.md` (una sola inclusión −50%, contraejemplo sin la
palabra separadora −50%, confundir $\lambda$ con $\emptyset$ −100%) está reproducida al pie de cada
modelo.

---

## 4. Qué temas se combinan naturalmente

| Combinación | Evidencia en las guías | Fuerza |
|---|---|---|
| **T2 + T3** | La cátedra ya los fusionó: T3 ej. 2 dice *«dar AFD mínimos para los ejercicios 1 y 2 de la práctica 2»*, y T3 ej. 3 pide el AFD **mínimo de $L_1 \cap L_2$*. | **Máxima.** Un ítem por parcial, seguro. |
| **T1 + T2** | T2 ej. 4 toma los operadores de T1 ($\mathrm{Ini}, \mathrm{Fin}, \mathrm{Sub}$) y pide autómatas. Es el puente explícito entre las dos guías. | **Máxima.** |
| **T4 + T1** | T4 ej. 1.f, 1.g, 1.r, 1.u sólo salen por clausura (complemento, $\cap$ con un regular), que es álgebra de T1. | Alta. |
| **T3 + T4** | Son *el mismo argumento*: finitas vs. infinitas clases de $\alpha^{-1}L$. Minimalidad = exhibir pares distinguibles; no-regularidad = exhibir infinitos. | Alta, y poco explotada — por eso está en B1 y C2. |
| **T4 + T5** | Clasificar un lenguaje obliga a las dos: *¿regular? ¿LC? ¿ninguno?* Es la única forma de cubrir T4 y T5 en un ítem. | Alta. |
| **T5 + T3** | *«¿Es determinístico el AP?»* es el eco de *«¿hace falta que el AF sea determinístico?»*. Y la clausura por complemento distingue LC de LC-determinísticos. | Media-alta. |
| ~~T1(cardinalidad) + cualquiera~~ | El bloque de diagonalización es el puente al **segundo** parcial, no una combinación de éste. | **Evitar.** |

### Plantilla que siguen los cuatro modelos

| | Ejercicio | Temas | Presupuesto |
|---|---|---|---|
| **1** | Álgebra de lenguajes / operación nueva | T1 (+T2, +T4) | 30–45 min |
| **2** | Construir → determinizar → minimizar + meta-pregunta | T2 + T3 | 40–45 min |
| **3** | Regularidad / no regularidad | T4 (+T1) | 40–45 min |
| **4** | AP, determinismo, no-LC | T5 (+T4) | 40–45 min |

Cuatro ejercicios, cinco temas: T3 nunca es un ejercicio propio (siempre viaja con T2), y T1 aparece
dos veces — una sola vez como tema puro.

---

## 5. Progresión hasta el 30 de septiembre

Hoy es **8 de septiembre**: 22 días. La regla del plan (`STUDY_STRUCTURE.md` §4) es que la última
semana es sólo parciales cronometrados. Estos cuatro modelos son esa semana, más dos anticipos.

| Modelo | Nivel | Hacelo cuando tengas hecha… | Ventana sugerida | Duración |
|---|---|---|---|---|
| **A** | ★ | guías **1 y 2** | 12–14 sep | 2 h 40 |
| **B** | ★★ | + guías **3 (det/min) y 4 (bombeo)** | 18–20 sep | 3 h |
| **C** | ★★ | + guía **5 (AP)** — temario completo | 23–24 sep | 3 h |
| **D** | ★★★ | todo, ya consolidado | 27–28 sep | 3 h |

**Cómo suben de dificultad, concretamente:**

- **A** usa los lenguajes de las guías con parámetros cambiados y pide una construcción por ítem.
  Los ejercicios de T3/T4/T5 están en su versión más mecánica para que puedas rendirlo con sólo dos
  guías hechas: **cada ítem lleva marcado qué guía necesita**, y si todavía no la hiciste, salteálo
  y anotá el tiempo que sobró.
- **B** introduce las dos combinaciones que la cátedra usa siempre (T2+T3 con minimalidad
  demostrada, T4 por clausura) y el primer «$\neq$».
- **C** cubre los cinco temas al nivel real del parcial e incluye el ítem ★★★ del recíproco del
  bombeo y el de LC no determinístico.
- **D** es el margen: clasificación completa en la jerarquía, dos operaciones nuevas sobre lenguajes
  ($\mathrm{Ciclo}$), primos, y no-clausura por complemento. Si D sale, el tema está sobrado.

**Protocolo por modelo** (mismo que el set de T1):

1. Cronómetro, de una sentada, sin apuntes, a página en blanco.
2. Autocorregir con la clave **con dureza**, aplicando la tabla de descuentos.
3. Cada error → una línea en [`../../errores.md`](../../errores.md): *qué salió mal → por qué
   (concepto / notación / lectura / tiempo) → la idea correcta en una oración.*
4. Antes del modelo siguiente, releer `errores.md` entero. Si un error aparece por tercera vez, ese
   es el tema del bloque profundo de esa semana, no el que tenías planeado.

**La hoja permitida.** El parcial se rinde con 1 hoja A4 doble faz manuscrita: está armada en
[`../hoja-resumen.md`](../hoja-resumen.md), escrita en orden de transcripción y con marcadores `○`
para lo que se recorta si no entra. **Transcribila después del modelo B**, con `errores.md` al lado
— lo que aparezca dos veces en el error log manda sobre el orden que trae. El dry run que la valida
es rendir el modelo C con la hoja y nada más.

**Criterio 🟢 para ir al parcial:** modelo **C** aprobado (≥60) **dentro del tiempo**, y poder
explicar, sin mirar, por qué falla el contraejemplo típico de cada uno de sus cuatro ejercicios.
Los ★★★ de D no hacen falta para Green.
