# Parcial modelo A — ★ mecánico

**Temas:** T1 lenguajes · T2 autómatas finitos · T3 determinización y minimización · T4 bombeo
regular · T5 autómatas de pila.
**Duración: 2 h 40.** Cuatro ejercicios, 25 puntos cada uno. Se aprueba con 60.
**Sin apuntes, a página en blanco, de una sentada.**

> Hacelo con las **guías 1 y 2** terminadas. Cada ejercicio lleva marcada la guía que necesita: si
> todavía no llegaste a esa guía, salteá el ítem y **anotá el tiempo que sobró** — ese dato vale
> tanto como la nota.

---

## Ejercicio 1 — Álgebra de lenguajes · *T1 (guía 1)* · 30 min

Decidir si cada afirmación es verdadera o falsa. Si es verdadera, **demostrarla**; si es falsa,
**dar un contraejemplo explícito**, exhibiendo la palabra que separa ambos lados. $\Sigma$ es un
alfabeto cualquiera y $L, L_1, L_2 \subseteq \Sigma^*$.

**a.** $(L^c)^r = (L^r)^c$.

**b.** $\mathrm{Sub}(L^*) = \mathrm{Sub}(L)^*$.

**c.** $L\,\Sigma^* = \Sigma^* \iff \lambda \in L$.

---

## Ejercicio 2 — Determinizar y minimizar · *T2 + T3 (guías 2 y 3)* · 45 min

Sea $M = \langle \{q_0,\dots,q_5\}, \{a,b\}, \delta, q_0, \{q_1,q_5\}\rangle$ el autómata finito no
determinístico con transiciones $\lambda$ dado por:

| $\delta$ | $a$ | $b$ | $\lambda$ |
|---|---|---|---|
| $q_0$ | $\emptyset$ | $\emptyset$ | $\{q_1, q_3\}$ |
| $q_1$ | $\{q_2\}$ | $\{q_1\}$ | $\emptyset$ |
| $q_2$ | $\{q_1\}$ | $\{q_2\}$ | $\emptyset$ |
| $q_3$ | $\{q_3\}$ | $\{q_4\}$ | $\emptyset$ |
| $q_4$ | $\{q_3\}$ | $\{q_5\}$ | $\emptyset$ |
| $q_5$ | $\{q_3\}$ | $\{q_5\}$ | $\emptyset$ |

**a.** Dar las $\lambda$-clausuras y construir el AFD equivalente por subconjuntos. Indicar cuántos
estados alcanzables tiene.

**b.** Minimizarlo. Mostrar la tabla de clases y el autómata mínimo resultante.

**c.** Describir $L(M)$ **por comprensión**.

**d.** Dar el AFD mínimo de $L(M)^c$ e indicar cuántos estados tiene. ¿Es cierto **en general** que
el AFD mínimo de $L^c$ tiene la misma cantidad de estados que el de $L$? Demostrarlo o refutarlo, y
en el caso verdadero decir exactamente dónde se usa que el autómata sea **total**.

---

## Ejercicio 3 — ¿Regular? · *T2 + T4 (guías 2 y 4)* · 45 min

Para cada lenguaje: si es regular, dar un autómata finito que lo reconozca; si no lo es,
demostrarlo.

**a.** $L_1 = \{\alpha \in \{a,b\}^* : |\alpha|_a - |\alpha|_b \equiv 0 \ (\mathrm{mod}\ 3)\}$

**b.** $L_2 = \{a^n b^{2n} : n \geq 0\}$

**c.** $L_3 = \{\alpha \in \{0,1\}^+ : \alpha$ interpretada como número binario es múltiplo de $3\}$

**d.** Para el/los lenguajes no regulares: ¿alcanzaría con exhibir **una** palabra que no se puede
bombear? Explicar qué cuantificador del enunciado del lema se estaría invirtiendo y por qué el
argumento correcto necesita razonar sobre **todas** las descomposiciones.

---

## Ejercicio 4 — Autómatas de pila · *T5 (guía 5)* · 40 min

**a.** Dar un autómata de pila que reconozca $L_1 = \{a^n b^m c^n : n, m \geq 0\}$. ¿Es
determinístico? Justificar.

**b.** Demostrar que $L_2 = \{a^n b^n c^n : n \geq 0\}$ no es libre de contexto.

**c.** Exhibir dos lenguajes libres de contexto $L_3$ y $L_4$ tales que $L_3 \cap L_4 = L_2$ (dar un
AP o una descripción constructiva de cada uno). ¿Qué se concluye sobre la clausura de los lenguajes
libres de contexto por intersección?

---

## Corrección

25 puntos por ejercicio, repartidos en partes iguales entre sus ítems. Se aprueba con 60.
Aplicar los descuentos **sobre uno mismo, con dureza**:

| Falla | Descuento |
|---|---|
| Identidad correcta pero probada en una sola inclusión (cuando hacen falta las dos) | −50% del ítem |
| Contraejemplo sin exhibir la palabra que separa ambos lados | −50% del ítem |
| Usar $\lambda$ y $\emptyset$ como intercambiables, aunque sea una vez | −100% del ítem |
| Autómata sin decir cuál es el estado inicial y cuáles los finales | −25% del ítem |
| Construcción dada sin contestar la meta-pregunta (¿determinístico? ¿de qué tipo sale?) | −50% del ítem |
| Bombeo que analiza una sola descomposición de $w$ | −100% del ítem |
| Inducción sin caso base explícito, o sin decir sobre qué variable se induce | −50% del ítem |

Cada error → una línea en [`../../errores.md`](../../errores.md).
Clave en [`modelo-a-clave.md`](modelo-a-clave.md) — no abrirla antes de haber escrito algo.
