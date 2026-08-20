# Arquitectura básica IA-32 e Intel 64

## Ejercicio 1: IA-32 Entorno de ejecución
Busquen en el manual la sección 3.2 Overview of the basic execution environment en Vol. 1 3-2. En base a lo que dice la sección Address Space y la figura 3-1 IA-32 Basic Execution Environment for Non-64 bit Modes. Indiquen:
  a. ¿Cuál es el tamaño en bits de una dirección de memoria en la arquitectura IA-32 y cuál es la unidad más pequeña que podemos direccionar?
  b. ¿Cuántos registros de propósito general hay en IA-32 y que tamaño tienen? Sección 3.4.1 General Purpose Registers
  c. Busquen en el manual que guarda el registro EIP (Instruction Pointer) e indiquen su tamaño en bits. ¿Por qué motivo creen que el EIP tiene ese tamaño en bits?

## Solución
### Ejercicio 1
  a. El tamaño en bits de una dirección de memoria de IA-32 son 32 bits (equivalentemente, 4 bytes). La unidad más pequeña que podemos direccionar es de a byte.
  b. La arquitectura IA-32 cuenta con un conjunto de 8 registros de propósito general de 32 bits (4 bytes). Los mismos se definen de la siguiente manera: \[eax, ebx, ecx, edx, esi, edi, ebp, esp\].
  c. El registro EIP (Instruction Pointer) guarda en el entorno de ejecución, la dirección de memoria de la siguiente instrucción a ejecutar. Dado que la arquitectura IA-32 cuenta con direcciones de 32 bits, el registro EIP almacenará direcciones que pertenecen al espacio direccionable.

## Ejercicio 2: Flags
Busquen en el manual la sección 3.4 BASIC PROGRAM EXECUTION REGISTERS en Vol. 1 3-10. Indiquen:
  a. Busquen en la sección del manual qué guarda el registro EFLAGS ve indiquen su tamaño en bits.
  b. En el formato del registro, busquen los siguiente bits e indiquen para qué son y en qué posición del registro están
almacenados: Flag de Overflow, Flag de Signo, Flag de Interrupciones.
  c. Indiquen si en la arquitectura Intel 64 se usa el mismo registro. En caso que sea otro, indiquen su tamaño y la relación tendrı́a con el de IA-32.

## Solución
### Ejercicio 2
  a. El registro EFLAGS (execution flags) es un registro de propósito especifico con tamaño de 4 bytes, 32 bits, que registra el estado de ejecución del programa actual. Nos permite guardar un "snapshot" del estado de la ejecución para luego retomarla en el caso de que otra tarea necesite ser ejecutada (el estado de EFLAGS se guarda en la TSS asociada a la tarea que se pausará)
  b. Bits de:
    * Flag overflow (OF): Bit 11
    * Sign flag (SF): Bit 7
    * Interruption flag (IF): Bit 9
  c. Intel-64 utiliza el registro RFLAGS como extensión de EFLAGS, donde la parte alta (32 bits más altos) se reservan, mientras que los 32 bits más bajos mantienen el significado de EFLAGS IA-32.

## Ejercicio 3: Stack y llamadas a función 
Busquen en el manual la sección Overview of the basic execution environment en 3-2 Vol. 1. En el párrafo donde menciona la pila (Stack), en la página 3-4 Vol. 1. Indiquen:
  a. ¿Para qué es necesaria la pila? ¿Donde está ubicada?
  b. ¿Para qué sirven los registros ESP y EBP?¿Que consideraciones debemos tener al trabajar con cada uno ellos?
  c. En el primer parrafo de la sección 6.2.4.2 Return Instruction Pointer, ¿Qué registro se pushea en la pila al hacer un CALL? Discutan con sus compañeros por qué creen que ocurre eso.
  d. En el primer parrafo de la sección 6.2.4.2 Return Instruction Pointer, ¿Qué ocurre al hacer un RET? Discutan con sus compañeros por qué creen que ocurre eso.
  e. En el segundo parrafo de la sección 6.2.4.2 Return Instruction Pointer, ¿Qué debe asegurarse el programador antes de llamar a un RET cuando esta escribiendo una subrutina? ¿Cómo lo asegura?
  f. ¿Cuál es el ancho de la pila en modo 32 bits y en 64 bits? (tamaño del dato de PUSH y POP)
  g. Luego de responder las preguntan anteriores, discutan en grupo si el EBP podrı́a ser usado para guardar datos que no sean la base de la pila. ¿Qué opinan?

## Solución
### Ejercicio 3
  a. La pila es una estructura de datos contiguo en memoria, utilizada para el almacenamiento de valores fundamentales al contexto de ejecución de un programa. La misma se determina relativa a las direcciones de memoria delimitadas por los registros \[RBP,RSP\] en IA-64 o \[EBP,ESP\] en IA-32.
  b. Los registros ESP (Stack Pointer) y EBP (Base Pointer) nos permiten determinar el stack frame de la función de ejecución actual. Al trabajar con estos registros, debemos recordar que EBP (por convención) se debe alinear a direcciones de memoria múltiplo de 4 bytes. Adicionalmente, el EBP guarda la dirección de memoria perteneciente al EBP de la función caller, con el objetivo de retomar la posición de base de la pila una vez concluída la ejecución de la función callee.
  c. El registro RIP en IA-64 o EIP en IA-32 es el registro pusheado a la pila (de la función en ejecución) a la hora de realizar una llamada a CALL. Dado que requeriremos retomar la ejecución de la función Caller (apuntada por RIP/EIP) una vez que hayamos terminado de ejecutar la función llamada por CALL, en la instrucción consecutiva al llamado a la función Dado que 
  d. Una vez que terminamos de ejecutar la función llamada por CALL, debemos retomar la ejecución en la siguiente instrucción al CALL. El RET es una operación que realiza POP al tope de la pila, ubicando nuevamente el valor de la función caller en el registro EIP y continuar la ejecución. 
  e. Que la pila quede alineada al retornar a la función caller (PREGUNTAR)
  f. El ancho de la pila está determinado por el tamaño de la arquitectura: 32 bits => 32 bits (4 bytes) el ancho de la pila, 64 bits => 64 bits (8 bytes) el ancho de la pila
  g. El EBP podría ser un registro utilizado como propósito general, nada impide su uso para este propósito; la limitación que impondría esto es la pérdida de la base del stack frame (pues no sabremos donde arranca la pila apuntada por el ESP de la función actual) y por ende no sabríamos donde movernos, relativo al EBP de la función.

## Ejercicio 4: Set de instrucciones
  a. DEC, ADD, MOV, JZ, JE
  b. Observen el formato de la instrucción y respondan, ¿cuántos operandos recibe, de qué tipo son y qué tamaño tienen?. Por ejemplo, 2 operandos de los tipo registro-registro de 8 a 64 bits, memoria-registro, memoria-memoria.
  c. ¿Qué hace cada instrucción?
  d. Den uno o más ejemplos de su uso (traten que varı́en los operandos y tamaño de dato leı́do).

## Solución
### Ejercicio 4

| Op.     | Op. 1 | Op. 2 | Description                                    | Size   | Example      |
| ------- | ----- | ----- | ---------------------------------------------- | ------ | ------------ |
| **Add** | r/m8  | r8    | Adds Op. 2 to Op. 1                            | 1 byte | `ADD AL, BL` |
| **Dec** | r/m8  | ∅     | Decrements Op. 1 by 1                          | 1 byte | `DEC AL`     |
| **Mov** | r/m8  | r8    | Copies Op. 2 into Op. 1                        | 1 byte | `MOV AL, BL` |
| **JE**  | D     | ∅     | Jumps if **R1 − R2 = 0** (ZF = 1)              | —      | `JE label`   |
| **JZ**  | D     | ∅     | Jumps if the previous result is **0** (ZF = 1) | —      | `JZ label`   |

  d. La diferencia entre JZ y JE recae en los flags que verifica cada operación. JZ verifica el flag (FZ=1), mientras que JE verifica el flag (FE=1), ambos producto de CMP R1, R2. 

