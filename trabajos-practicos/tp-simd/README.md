# TP SIMD - 2do Cuatrimestre 2026
## Arquitectura y Organización del Computador

- **Presentación**: 28/09/2026
- **Entregas y reentregas**: Hasta el 12/10/2026 a las 23:59

-----------

En este trabajo vamos a implementar una secuencia de algoritmos para procesar tonos de teléfono y decodificar los números marcados.
Utilizaremos los sets de instrucciones SIMD disponibles en procesadores intel (SSE, SSE2, SSE3, AVX, etc).
Aplicaremos lo visto en clase programando de manera vectorizada cada una de las manipulaciones relevantes.

Se espera que los ejercicios se resuelvan haciendo uso del paradigma SIMD, procesando **múltiples datos simultáneamente** siempre que sea posible.

# Compilación y Testeo

Para compilar y ejecutar los tests se dispone de un archivo
`Makefile` con los siguientes *targets*:

| Comando             | Descripción                                                                    |
| ------------------- | ------------------------------------------------------------------------------ |
| `make run_c`        | Corre el ejecutable principal del ejercicio.                                   |
| `make run_asm`      | Corre el ejecutable principal del ejercicio.                                   |
| `make run_test_c`   | Corre los tests  usando la implementación en C.                                |
| `make run_test_asm` | Corre los tests  usando la implementación en ASM.                              |
| `make valgrind_c`   | Corre los tests  en valgrind usando la implementación en C.                    |
| `make valgrind_asm` | Corre los tests  en valgrind usando la implementación en ASM.                  |
| `make main_c`       | Genera el ejecutable principal del ejercicio usando la implementación en C.    |
| `make main_asm`     | Genera el ejecutable principal del ejercicio usando la implementación en ASM.  |
| `make test_c`       | Genera el ejecutable de testing usando la implementación en C del ejercicio.   |
| `make test_asm`     | Genera el ejecutable de testing usando la implementación en ASM del ejercicio. |
| `make clean`        | Borra todo archivo generado por el `Makefile`.                                 |

# A tener en cuenta

- Es importante que lean la documentación provista en los archivos correspondientes (`ej.h`, `ej.c` ó `ej.asm` según corresponda).
- Todos los incisos son independientes entre sí.
- El sistema de tests de este trabajo práctico **sólo correrá los tests que hayan marcado como hechos**.
  Para esto deben modificar la variable correspondiente (`ej_1_hecho`, `ej_2_hecho`, etc) asignándole `true` (en C) ó `TRUE` (en ASM).

## Ejercicio 1

Los tonos de teléfono están dados por la suma de dos senos.
La rutina `ej1_sample` realiza esa suma respetando la periodicidad correspondiente a cada uno de ellos.

|            | 1209 Hz | 1336 Hz | 1477 Hz |
| ---------- | ------- | ------- | ------- |
| **697 Hz** |    1    |    2    |    3    |
| **770 Hz** |    4    |    5    |    6    |
| **852 Hz** |    7    |    8    |    9    |
| **941 Hz** |    *    |    0    |    #    |


La firma de la rutina a implementar el la siguiente:
```c
void ej1_sample(size_t buf_len, int16_t buf[buf_len],
                size_t freq_a_len, int16_t freq_a[freq_a_len], size_t a_start,
                size_t freq_b_len, int16_t freq_b[freq_b_len], size_t b_start);
```

La rutina debe llenar `buf[i]` con la suma `(freq_a[j] + freq_b[k]) / 2` correspondiente.
Se debe respetar el desfasaje solicitado para cada una (`a_start` y `b_start`).

## Ejercicio 2

Así como generamos señales también nos interesa poder detectarlas.
Para esto podemos hacer uso de la amplitud observada en la transformada de fourier de una señal en cuestión.

La rutina a implementar tiene la siguiente firma:
```c
float ej2_detect(size_t size, int16_t signal[size], sincos_t freq[size]);
```

Dónde `sincos_t` es la estructura:
```c
typedef struct sincos {
	float sin;
	float cos;
} sincos_t;
```

Y el resultado se corresponde con la siguiente expresión:
```math
\begin{align*}
\text{Re} &= \sum_{i=0}^{\text{Size}} \text{Signal}[i] * \text{Cos}[i] \\
\text{Im} &= \sum_{i=0}^{\text{Size}} \text{Signal}[i] * \text{Sin}[i] \\
\text{Resultado} &= \frac{2\sqrt{\text{Re}^2 + \text{Im}^2}}{\text{Size}}
\end{align*}
```

## Ejercicio 3

Apretar un botón lo registra durante muchísimo tiempo por lo que marcar `1256` puede generar un registro con la forma `11111111111111111122222222222222222222222222255555555555555555555555555555555555556666666666666666666666666666666666`.
También ocurre que entre botón y botón una persona puede dejar la línea en silencio por un tiempo considerable obteniendo `111111111111111111                  11111111111111111111` para la secuencia `11`.

Queremos entonces implementar una rutina que elimine tanto los duplicados como el silencio entre cada botón presionado.
El algoritmo a implementar es el siguiente:

1. Se parte la entrada en bloques de 16 señales (posibles dígitos o silencios detectados).
2. El silencio  (` `) es la nueva señal de referencia.
3. Se recorren todos los bloques de la entrada:
   1. Si no todas las señales del bloque actual son iguales se descarta el bloque.
   2. Si es igual a la señal de referencia se descarta el bloque.
   3. Sino la señal actual es la nueva "señal de referencia"
   4. Si la actual señal es un silencio se descarta el bloque.
   5. Sino se registra la señal de referencia en la salida.

Se debe implementar la rutina:
```c
void ej3_remove_duplicates(size_t size, char detected[size], char output[]);
```

## Ejercicio 4

Finalmente queremos poder expresar estas señales de forma numérica.
Cada una posee hasta 10 dígitos y se encuentra alineada con silencios (` `) a la izquierda.

La firma de la rutina a implementar es:
```c
void ej4_get_numbers(size_t size, char numbers[10 * (size - 1) + 16], size_t output[size]);
```

## Cosas a tener en consideración

- Las entradas tienen suficiente padding al final (no es necesario hacer lecturas pequeñas para la última iteración).
- Las entradas del ejercicio 1 no causan overflow al sumarse.
- En el ejercicio 3 y 4 se puede asumir que la entrada está compuesta por ` ` y caracteres numéricos.
- El ejercicio 1 puede resolverse de a 8 words en simultáneo.
- El ejercicio 2 puede resolverse de a 2 words en simultáneo.
- El ejercicio 3 realiza la comparación en paralelo y procesa de a un único bloque.
- El ejercicio 4 realiza la conversión en paralelo. Se puede resolver procesando de a 10 bytes en simultáneo. Soluciones que parten la entrada en sub-bloques de 4 u 8 bytes también son válidas.
