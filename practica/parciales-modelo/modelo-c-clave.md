# Clave — Parcial modelo C

## Ejercicio 1

**a.** $\mathrm{Med}((ab)^*) = (ab)^* \cup (ab)^*a$. Si $\alpha\beta = (ab)^n$ con
$|\alpha| = |\beta| = n$: para $n$ par $\alpha = (ab)^{n/2}$, para $n$ impar
$\alpha = (ab)^{(n-1)/2}a$.

$\mathrm{Med}(\{a^nb^n\}) = a^*$. Si $\alpha\beta = a^nb^n$ con $|\alpha| = |\beta| = n$, entonces
$\alpha$ es el prefijo de longitud $n$, o sea exactamente $a^n$; y todo $a^n$ se obtiene así.

⚠ **Trampa.** $\mathrm{Med}$ de un lenguaje **no** regular puede ser regular: el segundo ejemplo lo
muestra. No sirve de nada intentar «heredar» propiedades hacia atrás.

**b.** $\mathrm{Med}(L) \subseteq \mathrm{Ini}(L)$: si $\alpha \in \mathrm{Med}(L)$ existe $\beta$
con $\alpha\beta \in L$, que es justo la definición de prefijo.

**La igualdad es falsa.** Con $L = \{a^nb^n\}$: $\mathrm{Ini}(L) = \{a^nb^k : k \leq n\}$ y
$\mathrm{Med}(L) = a^*$. **Palabra que separa: $ab$** — es prefijo de $aabb$ pero no es la primera
mitad de ninguna palabra de $L$.

⚠ **Trampa.** Con $L = (ab)^*$ los dos conjuntos **coinciden**, así que ése no sirve de
contraejemplo. Hay que elegir un $L$ cuyos prefijos tengan longitudes que no sean la mitad de
ninguna palabra.

**c.** Sea $M = \langle Q,\Sigma,\delta,q_0,F\rangle$ un AFD para $L$. Construyo el AFND $M'$ con
estados $Q \times Q \times Q \times Q$ más un inicial nuevo. Desde el inicial, con transiciones
$\lambda$, **adivino** $m \in Q$ (el estado del medio) y $f \in F$ (el estado final), y voy a
$(q_0, m, m, f)$. En un estado $(p, r, m, f)$, al leer $x \in \Sigma$:
$$(p,r,m,f) \ \longrightarrow\ (\delta(p,x),\ \delta(r,y),\ m,\ f) \quad
\text{para **algún** } y \in \Sigma \text{ adivinado.}$$
Finales: los $(p,r,m,f)$ con $p = m$ y $r = f$.

Correctitud: la primera componente sigue $\alpha$ desde $q_0$; la segunda sigue una $\beta$ adivinada
desde $m$; como ambas avanzan **un paso por símbolo leído**, se cumple $|\beta| = |\alpha|$ gratis.
Entonces $\alpha$ es aceptada $\iff \exists m, f \in F, \exists \beta$ con $|\beta| = |\alpha|$,
$\widehat\delta(q_0,\alpha) = m$ y $\widehat\delta(m,\beta) = f \iff \alpha \in \mathrm{Med}(L)$.
La cantidad de estados es finita ($\leq |Q|^4 + 1$), así que $\mathrm{Med}(L)$ es regular.

⚠ **Trampa.** Que $|\beta| = |\alpha|$ salga **de la construcción** (un paso de cada componente por
símbolo) y no de una cuenta aparte: un autómata finito no puede contar la longitud.

**d.** Es un **AFND con transiciones $\lambda$** — la adivinanza de $m$, $f$ y de cada $y$ es
irreducible en la construcción. Después se determiniza si hace falta. El autómata de entrada
conviene que sea determinístico, para que «$\widehat\delta(q_0,\alpha) = m$» sea una condición sobre
un único estado; con un AFND hay que determinizar primero.

---

## Ejercicio 2

**a.** **4 estados.** Representantes $\lambda,\ a,\ b,\ aa$:

| | $a$ | $b$ | |
|---|---|---|---|
| $s_0 = [\lambda]$ | $s_1$ | $s_2$ | inicial |
| $s_1 = [a]$ | $s_3$ | $s_1$ | |
| $s_2 = [b]$ | $s_1$ | $s_2$ | **final** |
| $s_3 = [aa]$ | $s_0$ | $s_3$ | |

Distinguidoras: $(s_0,s_1)$: $b$; $(s_0,s_3)$: $b$; $(s_1,s_3)$: $ab$; $(s_0,s_2)$, $(s_1,s_2)$,
$(s_2,s_3)$: $\lambda$.

**Por qué no son 6.** El bit «termina en $b$» sólo distingue cuando el residuo es $0$. Si el residuo
es $1$ o $2$, la palabra se rechaza con $\lambda$ en ambos casos, y cualquier sufijo no vacío
**reescribe** el último símbolo, con lo cual el bit deja de tener efecto. Se fusionan entonces
$(1,b)\sim(1,\neg b)$ y $(2,b)\sim(2,\neg b)$; sólo sobrevive $(0,b)$ vs. $(0,\neg b)$. $6 \to 4$.

**b.** Las palabras $a^i$, $i \geq 0$, son **dos a dos distinguibles** para $L'$: si $i \neq j$,
el sufijo $b^i$ separa, porque $a^ib^i \in L'$ y $a^jb^i \notin L'$. Hay entonces infinitas clases de
equivalencia, y ningún AFD (que tiene finitos estados) puede reconocer $L'$.

**c.** $\alpha \sim_L \beta \iff \alpha^{-1}L = \beta^{-1}L$, y la cantidad de cocientes distintos
$|\{\alpha^{-1}L\}|$ es **exactamente** la cantidad de estados del AFD mínimo (Myhill–Nerode). En
consecuencia $L$ es regular $\iff$ esa cantidad es finita.

- Para **minimalidad**: exhibir $k$ palabras dos a dos distinguibles prueba que hacen falta al menos
  $k$ estados (cota inferior); si además tenés un AFD de $k$ estados, es mínimo.
- Para **no regularidad**: exhibir una familia **infinita** de palabras dos a dos distinguibles.

Es el mismo argumento en las dos direcciones — por eso (a) y (b) son el mismo ejercicio.

---

## Ejercicio 3

**a.** Sea $\alpha = a^ib^jc^k \in L$ con $|\alpha| \geq 2$. Por casos según $i$:

| $i$ | $x$ | $y$ | por qué funciona |
|---|---|---|---|
| $0$ | $\lambda$ | primer símbolo | $i$ queda en $0$, la implicación es vacía y la forma $b^*c^*$ se preserva |
| $1$ | $\lambda$ | $a$ | $xy^mz = a^mb^jc^k$: $m=0$ da $i=0$ ✔; $m=1$ es la original, con $j=k$ ✔; $m\geq2$ da $i\geq2$ ✔ |
| $2$ | $\lambda$ | $aa$ | $xy^mz = a^{2m}b^jc^k$: $m=0$ da $i=0$ ✔; $m\geq1$ da $i=2m\geq2$ ✔ — **nunca pasa por $i=1$** |
| $\geq 3$ | $\lambda$ | $a$ | $xy^mz = a^{i-1+m}b^jc^k$ con $i-1 \geq 2$, luego $i-1+m \geq 2$ para todo $m$ ✔ |

Y $|xy| \leq 2$ en los cuatro casos.

⚠ **Trampa — es el ejercicio entero.** En $i = 2$ la elección $y = a$ **falla**: $m = 0$ deja
$i = 1$ y ahí hace falta $j = k$, que no está garantizado. Hay que tomar $y = aa$ para saltear
$i=1$. Quien no separa el caso $i=2$ «demuestra» algo falso.

**b.** $ab^*c^*$ es regular y los regulares son cerrados por intersección con regulares. Ahora
$L \cap ab^*c^* = \{ab^jc^j : j \geq 0\}$, porque la restricción a $i = 1$ activa la implicación.
Ese lenguaje no es regular (con $n$ la constante, $w = ab^nc^n$ tiene $|xy| \leq n$, luego $y$ está
dentro del bloque inicial $ab^{\dots}$; bombeando se rompe $j = k$ o se duplica la $a$). Absurdo,
luego $L$ no es regular.

**c.** El lema de bombeo es una condición **necesaria pero no suficiente**. Sólo sirve para probar
**no regularidad**, por el contrarrecíproco. Que un lenguaje cumpla su conclusión **no dice nada**:
este ejercicio es el testigo. Para caracterizar la regularidad hay que ir a Myhill–Nerode
(ejercicio 2c).

---

## Ejercicio 4

**a.** Un contador con signo. $\Gamma = \{Z_0, A, B\}$: $A$ cuenta excedente de $a$, $B$ cuenta
excedente de $b$+$c$; la pila nunca mezcla los dos. Al leer $a$: si el tope es $B$, desapilar; si no,
apilar $A$. Al leer $b$ o $c$: si el tope es $A$, desapilar; si no, apilar $B$. Aceptar con $Z_0$
en el tope al terminar el input.

**Es determinístico:** cada par (símbolo leído, tope de la pila) determina una única transición, y no
hay transiciones $\lambda$ que compitan.

**b.** $z = a^pb^p\,c\,a^pb^p$, con $p$ la constante. Sea $z = uvwxy$, $|vwx| \leq p$,
$|vx| \geq 1$. Toda palabra de $L_2$ tiene **exactamente una** $c$, y sus dos mitades son iguales
(en particular, del mismo largo). Tres casos:

- **$v$ o $x$ contienen la $c$.** Entonces $uv^2wx^2y$ tiene dos o más $c$. $\notin L_2$.
- **$vwx$ contiene la $c$, pero $v$ y $x$ no.** Como $|vwx| \leq p$, entonces
  $vwx \subseteq b^p\,c\,a^p$, con $v$ dentro de las $b$ de la primera mitad y $x$ dentro de las
  $a$ de la segunda. Si $s = |v|$ y $t = |x|$, $uv^2wx^2y = a^pb^{p+s}\,c\,a^{p+t}b^p$, y para
  estar en $L_2$ haría falta $a^pb^{p+s} = a^{p+t}b^p$, o sea $s = t = 0$, contra $|vx| \geq 1$.
  $\notin L_2$.
- **$vwx$ no contiene la $c$.** Entonces $vwx$ está enteramente dentro de una de las dos mitades, y
  $uv^2wx^2y$ cambia el largo de esa mitad y no el de la otra. $\notin L_2$.

⚠ **Trampa.** El caso del medio es el que se saltea todo el mundo: $vwx$ **puede** contener la $c$
sin que la contengan $v$ ni $x$, y ahí hay que comparar bloque contra bloque, no sólo longitudes.

**c.** El AP adivina al principio, con una transición $\lambda$, cuál de los dos disyuntos va a
verificar: o aparea $a$ con $b$ y después consume $c$ libremente, o consume $a$ libremente y aparea
$b$ con $c$. Es un AP **no determinístico**.

**Por qué no puede ser determinístico:** al leer las $a$ el autómata todavía no sabe si le van a
pedir $n = m$ entre $a$ y $b$ o entre $b$ y $c$, y la pila es de un solo uso — apilar las $a$ o no
apilarlas es una decisión irreversible que tiene que tomarse antes de ver la información que la
justifica.

**La propiedad de clausura que lo formaliza:** los LC **determinísticos son cerrados por
complemento** (los LC en general no). Entonces, si $L_3$ fuese determinístico, $L_3^c$ sería
determinístico y en particular libre de contexto; intersecando con el regular $a^*b^*c^*$ —los LC
son cerrados por intersección con regulares— quedaría que
$\{a^ib^jc^k : i \neq j \ \wedge\ j \neq k\}$ es libre de contexto, y de ahí se saca el absurdo.

⚠ **Trampa.** Decir «no encontré ninguno determinístico» **no** es una demostración. La única vía
formal disponible con las herramientas de la materia es la clausura por complemento de los LCD.
