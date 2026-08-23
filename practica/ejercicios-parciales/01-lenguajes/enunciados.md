# Ejercicios nivel parcial — Guía 01: Lenguajes

> Compañero de la *Práctica 1: Lenguajes*. **No** es la guía otra vez: acá el foco está en lo
> que un parcial realmente pide sobre este tema — demostrar, refutar con contraejemplo, y
> detectar los casos borde ($\emptyset$ vs $\Lambda$, $\lambda \in L$) que hacen fallar identidades
> "obvias".

## Convenciones

- $\Sigma$ es un alfabeto (finito, no vacío). $\alpha, \beta, \gamma, \mu$ denotan **cadenas**; $L, A, B$ denotan **lenguajes**.
- $\Lambda = \{\lambda\}$, y $\emptyset \neq \Lambda$ (uno no tiene palabras, el otro tiene una).
- $\alpha^r$ = reverso, $|\alpha|$ = longitud, $L^c = \Sigma^* \setminus L$ (siempre relativo a un $\Sigma$ que hay que fijar).
- $\mathrm{Ini}(L)$ = prefijos, $\mathrm{Fin}(L)$ = sufijos, $\mathrm{Sub}(L)$ = subcadenas.
- Definiciones recursivas que se usan como base de toda inducción:
  - $|\lambda| = 0$, $\quad |\alpha a| = |\alpha| + 1$ para $a \in \Sigma$.
  - $\lambda^r = \lambda$, $\quad (\alpha a)^r = a\,\alpha^r$.
  - $\alpha \cdot \lambda = \alpha$, $\quad \alpha \cdot (\beta a) = (\alpha \cdot \beta)a$.
  - $L^0 = \Lambda$, $\quad L^{n+1} = L^n L$, $\quad L^* = \bigcup_{n \geq 0} L^n$, $\quad L^+ = \bigcup_{n \geq 1} L^n$.

## Cómo usar esto

Dificultad: ★ = mecánico de parcial · ★★ = nivel parcial pleno · ★★★ = por encima del parcial (el "spare room").
Los minutos son presupuesto de examen, no de estudio. Todo a página en blanco, sin apuntes.
Bloque F es un simulacro cronometrado: hacelo **después** de A–E, de una sentada, 60 minutos.

Soluciones completas en [`soluciones.md`](soluciones.md). No las abras antes de haber escrito algo.

---

## Bloque A — Definiciones y cálculo exacto (velocidad)

**A1** (★, 10 min, sin apuntes). Escribir las definiciones formales de: $\Sigma^*$, $\Sigma^+$, $|\alpha|$ y $\alpha^r$ (recursivas), $L_1L_2$, $L^n$, $L^*$, $L^+$, $\mathrm{Ini}$, $\mathrm{Fin}$, $\mathrm{Sub}$, y el orden longitud-lexicográfico. Después, con la definición en la mano, decidir y justificar en una línea cada uno:
$$\lambda \in \emptyset^*,\quad \emptyset^+ = \emptyset,\quad \Lambda^* = \Lambda,\quad \emptyset \subseteq \Sigma^*,\quad |\Sigma^0| = 1,\quad \Sigma^* \subseteq \Sigma^+ .$$

**A2** (★, 10 min). Sean $L_1 = \{a, ab\}$ y $L_2 = \{a, aa\}$ sobre $\Sigma = \{a,b\}$.

a. Calcular $L_1^2$ y $L_2^2$.
b. Dar $|L_1^n|$ y $|L_2^n|$ en función de $n$, **con demostración**.
c. Explicar en una oración a qué se debe la diferencia.

**A3** (★, 8 min). Sean $A = \{\lambda, a\}$, $B = \{b, ab\}$ sobre $\Sigma = \{a,b\}$. Calcular:
$$AB,\quad BA,\quad (AB)^r,\quad A \cap B^*,\quad A^c,\quad A^0B^2,\quad A\emptyset B,\quad A\Lambda B .$$

**A4** (★★, 12 min). Para $n \geq 1$ fijo, calcular **exactamente** (con justificación del conteo):

a. $|\mathrm{Sub}(\{a^n\})|$
b. $|\mathrm{Ini}(\{a^nb^n\})|$ y $|\mathrm{Sub}(\{a^nb^n\})|$
c. $|\mathrm{Sub}(\{(ab)^n\})|$

**A5** (★★, 15 min). Sea $\Sigma = \{a,b\}$ con $a < b$ y el orden longitud-lexicográfico, y sea $\mathrm{ind} : \Sigma^* \to \mathbb{N}_0$ la función que asigna a cada palabra su posición ($\mathrm{ind}(\lambda) = 0$).

a. Calcular $\mathrm{ind}(abba)$ y la palabra de índice $100$.
b. Dar una fórmula cerrada para $\mathrm{ind}(c_1c_2\dots c_n)$.
c. Demostrar que $\mathrm{ind}$ es una biyección (y por lo tanto $|\Sigma^*| = |\mathbb{N}|$).

---

## Bloque B — Cadenas: inducción y estructura

**B1** (★★, 10 min). Demostrar por inducción, usando **solo** las definiciones recursivas, que $|\alpha\beta| = |\alpha| + |\beta|$ para todas $\alpha, \beta \in \Sigma^*$. Indicar explícitamente sobre qué variable se hace la inducción y por qué no sirve hacerla sobre la otra.

**B2** (★★, 10 min). Demostrar por inducción que $(\alpha\beta)^r = \beta^r\alpha^r$. Deducir $(\alpha^r)^r = \alpha$ y $(\alpha^n)^r = (\alpha^r)^n$.

**B3** (★★, 8 min). Demostrar las dos leyes de cancelación en $\Sigma^*$:
a. $\alpha\gamma = \alpha\delta \implies \gamma = \delta$
b. $\gamma\alpha = \delta\alpha \implies \gamma = \delta$

**B4** (★★, 10 min) *(Lema de Levi — herramienta reutilizable)*. Sean $\alpha,\beta,\gamma,\delta \in \Sigma^*$ con $\alpha\beta = \gamma\delta$ y $|\alpha| \leq |\gamma|$. Demostrar que existe $\mu \in \Sigma^*$ tal que $\gamma = \alpha\mu$ y $\beta = \mu\delta$.

**B5** (★★★, 20 min) *(Teorema de conmutación)*. Demostrar:
$$\alpha\beta = \beta\alpha \iff \exists\, \gamma \in \Sigma^*,\ \exists\, n,m \geq 0 : \alpha = \gamma^n \ \wedge\ \beta = \gamma^m .$$
*Sugerencia:* la vuelta es directa; la ida sale por inducción fuerte en $|\alpha| + |\beta|$ usando B4 y B3.

**B6** (★★, 12 min). Sea $P = \{\alpha \in \Sigma^* : \alpha = \alpha^r\}$ (palíndromos).

a. Demostrar que $\alpha\alpha^r \in P$ para toda $\alpha$.
b. Demostrar que si $\alpha, \beta \in P$ y $\alpha\beta \in P$, entonces $\alpha\beta = \beta\alpha$.
c. Concluir, usando B5, la forma que deben tener $\alpha$ y $\beta$ en (b).
d. ¿Es $P$ cerrado por concatenación? Demostrarlo o dar contraejemplo.

**B7** (★★, 12 min). Sea $X \subseteq \{a,b\}^*$ el **menor** conjunto tal que $\lambda \in X$ y ($\alpha \in X \implies a\alpha b \in X$). Demostrar que $X = \{a^nb^n : n \geq 0\}$. (Las dos inclusiones, cada una con su inducción; decir cuál usa la minimalidad de $X$.)

---

## Bloque C — Álgebra de lenguajes: verdadero o falso

> Formato de parcial: si es verdadero, **demostración**; si es falso, **contraejemplo explícito**
> (dar los lenguajes y exhibir la palabra que separa ambos lados). "Es falso porque en general no
> vale" no suma puntos.

**C1** (★, 5 min). $L^+ = L^* \setminus \{\lambda\}$ para todo $L$.

**C2** (★★, 8 min). $L^* = (L \setminus \{\lambda\})^*$ para todo $L$.

**C3** (★★, 6 min). $L^+ = L^* \iff \lambda \in L$.

**C4** (★★, 8 min). $L(L_1 \cap L_2) = LL_1 \cap LL_2$. (Si es falso: ¿alguna de las dos inclusiones vale siempre?)

**C5** (★★, 10 min). $(L_1 \cup L_2)^* = (L_1^*L_2^*)^*$.

**C6** (★★★, 12 min). $(L_1L_2)^*L_1 = L_1(L_2L_1)^*$.

**C7** (★★, 8 min). $L_1L = L_2L \implies L_1 = L_2$, incluso suponiendo $L \neq \emptyset$.

**C8** (★★, 8 min). Demostrar que **para todo** $L \subseteq \Sigma^*$ vale $(L^c)^* \neq (L^*)^c$.

**C9** (★★, 8 min). $L^*$ es finito $\iff L \subseteq \Lambda$.

**C10** (★★, 8 min). $(L^*)^r = (L^r)^*$.

**C11** (★, 6 min). $(L_1 \setminus L_2)^r = L_1^r \setminus L_2^r$.

**C12** (★, 5 min). $L_1L_2 = \emptyset \iff L_1 = \emptyset \ \vee\ L_2 = \emptyset$.

**C13** (★★★, 12 min). $L \subseteq L^2 \iff \lambda \in L$.

---

## Bloque D — Ini / Fin / Sub y cocientes

**D1** (★★★, 12 min) *(el clásico caso borde)*. Decidir para qué lenguajes $L_1, L_2$ vale
$$\mathrm{Ini}(L_1L_2) = \mathrm{Ini}(L_1) \cup L_1\,\mathrm{Ini}(L_2),$$
demostrar la identidad bajo esa hipótesis, y exhibir un contraejemplo cuando la hipótesis falla.
(Comparar con el enunciado del ejercicio 11.c de la guía: ¿le falta una hipótesis?)

**D2** (★★, 8 min). Demostrar $\mathrm{Fin}(L)^r = \mathrm{Ini}(L^r)$ y $\mathrm{Sub}(L^r) = \mathrm{Sub}(L)^r$.

**D3** (★★, 10 min). Demostrar $\mathrm{Sub}(L) = \mathrm{Ini}(\mathrm{Fin}(L)) = \mathrm{Fin}(\mathrm{Ini}(L))$.

**D4** (★★, 6 min). Decidir V/F: $\mathrm{Sub}(L_1 \cap L_2) = \mathrm{Sub}(L_1) \cap \mathrm{Sub}(L_2)$. ¿Y con $\cup$ en lugar de $\cap$?

**D5** (★★★, 15 min). Decidir V/F y demostrar: $\mathrm{Ini}(L^*) = L^*\,\mathrm{Ini}(L)$. Prestar atención al caso $L = \emptyset$.

**D6** (★★, 10 min). Un lenguaje $L$ es *cerrado por prefijos* si $\mathrm{Ini}(L) \subseteq L$.

a. Demostrar: $L$ es cerrado por prefijos $\iff \mathrm{Ini}(L) = L$.
b. Demostrar que $\mathrm{Ini}(L)$ es el menor lenguaje cerrado por prefijos que contiene a $L$.
c. Deducir $\mathrm{Ini}(\mathrm{Ini}(L)) = \mathrm{Ini}(L)$ sin repetir la cuenta del ítem anterior.

**D7** (★★★, 20 min) *(cociente / derivada — aparece en parciales disfrazado)*. Se define
$$\alpha^{-1}L = \{\beta \in \Sigma^* : \alpha\beta \in L\}, \qquad L_1^{-1}L_2 = \bigcup_{\alpha \in L_1} \alpha^{-1}L_2 .$$

a. Demostrar $\mathrm{Fin}(L) = (\Sigma^*)^{-1}L$.
b. Demostrar $(L_1 \cup L_2)^{-1}L = L_1^{-1}L \cup L_2^{-1}L$.
c. Demostrar $(L_1L_2)^{-1}L = L_2^{-1}(L_1^{-1}L)$.
d. Dar y demostrar una fórmula para $\alpha^{-1}(L_1L_2)$ en términos de $\alpha^{-1}L_1$ y de cocientes de $L_2$. ¿Por qué no vale simplemente $(\alpha^{-1}L_1)L_2$?

**D8** (★★, 8 min).

a. Demostrar: $\mathrm{Sub}(L)$ finito $\implies L$ finito.
b. Exhibir $L \subsetneq \Sigma^*$ infinito con $\mathrm{Sub}(L) = \Sigma^*$.

---

## Bloque E — Cardinalidad y diagonalización

> Este bloque es el puente al segundo parcial: la diagonalización de E2 es literalmente la misma
> maquinaria que la del halting problem, y conviene que esté automatizada desde ahora.

**E1** (★★, 10 min). Demostrar que para todo alfabeto $\Sigma$ (finito, no vacío) vale $|\Sigma^*| = |\mathbb{N}|$. ¿Dónde se usa que $\Sigma$ es finito? ¿Qué pasaría si $\Sigma$ fuese numerable infinito?

**E2** (★★, 12 min). Demostrar que el conjunto de **todos** los lenguajes sobre $\Sigma$, es decir $\mathcal{P}(\Sigma^*)$, no es numerable.

**E3** (★★, 10 min). Demostrar que el conjunto de los lenguajes **finitos** sobre $\Sigma$ es numerable infinito.

**E4** (★★, 8 min). Sea $\Delta$ un alfabeto de "descripciones" (finito). Demostrar que existe al menos un lenguaje $L \subseteq \Sigma^*$ que no es descripto por ninguna cadena de $\Delta^*$, cualquiera sea la convención de descripción que se elija. Explicar por qué el argumento no exhibe ningún $L$ concreto.

**E5** (★★, 8 min) *(lema que se reusa en bombeo)*. Demostrar: si $L$ es infinito, entonces existe una sucesión $\alpha_1, \alpha_2, \alpha_3, \dots$ de palabras de $L$ con $|\alpha_1| < |\alpha_2| < |\alpha_3| < \cdots$. En particular, $L$ tiene palabras de longitud arbitrariamente grande.

---

## Bloque F — Simulacro de parcial (60 min, cronometrado, sin apuntes)

**F1** (15 min). Decidir V/F. Demostración o contraejemplo explícito en cada caso.
a. $L^+ = L^* \setminus \{\lambda\}$ para todo $L$.
b. $(L_1 \cap L_2)^* = L_1^* \cap L_2^*$.
c. $L \subseteq L^2 \iff \lambda \in L$.

**F2** (15 min). Demostrar o refutar: $\mathrm{Ini}(L_1L_2) = \mathrm{Ini}(L_1) \cup L_1\mathrm{Ini}(L_2)$. Si hace falta agregar hipótesis, enunciarlas con precisión y demostrar el enunciado corregido.

**F3** (15 min). Demostrar $(L_1L_2)^*L_1 = L_1(L_2L_1)^*$.

**F4** (15 min). Demostrar que $\mathcal{P}(\Sigma^*)$ no es numerable, enunciando explícitamente el hecho sobre $\Sigma^*$ que se usa y por qué vale.

**Corrección.** Cada ítem: 25 puntos. Se aprueba con 60. Criterio de descuento típico de cátedra —
aplicalo con dureza sobre vos mismo:

| Falla | Descuento |
|---|---|
| Identidad correcta pero probada en una sola inclusión (cuando hacen falta las dos) | −50% del ítem |
| Contraejemplo sin exhibir la palabra que separa ambos lados | −50% del ítem |
| Usar $\lambda$ y $\emptyset$ como intercambiables, aunque sea una vez | −100% del ítem |
| Inducción sin caso base explícito, o sin decir sobre qué variable se induce | −50% del ítem |
| "Sin pérdida de generalidad" sin justificar la simetría | −25% del ítem |

Después del simulacro: cada error va a `errores.md` en una línea —
*qué me salió mal → por qué (concepto / notación / lectura / tiempo) → la idea correcta en una oración.*
