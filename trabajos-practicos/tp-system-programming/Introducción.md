# Trabajo Práctico de System Programming

Arquitectura y Organización del Computador

## Partes

- [Parte 1: Pasaje a modo protegido](01_modo-protegido.md)
- [Parte 2: Interrupciones](02_interrupciones.md)
- [Parte 3: Paginación](03_paginacion.md)
- [Parte 4: Tareas](04_tareas.md)

## Introducción

Durante la actual y las próximas clases, vamos a adentrarnos al mundo de
System Programming. Como hemos visto en la teórica, al arrancar una
computadora, hay una serie de tareas que realiza el sistema operativo
que tienen como objetivo crear un entorno controlado y seguro donde
ejecutar programas y arbitrar el acceso a los recursos.

El trabajo va a ser incremental a lo largo de varias clases prácticas.
Vamos a crear un único software en modo 32 bits desde hoy a fin de
cuatrimestre.

Clase a clase, vamos a trabajar una perspectiva o parte diferente del
sistema.

## El manual

Intel nos ofrece documentación para que podamos llevar a cabo la tarea
antes descripta. A partir de ahora, vamos a utilizar también el manual:

[*Intel® 64 and IA-32 Architectures Software Developer's Manual Volume 3
(3A, 3B, 3C & 3D):System Programming
Guide*](https://software.intel.com/content/dam/develop/external/us/en/documents-tps/325384-sdm-vol-3abcd.pdf)

Adicionalmente, van a tener que consultar los manuales que vimos en la
primeras clases:

[*Intel® 64 and IA-32 Architectures Software Developer\'s Manual Volume
1: Basic
Architecture*](https://software.intel.com/content/dam/develop/external/us/en/documents-tps/253665-sdm-vol-1.pdf)

[*Intel® 64 and IA-32 Architectures Software Developer\'s Manual Volume
2: Instruction Set Reference,
A-Z*](https://software.intel.com/content/dam/develop/external/us/en/documents-tps/325383-sdm-vol-2abcd.pdf)

## QEMU

Vamos a utilizar como entorno de pruebas el programa QEMU. Este nos
permite simular el arranque de una computadora IBM-PC compatible.

Como vimos en las clases teóricas, al inicio, una computadora comienza
con la ejecución del POST y del BIOS. El BIOS se encarga de reconocer el
primer dispositivo de booteo. En nuestro taller, vamos a utilizar como
dispositivo un Floppy Disk (el disquete en lugar del disco rígido como
suele ser comúnmente). Para eso, vamos a utilizar una imagen Floppy Disk
virtual en QEMU como dispositivo de booteo. En el primer sector del
floppy, se almacena el boot-sector (sector de arranque). El BIOS se
encarga de copiar a memoria 512 bytes del sector de booteo, y dejarlo a
partir de la dirección `0x7C00`. Luego, se comienza a ejecutar el código a
partir de esta dirección. El boot-sector debe encontrar en el floppy el
archivo `KERNEL.BIN` y copiarlo a memoria. Éste se copia a partir de la
dirección `0x1200`, y luego se ejecuta a partir de esa misma dirección.

Es importante tener en cuenta que el código del boot-sector se encarga
exclusivamente de copiar el kernel y dar el control al mismo, es decir,
no cambia el modo del procesador. Este código inicial viene dado en el
taller y nuestro trabajo, a partir de ahí, va a ser construir parte de
ese kernel de modo que a final de cuatrimestre, pueda ejecutar programas
y tareas sencillas.

## Resolución del trabajo práctico

Este bundle contiene todo el código necesario para resolver las cuatro partes del trabajo práctico. A medida que avancen con las consignas, en el código van a encontrar comentarios del estilo `COMPLETAR ... (Parte 1: Pasaje a modo protegido)` o `COMPLETAR ... (Parte 4: Tareas)`. Esto indica que ese comentario del código aplica solo a la consigna de la parte que especifica.

Al principio de la consigna de cada parte hay una lista con los archivos relevantes a esa parte del trabajo práctico. Hay muchos archivos que no serán usados hasta la última parte del trabajo.
