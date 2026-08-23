# 01 — Lenguajes: ejercicios nivel parcial

Set de práctica **posterior** a la *Práctica 1: Lenguajes*. La guía entrena el cálculo; esto entrena
lo que se evalúa: demostrar, refutar con contraejemplo, y no morir en los casos borde.

- [`enunciados.md`](enunciados.md) — 38 ejercicios en 5 bloques + un simulacro cronometrado de 4 ítems.
- [`soluciones.md`](soluciones.md) — soluciones completas, con la trampa que cada ejercicio caza.

## Protocolo

1. **Bloques A–E, a página en blanco, sin apuntes.** Los minutos indicados son presupuesto de examen: si un ★★ te lleva el triple, ese es el dato, no el fracaso.
2. Recién después, **Bloque F: 60 minutos cronometrados, de una sentada, sin interrupciones.** Autocorregir con la rúbrica del final de `enunciados.md`, con dureza.
3. Cada error → una línea en [`../../../errores.md`](../../../errores.md): *qué salió mal → por qué (concepto / notación / lectura / tiempo) → la idea correcta en una oración.*
4. Los ★★★ son el "spare room": no son el piso del parcial, son el margen. Si salen, el tema está sobrado.

**Criterio 🟢 para este tema** (según §8 del plan): resolver cualquier ítem ★★ de los bloques C y D
en su tiempo, de memoria, **y** poder decir por qué falla el contraejemplo típico de cada uno.
Los ★★★ no hacen falta para Green.

## Cobertura respecto de la guía

| Tema de la guía | Ejercicios de la guía | Acá |
|---|---|---|
| $\Sigma^n$, $\Sigma^*$, $\Sigma^+$, $\lambda$ vs $\emptyset$ | 1, 2 | A1, A3 |
| Operaciones sobre cadenas, $\alpha^r$, longitud | 3, 4, 5 | A2, B1, B2, B3, B6 |
| Lenguajes por extensión / comprensión | 6, 7 | A4, B7 |
| Operaciones sobre lenguajes ($\cup,\cap,\cdot,{}^n,{}^*,{}^+$) | 8 | A2, A3, C1–C13 |
| Complemento | 9 | A3, C8, C11 |
| Identidades V/F sobre $^*$, $^+$, $^r$ | 10 | C1–C13 (C5, C6, C13 van más allá) |
| $\mathrm{Sub}$, $\mathrm{Ini}$, $\mathrm{Fin}$ | 11 | D1–D6 |
| — *no está en la guía* — | | **B4/B5** (Levi, conmutación), **D7** (cociente), **A5, E1–E5** (cardinalidad y diagonalización) |

Lo agregado no es relleno: el cociente $\alpha^{-1}L$ reaparece en la minimización de AFDs y en las
derivadas de expresiones regulares; el lema de Levi es la herramienta de todo argumento de doble
factorización (y de la mitad de las demostraciones de este set); E5 es el paso "tomo $w \in L$ con
$|w| \geq n$" del lema de bombeo; y E2 es, argumento por argumento, la diagonalización del halting
problem del segundo parcial.

## Un hallazgo sobre la guía

El ejercicio **11.c** de la práctica ($\mathrm{Fin}(\mathcal{L}_1\mathcal{L}_2) = \mathrm{Fin}(\mathcal{L}_2)\cup\mathrm{Fin}(\mathcal{L}_1)\mathcal{L}_2$) es **falso tal
como está enunciado**: falla cuando $\mathcal{L}_1 = \emptyset$ y $\mathcal{L}_2 \neq \emptyset$ (izquierda $\emptyset$, derecha
$\mathrm{Fin}(\mathcal{L}_2)$). El ejercicio D1 trabaja la versión espejada con $\mathrm{Ini}$ y pide detectar y reparar la
hipótesis faltante — que es exactamente lo que hay que hacer en el parcial si aparece así.
