# Parcial modelo C — ★★ temario completo

**Duración: 3 h.** Cuatro ejercicios, 25 puntos cada uno. Se aprueba con 60.
**Sin apuntes, a página en blanco, de una sentada.**

> Hacelo con **las cinco guías** terminadas. Éste es el modelo que define el criterio 🟢:
> aprobarlo dentro del tiempo es la condición para llegar tranquilo al 30.

---

## Ejercicio 1 — Una operación nueva · *T1 + T2* · 40 min

Para $L \subseteq \Sigma^*$ se define **la primera mitad** de $L$:
$$\mathrm{Med}(L) = \{\alpha \in \Sigma^* : \exists\, \beta \in \Sigma^*,\ |\beta| = |\alpha|
\ \wedge\ \alpha\beta \in L\}.$$

**a.** Calcular $\mathrm{Med}((ab)^*)$ y $\mathrm{Med}(\{a^nb^n : n \geq 0\})$.

**b.** Demostrar que $\mathrm{Med}(L) \subseteq \mathrm{Ini}(L)$ para todo $L$. ¿Vale la igualdad?
Demostrarla o dar un contraejemplo explícito.

**c.** Demostrar que si $L$ es regular entonces $\mathrm{Med}(L)$ es regular.
*(Sugerencia: el autómata debe leer $\alpha$ y a la vez llevar la cuenta de qué le pasaría a un
estado si leyera $\beta$; adivinar el estado del medio y verificarlo al final.)*

**d.** ¿De qué tipo es el autómata que construiste en (c)? ¿Hacía falta que el de $L$ fuese
determinístico?

---

## Ejercicio 2 — Minimalidad y distinguibilidad · *T3 + T4* · 40 min

**a.** Dar el AFD mínimo de
$L = \{\alpha \in \{a,b\}^* : |\alpha|_a \equiv 0 \ (\mathrm{mod}\ 3) \ \wedge\ \alpha$ termina en
$b\}$ y demostrar que es mínimo. El producto «residuo módulo 3 × último símbolo» sugiere 6 estados:
explicar por qué no son 6.

**b.** Demostrar que $L' = \{\alpha \in \{a,b\}^* : |\alpha|_a = |\alpha|_b\}$ **no** es regular
usando el argumento de distinguibilidad del ítem (a) —  no el lema de bombeo.

**c.** Enunciar con precisión la relación entre «cantidad de cocientes $\alpha^{-1}L$ distintos» y
«cantidad de estados del AFD mínimo de $L$». ¿En qué dirección se usa para probar minimalidad y en
cuál para probar no-regularidad?

---

## Ejercicio 3 — El recíproco del bombeo · *T4* · 40 min

Sobre $\Sigma = \{a,b,c\}$, sea
$$L = \{a^i b^j c^k : i,j,k \geq 0 \ \wedge\ (i = 1 \Rightarrow j = k)\}.$$

**a.** Demostrar que $L$ cumple la conclusión del lema de bombeo con $n = 2$: para toda
$\alpha \in L$ con $|\alpha| \geq 2$ existen $x,y,z$ con $\alpha = xyz$, $|xy| \leq 2$,
$|y| \geq 1$ y $xy^mz \in L$ para todo $m \geq 0$. **Dar la descomposición explícita en cada caso.**

**b.** Demostrar que $L$ no es regular.

**c.** ¿Qué se concluye sobre el lema de bombeo como criterio de regularidad? Enunciar con precisión
qué permite demostrar y qué no.

---

## Ejercicio 4 — Pila y determinismo · *T5* · 40 min

**a.** Dar un autómata de pila para
$L_1 = \{\alpha \in \{a,b,c\}^* : |\alpha|_a = |\alpha|_b + |\alpha|_c\}$. ¿Es determinístico?

**b.** Demostrar que $L_2 = \{\omega\, c\, \omega : \omega \in \{a,b\}^*\}$ no es libre de contexto.

**c.** Sea $L_3 = \{a^n b^n c^m : n,m \geq 0\} \cup \{a^n b^m c^m : n,m \geq 0\}$. Dar un autómata
de pila que lo reconozca. Argumentar por qué **no** puede hacerse determinístico, e indicar qué
propiedad de clausura de los lenguajes libres de contexto **determinísticos** permitiría
demostrarlo formalmente.

---

## Corrección

25 puntos por ejercicio, repartidos en partes iguales entre sus ítems. Se aprueba con 60.
Misma tabla de descuentos que el modelo B, más:

| Falla | Descuento |
|---|---|
| Afirmar «no es determinístico» sin exhibir el conflicto o la propiedad de clausura que lo prueba | −75% del ítem |
| Confundir «no encontré un AP determinístico» con «no existe» | −75% del ítem |

Clave en [`modelo-c-clave.md`](modelo-c-clave.md).
