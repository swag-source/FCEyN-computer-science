# Clave — Parcial modelo B

## Ejercicio 1

**a.** $(aab)^{-1}\{a^nb^n\} = \{b\}$ — la única palabra del lenguaje que empieza con $aab$ es
$aabb$ ($n = 2$); para $n \geq 3$ el prefijo es $aaa$.
$(ab)^{-1}(ab)^* = (ab)^*$.  $(ba)^{-1}(ab)^* = \emptyset$ — ninguna palabra de $(ab)^*$ empieza con
$ba$.

⚠ **Trampa.** $\emptyset$, no $\{\lambda\}$. El cociente vacío significa «$\alpha$ no es prefijo de
nada en $L$»; $\{\lambda\}$ significaría «$\alpha \in L$ y nada más la extiende».

**b.** Si $M = \langle Q,\Sigma,\delta,q_0,F\rangle$ es un AFD para $L$, entonces
$\alpha^{-1}L = L(\langle Q,\Sigma,\delta,\widehat\delta(q_0,\alpha),F\rangle)$: **el mismo autómata,
movido el estado inicial**. Correctitud: $\beta \in \alpha^{-1}L \iff \alpha\beta \in L \iff
\widehat\delta(q_0,\alpha\beta) \in F \iff \widehat\delta(\widehat\delta(q_0,\alpha),\beta) \in F$,
usando la propiedad de concatenación de $\widehat\delta$.

**Meta-pregunta:** no hace falta que sea determinístico, pero con un AFND
$\widehat\delta(q_0,\alpha)$ es un **conjunto** de estados, así que hay que agregar un estado inicial
nuevo con transiciones $\lambda$ hacia todos ellos (o determinizar primero). El resultado es del
mismo tipo que la entrada.

**c.** Por (b), $\alpha^{-1}L$ queda determinado por $\widehat\delta(q_0,\alpha) \in Q$. Es decir, la
función $\alpha \mapsto \alpha^{-1}L$ factoriza por $Q$, luego
$|\{\alpha^{-1}L : \alpha \in \Sigma^*\}| \leq |Q| < \infty$.

⚠ **Trampa.** Es $\leq$, no $=$: dos estados distintos pueden dar el mismo cociente (justamente los
que la minimización fusiona).

**d.** $(a^i)^{-1}\{a^nb^n\} = \{a^jb^{i+j} : j \geq 0\}$. Para $i \neq i'$ estos cocientes son
distintos: $b^i$ pertenece al primero y no al segundo. Hay entonces infinitos cocientes distintos,
y por (c) $L$ no puede ser regular.

---

## Ejercicio 2

**a.** $\min(L_1)$, **3 estados** (λ / «vi un $0$» / «vi $01$»): $t_0: 0\to t_1, 1 \to t_0$;
$t_1: 0 \to t_1, 1 \to t_2$; $t_2: 0 \to t_1, 1 \to t_0$; $F = \{t_2\}$.
$\min(L_2)$, **2 estados** (paridad de ceros), final el par.

**b.** El producto arranca con $3 \cdot 2 = 6$ estados y minimiza a **4**.
Representantes $\lambda,\ 0,\ 00,\ 001$:

| | $0$ | $1$ | |
|---|---|---|---|
| $s_0 = [\lambda]$ | $s_1$ | $s_0$ | inicial |
| $s_1 = [0]$ | $s_2$ | $s_1$ | |
| $s_2 = [00]$ | $s_1$ | $s_3$ | |
| $s_3 = [001]$ | $s_1$ | $s_0$ | final |

Los que se fusionan son, por ejemplo, $0$ y $01$: ambos tienen cantidad impar de ceros, y con
cantidad impar de ceros el estado de la ventana «$01$» ya no distingue nada (cualquier sufijo no
vacío la reescribe, y $\lambda$ rechaza en los dos).

**c.** $(s_0,s_1)$: $01$ — $01 \notin L$ (un cero), $001 \in L$.
$(s_0,s_2)$: $1$ — $1 \notin L$, $001 \in L$.
$(s_1,s_2)$: $1$ — $01 \notin L$, $001 \in L$.
$(s_0,s_3), (s_1,s_3), (s_2,s_3)$: $\lambda$ — sólo $s_3$ es final.

**d.** **Falsa, y el contraejemplo es este mismo ejercicio:** $3 \cdot 2 = 6 \neq 4$.
La cota **superior sí vale**: el autómata producto reconoce $L_1 \cap L_2$ y tiene
$|\min(L_1)|\cdot|\min(L_2)|$ estados, y el mínimo no tiene más estados que ningún AFD del lenguaje.
Caso extremo: $L_1 = L_2$ da $n$ y no $n^2$.

---

## Ejercicio 3

**a. No regular, por clausura.** Los regulares son cerrados por complemento, así que si $L_1$ fuese
regular también lo sería $L_1^c = \{\alpha : |\alpha|_a = |\alpha|_b\}$. Pero éste no lo es: con $n$
la constante, $w = a^nb^n$, toda descomposición admisible tiene $y = a^k$ con $k \geq 1$, y
$xy^0z = a^{n-k}b^n \notin L_1^c$. Absurdo.

**b. No regular.** $a^*\#a^*$ es regular y $L_2 \cap a^*\#a^* = \{a^n\#a^m : n \neq m\}$. Si $L_2$
fuese regular, éste también, y su complemento dentro de $a^*\#a^*$ —también regular— sería
$\{a^n\#a^n : n \geq 0\}$, que se refuta con $w = a^n\#a^n$ igual que en (a).

**c. Regular.** Producto de: paridad de $a$ (2 estados) × cantidad de $b$ consecutivas al final,
$0/1/2$ más trampa en 3 (4 estados). $F$ = paridad par y ventana $\neq$ trampa.

**d.** Con $w = a^nb^{n+1}$: la descomposición da $y = a^k$, y $xy^mz = a^{n-k+mk}b^{n+1}$. Hace
falta un $m$ con $n - k + mk = n+1$, o sea $k(m-1) = 1$: **sólo existe si $k = 1$**. Para
$k \geq 2$ ninguna potencia sirve y la palabra no se puede romper. Ahí se cae el argumento: elegir
$w$ después de ver $k$ invierte los cuantificadores.

Dos reparaciones: la de una línea es el complemento (ítem a); la directa es
$w = a^nb^{n+n!}$, porque $k \leq n$ divide a $n!$ y entonces $m = 1 + n!/k$ da
$a^{n+n!}b^{n+n!} \notin L_1$.

---

## Ejercicio 4

**a.** $\Gamma = \{Z_0,A\}$. Leyendo $a$ apilar $A$; leyendo $b$ desapilar $A$. Si el input termina
con algún $A$ en la pila, $n > m$: aceptar. Si aparece una $b$ con $Z_0$ en el tope, pasar a un
estado «$m > n$» que consume el resto de las $b$ y acepta. Rechazar exactamente cuando el input
termina con la pila en $Z_0$ habiendo leído sólo $a$s y $b$s balanceadas.

**Sí se puede determinístico.** La comparación se **resuelve leyendo**: en cada momento el AP sabe si
va ganando $a$ o $b$, y el desbalance se detecta con $Z_0$. No hace falta adivinar nada de
antemano.

⚠ **Trampa.** «Tiene un $\neq$, entonces es no determinístico» es falso. Comparar con D4a, donde el
$\neq$ **sí** obliga a adivinar: la diferencia es si la comparación se puede resolver en el orden en
que llega el input.

**b.** $z = a^pb^{2p}c^{3p}$. Como $|vwx| \leq p$, $vwx$ toca a lo sumo dos bloques **adyacentes**,
o sea nunca las $a$ y las $c$ a la vez. En cualquier caso $uv^2wx^2y$ deja **fija** al menos una de
las tres cantidades y cambia al menos otra, rompiendo la proporción $n : 2n : 3n$. Concretamente, si
$vx$ no toca las $c$, la cantidad de $c$ sigue siendo $3p$, así que haría falta $n' = p$; pero
$|vx| \geq 1$ cambió las $a$ o las $b$. Absurdo.

**c.** $z = a^pb^pc^p$ es la elección correcta porque satura las **dos** desigualdades a la vez
($i = j$ y $j = k$): cualquier cambio en una sola cantidad rompe una de ellas.

- $vwx$ dentro de las $a$: bombear **hacia arriba** da $i > j$.
- $vwx$ dentro de las $b$: bombear **hacia abajo** ($m = 0$) da $j < i$. ← **el caso que se olvida**
- $vwx$ dentro de las $c$: hacia abajo, $k < j$.
- $vwx$ entre $a$ y $b$: hacia arriba; si $vx$ tiene $b$s, $j > k$ (las $c$ no cambiaron); si sólo
  tiene $a$s, $i > j$.
- $vwx$ entre $b$ y $c$: hacia abajo; si $vx$ tiene $b$s, $j < i$; si sólo tiene $c$s, $k < j$.

⚠ **Trampa.** Con $i \leq j \leq k$ hay casos que **sólo** se rompen bombeando hacia abajo. Un
parcial que sólo prueba $m = 2$ pierde el ejercicio entero.
