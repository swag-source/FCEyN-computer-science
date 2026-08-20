***
*Conceptos clave*
* **Automata Finito Deterministico**
* **Autómata Finito No Deterministico**
* **Alfabeto**
* **Lenguaje**
* **Función de transición**

**Alfabetos y Lenguajes**
---
*Definición:* se define un **alfabeto** como un **conjunto finito, no vacío, de simbolos**.

Una **cadena/palabra** se define como la concatenación de símbolos.

Esta **palabra** se escribe sobre el alfabeto $\Sigma$ siendo la concatenación de elementos de una secuencia finita de simbolos (*a.k.a string*).

La **palabra** **nula** $\lambda$. No tiene símbolos.

*Ej:* cadenas sobre $\Sigma = \{a,j,r\} \rightarrow \ \{a, aj, ja, raja,jarra\}$   

**El conjunto de palabras sobre un alfabeto**
---
Dado un alfabeto $\Sigma$, escribimos.
$\Sigma^{0} = \lambda$
$\Sigma^{1} = \Sigma$
$\Sigma^{2} = \Sigma \Sigma = \{ab : a \in \Sigma, b \in \Sigma\}$
$\Sigma^{3} = \Sigma \Sigma \Sigma = \{abc : a \in \Sigma, b \in \Sigma , c \in \Sigma\}$ 
...
(esta notación nos dice el conjunto de cadenas de longitud $n$ dado un abecedario ).

**Clausura de Kleene del alfabeto** $\Sigma$:
$$\Sigma^{*} = \bigcup_{i \geq 0} \Sigma^{i} = \{\lambda\} \cup \Sigma^{1} ...\Sigma^{i} $$
**Clausura positiva del alfabeto** $\Sigma$:
$$\Sigma^{+} = \bigcup_{i \geq 1} \Sigma^{i} = \Sigma^{1} \cup \Sigma^{2} \cup \ ... \ \Sigma^{i}$$

*Observación:* recordar que **hay tantas palabras como números naturales**.

**Teorema:** La *cardinalidad de* $\Sigma^{*}$ es igual a la cardinalidad de $\mathbb{N}$.
---
Un orden es una relación entre pares de elementos, la misma es antisimétrica y transitiva.

Asumimos un orden lexicográfico entre los elementos del alfabeto (a < b, por ejemplo). Lo extendemos a un orden entre todas las palabras de la misma longitud, posición a posición.


**Definición (Orden longitud-lexicográfico en $\Sigma^{*})$**
---
*Definimos el orden*

Por ejemplo para $\Sigma = \{a,b,c\}$
$\lambda < a < b < c < aa < ab < ac < aaa < aab < aac ...$
* Observar que lo que estamos haciendo es asignar, a cada letra del abecedario, un valor ordinal comparativo.

**Lenguaje sobre un alfabeto**
---
*Definición:* Un lenguaje es un **conjunto** sobre palabras.
Un lenguaje $L$ sobre un alfabeto $\Sigma$ es un conjunto de palabras sobre $\Sigma$. Es decir, $L \subseteq \Sigma^{*}.$

*Ejs:*
$\emptyset$
$\lambda$ (observar que $\lambda \neq \emptyset$ pues $\lambda$ es una palabra)
$\{0, 01, 011, 0111, 01111, ... \}$ es un lenguaje sobre $\Sigma = \{0, 1\}$.

**Autómata finito deterministico (AFD)**
---
¿*Qué es un autómata*? ¿*De donde nace este concepto*?

Un autómata es un modelo matemático de cómputo simple que permite el reconocimiento de lenguajes regulares. El objetivo de de un autómata es proponer un *framework* para entender cuales son los límites del **cómputo** y la **computación**, determinando que es posible computar y que no.

*Ej (de lógica):* con una máquina de Turing, si nosotros buscamos verificar si un programa se cuelga o no, demostramos que no es posible computar este valor y entramos en el **halting problem**.

*Definición:* Un **Autómata Finito Deterministico** es una 5-upla $<Q, \Sigma, \delta, q_0, F>$ tal que:
* $Q$ es un **conjunto finito de estados**.
* $\Sigma$ **alfabeto**.
* $\delta : Q \times \Sigma \longrightarrow Q$ la **función de transición** (aquella que se encarga de responder cómo se realiza la modificar estados).
* $q_0 \in Q$ el **estado inicial**.
* $F \subseteq Q$ el conjunto de **estados finales**.

*Obs:* Fijarse que no definimos a priori una *función formal* para la **función de transición**. Acá vemos una función de transición "diagramada".

![[Pasted image 20250319175137.png]]

**Función de transición (generalizada)**
---
Dado que la función de transición únicamente se encarga de procesar caracteres, tenemos que extender esta función para que acepte "cadenas", llamémosla $\alpha = q \ \alpha^{'}$. 

*Definimos* $\widehat{\delta} \ : Q \times \Sigma^{*} \rightarrow Q$
* $\widehat{\delta}(q, \lambda) = q$
* $\widehat{\delta}(q, xa) = \delta(\widehat{\delta}(q,x), a)$, con $x \in \Sigma^{*}$ y $a \in \Sigma.$

Notar que $\widehat{\delta}(q,a) = \delta(\widehat{\delta}(q, \lambda), a) = \delta(q,a)$, por ende, terminamos usando indistintamente $\widehat{\delta}(q,a) = \delta(q,a)$.

**Lenguaje aceptado por un Automata Deterministico Finito**
---
*Definición:* El **lenguaje aceptado por un ADF** $M = <Q, \Sigma, \delta, q_0, F>$, al que denotamos $L(M)$, es el conjunto de palabras de $\Sigma^{*}$ aceptadas por M:
$$L(M) = \{x \in \Sigma^{*} : \widehat{\delta}(q_0, x) \in F \}$$
Esto nos dice que: "Dada una cadena $x$, la misma pertenece a un **lenguaje aceptado** por el Autómata $\iff$ comenzando desde un estado inicial $q_0$ y siguiendo las transiciones definidas por los caracteres en $x$, llegamos a un estado final válido perteneciente al conjunto de estados finales posibles $F$".

Vamos a ver autómatas finitos como funciones tal que, para cada palabra, devuelven un booleano: *aceptación o negación*.

$$M : \Sigma^{*} \rightarrow \{0,1\}$$

¿Cómo definimos el **Autómata Complemento**?
* No equivocarnos con el "grafo" complemento donde invertimos todas las aristas. El $M^{c}$ mantiene los mismos estados, alfabeto y transiciones que $M$
* El **autómata complemento** $M^{c}$ marca a todos los vértices que **NO ERAN ESTADO FINAL** como estado final del nuevo autómata y quienes **ERAN ESTADO FINAL** en $M$ los marca como estado no-final.

**Automata Finito no Deterministico (AFND)**
---
Observar que existen transiciones donde no podemos determinar a donde "termina" nuestro autómata dado que, el *camino* en el autómata, no está definido con certeza por el grafo.

En este caso, si $q_0 = a$ tenemos dos estados aceptados posibles $q_1$ o $q_4$ pero no tenemos certeza cual de los dos tomará. 
![[Pasted image 20250319181447.png|500]]
*Definición:* Un **autómata finito no determinístico** $<Q, \Sigma, \delta, q_0, F>$ donde:
* $Q$ es un **conjunto finito de estados**.
* $\Sigma$ **alfabeto**.
* $\delta : Q \times \Sigma \longrightarrow \mathcal{P}(Q)$ la **función de transición** (aquella que se encarga del cómputo y modificar estados).
* $q_0 \in Q$ el **estado inicial**.
* $F \subseteq Q$ el conjunto de **estados finales**.


*Definición:* Una **cadena $x$ es aceptada por un Autómata Finito No Deterministico** $M = <Q, \Sigma, \delta, q_0, F> \iff \widehat{\delta}(q_0, x) \cap F \neq \phi$  

*Ej:*
* $Q = \{q_0, q_1, q_2\}$
* $\Sigma = \{a, b\}$
* $\text{Estado inicial: } q_0$
* $F = \{q_2\}$ 
* $x = \text{'aab'}$
![[Pasted image 20250320114241.png|500]]
	1. Empezando desde $q_0$, leyendo $a$.
		1. $\delta (\{q_0\}, a) = \{q_0, q_1\}$
	2. Empezando desde $q_0$ o $q_1$, leyendo $a$
		1. $\delta (\{q_0\}, a) = \{q_0, q_1\}$
		2. $\delta(\{q_1\}, a) = \phi$
		3. **Combinado** = $\{q_0, q_1\}$
	3. Empezando desde $q_0$ o $q_1$, leyendo $b$.
		1. $\delta (\{q_0\}, b) = \{q_0\}$
		2. $\delta (\{q_1\}, b) = \{q_2\}$
		3. **Combinado** = $\{q_0, q_2\}$


| $\text{Estado inicial}$ | $a$            | $b$       |
| ----------------------- | -------------- | --------- |
| $q_0$                   | $\{q_0, q_1\}$ | $\{q_0\}$ |
| $q_1$                   | $\emptyset$    | $\{q_2\}$ |
| $q_2$                   | $\emptyset$    | $\{q_2\}$ |

Conjunto final de estados $\delta(q_0, \text{"aab"}) = \{q_0, q_2\}.$ 
Dado que $q_2$ pertenece a un estado final $q_2 \in F$, tenemos que:
$$\delta(q_0, \text{"aab"}) \cap F = \{q_2\} = \{q_2\} \neq \emptyset$$
Entonces decimos que "aab" es una cadena válida de $M$.

*Definición:* Un **lenguaje aceptado por un Autómata Finito No Deterministico**, con el lenguaje $M = <Q,\Sigma, \delta, q_0, F>$ al que denotamos $\mathcal{L}(M)$.

$$\mathcal{L}(M) = \{x \in \Sigma^{*} : \delta(q_0, x) \cap F \neq \phi\}$$

¿Existe una forma de hacer *deterministico* nuestra función de transición de nuestro autómata *no deterministico*? 

**Función de transición de conjuntos de estados**
---
Función de transición $\delta$-extendida : $P(Q) \times \Sigma \rightarrow P(Q)$,
$$\delta \text{-extendida}(P, a) = \bigcup_{q \in P} \delta(q,x)$$
...
...

**Teorema (Equivalencia entre Automata Finito No Deterministico y Deterministico)**
***
Dado un *AFND* $M = <Q, \Sigma, \delta, q_0, F>$, existe un *AFD* $M' = <Q', \Sigma, \delta^{'}, q_0^{'}, F^{'}>$ tal que $L(M) = L(M')$.

