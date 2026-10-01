# Checklist de examen — ASM x86-64

> Hoja de vuelo personal. Derivada de los errores reales cometidos resolviendo
> `ej3a` (segmentar_casos), no de consejos genéricos.

---

## 0. Antes de escribir una sola instrucción (~25 min)

1. **Leer los 3 enunciados completos.** No arrancar por el ejercicio 1.
2. **Derivar el bloque `EQU` de TODOS los structs, en papel.** Los structs se
   comparten entre ejercicios: 25 minutos acá protegen las 5 horas.

   - **Regla A (offset de campo):** cada campo arranca en el próximo offset que
     es múltiplo de **su propia** alineación.
   - **Regla B (tamaño del struct):** redondear el final del último campo al
     próximo múltiplo de la alineación **del struct** (= la máxima de sus campos).

   Son dos reglas distintas. La B es un no-op muchas veces, y por eso se olvida
   que existe.

   | tipo | alineación |
   |---|---|
   | `char`, `uint8_t`, `bool` | 1 |
   | `uint16_t` | 2 |
   | `int`, `uint32_t`, `float` | 4 |
   | punteros, `uint64_t`, `double` | 8 |

   Ejemplos verificados:

   ```c
   struct { char categoria[3]; uint16_t estado; usuario_t* usuario; }
   // 0, 4, 8  → size 16  (padding interno en byte 3 y bytes 6-7, sin cola)

   struct { uint8_t a,b,c,d,e,f,g; }
   // alineación del struct = 1 → size 7, NO 8
   ```

3. **Por qué el `SIZE` importa:** es el paso del arreglo.
   `&arr[i] = base + i * SIZE`. Si el SIZE está mal, todo el direccionamiento
   de abajo hereda el error.

---

## 1. Orden de trabajo, por ejercicio

1. C completo (o C en comentarios), **con tabla de registros** anotando cuáles
   son no volátiles.
2. **Prólogo y epílogo como par**, tipeados juntos, antes del cuerpo.
   Cada `push` recibe su `pop` en el momento.
3. Cuerpo, una línea de C por vez, con la línea de C como comentario arriba.
4. Pasar el checklist de la sección 2. **Recién ahí** correr los tests.

---

## 2. Checklist (pasar antes de correr los tests)

- [ ] 1. Bloque `EQU` derivado en papel, **todos los structs**, tamaños redondeados.
- [ ] 2. `push`es = `pop`s, mismos registros, orden inverso.
- [ ] 3. No volátiles (`rbx`, `rbp`, `r12`–`r15`): o no los toco, o los preservo.
       **`rbx` es mi trampa personal** — es corto de tipear y se siente scratch.
- [ ] 4. `rsp ≡ 0 (mod 16)` en **cada** `call`.
- [ ] 5. Cada slot de stack: **mismo ancho al escribir que al leer.**
       Un slot de `int` reusado como puntero necesita escritura de 8 bytes.
- [ ] 6. Escritura de campo = `mov [base + OFF], val`. Una instrucción, sin
       load intermedio. **La dirección ES base + offset.**
- [ ] 7. La escala del índice de un arreglo es siempre `sizeof(struct)`, nunca
       el tamaño de un campo.
- [ ] 8. Copiar un struct = `size/8` movimientos, no uno.
- [ ] 9. Una etiqueta por salida de rama. Si hay más de un `if`, dibujar el
       diagrama de flujo y verificar que las ramas **reconvergen**.
- [ ] 10. Valor de retorno en `rax`.

---

## 3. ABI System V — referencia rápida

| | registros |
|---|---|
| Argumentos enteros | `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9` |
| Retorno | `rax` |
| **Volátiles** (puedo pisar) | `rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8`–`r11` |
| **No volátiles** (debo preservar) | `rbx`, `rbp`, `r12`, `r13`, `r14`, `r15` |

Alineación de stack: al entrar a una función `rsp ≡ 8 (mod 16)`.
`push rbp` → `≡ 0`. Cada `push` posterior invierte la paridad.
Si pusheo registros **después** del `sub rsp, N`, no colisionan con los slots
`[rbp - k]` — y si no hay ningún `call` después, el desalineo no molesta.

---

## 4. Idiomas que siempre uso

```nasm
; leer campo
mov reg, [base + CAMPO_OFFSET]

; escribir campo   <-- NO hacer un load intermedio primero
mov [base + CAMPO_OFFSET], reg

; &arr[i]
imul r11, r_i, STRUCT_SIZE
add  r11, base

; copiar un struct de 16 bytes
mov rax, qword [rsrc]
mov qword [rdst], rax
mov rax, qword [rsrc + 8]
mov qword [rdst + 8], rax

; poner NULL en un slot (los 8 bytes, no 4)
mov qword [rbp - N], 0

; patrón if/else que reconverge
    test edi, edi
    jz .skip_0
    ; ... rama verdadera
.skip_0:
```

---

## 5. Mis errores recurrentes, por frecuencia

1. `EQU` mal derivado
2. Ancho de escritura ≠ ancho de lectura en el mismo slot
3. Leer un campo cuando quería escribirlo
4. `push`/`pop` desbalanceado
5. Slots de stack intercambiados (`[rbp-24]` vs `[rbp-32]`)
6. Una sola etiqueta para tres salidas distintas
7. `rbx` pisado sin guardar
8. Copiar un struct con un solo `mov`

> **Regla de oro:** cuando encuentro UNO, busco inmediatamente los otros del
> mismo tipo en todo el archivo. El error más caro del último práctico fue
> arreglar la instancia y no la clase.

---

## 6. Triage de segfault (máximo 15 min por crash)

```
gdb -batch -ex run -ex bt -ex "info registers" ./test_asm
```

La única pregunta que importa:

> **¿Cuál operando de la instrucción que falló ya era basura antes de que
> esta instrucción corriera?**

Después se trabaja hacia atrás desde ese registro.

- Si un puntero se ve como `0x300000000`: **partirlo al medio** y preguntar
  quién escribió cada mitad. Mitad baja correcta + mitad alta basura =
  escribí `dword` y leí `qword`.
- Si `i == 0` y falla igual: la multiplicación es irrelevante, **solo el
  offset puede estar mal.**

Sospechosos, en orden:
1. El bloque `EQU`
2. Desajuste de ancho (`dword` / `qword`)
3. Una etiqueta haciendo doble función

Si a los 15 min no está localizado: dejar un comentario, pasar al siguiente
ejercicio, volver después.

---

## 7. Plan de 5 horas

| tramo | qué |
|---|---|
| 0:00 – 0:25 | Leer los 3 enunciados. Derivar todos los `EQU`. |
| 0:25 – 1:45 | Ejercicio **más fácil** — calentar y asegurar puntos. |
| 1:45 – 1:55 | **Pausa lejos de la pantalla.** |
| 1:55 – 3:20 | Ejercicio **más difícil** — foco pico. |
| 3:20 – 3:30 | **Pausa.** |
| 3:30 – 4:20 | Ejercicio restante (el más confiable va último: voy cansado). |
| 4:20 – 5:00 | Pasada de checklist sobre los 3. **Nada de código nuevo.** |

Un ejercicio parcialmente correcto, con prólogo limpio, offsets bien y
estructura sana, puntúa. Uno que segfaultea y que seguía editando a las 4:58,
no.

---

## 8. Antes de entregar

```
make valgrind_asm     # fugas y errores de memoria
make test_abi         # offsets + preservación de no volátiles
```

Ambos estaban en el Makefile todo el tiempo y no los corrí ni una vez por
iniciativa propia. Son el único feedback disponible en el examen.
