# Soluciones — Ejercicios nivel parcial, Guía 01: Lenguajes

> Leer una solución no es estudiar. Si abriste esto sin haber escrito nada, el ejercicio queda
> quemado como diagnóstico: marcalo y volvé a él en dos semanas con una variante.
> Cada solución termina, cuando corresponde, con **⚠ Trampa**: el error que el ejercicio está
> diseñado para cazar. Esos van a `errores.md`.

Notación y definiciones recursivas: ver [`enunciados.md`](enunciados.md).

**Hechos básicos que uso libremente** (todos salen por inducción directa y conviene tenerlos probados una vez):

- (H1) Asociatividad: $(\alpha\beta)\gamma = \alpha(\beta\gamma)$.
- (H2) $|\alpha\beta| = |\alpha| + |\beta|$ (B1).
- (H3) $(\alpha\beta)^r = \beta^r\alpha^r$ y $(\alpha^r)^r = \alpha$ (B2).
- (H4) Descomposición única por izquierda: toda $\alpha \neq \lambda$ se escribe de manera única como $\alpha = a\alpha_1$ con $a \in \Sigma$ (y análogamente por derecha, $\alpha = \alpha_1 a$).
- (H5) Monotonía: $L_1 \subseteq L_2 \implies L_1^* \subseteq L_2^*$, $\ \mathrm{Ini}(L_1) \subseteq \mathrm{Ini}(L_2)$, ídem $\mathrm{Fin}, \mathrm{Sub}$.
- (H6) $L^*L^* = L^*$, $(L^*)^* = L^*$, $\lambda \in L^*$ para todo $L$ (incluso $L = \emptyset$).

---

## Bloque A

### A1

$\Sigma^* = \bigcup_{i \geq 0}\Sigma^i$, $\ \Sigma^+ = \bigcup_{i \geq 1}\Sigma^i$; longitud y reverso como en las definiciones recursivas; $L_1L_2 = \{\alpha\beta : \alpha \in L_1, \beta \in L_2\}$; $L^0 = \Lambda$, $L^{n+1} = L^nL$; $L^* = \bigcup_{n\geq 0}L^n$, $L^+ = \bigcup_{n\geq 1}L^n$;
$\mathrm{Ini}(L) = \{\alpha : \exists\beta,\ \alpha\beta \in L\}$, $\ \mathrm{Fin}(L) = \{\beta : \exists\alpha,\ \alpha\beta \in L\}$, $\ \mathrm{Sub}(L) = \{\beta : \exists\alpha,\gamma,\ \alpha\beta\gamma \in L\}$.
Orden longitud-lexicográfico: $\alpha < \beta$ sii $|\alpha| < |\beta|$, o bien $|\alpha| = |\beta|$ y $\alpha$ precede a $\beta$ lexicográficamente (primera posición donde difieren).

| Afirmación | | Razón |
|---|---|---|
| $\lambda \in \emptyset^*$ | **V** | $\emptyset^0 = \Lambda$ por definición, y $\emptyset^* \supseteq \emptyset^0$. Es decir $\emptyset^* = \Lambda \neq \emptyset$. |
| $\emptyset^+ = \emptyset$ | **V** | $\emptyset^n = \emptyset$ para $n \geq 1$; la unión desde $n=1$ es vacía. |
| $\Lambda^* = \Lambda$ | **V** | $\Lambda^n = \Lambda$ para todo $n \geq 0$. |
| $\emptyset \subseteq \Sigma^*$ | **V** | El vacío es subconjunto de todo; $\emptyset$ es un lenguaje legítimo. |
| $|\Sigma^0| = 1$ | **V** | $\Sigma^0 = \{\lambda\}$, que tiene un elemento (la palabra vacía). |
| $\Sigma^* \subseteq \Sigma^+$ | **F** | $\lambda \in \Sigma^*$ y $\lambda \notin \Sigma^+$. Vale la inclusión recíproca. |

**⚠ Trampa.** $\emptyset^* = \{\lambda\}$, no $\emptyset$. La estrella *siempre* aporta $\lambda$ (H6): es la fuente número uno de errores de este tema y reaparece en C8 y en C1.

### A2

**(a)** $L_1^2 = \{aa,\ aab,\ aba,\ abab\}$.  $L_2^2 = \{aa,\ aaa,\ aaaa\}$.

**(b)** $|L_1^n| = 2^n$. Basta ver que la función $\{a,ab\}^n \to \Sigma^*$, $(w_1,\dots,w_n) \mapsto w_1\cdots w_n$, es inyectiva. Sea $w = w_1\cdots w_n$ con $w_i \in L_1$. Toda palabra de $L_1$ empieza con $a$, así que $w$ empieza con $a$; miro el segundo símbolo de $w$:
- si $w = a$ o el segundo símbolo es $a$, entonces $w_1 = a$ (si fuese $w_1 = ab$, el segundo símbolo sería $b$);
- si el segundo símbolo es $b$, entonces $w_1 = ab$ (si fuese $w_1 = a$, ese $b$ debería iniciar $w_2$, imposible).

En ambos casos $w_1$ queda determinado por $w$; cancelando por izquierda (B3) se repite el argumento con $w_2\cdots w_n$, e inductivamente toda la factorización queda determinada. Luego la función es inyectiva y $|L_1^n| = |\{a,ab\}^n| = 2^n$.

$|L_2^n| = n+1$: $L_2^n = \{a^k : n \leq k \leq 2n\}$. En efecto, un producto de $n$ factores de $\{a,aa\}$ con $j$ factores iguales a $aa$ da $a^{n+j}$ con $0 \leq j \leq n$; recíprocamente todo $a^{n+j}$ con $0\leq j \leq n$ se obtiene así. Son $n+1$ palabras distintas.

**(c)** $L_1$ es un **código** (la factorización de cada palabra es única: ningún elemento es sufijo de otro), $L_2$ no lo es: $a\cdot aa = aa \cdot a$. Sin unicidad de factorización, $|L^n|$ colapsa muy por debajo de $|L|^n$.

### A3

$AB = \{b,\ ab,\ aab\}$ (ojo: $\lambda\cdot ab = a\cdot b = ab$ aparece dos veces y se cuenta una).
$BA = \{b,\ ba,\ ab,\ aba\}$ — nótese $AB \neq BA$.
$(AB)^r = \{b,\ ba,\ baa\}$.
$A \cap B^* = \{\lambda\}$: $\lambda \in B^*$ siempre; $a \notin B^*$ porque toda palabra no vacía de $B^*$ termina en $b$.
$A^c = \Sigma^* \setminus \{\lambda, a\}$ con $\Sigma = \{a,b\}$.
$A^0B^2 = \Lambda B^2 = B^2 = \{bb,\ bab,\ abb,\ abab\}$.
$A\emptyset B = \emptyset$ (concatenar con $\emptyset$ aniquila; ver C12).
$A\Lambda B = AB = \{b,\ ab,\ aab\}$ ($\Lambda$ es el neutro).

**⚠ Trampa.** $\emptyset$ es el aniquilador y $\Lambda$ el neutro del producto de lenguajes. Confundirlos rompe todo el bloque C.

### A4

**(a)** $\mathrm{Sub}(\{a^n\}) = \{a^k : 0 \leq k \leq n\}$: **$n+1$**.

**(b)** $\mathrm{Ini}(\{a^nb^n\}) = \{a^i : 0\leq i \leq n\} \cup \{a^nb^j : 1 \leq j \leq n\}$: $(n+1) + n = \mathbf{2n+1}$ (el $j=0$ ya estaba contado como $a^n$).

$\mathrm{Sub}(\{a^nb^n\}) = \{a^ib^j : 0 \leq i,j \leq n\}$. Toda subcadena es un tramo contiguo, luego de la forma $a^ib^j$ con $i,j\leq n$; y toda $a^ib^j$ con $i,j \leq n$ es contigua (tomar el tramo que termina en el borde entre bloques). Son todas distintas: $(i,j)$ se recupera de la palabra. Total **$(n+1)^2$**.

**(c)** $\mathrm{Sub}(\{(ab)^n\}) = \{\lambda\} \cup \{$alternadas de longitud $k$ que empiezan con $a$, $1\leq k \leq 2n\} \cup \{$alternadas de longitud $k$ que empiezan con $b$, $1 \leq k \leq 2n-1\}$. Para cada longitud y cada símbolo inicial hay a lo sumo una palabra alternada, y existe como factor exactamente en los rangos indicados. Total: $1 + 2n + (2n-1) = \mathbf{4n}$. (Chequeo: $n=1$, $ab$: $\lambda, a, b, ab$ → $4$. $n=2$, $abab$: $\lambda,a,b,ab,ba,aba,bab,abab$ → $8$.)

### A5

**(a)** Con $a \mapsto 1$, $b \mapsto 2$: $\mathrm{ind}(abba) = 1\cdot 2^3 + 2\cdot 2^2 + 2 \cdot 2 + 1 = 8+8+4+1 = \mathbf{21}$.

Palabra de índice $100$ (decodificación: mientras $n > 0$, si $n$ es impar el último símbolo es $a$ y $n \leftarrow (n-1)/2$; si es par, el último símbolo es $b$ y $n \leftarrow (n-2)/2$):
$100 \to b,\ 49 \to a,\ 24 \to b,\ 11 \to a,\ 5 \to a,\ 2 \to b,\ 0$. Leyendo los símbolos en orden inverso al que salieron: $\mathbf{baabab}$.
Verificación: $2\cdot 32 + 1\cdot 16 + 1 \cdot 8 + 2\cdot 4 + 1\cdot 2 + 2 = 100$ ✓. Segunda verificación independiente: hay $1+2+4+8+16+32 = 63$ palabras de longitud $\leq 5$ (índices $0$ a $62$), así que la de índice $100$ es la de rango $37$ (base $0$) entre las de longitud $6$; $37 = 100101_2$, y con $0\mapsto a$, $1 \mapsto b$ da $baabab$ ✓.

**(b)** Para $\Sigma = \{a,b\}$ y $d_i = 1$ si $c_i = a$, $d_i = 2$ si $c_i = b$:
$$\mathrm{ind}(c_1\cdots c_n) = \sum_{i=1}^{n} d_i\, 2^{\,n-i}.$$
Equivalentemente $\mathrm{ind}(\alpha) = \underbrace{(2^n - 1)}_{\#\{\beta\,:\,|\beta| < n\}} + \underbrace{\sum_{i=1}^n (d_i - 1)2^{n-i}}_{\text{rango lexicográfico dentro de }\Sigma^n}$, que da lo mismo porque $\sum_{i=1}^{n}2^{n-i} = 2^n-1$.

**(c)** Dos demostraciones; en el parcial alcanza una.

*Vía orden.* En el orden longitud-lexicográfico, cada palabra $\alpha$ tiene **finitos** predecesores: las de longitud menor son $\sum_{i<|\alpha|}2^i = 2^{|\alpha|}-1$, y las de su misma longitud son a lo sumo $2^{|\alpha|}$. Además el orden es total y todo subconjunto no vacío tiene mínimo (tomar la longitud mínima, y dentro de ella el mínimo lexicográfico, que existe por ser un conjunto finito). Un orden total, sin último elemento, en el que todo elemento tiene finitos predecesores, es isomorfo a $(\mathbb{N}_0,<)$; el isomorfismo es exactamente $\mathrm{ind}$.

*Vía fórmula.* La expresión de (b) es la **numeración biyectiva en base 2** (dígitos $1,2$ en vez de $0,1$). Inyectividad y sobreyectividad se prueban juntas por inducción fuerte en $n \in \mathbb{N}_0$: $n = 0$ solo lo representa la cadena vacía; para $n \geq 1$, el último dígito está forzado por la paridad de $n$ ($d_n = 1$ si $n$ impar, $d_n = 2$ si $n$ par, ya que $n \equiv d_n \pmod 2$), y el resto de la palabra es la representación de $(n - d_n)/2 < n$, que por hipótesis inductiva existe y es única.

Como $\mathrm{ind}$ es biyección, $|\Sigma^*| = |\mathbb{N}|$.

---

## Bloque B

### B1

Inducción **en $\beta$** (es la variable sobre la que recursan tanto $\cdot$ como $|\cdot|$; induciendo en $\alpha$ el término $\alpha\beta$ no se puede reducir con las definiciones dadas).

- *Base* $\beta = \lambda$: $|\alpha\lambda| = |\alpha| = |\alpha| + 0 = |\alpha| + |\lambda|$.
- *Paso* $\beta = \gamma a$, con HI para $\gamma$:
$$|\alpha(\gamma a)| \overset{\text{def}\cdot}{=} |(\alpha\gamma)a| \overset{\text{def}|\cdot|}{=} |\alpha\gamma| + 1 \overset{\text{HI}}{=} |\alpha| + |\gamma| + 1 = |\alpha| + |\gamma a|. \qquad \blacksquare$$

### B2

Inducción en $\beta$.
- *Base* $\beta = \lambda$: $(\alpha\lambda)^r = \alpha^r = \lambda\alpha^r = \lambda^r\alpha^r$.
- *Paso* $\beta = \gamma a$: $(\alpha(\gamma a))^r = ((\alpha\gamma)a)^r = a(\alpha\gamma)^r \overset{\text{HI}}{=} a(\gamma^r\alpha^r) \overset{\text{(H1)}}{=} (a\gamma^r)\alpha^r = (\gamma a)^r\alpha^r$. $\blacksquare$

$(\alpha^r)^r = \alpha$: inducción en $\alpha$. Base $\lambda$ trivial. Paso $\alpha = \gamma a$: $((\gamma a)^r)^r = (a\gamma^r)^r \overset{\text{B2}}{=} (\gamma^r)^r a^r = \gamma a$.

$(\alpha^n)^r = (\alpha^r)^n$: inducción en $n$. Base $n=0$: $\lambda^r = \lambda$. Paso: $(\alpha^{n+1})^r = (\alpha^n\alpha)^r = \alpha^r(\alpha^n)^r \overset{\text{HI}}{=} \alpha^r(\alpha^r)^n = (\alpha^r)^{n+1}$.

**⚠ Trampa.** El orden se invierte: $(\alpha\beta)^r = \beta^r\alpha^r$, no $\alpha^r\beta^r$. En cambio con potencias de *una sola* palabra no hay inversión, y por eso $(\alpha^n)^r = (\alpha^r)^n$ sí vale.

### B3

**(b) primero** (es la que sale directo con las definiciones que recursan por derecha). Inducción en $\alpha$:
- Base $\alpha = \lambda$: $\gamma\lambda = \gamma$ y $\delta\lambda = \delta$, luego $\gamma = \delta$.
- Paso $\alpha = \alpha' a$: $\gamma(\alpha'a) = (\gamma\alpha')a$ y $\delta(\alpha'a) = (\delta\alpha')a$. Por (H4) la escritura $\mu a$ de una palabra no vacía es única, luego $\gamma\alpha' = \delta\alpha'$ y por HI $\gamma = \delta$.

**(a)** Sale de (b) por reverso: $\alpha\gamma = \alpha\delta \implies (\alpha\gamma)^r = (\alpha\delta)^r \implies \gamma^r\alpha^r = \delta^r\alpha^r \overset{\text{(b)}}{\implies} \gamma^r = \delta^r \implies \gamma = (\gamma^r)^r = (\delta^r)^r = \delta$. $\blacksquare$

### B4 (Levi)

Inducción en $|\alpha|$.

- *Base* $|\alpha| = 0$, o sea $\alpha = \lambda$: tomo $\mu = \gamma$. Entonces $\gamma = \lambda\gamma = \alpha\mu$ ✓, y $\beta = \lambda\beta = \alpha\beta = \gamma\delta = \mu\delta$ ✓.
- *Paso* $|\alpha| \geq 1$: por (H4), $\alpha = a\alpha_1$. Como $|\gamma| \geq |\alpha| \geq 1$, también $\gamma = c\gamma_1$. Ahora $\alpha\beta = a(\alpha_1\beta)$ y $\gamma\delta = c(\gamma_1\delta)$; por unicidad de (H4) aplicada a la palabra $\alpha\beta = \gamma\delta$, resulta $a = c$ y $\alpha_1\beta = \gamma_1\delta$. Como $|\alpha_1| = |\alpha|-1 \leq |\gamma|-1 = |\gamma_1|$, la HI da $\mu$ con $\gamma_1 = \alpha_1\mu$ y $\beta = \mu\delta$. Entonces $\gamma = a\gamma_1 = a\alpha_1\mu = \alpha\mu$. $\blacksquare$

*Lectura del lema:* si dos factorizaciones producen la misma palabra, una "corta más tarde" que la otra y el pedazo intermedio $\mu$ es lo único que las separa. Es la herramienta estándar para todo argumento del tipo "comparar dos descomposiciones".

### B5 (conmutación)

**($\Leftarrow$)** $\gamma^n\gamma^m = \gamma^{n+m} = \gamma^m\gamma^n$.

**($\Rightarrow$)** Inducción fuerte en $|\alpha| + |\beta|$.

- Si $\alpha = \lambda$: tomo $\gamma = \beta$, $n = 0$, $m = 1$. Si $\beta = \lambda$: simétrico ($\gamma = \alpha$, $n=1$, $m=0$).
- Si ambas son no vacías: como el enunciado y la hipótesis son simétricos en $\alpha,\beta$, supongo $|\alpha| \leq |\beta|$ (esto **sí** es una simetría legítima, y hay que decirlo). Aplico Levi a la igualdad $\alpha\beta = \beta\alpha$ (con $\gamma := \beta$, $\delta := \alpha$ y $|\alpha| \leq |\beta|$): existe $\mu$ con
$$\beta = \alpha\mu \qquad\text{y}\qquad \beta = \mu\alpha .$$
De $\alpha\beta = \beta\alpha$ y $\beta = \alpha\mu$: $\ \alpha(\alpha\mu) = (\alpha\mu)\alpha$, y cancelando $\alpha$ por izquierda (B3), $\alpha\mu = \mu\alpha$. Como $|\alpha| \geq 1$, $|\mu| = |\beta| - |\alpha| < |\beta|$, así que $|\alpha| + |\mu| < |\alpha| + |\beta|$ y vale la HI: existen $\gamma, p, q$ con $\alpha = \gamma^p$ y $\mu = \gamma^q$. Entonces $\beta = \alpha\mu = \gamma^{p+q}$, y tomando $n = p$, $m = p+q$ termina. $\blacksquare$

*Corolario que se usa seguido:* dos palabras conmutan sii son potencias de una misma palabra; en particular, si $\alpha\beta = \beta\alpha$ con $\alpha,\beta \neq \lambda$, entonces $\alpha$ y $\beta$ son potencias de una raíz común.

### B6

**(a)** $(\alpha\alpha^r)^r = (\alpha^r)^r\alpha^r = \alpha\alpha^r$. $\blacksquare$

**(b)** $\alpha\beta \in P$ significa $\alpha\beta = (\alpha\beta)^r = \beta^r\alpha^r = \beta\alpha$ (usando $\alpha = \alpha^r$, $\beta = \beta^r$). $\blacksquare$

**(c)** Por B5, existen $\gamma$ y $n,m \geq 0$ con $\alpha = \gamma^n$, $\beta = \gamma^m$: dos palíndromos cuyo producto es palíndromo son potencias de una misma palabra. (Y esa $\gamma$ puede tomarse palíndroma: si $\alpha \neq \lambda$, la raíz primitiva de $\alpha$ hereda la simetría.)

**(d)** No: $\alpha = a$, $\beta = b$ son palíndromos y $ab \notin P$ pues $(ab)^r = ba \neq ab$. Luego $P$ no es cerrado por concatenación.

### B7

Sea $Y = \{a^nb^n : n \geq 0\}$.

**$X \subseteq Y$** (acá se usa la minimalidad): $Y$ cumple las dos cláusulas — $\lambda = a^0b^0 \in Y$, y si $a^nb^n \in Y$ entonces $a(a^nb^n)b = a^{n+1}b^{n+1} \in Y$. Como $X$ es el **menor** conjunto que las cumple, $X \subseteq Y$.

**$Y \subseteq X$** (inducción en $n$): $n = 0$: $\lambda \in X$ por la primera cláusula. Paso: si $a^nb^n \in X$, la segunda cláusula da $a(a^nb^n)b = a^{n+1}b^{n+1} \in X$. $\blacksquare$

**⚠ Trampa.** Las dos inclusiones no son la misma inducción: una usa las cláusulas para *generar*, la otra usa la minimalidad para *acotar*. Probar solo la segunda deja abierto que $X$ tenga basura de más.

---

## Bloque C

### C1 — **Falso**

$L = \Lambda$: $L^+ = \Lambda = \{\lambda\}$ pero $L^* \setminus \{\lambda\} = \Lambda\setminus\{\lambda\} = \emptyset$. Palabra que separa: $\lambda \in L^+$, $\lambda \notin L^*\setminus\{\lambda\}$.

Lo que **sí** vale siempre: $L^* = L^+ \cup \{\lambda\}$, y $L^+ = L^*\setminus\{\lambda\}$ exactamente cuando $\lambda \notin L$.

### C2 — **Verdadero**

Sea $M = L \setminus \{\lambda\}$.
$\supseteq$: $M \subseteq L$, luego $M^* \subseteq L^*$ por (H5).
$\subseteq$: sea $w \in L^*$, $w = w_1\cdots w_n$ con $w_i \in L$. Borrando de la lista los $w_i$ que son $\lambda$ (lo cual no cambia el producto, porque $\lambda$ es neutro) queda $w = w_{i_1}\cdots w_{i_k}$ con todos los factores en $M$, o sea $w \in M^k \subseteq M^*$ (si se borran todos, $w = \lambda \in M^0 \subseteq M^*$). $\blacksquare$

### C3 — **Verdadero**

($\Leftarrow$) Si $\lambda \in L$: $L^0 = \{\lambda\} \subseteq L = L^1 \subseteq L^+$ y $L^n \subseteq L^+$ para $n \geq 1$; luego $L^* \subseteq L^+$. La inclusión $L^+ \subseteq L^*$ es por definición.
($\Rightarrow$) Si $L^+ = L^*$, entonces $\lambda \in L^*= L^+$, así que $\lambda = w_1\cdots w_n$ con $n \geq 1$ y $w_i \in L$. Por (H2), $0 = |\lambda| = \sum_i |w_i|$, luego todos los $w_i = \lambda$ y en particular $\lambda = w_1 \in L$. $\blacksquare$

### C4 — **Falso**

Vale siempre $L(L_1\cap L_2) \subseteq LL_1 \cap LL_2$ (si $w = uv$ con $u \in L$, $v \in L_1\cap L_2$, entonces $w$ está en ambos productos).

Contraejemplo para la otra inclusión: $L = \{a,aa\}$, $L_1 = \{a\}$, $L_2 = \{aa\}$. Como $L_1 \cap L_2 = \emptyset$, el lado izquierdo es $\emptyset$. Pero $LL_1 = \{aa, aaa\}$ y $LL_2 = \{aaa,aaaa\}$, de donde $LL_1\cap LL_2 = \{aaa\} \neq \emptyset$. Palabra que separa: $aaa$ (dos factorizaciones distintas, $a\cdot aa$ y $aa \cdot a$).

**⚠ Trampa.** La concatenación distribuye sobre $\cup$ pero **no** sobre $\cap$: el mismo $w$ puede llegar a cada lado con factorizaciones distintas.

### C5 — **Verdadero**

$\subseteq$: $L_1 \cup L_2 \subseteq L_1^*L_2^*$, porque $u \in L_1 \Rightarrow u = u\lambda \in L_1^*L_2^*$ y $v \in L_2 \Rightarrow v = \lambda v \in L_1^*L_2^*$. Por (H5), $(L_1\cup L_2)^* \subseteq (L_1^*L_2^*)^*$.
$\supseteq$: $L_i^* \subseteq (L_1\cup L_2)^*$ por (H5), luego
$$L_1^*L_2^* \subseteq (L_1\cup L_2)^*(L_1\cup L_2)^* \overset{\text{(H6)}}{=} (L_1\cup L_2)^*,$$
y aplicando $^*$ a ambos lados, $(L_1^*L_2^*)^* \subseteq ((L_1\cup L_2)^*)^* \overset{\text{(H6)}}{=} (L_1\cup L_2)^*$. $\blacksquare$

### C6 — **Verdadero**

$\subseteq$: sea $w \in (L_1L_2)^nL_1$. Entonces $w = (u_1v_1)(u_2v_2)\cdots(u_nv_n)u_{n+1}$ con $u_i \in L_1$, $v_i \in L_2$. Reagrupando con (H1):
$$w = u_1\,(v_1u_2)\,(v_2u_3)\cdots(v_nu_{n+1}) \in L_1(L_2L_1)^n \subseteq L_1(L_2L_1)^*.$$
$\supseteq$: sea $w \in L_1(L_2L_1)^n$, o sea $w = u_1(v_1u_2)(v_2u_3)\cdots(v_nu_{n+1})$; el mismo reagrupamiento al revés da $w = (u_1v_1)\cdots(u_nv_n)u_{n+1} \in (L_1L_2)^nL_1$. $\blacksquare$

(Formalmente cada inclusión es una inducción en $n$; el reagrupamiento es el paso inductivo.)

### C7 — **Falso**

$\Sigma = \{a\}$, $L = \{a\}^* = a^*$ (no vacío), $L_1 = \Lambda$, $L_2 = \{\lambda, a\}$:
$$L_1L = a^*, \qquad L_2L = \{\lambda,a\}a^* = a^* \cup aa^* = a^*.$$
Entonces $L_1L = L_2L$ pero $L_1 \neq L_2$ (la palabra $a$ está en $L_2$ y no en $L_1$).

**⚠ Trampa.** No hay ley de cancelación para lenguajes, ni siquiera pidiendo $L \neq \emptyset$ o $\lambda \notin L$ (variante: $L = a^+$ con los mismos $L_1,L_2$ da $L_1L = L_2L = a^+$). La cancelación de B3 es para **cadenas**, no para lenguajes.

### C8 — **Verdadero**

Para todo $L$: $\lambda \in (L^c)^*$ porque toda estrella contiene $\lambda$ (H6). Y $\lambda \in L^*$ por lo mismo, luego $\lambda \notin (L^*)^c$. Entonces $\lambda$ pertenece a uno y no al otro, de donde $(L^c)^* \neq (L^*)^c$ cualquiera sea $L$. $\blacksquare$

(Observar que no hizo falta calcular nada: alcanzó con una palabra testigo elegida por lo que la definición garantiza.)

### C9 — **Verdadero**

($\Leftarrow$) $L \subseteq \Lambda$ significa $L = \emptyset$ o $L = \Lambda$; en ambos casos $L^* = \Lambda$, finito.
($\Rightarrow$) Contrarrecíproco: si $L \not\subseteq \Lambda$, existe $w \in L$ con $w \neq \lambda$. Entonces $\{w^n : n \geq 0\} \subseteq L^*$, y estas palabras son todas distintas porque $|w^n| = n|w|$ con $|w| \geq 1$ (H2). Luego $L^*$ es infinito. $\blacksquare$

### C10 — **Verdadero**

$w \in (L^*)^r \iff w^r \in L^* \iff w^r = u_1\cdots u_n$ con $u_i \in L$, $n \geq 0$. Aplicando reverso (H3): $w = (w^r)^r = (u_1\cdots u_n)^r = u_n^r\cdots u_1^r$, y cada $u_i^r \in L^r$, o sea $w \in (L^r)^n \subseteq (L^r)^*$. Todos los pasos son equivalencias (el reverso es involutivo), así que vale la doble inclusión. El caso $n = 0$ da $w = \lambda$, que está en ambos lados. $\blacksquare$

### C11 — **Verdadero**

Clave: $w \in M^r \iff w^r \in M$ (por involutividad de $^r$). Entonces
$$w \in (L_1\setminus L_2)^r \iff w^r \in L_1 \setminus L_2 \iff (w^r \in L_1 \wedge w^r \notin L_2) \iff (w \in L_1^r \wedge w \notin L_2^r) \iff w \in L_1^r \setminus L_2^r.$$
El mismo argumento vale para $\cup$, $\cap$ y complemento: el reverso es una **biyección** de $\Sigma^*$ en sí mismo y por eso conmuta con todas las operaciones booleanas. (Con concatenación y estrella **no** conmuta: ahí invierte el orden, C10.) $\blacksquare$

### C12 — **Verdadero**

($\Leftarrow$) Si alguno es $\emptyset$ no hay pares $(u,v)$ que formar, luego el producto es $\emptyset$.
($\Rightarrow$) Contrarrecíproco: si $L_1 \neq \emptyset$ y $L_2 \neq \emptyset$, tomo $u \in L_1$, $v \in L_2$; entonces $uv \in L_1L_2 \neq \emptyset$. $\blacksquare$

### C13 — **Falso** (por un único lenguaje: $L = \emptyset$)

Contraejemplo a la ida: $L = \emptyset$ cumple $L^2 = \emptyset$, luego $L \subseteq L^2$, pero $\lambda \notin \emptyset$.

Enunciado corregido y demostración: **si $L \neq \emptyset$, entonces $L \subseteq L^2 \iff \lambda \in L$.**

($\Leftarrow$) Si $\lambda \in L$: $L = L\Lambda \subseteq LL = L^2$.
($\Rightarrow$) Supongamos $L \subseteq L^2$, $L \neq \emptyset$ y $\lambda \notin L$. Como $L \neq \emptyset$, existe $w \in L$ de **longitud mínima** $m := |w|$ (el conjunto de longitudes es un subconjunto no vacío de $\mathbb{N}_0$, así que tiene mínimo), y $m \geq 1$ porque $\lambda \notin L$. Por hipótesis $w \in L^2$, o sea $w = uv$ con $u,v \in L$; por minimalidad $|u|,|v| \geq m$, y por (H2) $|w| = |u| + |v| \geq 2m > m = |w|$, absurdo. $\blacksquare$

**⚠ Trampa.** El "$\iff$" es cierto en espíritu y falso en la letra: $\emptyset$ satisface vacuamente casi cualquier inclusión. Antes de dar por verdadera una equivalencia, evaluar siempre en $\emptyset$ y en $\Lambda$ — cuesta diez segundos y decide la mitad de estos ítems.

---

## Bloque D

### D1

**La identidad vale exactamente cuando $L_2 \neq \emptyset$ o $L_1 = \emptyset$** (equivalentemente: falla sii $L_1 \neq \emptyset$ y $L_2 = \emptyset$).

*Contraejemplo cuando falla:* $L_1 = \{a\}$, $L_2 = \emptyset$. Entonces $L_1L_2 = \emptyset$ y $\mathrm{Ini}(\emptyset) = \emptyset$, mientras que $\mathrm{Ini}(L_1)\cup L_1\mathrm{Ini}(L_2) = \{\lambda,a\}\cup\emptyset = \{\lambda,a\}$. Palabra que separa: $a$ (o $\lambda$).

*Demostración suponiendo $L_2 \neq \emptyset$:*

$\supseteq$: sea $p \in \mathrm{Ini}(L_1)$, digamos $u = p p'$ con $u \in L_1$. Tomo cualquier $v \in L_2$ (existe por hipótesis, **acá se usa**): $uv = p(p'v) \in L_1L_2$, luego $p \in \mathrm{Ini}(L_1L_2)$. Sea ahora $p = uq$ con $u \in L_1$ y $q \in \mathrm{Ini}(L_2)$, digamos $v = qq'$ con $v \in L_2$: entonces $uv = u q q' = p q'$, con $uv \in L_1L_2$, luego $p \in \mathrm{Ini}(L_1L_2)$.

$\subseteq$: sea $p \in \mathrm{Ini}(L_1L_2)$, o sea $p p' = uv$ con $u \in L_1$, $v \in L_2$.
- Si $|p| \leq |u|$: por Levi (B4) aplicado a $pp' = uv$, existe $\mu$ con $u = p\mu$; luego $p \in \mathrm{Ini}(L_1)$.
- Si $|p| > |u|$: por Levi aplicado con los roles invertidos ($|u| \leq |p|$), existe $\mu$ con $p = u\mu$ y $v = \mu p'$; entonces $\mu \in \mathrm{Ini}(L_2)$ y $p = u\mu \in L_1\mathrm{Ini}(L_2)$. $\blacksquare$

*Sobre el ejercicio 11.c de la guía* ($\mathrm{Fin}(L_1L_2) = \mathrm{Fin}(L_2)\cup \mathrm{Fin}(L_1)L_2$): tiene el hueco espejado. Falla sii $L_1 = \emptyset$ y $L_2 \neq \emptyset$ (con $L_1 = \emptyset$, $L_2 = \{a\}$: izquierda $\emptyset$, derecha $\{\lambda,a\}$). En un parcial, señalar la hipótesis faltante y demostrar el enunciado corregido suma; asumirla en silencio, no.

### D2

**$\mathrm{Fin}(L)^r = \mathrm{Ini}(L^r)$.**
$\beta \in \mathrm{Fin}(L)^r \iff \beta^r \in \mathrm{Fin}(L) \iff \exists \alpha: \alpha\beta^r \in L \iff \exists\alpha: (\alpha\beta^r)^r = \beta\alpha^r \in L^r \iff \beta \in \mathrm{Ini}(L^r)$.
(La última equivalencia: si $\beta\gamma \in L^r$ para algún $\gamma$, basta tomar $\alpha = \gamma^r$ y usar involutividad.) $\blacksquare$

**$\mathrm{Sub}(L^r) = \mathrm{Sub}(L)^r$.**
$\beta \in \mathrm{Sub}(L^r) \iff \exists\alpha,\gamma: \alpha\beta\gamma \in L^r \iff \exists\alpha,\gamma: \gamma^r\beta^r\alpha^r \in L \iff \beta^r \in \mathrm{Sub}(L) \iff \beta \in \mathrm{Sub}(L)^r$. $\blacksquare$

### D3

$$\beta \in \mathrm{Ini}(\mathrm{Fin}(L)) \iff \exists\gamma:\ \beta\gamma \in \mathrm{Fin}(L) \iff \exists\gamma\,\exists\alpha:\ \alpha(\beta\gamma) \in L \overset{\text{(H1)}}{\iff} \exists\alpha,\gamma:\ \alpha\beta\gamma \in L \iff \beta \in \mathrm{Sub}(L).$$
$$\beta \in \mathrm{Fin}(\mathrm{Ini}(L)) \iff \exists\alpha:\ \alpha\beta \in \mathrm{Ini}(L) \iff \exists\alpha\,\exists\gamma:\ (\alpha\beta)\gamma \in L \iff \beta \in \mathrm{Sub}(L). \qquad\blacksquare$$
La asociatividad (H1) es literalmente el contenido de la identidad: "cortar por izquierda y después por derecha" es lo mismo que "cortar de una".

### D4

**Con $\cap$: falso.** $L_1 = \{ab\}$, $L_2 = \{ba\}$: $L_1 \cap L_2 = \emptyset$, luego el lado izquierdo es $\emptyset$; pero $\mathrm{Sub}(L_1) = \{\lambda,a,b,ab\}$ y $\mathrm{Sub}(L_2) = \{\lambda,a,b,ba\}$, cuya intersección es $\{\lambda,a,b\}$. Palabra que separa: $a$.
Vale siempre la inclusión $\subseteq$ (por monotonía, H5).

**Con $\cup$: verdadero.** $\beta \in \mathrm{Sub}(L_1\cup L_2) \iff \exists\alpha,\gamma: \alpha\beta\gamma \in L_1\cup L_2 \iff (\exists\alpha,\gamma: \alpha\beta\gamma \in L_1) \vee (\exists\alpha,\gamma: \alpha\beta\gamma\in L_2) \iff \beta \in \mathrm{Sub}(L_1)\cup\mathrm{Sub}(L_2)$. (El cuantificador existencial conmuta con $\vee$ pero no con $\wedge$: esa es exactamente la asimetría entre los dos ítems.)

### D5

**La identidad $\mathrm{Ini}(L^*) = L^*\mathrm{Ini}(L)$ vale sii $L \neq \emptyset$.**

*Caso $L = \emptyset$:* $L^* = \Lambda$, luego $\mathrm{Ini}(L^*) = \{\lambda\}$, mientras que $L^*\mathrm{Ini}(L) = \Lambda\cdot\emptyset = \emptyset$. Falla.

*Caso $L \neq \emptyset$:*

$\supseteq$: si $u \in L^*$ y $p \in \mathrm{Ini}(L)$ con $pp' = w \in L$, entonces $up$ es prefijo de $uw \in L^*$.

$\subseteq$: sea $p \in \mathrm{Ini}(L^*)$, o sea $p$ prefijo de $w_1w_2\cdots w_n$ con $w_i \in L$, $n \geq 0$.
- Si $n = 0$: $p = \lambda$. Como $L \neq \emptyset$, $\lambda \in \mathrm{Ini}(L)$, y $\lambda \in L^*$; luego $p = \lambda\cdot\lambda \in L^*\mathrm{Ini}(L)$. (**Acá y solo acá se usa $L \neq \emptyset$**.)
- Si $n \geq 1$: sea $k$ el mayor índice $0 \leq k \leq n$ tal que $w_1\cdots w_k$ es prefijo de $p$ (existe: $k=0$ siempre sirve). Si $k = n$, entonces $p = w_1\cdots w_n$ y $p = (w_1\cdots w_n)\cdot\lambda \in L^*\mathrm{Ini}(L)$. Si $k < n$, por Levi $p = w_1\cdots w_k\, p'$ donde $p'$ es prefijo propio de $w_{k+1}$ (si $p'$ contuviera a $w_{k+1}$ entero, $k$ no sería máximo). Luego $p' \in \mathrm{Ini}(L)$ y $p \in L^*\mathrm{Ini}(L)$. $\blacksquare$

### D6

**(a)** ($\Leftarrow$) Si $\mathrm{Ini}(L) = L$ entonces en particular $\mathrm{Ini}(L)\subseteq L$. ($\Rightarrow$) Siempre vale $L \subseteq \mathrm{Ini}(L)$ (toda $w$ es prefijo de sí misma: $w = w\lambda$); con la hipótesis $\mathrm{Ini}(L)\subseteq L$ queda la igualdad.

**(b)** Tres cosas: (i) $L \subseteq \mathrm{Ini}(L)$, ya visto. (ii) $\mathrm{Ini}(L)$ es cerrado por prefijos: si $p$ es prefijo de $q$ y $q$ es prefijo de $w \in L$, entonces $q = p\mu$ y $w = q\nu = p(\mu\nu)$ por (H1), o sea $p$ es prefijo de $w$, luego $p \in \mathrm{Ini}(L)$. (iii) Minimalidad: si $M$ es cerrado por prefijos y $L \subseteq M$, entonces $\mathrm{Ini}(L) \subseteq \mathrm{Ini}(M) = M$, usando (H5) y (a). $\blacksquare$

**(c)** Por (b)(ii), $\mathrm{Ini}(L)$ es cerrado por prefijos; aplicándole (a) a ese lenguaje: $\mathrm{Ini}(\mathrm{Ini}(L)) = \mathrm{Ini}(L)$. (Es el mismo patrón que los ítems 11.a y 11.b de la guía: idempotencia = "es un operador de clausura".)

### D7

**(a)** $\beta \in (\Sigma^*)^{-1}L \iff \exists \alpha \in \Sigma^*: \alpha\beta \in L \iff \beta \in \mathrm{Fin}(L)$: es la definición de sufijo. $\blacksquare$
(Análogamente $\mathrm{Ini}(L) = \{\alpha : \alpha^{-1}L \neq \emptyset\}$, que es otra forma útil de decir lo mismo.)

**(b)** $\beta \in (L_1\cup L_2)^{-1}L \iff \exists\alpha \in L_1\cup L_2: \alpha\beta \in L \iff (\exists\alpha\in L_1: \alpha\beta\in L) \vee (\exists\alpha\in L_2:\alpha\beta\in L) \iff \beta \in L_1^{-1}L \cup L_2^{-1}L$. $\blacksquare$

**(c)** $\beta \in (L_1L_2)^{-1}L \iff \exists u \in L_1, v\in L_2: (uv)\beta \in L \overset{\text{(H1)}}{\iff} \exists u \in L_1, v \in L_2: u(v\beta) \in L \iff \exists v \in L_2: v\beta \in L_1^{-1}L \iff \beta \in L_2^{-1}(L_1^{-1}L)$. $\blacksquare$
(Notar la inversión del orden, como en el reverso.)

**(d)**
$$\alpha^{-1}(L_1L_2) \;=\; (\alpha^{-1}L_1)\,L_2 \;\cup\; \bigcup_{\substack{\alpha = u\mu \\ u \in L_1}} \mu^{-1}L_2 .$$

*Demostración.* $\beta \in \alpha^{-1}(L_1L_2)$ sii $\alpha\beta = uv$ con $u \in L_1$, $v\in L_2$. Por Levi, hay dos casos según dónde caiga el corte:
- $|u| \geq |\alpha|$: existe $\mu$ con $u = \alpha\mu$ y $\beta = \mu v$. Entonces $\mu \in \alpha^{-1}L_1$ y $\beta \in (\alpha^{-1}L_1)L_2$.
- $|u| < |\alpha|$: existe $\mu$ con $\alpha = u\mu$ y $v = \mu\beta$. Entonces $u \in L_1$, $\mu$ es el sufijo correspondiente de $\alpha$, y $\mu\beta = v \in L_2$, o sea $\beta \in \mu^{-1}L_2$.

Recíprocamente, cada caso produce un elemento del lado izquierdo, deshaciendo las igualdades. $\blacksquare$

*Por qué no alcanza $(\alpha^{-1}L_1)L_2$:* porque $\alpha$ puede pasarse de largo y consumir parte de $L_2$. Ejemplo: $L_1 = \{a\}$, $L_2 = \{bc\}$, $\alpha = ab$. Entonces $\alpha^{-1}(L_1L_2) = (ab)^{-1}\{abc\} = \{c\}$, mientras que $(\alpha^{-1}L_1)L_2 = \emptyset\cdot L_2 = \emptyset$.

### D8

**(a)** Toda $w \in L$ cumple $w = \lambda w \lambda$, luego $L \subseteq \mathrm{Sub}(L)$. Si $\mathrm{Sub}(L)$ es finito, un subconjunto suyo también lo es, así que $L$ es finito. $\blacksquare$
(Contrarrecíproco útil: $L$ infinito $\Rightarrow \mathrm{Sub}(L)$ infinito.)

**(b)** $L = \{\alpha\alpha : \alpha \in \Sigma^*\}$ con $\Sigma = \{a,b\}$. Es infinito ($a^na^n$ para todo $n$, todas distintas). Es propio: $a \notin L$, porque toda palabra de $L$ tiene longitud par (H2). Y $\mathrm{Sub}(L) = \Sigma^*$: dada $\alpha$ cualquiera, $\alpha$ es prefijo (luego subcadena) de $\alpha\alpha \in L$. $\blacksquare$

---

## Bloque E

### E1

$\Sigma$ finito con $|\Sigma| = k \geq 1$. Entonces $|\Sigma^i| = k^i$ es finito para cada $i$, y $\Sigma^* = \bigcup_{i\geq 0}\Sigma^i$ es unión numerable de conjuntos finitos, luego es numerable; y es infinito porque contiene $\{a^n : n\geq 0\}$ para cualquier $a \in \Sigma$ (todas distintas por longitud). Luego $|\Sigma^*| = |\mathbb{N}|$. La biyección explícita es la de A5 (orden longitud-lexicográfico), generalizada a $|\Sigma| = k$ como numeración biyectiva en base $k$.

**Dónde se usa la finitud:** en que cada $\Sigma^i$ sea finito, que es lo que hace que cada palabra tenga finitos predecesores y que el orden longitud-lexicográfico tenga tipo de orden $\omega$.

**Si $\Sigma$ fuese numerable infinito:** $\Sigma^*$ **sigue siendo numerable** (unión numerable de conjuntos numerables, o codificando $a_{i_1}\cdots a_{i_n} \mapsto p_1^{i_1}\cdots p_n^{i_n}$ con primos distintos). Lo que se rompe es la *enumeración por longitud-lexicográfico*: ya $\Sigma^1$ es infinito, así que la palabra $a_1a_1$ tendría infinitos predecesores y ese orden deja de ser de tipo $\omega$. La conclusión sobrevive; el método, no.

### E2

Supongamos que $\mathcal{P}(\Sigma^*)$ es numerable, digamos $\mathcal{P}(\Sigma^*) = \{L_0, L_1, L_2, \dots\}$ (todo lenguaje aparece en la lista). Por E1/A5, $\Sigma^*$ también es numerable: $\Sigma^* = \{w_0, w_1, w_2,\dots\}$ (por ejemplo en orden longitud-lexicográfico). Defino el lenguaje **diagonal**
$$D = \{w_i \in \Sigma^* : w_i \notin L_i\} \subseteq \Sigma^* .$$
$D$ es un lenguaje sobre $\Sigma$, así que $D = L_j$ para algún $j$. Pero entonces
$$w_j \in D \iff w_j \notin L_j = D,$$
absurdo. Luego no existe tal enumeración y $\mathcal{P}(\Sigma^*)$ no es numerable. $\blacksquare$

**Guardar el esqueleto:** *suponer enumeración → construir el objeto que difiere de cada elemento de la lista en el lugar $i$ → evaluar el objeto en su propio índice → contradicción.* Es literalmente el mismo movimiento que en el halting problem; la única diferencia es qué se pone en la diagonal.

### E3

Sea $\mathcal{F}$ el conjunto de los lenguajes finitos sobre $\Sigma$, y sea $\mathrm{ind}: \Sigma^* \to \mathbb{N}_0$ la biyección de A5/E1. Defino $f : \mathcal{F}\to\mathbb{N}_0$ por
$$f(F) = \sum_{w \in F} 2^{\,\mathrm{ind}(w)}$$
(la suma es finita porque $F$ lo es; $f(\emptyset) = 0$). $f$ es inyectiva por unicidad de la representación binaria: $f(F)$ tiene un $1$ en la posición $i$ exactamente cuando $w_i \in F$, así que $f(F) = f(G) \Rightarrow F = G$. Luego $\mathcal{F}$ es numerable. Y es infinito: los singuletes $\{w\}$, $w \in \Sigma^*$, son infinitos lenguajes finitos distintos. Por lo tanto $\mathcal{F}$ es numerable infinito. $\blacksquare$

(De hecho $f$ es biyección sobre $\mathbb{N}_0$: todo natural, escrito en binario, codifica un único lenguaje finito.)

### E4

Fijada cualquier convención que a cada cadena $d \in \Delta^*$ le asigne a lo sumo un lenguaje $\llbracket d\rrbracket \subseteq \Sigma^*$, el conjunto de lenguajes **describibles** es $\mathcal{D} = \{\llbracket d\rrbracket : d \in \Delta^*,\ \llbracket d \rrbracket \text{ definido}\}$, que es la imagen de un conjunto numerable ($\Delta^*$ es numerable por E1, pues $\Delta$ es finito) y por lo tanto es numerable. Por E2, $\mathcal{P}(\Sigma^*)$ no es numerable, así que $\mathcal{D} \subsetneq \mathcal{P}(\Sigma^*)$: existe $L \subseteq \Sigma^*$ que no es descripto por ninguna cadena. Más aún, "casi todos" los lenguajes no lo son, en el sentido de que los describibles son un subconjunto numerable de uno no numerable. $\blacksquare$

**Por qué no exhibe ningún $L$:** el argumento es puramente de cardinalidad — compara tamaños y concluye que el complemento es no vacío, sin construir un testigo. El diagonal de E2 *parece* un testigo, pero depende de una enumeración fijada de antemano de todos los lenguajes, que es justamente lo que se probó imposible; el diagonal contra una enumeración de los **describibles** sí es concreto, pero solo si esa enumeración es efectiva, y eso es una condición del segundo parcial, no de este tema.

### E5

Sea $L$ infinito y $k = |\Sigma| \geq 1$. Para cada $n$, el conjunto $\Sigma^{\leq n} = \bigcup_{i\leq n}\Sigma^i$ es finito (tiene $\sum_{i\leq n}k^i$ elementos).

Construyo la sucesión recursivamente. $\alpha_1$: cualquier palabra de $L$ (existe, $L \neq \emptyset$ por ser infinito). Dado $\alpha_j$, considero $L \cap \Sigma^{\leq |\alpha_j|}$, que es finito por ser subconjunto de un conjunto finito. Como $L$ es infinito, $L \not\subseteq \Sigma^{\leq|\alpha_j|}$, así que existe $\alpha_{j+1} \in L$ con $|\alpha_{j+1}| > |\alpha_j|$. La sucesión así construida cumple $|\alpha_1| < |\alpha_2| < \cdots$, y en particular $|\alpha_j| \geq j - 1 \to \infty$: $L$ tiene palabras de longitud arbitrariamente grande. $\blacksquare$

**Por qué importa más adelante:** el lema de bombeo empieza siempre con "sea $n$ la constante de bombeo, tomo $w \in L$ con $|w| \geq n$". Ese "tomo" es exactamente este lema, y necesita que $L$ sea infinito y que $\Sigma$ sea finito. Si en un parcial hay que justificar la existencia de la palabra, se justifica así.

---

## Bloque F — Simulacro: soluciones y criterio de corrección

**F1.**
a. **Falso** — ver C1 ($L = \Lambda$; separa $\lambda$).
b. **Falso** — $L_1 = \{a\}$, $L_2 = \{aa\}$: $(L_1\cap L_2)^* = \emptyset^* = \Lambda$, pero $L_1^*\cap L_2^* = a^*\cap(aa)^* = (aa)^*$. Palabra que separa: $aa$.
   (Vale siempre $\subseteq$, por monotonía.)
c. **Falso** — ver C13: $L = \emptyset$ es contraejemplo de la ida; con $L \neq \emptyset$ la equivalencia es verdadera y se demuestra con el argumento de la palabra de longitud mínima.

*Puntaje:* 25 puntos. Cada ítem sin **la palabra que separa** exhibida: la mitad. Si en (c) respondiste "verdadero" con la demostración de longitud mínima: 15/25 — la demostración estaba bien, faltó evaluar en $\emptyset$.

**F2.** Ver D1. Se espera: (i) detectar que el enunciado es falso, (ii) el contraejemplo $L_1 \neq \emptyset$, $L_2 = \emptyset$, (iii) el enunciado corregido con hipótesis explícita, (iv) las dos inclusiones, señalando dónde se usa $L_2 \neq \emptyset$.
*Puntaje:* 25. Sin (i)/(ii): máximo 12. Con las cuatro partes: 25.

**F3.** Ver C6. Se espera el reagrupamiento explícito en ambas direcciones. Una sola inclusión: 12/25. Reagrupamiento "por analogía" sin escribir los índices: 18/25.

**F4.** Ver E2. Se espera enunciar explícitamente que $\Sigma^*$ es numerable **y por qué** ($\Sigma$ finito ⟹ cada $\Sigma^i$ finito ⟹ unión numerable), la definición del diagonal, y la evaluación en el propio índice.
*Puntaje:* 25. Sin justificar la numerabilidad de $\Sigma^*$: 18/25. Diagonal mal definido (por ejemplo sin fijar la enumeración de $\Sigma^*$): 10/25.

---

## Cierre: los cinco reflejos que este tema tiene que dejar

1. **Evaluar en $\emptyset$ y en $\Lambda$ antes de creerle a cualquier identidad.** Decide C1, C13, D1, D5 — cuatro de los ítems más difíciles del set.
2. **$\lambda \in L^*$ siempre**, incluso para $L=\emptyset$. Solo con eso sale C8 en dos líneas.
3. **Contraejemplo = lenguajes concretos + la palabra que separa.** Sin la palabra, no es un contraejemplo, es una intuición.
4. **Levi (B4) es la navaja para todo argumento de "dos factorizaciones de la misma palabra".** Aparece en B5, D1, D5 y D7d; en el parcial se puede citar como lema si se lo enunció bien.
5. **La diagonalización de E2 es la del halting problem.** Cada vez que se practica acá, se está adelantando trabajo del segundo parcial.
