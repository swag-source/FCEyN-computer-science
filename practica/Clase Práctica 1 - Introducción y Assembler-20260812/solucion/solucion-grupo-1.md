# Arquitectura básica IA-32 e Intel 64

## Ejercicio 1: IA-32 Entorno de ejecución
Busquen en el manual la sección 3.2 Overview of the basic execution environment en Vol. 1 3-2. En base a lo que dice la sección Address Space y la figura 3-1 IA-32 Basic Execution Environment for Non-64 bit Modes. Indiquen:
  a. ¿Cuál es el tamaño en bits de una dirección de memoria en la arquitectura IA-32 y cuál es la unidad más pequeña que podemos direccionar?
  b. ¿Cuántos registros de propósito general hay en IA-32 y que tamaño tienen? Sección 3.4.1 General Purpose Registers
  c. Busquen en el manual que guarda el registro EIP (Instruction Pointer) e indiquen su tamaño en bits. ¿Por qué motivo creen que el EIP tiene ese tamaño en bits?

## Solución
  a. El tamaño en bits de una dirección de memoria de IA-32 son 32 bits (equivalentemente, 4 bytes). La unidad más pequeña que podemos direccionar es de a byte.
  b. La arquitectura IA-32 cuenta con un conjunto de 8 registros de propósito general de 32 bits (4 bytes). Los mismos se definen de la siguiente manera: \[eax, ebx, ecx, edx, esi, edi, ebp, esp\].
  c. El registro EIP (Instruction Pointer) guarda en el entorno de ejecución, la dirección de memoria de la siguiente instrucción a ejecutar. Dado que la arquitectura IA-32 cuenta con direcciones de 32 bits, el registro EIP almacenará direcciones que pertenecen al espacio direccionable.
