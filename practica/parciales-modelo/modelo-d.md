# Parcial modelo D — ★★★ margen

**Duración: 3 h.** Cuatro ejercicios, 25 puntos cada uno.
**Sin apuntes, a página en blanco, de una sentada.**

> Éste está **por encima** del nivel del parcial: es el *spare room*. No es el piso, es el margen.
> Si sale, el tema está sobrado; si no sale, no cambia el diagnóstico del modelo C.

---

## Ejercicio 1 — Clasificación en la jerarquía · *T4 + T5 + T1* · 45 min

Para cada lenguaje, ubicarlo en **exactamente una** de estas categorías y **demostrar** la
ubicación (las dos mitades: que pertenece a la clase, y que no pertenece a la anterior):

> regular · libre de contexto determinístico pero no regular · libre de contexto pero no
> determinístico · no libre de contexto

**a.** $\{a^n b^m : n \neq m\}$

**b.** $\{\alpha \in \{a,b\}^* : \alpha \neq \alpha^r\}$

**c.** $\{a^{n!} : n \geq 0\}$

---

## Ejercicio 2 — Rotaciones · *T1 + T2 + T3* · 45 min

Para $L \subseteq \Sigma^*$ se define
$$\mathrm{Ciclo}(L) = \{\beta\alpha : \alpha\beta \in L\}.$$

**a.** Calcular $\mathrm{Ciclo}((ab)^*)$.

**b.** Demostrar que si $L$ es regular entonces $\mathrm{Ciclo}(L)$ es regular. ¿De qué tipo es el
autómata que construís? ¿Hace falta que el de $L$ sea determinístico?

**c.** Demostrar que $\mathrm{Ciclo}(\mathrm{Ciclo}(L)) = \mathrm{Ciclo}(L)$ para todo $L$.

**d.** Decidir V/F con demostración o contraejemplo explícito:
*$\mathrm{Ciclo}(L)$ regular $\Rightarrow$ $L$ regular.*

---

## Ejercicio 3 — Lenguajes unarios · *T4* · 45 min

**a.** Demostrar que si $L \subseteq \{a\}^*$ es regular e infinito, entonces existen $c \geq 0$ y
$d \geq 1$ tales que $a^{c + kd} \in L$ para todo $k \geq 0$.

**b.** Deducir de (a) que $\{a^p : p$ primo$\}$ no es regular.

**c.** Demostrar que $\{a^{2^n} : n \geq 0\}$ no es regular **directamente** con el lema de bombeo.
Escribir la desigualdad que cierra el argumento y decir por qué acá conviene bombear hacia arriba.

---

## Ejercicio 4 — Pila: no determinismo esencial y no clausura · *T5* · 45 min

**a.** Dar un autómata de pila para
$L_1 = \{\alpha \# \beta : \alpha, \beta \in \{a,b\}^*,\ \alpha \neq \beta\}$ sobre
$\Sigma = \{a,b,\#\}$. **Demostrar** que no es determinístico. Explicar por qué acá el no
determinismo es esencial y en cambio **no** lo es en $\{a^n b^m : n \neq m\}$ — ¿cuál es la
diferencia estructural?

**b.** Demostrar que $L_2 = \{a^i b^j c^i d^j : i,j \geq 0\}$ no es libre de contexto.

**c.** Demostrar que los lenguajes libres de contexto **no** son cerrados por complemento, sabiendo
que sí lo son por unión. Explicar por qué el mismo argumento **no** se aplica a los libres de
contexto determinísticos.

---

## Corrección

25 puntos por ejercicio. Misma tabla de descuentos que los modelos B y C.
Clave en [`modelo-d-clave.md`](modelo-d-clave.md).
