# Hoja resumen — Parcial 1 (1 hoja A4, doble faz, manuscrita)

> **Esto no es para leer: es para copiar a mano.** Está escrito en el orden de transcripción.
> Notación en unicode plano y no en LaTeX a propósito — se copia mucho más rápido.
>
> **Marcador `○`** = se cae primero si te quedás sin espacio. Núcleo (sin marca):
> **49 renglones cara A + 51 cara B**. Con los `○`, 114. A mano entran ~50-55 por
> carilla escribiendo chico, así que el núcleo entra justo y los `○` son bonus.
> El bloque `[15]` es enteramente repetido a propósito: es lo primero que sobra.
>
> **Cuándo transcribirla:** después del modelo B, con `../errores.md` al lado. Lo que aparezca
> dos veces en el error log manda sobre el orden de acá: agrandá ese renglón y bajá un `○`.
>
> Antes de pasarla en limpio, hacé el dry run: modelo C con esta hoja y nada más. Lo que
> buscaste y no estaba se agrega; el bloque que no miraste ni una vez se borra.

---

```
════════════ CARA A — LENGUAJES Y DEMOSTRACIONES ════════════

[1] DEFINICIONES RECURSIVAS  (base de toda inducción)
    |λ|=0   |αa|=|α|+1        λʳ=λ   (αa)ʳ=a·αʳ
    α·λ=α   α·(βa)=(α·β)a
    L⁰=Λ   Lⁿ⁺¹=Lⁿ·L   L*=⋃_{n≥0}Lⁿ   L⁺=⋃_{n≥1}Lⁿ
    δ̂(q,λ)=q     δ̂(q,xa)=δ(δ̂(q,x),a)

[2] SOBRE QUÉ VARIABLE INDUCIR
    Todo recursa POR DERECHA ⟹ inducir en la variable derecha.
    |αβ| y (αβ)ʳ → en β.   γα=δα → en α.   δ̂ → en la palabra.
    Decir siempre sobre cuál se induce + caso base. (−50% si falta)

[3] HECHOS CITABLES SIN DEMOSTRAR
    H2  |αβ| = |α|+|β|
    H3  (αβ)ʳ = βʳαʳ      (αʳ)ʳ = α
    H4  α≠λ se escribe única como α=aα₁ y como α=α₁a
    H5  L₁⊆L₂ ⟹ L₁*⊆L₂*, Ini(L₁)⊆Ini(L₂), ídem Fin, Sub
    H6  L*L*=L*   (L*)*=L*   λ∈L* SIEMPRE (aun L=∅)
    H7  Cancelación: vale para CADENAS, no para lenguajes
    H8  LEVI: αβ=γδ ∧ |α|≤|γ| ⟹ ∃μ: γ=αμ ∧ β=μδ
        (la navaja de todo argumento de dos factorizaciones)

┌─[4] CAJA ∅ / Λ / λ ──────────── confundirlos = −100% ─┐
│  ∅* = Λ     ∅⁺ = ∅     Λ* = Λ⁺ = Λ     L⁰ = Λ         │
│  ∅·L = L·∅ = ∅  (aniquilador)                         │
│  Λ·L = L·Λ = L  (neutro)                              │
│  λ ∈ L*  para TODO L                                  │
│  ⇒ evaluar en ∅ y en Λ antes de creerle a nada.       │
└───────────────────────────────────────────────────────┘

[5] IDENTIDADES VERDADERAS  (citables directo)
    L* = (L∖{λ})*         L⁺ = L*∖{λ} ⟺ λ∉L
    L⁺ = L*  ⟺  λ∈L
    (L₁∪L₂)* = (L₁*L₂*)*
    (L₁L₂)*L₁ = L₁(L₂L₁)*
    (L*)ʳ = (Lʳ)*
    ʳ conmuta con ∪ ∩ ∖ ᶜ  —  pero INVIERTE el orden en · y *

[6] FALSAS FAMOSAS + TESTIGO
    L⁺=L*∖{λ}          — L=Λ; separa λ
    (L₁∩L₂)*=L₁*∩L₂*   — {a},{aa}; separa aa       (⊆ sí)
    L(L₁∩L₂)=LL₁∩LL₂   — {a,aa},{a},{aa}; separa aaa  (⊆ sí)
    L₁L=L₂L ⟹ L₁=L₂   — L=a*, L₁=Λ, L₂={λ,a}
    L⊆L² ⟺ λ∈L        — L=∅   (V si L≠∅)
    Sub(L₁∩L₂)=∩ de Sub — {ab},{ba}; separa a     (con ∪ es V)
○   Sub(L*)=Sub(L)*    — L={ab}; separa aa        (⊆ sí)
    ⇒ contraejemplo = lenguajes + LA PALABRA. Sin ella, −50%.

[7] Ini / Fin / Sub / COCIENTE
    Ini={α:∃β αβ∈L}  Fin={β:∃α αβ∈L}  Sub={β:∃α,γ αβγ∈L}
    Fin(L)ʳ = Ini(Lʳ)        Sub(Lʳ) = Sub(L)ʳ
    Sub(L) = Ini(Fin(L)) = Fin(Ini(L))
    Idempotentes; distribuyen sobre ∪ (sobre ∩, NO)
    α⁻¹L = {β : αβ∈L}    Fin(L) = (Σ*)⁻¹L
○   Ini(L) = {α : α⁻¹L ≠ ∅}      (L₁L₂)⁻¹L = L₂⁻¹(L₁⁻¹L)
    HIPÓTESIS QUE FALTAN:  Ini(L₁L₂)=Ini L₁ ∪ L₁Ini L₂ pide L₂≠∅
                           Ini(L*)=L*Ini(L)           pide L≠∅

═══ CARA B — AUTÓMATAS, DETERMINIZACIÓN, MINIMIZACIÓN ═══

[8] λ-CLAUSURA Y DETERMINIZACIÓN
    λ-cl(q)=menor conj. con q cerrado por λ; λ-cl(S)=⋃_{q∈S}λ-cl(q)
    q₀' = λ-cl(q₀)
    δ'(S,a) = λ-cl( ⋃_{q∈S} δ(q,a) )
    F' = { S : S ∩ F ≠ ∅ }
    AFND sin λ: ídem sin λ-cl. Construir SÓLO los S alcanzables.

[9] MINIMIZACIÓN POR n-EQUIVALENCIA
    ORDEN: (1) sacar inalcanzables (2) TOTALIZAR (3) refinar
    p ≡ₙ q ⟺ ∀α, |α|≤n : δ̂(p,α)∈F ⟺ δ̂(q,α)∈F
    ≡₀ = { F , Q∖F }
    p ≡ₖ₊₁ q ⟺ p ≡ₖ q ∧ ∀a∈Σ : δ(p,a) ≡ₖ δ(q,a)
    PARADA: ≡ₖ₊₁=≡ₖ ⟹ ≡=≡ₖ. Corta en ≤|Q| rondas. Mínimo ÚNICO.
    ⚠ Sin totalizar, minimización y complemento dan mal.

[10] MYHILL–NERODE   (puente [9] ↔ [12])
     #estados del mínimo = #{ α⁻¹L : α∈Σ* };  L reg ⟺ es finito
     MINIMALIDAD: k palabras 2 a 2 distinguibles ⟹ ≥k estados
     NO REG: exhibir INFINITAS 2 a 2 distinguibles

[11] CONSTRUCCIONES:  operación : cómo — qué exige — qué sale
     Lᶜ     : dar vuelta F — exige AFD TOTAL — AFD
     L₁∪L₂  : nuevo q₀ con λ a ambos — nada — AFND-λ
     L₁∩L₂  : producto, F=F₁×F₂ — exige AFDs — AFD
     L₁L₂   : λ de F₁ a q₀², F=F₂ — nada — AFND-λ
     L*     : nuevo q₀ FINAL, λ a q₀ viejo, λ de F a q₀ — AFND-λ
     Lʳ     : dar vuelta flechas, q₀↔F — AFND-λ (multi-inicial)
     Ini(L) : F'={q : q alcanza F} — nada — mismo tipo
     Fin(L) : iniciales={q alcanzable desde q₀} — AFND-λ
     Sub(L) : las dos cosas juntas — AFND-λ
○    Máx(L) : F'={q∈F : no alcanza F con α≠λ} — exige AFD — AFD
○    Mín(L) : borrar transiciones salientes de F — exige AFD — AFD
     α⁻¹L   : mover q₀ a δ̂(q₀,α) — exige AFD — AFD
○    L₁∖L₂  : = L₁ ∩ L₂ᶜ (total)      L·Σ* : λ de F a sumidero final
     ⚠ L*: sin el q₀ nuevo y final se pierde λ o sobran palabras.
     ⇒ contestar SIEMPRE qué exige y qué sale. Si no, −50%.

[12] BOMBEO REGULAR
     L reg ⟹ ∃n ∀w∈L,|w|≥n ∃x,y,z :
       w=xyz ∧ |xy|≤n ∧ |y|≥1 ∧ ∀m≥0 : xyᵐz ∈ L
     REFUTAR = dar, ∀n, una w, y romper TODA descomposición.
     Sea n. Tomo w=___∈L, |w|≥n. Como |xy|≤n, y=___ , 1≤k≤n.
     Tomo m=___ ⟹ xyᵐz=___ ∉ L porque ___.
     ⚠ Bombear también HACIA ABAJO (m=0).
     ⚠ Recíproco FALSO: cumplirlo no prueba nada.
     Alternativa: ∩ con regular / ᶜ / ʳ / cociente → caer en {aⁿbⁿ}

[13] BOMBEO LIBRE DE CONTEXTO
     L LC ⟹ ∃p ∀z∈L,|z|≥p ∃u,v,w,x,y :
       z=uvwxy ∧ |vwx|≤p ∧ |vx|≥1 ∧ ∀i≥0 : uvⁱwxⁱy ∈ L
     MAESTRA: |vwx|≤p ⟹ toca ≤2 BLOQUES ADYACENTES.
     Con 3 bloques: 3 "dentro de" + 2 "a caballo" = 5 casos.
○    Caso olvidado: vwx contiene el separador pero v y x no.

[14] CLAUSURA POR CLASE
     REGULAR: TODO (∪ ∩ · * ᶜ ʳ ∖)
     LC : SÍ ∪ · * ʳ y ∩ con REGULAR — NO ∩ , NO ᶜ
     LCD: SÍ ᶜ y ∩ con REGULAR — NO ∪ ∩ · *
○    LC no cerrado por ᶜ ← De Morgan + no cerrado por ∩
     PROBAR "no determinístico": si fuera LCD, Lᶜ sería LC;
       ∩ con regular → absurdo. ("No encontré uno" no vale.)

○[15] PRE-FLIGHT — primer minuto (TODO repetido: se cae primero)
○    1. Evaluar toda identidad en ∅ y en Λ.
○    2. Contraejemplo = lenguajes + LA PALABRA que separa.
○    3. Decir sobre qué variable se induce + caso base.
○    4. Totalizar ANTES de complementar o minimizar.
○    5. Contestar la meta-pregunta de toda construcción.
○    6. Bombeo: todas las descomposiciones, y también m=0.
```

---

## Trazabilidad

Todo renglón de los bloques [5] [6] [7] está demostrado en
[`ejercicios-parciales/01-lenguajes/soluciones.md`](ejercicios-parciales/01-lenguajes/soluciones.md):

| Bloque | Fuente |
|---|---|
| [3] H2–H6 | encabezado de `soluciones.md`; H7 ← C7, H8 ← B4 (Levi) |
| [4] | A1, A3, C8 |
| [5] | C2, C1, C3, C5, C6, C10, C11 |
| [6] | C1, F1b, C4, C7, C13, D4; el `○` ← `parciales-modelo/modelo-a-clave.md` |
| [7] | D2, D3, D4, D7; hipótesis faltantes ← D1 y D5 |
| [8] [9] | verificados contra el ej. 2 de `parciales-modelo/modelo-a-clave.md` |
| [10] | `modelo-b-clave.md` ej. 1, `modelo-c-clave.md` ej. 2 |
| [11] | ejercicios 4 y 5 de la *Práctica 2* (`guias/`) |
| [12] [13] [14] | claves de los modelos B, C y D |

## Lo que quedó afuera a propósito

- **Demostraciones.** Ilegibles a velocidad de examen: sólo enunciados.
- **Cómo construir un autómata desde una descripción.** Se sabe o no; ninguna tabla ayuda.
- **Cardinalidad y diagonalización** (bloque E de `01-lenguajes`): es puente al *segundo*
  parcial. Sobrevive una línea en [12], la que justifica el "tomo w∈L con |w|≥n".
- **Patrones de construcción de AP y catálogo de lenguajes de referencia.** Primero en caerse
  al elegir 2 carillas. Están en las claves de `parciales-modelo/`.
- **Expresiones regulares y gramáticas.** No hay guía de esos temas en `guias/` (ver
  `parciales-modelo/README.md` §0). Si entran al parcial, esta hoja necesita una tercera carilla.
