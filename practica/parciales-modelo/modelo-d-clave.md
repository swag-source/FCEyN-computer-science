# Clave — Parcial modelo D

## Ejercicio 1

**a. $\{a^nb^m : n \neq m\}$ — libre de contexto determinístico, no regular.**
*En la clase:* el AP determinístico del modelo B, ejercicio 4a.
*Fuera de la anterior:* si fuese regular, como $a^*b^*$ es regular y los regulares son cerrados por
complemento e intersección, $\big(L^c\big) \cap a^*b^* = \{a^nb^n\}$ sería regular. Absurdo.

**b. $\{\alpha \in \{a,b\}^* : \alpha \neq \alpha^r\}$ — libre de contexto, no determinístico.**
*Es LC:* el AP adivina la posición del centro y una posición $i$ con
$\alpha_i \neq \alpha_{|\alpha|+1-i}$: apila la primera mitad, adivina el centro, y al desapilar
verifica que en alguna posición el símbolo leído difiere del desapilado.
*No es regular:* $a^*ba^*$ es regular y $L \cap a^*ba^* = \{a^iba^j : i \neq j\}$, que no es regular
(mismo argumento que (a)).
*No es determinístico:* los LCD son cerrados por complemento, así que si $L$ lo fuera, también lo
sería $L^c = \{\alpha : \alpha = \alpha^r\}$, el lenguaje de los **palíndromos**. Pero los
palíndromos sobre $\{a,b\}$ son LC y **no** determinísticos (es el ítem 1.f de la guía 5: la
consigna pide «hacer una versión determinística en los casos en que sea posible», y ése es
justamente el caso en que no lo es). Absurdo.

**c. $\{a^{n!} : n \geq 0\}$ — no libre de contexto.**
Sea $p$ la constante del lema de bombeo para LC y elijo $m \geq 2$ con $m! \geq p$. Tomo
$z = a^{m!}$. Para toda descomposición $z = uvwxy$ con $|vwx| \leq p$ y $1 \leq |vx|$:
$$m! \ <\ |uv^2wx^2y| \ =\ m! + |vx| \ \leq\ m! + p \ \leq\ 2\cdot m! \ <\ (m+1)\cdot m! = (m+1)!$$
La longitud queda **estrictamente entre dos factoriales consecutivos**, luego $uv^2wx^2y \notin L$.

⚠ **Trampa.** La cadena de desigualdades necesita $m \geq 2$ (para que $m+1 > 2$) y $p \leq m!$.
Fijar esas dos condiciones **antes** de elegir $z$ es parte de la demostración.

---

## Ejercicio 2

**a.** $\mathrm{Ciclo}((ab)^*) = (ab)^* \cup (ba)^*$. Las rotaciones de $(ab)^n$ son $(ab)^n$ (rotar
un número par de posiciones) y $(ba)^n$ (impar). $\lambda$ está en ambos.

**b.** Sea $M = \langle Q,\Sigma,\delta,q_0,F\rangle$ un AFD para $L$. Para cada $q \in Q$ construyo
$A_q$: dos copias de $M$; la corrida arranca en $q$ de la **primera** copia (leyendo $\beta$), desde
todo estado de $F$ de la primera copia hay una transición $\lambda$ a $q_0$ de la **segunda** copia
(donde lee $\alpha$), y el único final es $q$ de la segunda copia. Entonces
$$L(A_q) = \{\beta\alpha : \widehat\delta(q,\beta) \in F \ \wedge\ \widehat\delta(q_0,\alpha) = q\}.$$
Y $\mathrm{Ciclo}(L) = \bigcup_{q \in Q} L(A_q)$, unión **finita** de regulares, luego regular.
(Equivalentemente: un solo AFND-$\lambda$ con un inicial nuevo que adivina $q$.)

**Meta-pregunta:** sale un **AFND con transiciones $\lambda$**, con $\leq 2|Q|^2 + 1$ estados; se
determiniza después. El autómata de entrada conviene determinístico para que
«$\widehat\delta(q_0,\alpha) = q$» sea una condición sobre un único estado.

⚠ **Trampa.** La adivinanza es de $q$, el **punto de corte**, y hay que verificarla al final
(terminar exactamente en $q$). Un autómata que adivina y no verifica reconoce de más.

**c.** ($\supseteq$) Si $w \in \mathrm{Ciclo}(L)$, escribo $w = \beta\alpha$ con $\beta = w$,
$\alpha = \lambda$; entonces $\alpha\beta = w \in \mathrm{Ciclo}(L)$, luego
$w \in \mathrm{Ciclo}(\mathrm{Ciclo}(L))$.
($\subseteq$) Si $w \in \mathrm{Ciclo}(\mathrm{Ciclo}(L))$, entonces $w$ es una rotación de una
palabra que es rotación de una de $L$. El lema clave es que **la relación «ser rotación de» es
transitiva** (las rotaciones son la órbita de una acción del grupo cíclico $\mathbb{Z}_{|w|}$, y
componer dos rotaciones da una rotación). Luego $w$ es rotación de una palabra de $L$, o sea
$w \in \mathrm{Ciclo}(L)$.

**d. Falsa.** Sea
$$L = \{a^nb^n : n \geq 0\} \ \cup\ \{\alpha \in \{a,b\}^* : ba \text{ es subcadena de } \alpha\}.$$

*$L$ no es regular:* ninguna palabra de $a^*b^*$ contiene $ba$, así que $L \cap a^*b^* =
\{a^nb^n\}$. Como $a^*b^*$ es regular, si $L$ lo fuera, $\{a^nb^n\}$ también. Absurdo.

*$\mathrm{Ciclo}(L)$ sí es regular:*
$\mathrm{Ciclo}(L) = \{\lambda\} \cup \{\alpha : |\alpha|_a \geq 1 \wedge |\alpha|_b \geq 1\}$.
($\supseteq$) si $\alpha$ tiene las dos letras, alguna rotación tiene una $b$ inmediatamente seguida
de una $a$, o sea cae en la segunda parte de $L$; y $\lambda \in L$ ($n = 0$).
($\subseteq$) toda palabra de $\mathrm{Ciclo}(L)$ es rotación de una de $L$, y las de $L$ son o bien
$\lambda$ o bien palabras con las dos letras; las rotaciones preservan la cantidad de cada símbolo.
Ese lenguaje es claramente regular (4 estados).

---

## Ejercicio 3

**a.** Sea $n$ la constante del lema para $L$. Como $L$ es infinito hay $a^N \in L$ con $N \geq n$.
Descompongo $a^N = xyz$ con $|xy| \leq n$, $|y| \geq 1$; necesariamente $y = a^d$ con
$1 \leq d \leq n$. Entonces $xy^kz = a^{N - d + kd} \in L$ para todo $k \geq 0$. Tomando
$c = N - d \geq 0$ queda $a^{c + kd} \in L$ para todo $k \geq 0$.

**b.** Supongamos $P = \{a^p : p \text{ primo}\}$ regular. Es infinito (hay infinitos primos), así
que por (a) existen $c \geq 0$, $d \geq 1$ con $c + kd$ primo **para todo** $k \geq 0$. Sea
$q = c + d$, que es primo y por lo tanto $q \geq 2$. Tomo $k = 1 + q$:
$$c + (1+q)d = (c + d) + qd = q + qd = q(1 + d).$$
Como $q \geq 2$ y $1 + d \geq 2$, ese número es **compuesto**, y sin embargo debería ser primo.
Absurdo.

**c.** Sea $n$ la constante y elijo $N$ con $2^N > n$; tomo $w = a^{2^N} \in L$, $|w| \geq n$.
Toda descomposición admisible da $y = a^k$ con $1 \leq k \leq n < 2^N$. Bombeando hacia arriba:
$$2^N \ <\ 2^N + k \ <\ 2^N + 2^N = 2^{N+1},$$
o sea la longitud queda **estrictamente entre dos potencias de 2 consecutivas**, luego
$xy^2z \notin L$.

**Por qué hacia arriba.** La cota de arriba usa exactamente lo que el lema te regala,
$k \leq n < 2^N$, sin pedir nada más. Bombeando hacia abajo hay que garantizar
$2^N - k > 2^{N-1}$, o sea $k < 2^{N-1}$: funciona, pero exige elegir $N$ con
$2^{N-1} > n$ en vez de $2^N > n$. Es un renglón extra que no hace falta.

---

## Ejercicio 4

**a.** Dos ramas no determinísticas, elegidas con una transición $\lambda$ al principio:

1. **Longitudes distintas.** Apilar un marcador por cada símbolo de $\alpha$; tras el $\#$,
   desapilar uno por cada símbolo de $\beta$. Aceptar si al terminar queda algo en la pila
   ($|\alpha| > |\beta|$), o si la pila se vacía y todavía queda input ($|\alpha| < |\beta|$).
2. **Mismo largo, algún símbolo distinto.** Adivinar una posición $i$: apilar un marcador por cada
   uno de los primeros $i$ símbolos de $\alpha$, **recordar $\alpha_i$ en el estado**, y leer el
   resto de $\alpha$ sin tocar la pila. Tras el $\#$, desapilar un marcador por símbolo de $\beta$;
   el símbolo que se lee cuando la pila queda vacía es $\beta_i$: verificar
   $\beta_i \neq \alpha_i$ y aceptar el resto libremente.

**No es determinístico, y se demuestra.** Los LCD son cerrados por complemento, así que si $L_1$
fuese determinístico, $L_1^c$ sería LCD y en particular libre de contexto. Los LC son cerrados por
intersección con regulares, y $\{a,b\}^*\#\{a,b\}^*$ es regular, luego
$$L_1^c \cap \{a,b\}^*\#\{a,b\}^* = \{\alpha\#\alpha : \alpha \in \{a,b\}^*\}$$
sería libre de contexto. Pero no lo es (mismo argumento que $\{\omega\omega\}$, ejercicio 9 de la
guía 5: con $z = a^pb^p\#a^pb^p$, ninguna descomposición con $|vwx| \leq p$ puede bombear las dos
mitades a la vez). Absurdo.

**La diferencia con $\{a^nb^m : n \neq m\}$.** Ahí la comparación se **resuelve en el orden en que
llega el input**: el AP va apilando y desapilando, y el desbalance se manifiesta solo. Acá, en
cambio, hay que **comprometerse con la posición $i$ antes de haber visto $\beta$**, y el compromiso
es irreversible porque la pila se consume una sola vez. Ésa es la diferencia estructural: no es el
símbolo $\neq$, es si la información necesaria para decidir llega antes o después del momento de
decidir.

**b.** $z = a^pb^pc^pd^p$, $|vwx| \leq p$, $|vx| \geq 1$. Como $|vwx| \leq p$, $vwx$ toca a lo sumo
**dos bloques adyacentes**. Pero las restricciones del lenguaje son $i = i$ entre las $a$ y las $c$,
y $j = j$ entre las $b$ y las $d$: **ninguno de esos dos pares es adyacente** ($a$ y $c$ están
separados por las $b$; $b$ y $d$ por las $c$). Entonces $uv^2wx^2y$ cambia la cantidad de alguna
letra sin poder cambiar la de su pareja, y rompe $i = i$ o $j = j$. En todos los casos
$uv^2wx^2y \notin L_2$.

⚠ **Trampa.** Hay que **enumerar** los casos (dentro de $a$, entre $a$ y $b$, dentro de $b$, entre
$b$ y $c$, …) y decir en cada uno qué igualdad se rompe. «$vwx$ no puede tocar las cuatro» no es la
demostración: es el comienzo de la demostración.

**c.** Los LC son cerrados por unión. Si además fuesen cerrados por complemento, entonces para
cualesquiera $L, L'$ libres de contexto
$$L \cap L' = \big(L^c \cup L'^c\big)^c$$
sería libre de contexto, o sea serían cerrados por intersección. Pero no lo son:
$\{a^nb^nc^k\} \cap \{a^kb^nc^n\} = \{a^nb^nc^n\}$, que no es LC (modelo A, ejercicio 4). Absurdo:
**los LC no son cerrados por complemento.**

**Por qué no se aplica a los determinísticos.** Los LCD **sí** son cerrados por complemento, pero
**no por unión** — así que el paso de De Morgan se cae: $L^c \cup L'^c$ no tiene por qué ser
determinístico y el argumento no llega a ninguna parte. El ejercicio 4c del modelo C es
exactamente el otro lado de esta moneda: la clausura por complemento de los LCD es lo que permite
probar que un lenguaje **no** es determinístico.
