# Parcial modelo B — ★★ parcial pleno

**Duración: 3 h.** Cuatro ejercicios, 25 puntos cada uno. Se aprueba con 60.
**Sin apuntes, a página en blanco, de una sentada.**

> Hacelo con las **guías 1 a 4** terminadas (lenguajes, autómatas finitos, determinización y
> minimización, bombeo regular). El ejercicio 4 necesita la guía 5.

---

## Ejercicio 1 — Cocientes · *T1 + T3 + T4* · 35 min

Para $\alpha \in \Sigma^*$ y $L \subseteq \Sigma^*$ se define el **cociente**
$$\alpha^{-1}L = \{\beta \in \Sigma^* : \alpha\beta \in L\}.$$

**a.** Calcular $\alpha^{-1}L$ en cada caso: ($\alpha = aab$, $L = \{a^nb^n : n \geq 0\}$);
($\alpha = ab$, $L = (ab)^*$); ($\alpha = ba$, $L = (ab)^*$).

**b.** Demostrar que si $L$ es regular entonces $\alpha^{-1}L$ es regular, **exhibiendo el
autómata**. ¿Hace falta que el autómata de $L$ sea determinístico?

**c.** Demostrar que si $L$ es regular, el conjunto $\{\alpha^{-1}L : \alpha \in \Sigma^*\}$ es
**finito**.

**d.** Usar (c) — y no el lema de bombeo — para demostrar que $\{a^nb^n : n \geq 0\}$ no es regular.

---

## Ejercicio 2 — Intersección y minimalidad · *T2 + T3* · 45 min

Sobre $\Sigma = \{0,1\}$, sean
$$L_1 = \{\alpha : \alpha \text{ termina en } 01\}, \qquad
  L_2 = \{\alpha : |\alpha|_0 \text{ es par}\}.$$

**a.** Dar los AFD mínimos de $L_1$ y de $L_2$.

**b.** Construir un AFD para $L_1 \cap L_2$ por producto y minimizarlo. ¿Con cuántos estados
arranca y con cuántos termina?

**c.** Demostrar que el autómata obtenido en (b) es mínimo, exhibiendo para **cada par** de estados
una palabra que los distinga.

**d.** Decidir V/F, con demostración o contraejemplo: *el AFD mínimo de $L_1 \cap L_2$ tiene siempre
exactamente $|{\min}(L_1)| \cdot |{\min}(L_2)|$ estados.* ¿Y es cierto que tiene **a lo sumo** esa
cantidad?

---

## Ejercicio 3 — ¿Regular? · *T4 + T1* · 40 min

Para cada lenguaje: si es regular, dar un autómata finito; si no lo es, demostrarlo.

**a.** $L_1 = \{\alpha \in \{a,b\}^* : |\alpha|_a \neq |\alpha|_b\}$

**b.** $L_2 = \{\alpha \# \beta : \alpha, \beta \in \{a,b\}^*,\ \alpha \neq \beta\}$ sobre
$\Sigma = \{a,b,\#\}$

**c.** $L_3 = \{\alpha \in \{a,b\}^* : |\alpha|_a$ es par $\wedge$ $\alpha$ no contiene la subcadena
$bbb\}$

**d.** En (a), mostrar **concretamente** qué se rompe si se intenta bombear de frente: elegir una
palabra, intentar el argumento, y señalar en qué renglón se cae.

---

## Ejercicio 4 — Autómatas de pila · *T5* · 40 min

**a.** Dar un autómata de pila que reconozca $L_1 = \{a^n b^m : n \neq m\}$. ¿Se puede hacer
determinístico? Justificar la respuesta, no sólo afirmarla.

**b.** Demostrar que $L_2 = \{a^n b^{2n} c^{3n} : n \geq 0\}$ no es libre de contexto.

**c.** Demostrar que $L_3 = \{a^i b^j c^k : 0 \leq i \leq j \leq k\}$ no es libre de contexto.
Indicar por qué $a^p b^p c^p$ es la elección correcta de palabra y cuál es el caso del análisis que
obliga a bombear **hacia abajo**.

---

## Corrección

25 puntos por ejercicio, repartidos en partes iguales entre sus ítems. Se aprueba con 60.

| Falla | Descuento |
|---|---|
| Identidad correcta pero probada en una sola inclusión | −50% del ítem |
| Contraejemplo sin exhibir la palabra que separa ambos lados | −50% del ítem |
| Usar $\lambda$ y $\emptyset$ como intercambiables | −100% del ítem |
| Autómata sin estado inicial / finales explícitos | −25% del ítem |
| Construcción sin contestar la meta-pregunta (¿determinístico? ¿de qué tipo sale?) | −50% del ítem |
| Bombeo que analiza una sola descomposición de $w$ | −100% del ítem |
| Minimalidad afirmada sin exhibir palabras distinguidoras | −50% del ítem |
| Bombeo LC sin cubrir todos los casos según dónde cae $vwx$ | −100% del ítem |

Clave en [`modelo-b-clave.md`](modelo-b-clave.md).
