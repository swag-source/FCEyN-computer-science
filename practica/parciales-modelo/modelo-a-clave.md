# Clave — Parcial modelo A

> Esquema de solución, no redacción de examen: lo que hay que **producir** es la demostración
> completa. Cada ítem cierra con **⚠ Trampa**, que es el error que el ejercicio caza. Esos van a
> [`../../errores.md`](../../errores.md).

## Ejercicio 1

**a. Verdadera.** $\alpha \in (L^c)^r \iff \alpha^r \in L^c \iff \alpha^r \notin L \iff
\alpha \notin L^r \iff \alpha \in (L^r)^c$. El tercer paso usa que $\alpha \in L^r \iff \alpha^r \in L$,
que a su vez usa $(\alpha^r)^r = \alpha$.

⚠ **Trampa.** Los dos complementos tienen que tomarse respecto del **mismo** $\Sigma^*$; el paso
funciona porque $\Sigma^*$ es cerrado por reverso ($(\Sigma^*)^r = \Sigma^*$). Si no lo decís, falta
un renglón.

**b. Falsa.** $L = \{ab\}$. Entonces $\mathrm{Sub}(L) = \{\lambda, a, b, ab\}$ y
$\mathrm{Sub}(L)^* = \{a,b\}^*$, mientras que $\mathrm{Sub}(L^*)$ son las subcadenas de $(ab)^n$,
todas alternadas. **Palabra que separa: $aa$** — está en $\mathrm{Sub}(L)^*$ y no en
$\mathrm{Sub}(L^*)$.

La inclusión $\mathrm{Sub}(L^*) \subseteq \mathrm{Sub}(L)^*$ **sí** vale: toda subcadena de
$w_1\cdots w_n$ se escribe como (sufijo de $w_i$)·$w_{i+1}\cdots w_{j-1}$·(prefijo de $w_j$), y cada
factor está en $\mathrm{Sub}(L)$.

⚠ **Trampa.** Decir «es falso» sin exhibir $aa$ vale la mitad. Y conviene decir cuál de las dos
inclusiones sobrevive: eso es lo que distingue entender de adivinar.

**c. Verdadera.** ($\Leftarrow$) Si $\lambda \in L$, $\Sigma^* = \lambda\Sigma^* \subseteq L\Sigma^*
\subseteq \Sigma^*$. ($\Rightarrow$) $\lambda \in \Sigma^* = L\Sigma^*$, así que $\lambda = \alpha\beta$
con $\alpha \in L$; como $|\lambda| = 0 = |\alpha| + |\beta|$, resulta $\alpha = \lambda$, luego
$\lambda \in L$.

⚠ **Trampa.** El caso $L = \emptyset$: $\emptyset\Sigma^* = \emptyset \neq \Sigma^*$, coherente con
que $\lambda \notin \emptyset$. Si tu demostración no sobrevive a $L = \emptyset$, está mal.

---

## Ejercicio 2

**a.** $\lambda\text{-cl}(q_0) = \{q_0,q_1,q_3\}$ y $\lambda\text{-cl}(q_i) = \{q_i\}$ para $i \geq 1$.
Subconjuntos alcanzables (**7**):

| | $a$ | $b$ | final |
|---|---|---|---|
| $A = \{q_0,q_1,q_3\}$ | $B$ | $C$ | ✔ |
| $B = \{q_2,q_3\}$ | $D$ | $E$ | |
| $C = \{q_1,q_4\}$ | $B$ | $F$ | ✔ |
| $D = \{q_1,q_3\}$ | $B$ | $C$ | ✔ |
| $E = \{q_2,q_4\}$ | $D$ | $G$ | |
| $F = \{q_1,q_5\}$ | $B$ | $F$ | ✔ |
| $G = \{q_2,q_5\}$ | $D$ | $G$ | ✔ |

**b.** Clases: $\{A,C,D,F\}$, $\{B\}$, $\{E\}$, $\{G\}$ — **4 estados**.

| | $a$ | $b$ | |
|---|---|---|---|
| $s_0 = [A]$ | $s_1$ | $s_0$ | inicial, final |
| $s_1 = [B]$ | $s_0$ | $s_2$ | |
| $s_2 = [E]$ | $s_0$ | $s_3$ | |
| $s_3 = [G]$ | $s_0$ | $s_3$ | final |

Representantes: $\lambda,\ a,\ ab,\ abb$. Distinguidoras: $(s_0,s_3)$ con $a$; $(s_1,s_2)$ con $b$;
los demás pares con $\lambda$.

**c.** $L(M) = \{\alpha \in \{a,b\}^* : |\alpha|_a \text{ es par}\} \cup \{\alpha : \alpha \text{
termina en } bb\}$. El $\lambda$ de $q_0$ es exactamente la unión: $q_1,q_2$ llevan la paridad de
$a$; $q_3,q_4,q_5$ son la ventana de sufijo $bb$.

**d.** Intercambiar finales por no finales en el mínimo **total** de (b): finales $s_1, s_2$.
Siguen siendo **4** estados y sigue siendo mínimo.

En general **es verdadero**: $\alpha$ y $\beta$ son indistinguibles para $L$ si y sólo si lo son para
$L^c$ (la condición «$\alpha\gamma \in L \iff \beta\gamma \in L$» es idéntica a
«$\alpha\gamma \in L^c \iff \beta\gamma \in L^c$»), así que ambos mínimos tienen la misma cantidad
de clases.

⚠ **Trampa — y es el ítem entero.** Vale **sólo si el autómata es total**. Si complementás un AFD
parcial dando vuelta los finales, perdés todas las palabras que no tenían corrida. Ejemplo:
$\Sigma = \{a,b\}$, $L = a^*$ con el AFD parcial de 1 estado; su «complemento» daría $\emptyset$,
cuando $L^c \neq \emptyset$. Hay que agregar el estado trampa **antes** de complementar, y ahí el
mínimo de $a^*$ tiene 2 estados, igual que el de $L^c$.

---

## Ejercicio 3

**a. Regular.** 3 estados $\{0,1,2\}$ = valor de $|\alpha|_a - |\alpha|_b$ módulo 3;
$\delta(i,a) = i+1$, $\delta(i,b) = i-1$ (mód 3); inicial y único final: $0$.

⚠ **Trampa.** $a$ y $b$ se mueven en **direcciones opuestas**. Escribir $\delta(i,b) = i+1$ reconoce
otro lenguaje.

**b. No regular.** Sea $n$ la constante. $w = a^nb^{2n} \in L_2$, $|w| \geq n$. Toda descomposición
$w = xyz$ con $|xy| \leq n$ y $|y| \geq 1$ tiene $y = a^k$ con $1 \leq k \leq n$. Entonces
$xy^0z = a^{n-k}b^{2n}$, y $2n \neq 2(n-k)$ porque $k \geq 1$. Luego $xy^0z \notin L_2$.

**c. Regular.** Estados = residuo módulo 3 del prefijo leído, con $\delta(r,d) = (2r+d) \bmod 3$
(agregar un dígito a la derecha duplica el valor y suma el dígito). Como $L_3 \subseteq \Sigma^+$,
hace falta un estado inicial aparte que rechace $\lambda$: el AFD mínimo tiene **4** estados, no 3.
Final: el estado de residuo $0$ alcanzado con al menos un símbolo.

⚠ **Trampa.** Olvidar que $\lambda \notin L_3$. Es el mismo mecanismo del ítem 1.e de la guía 2
(módulo 5), con la misma trampa.

**d.** El lema dice $L$ regular $\Rightarrow \exists n\ \forall w \in L, |w| \geq n\ \exists xyz \dots$
Para **negarlo** hay que dar, **para cada $n$**, una palabra $w \in L$ con $|w| \geq n$ tal que
**toda** descomposición admisible tenga algún $m$ con $xy^mz \notin L$. Exhibir una sola palabra
para un $n$ elegido por vos invierte el $\exists n$: la constante la elige el adversario. Y analizar
una sola descomposición invierte el $\forall$ interno.

---

## Ejercicio 4

**a.** $\Gamma = \{Z_0, A\}$. Leyendo $a$: apilar $A$. Leyendo $b$: no tocar la pila (estado
«fase $b$»). Leyendo $c$: desapilar $A$ (estado «fase $c$»). Aceptar con $Z_0$ en el tope al
terminar. **Es determinístico**: el símbolo leído determina la fase sin ambigüedad ($a$, $b$ y $c$
son distintos), y los casos $n=0$ y $m=0$ salen con transiciones $\lambda$ que no compiten con
ninguna lectura.

**b.** Sea $p$ la constante del lema para LC y $z = a^pb^pc^p$. Para toda
$z = uvwxy$ con $|vwx| \leq p$ y $|vx| \geq 1$: como $|vwx| \leq p$, $vwx$ **no puede tocar a la vez
las $a$ y las $c$** (están separadas por $p$ símbolos $b$). Entonces $uv^2wx^2y$ aumenta la cantidad
de al menos una letra y deja fija la de al menos otra, luego las tres cantidades dejan de ser
iguales y $uv^2wx^2y \notin L_2$.

**c.** $L_3 = \{a^nb^nc^k : n,k \geq 0\}$ y $L_4 = \{a^kb^nc^n : n,k \geq 0\}$. Ambos son libres de
contexto (AP que aparea $a$ con $b$ ignorando las $c$, y viceversa). $L_3 \cap L_4 = L_2$, que no es
LC. Luego **los LC no son cerrados por intersección**.

⚠ **Trampa.** Sí son cerrados por intersección **con un lenguaje regular** — que es la herramienta
que usás todo el tiempo en el ejercicio 3 de los otros modelos. No confundir las dos afirmaciones.
