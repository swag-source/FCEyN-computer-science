#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "Estructuras.h"

int main()
{
	/* Acá pueden realizar sus propias pruebas */
	lista_t l;

	nodo_t n1;
	nodo_t n2;
	nodo_t n3;

	uint32_t *arr_1 = calloc(sizeof(uint32_t), 3);
	uint32_t *arr_2 = calloc(sizeof(uint32_t), 2);
	uint32_t *arr_3 = calloc(sizeof(uint32_t), 4);

	n3.arreglo = arr_3;
	n3.categoria = 0x00;
	n3.longitud = 4;
	n3.next = NULL;

	n2.arreglo = arr_2;
	n2.categoria = 0x00;
	n2.longitud = 2;
	n2.next = &n3;

	n1.arreglo = arr_1;
	n1.categoria = 0x00;
	n1.longitud = 3;
	n1.next = &n2;

	l.head = &n1;

	assert(cantidad_total_de_elementos(&l) == 9);

	packed_lista_t pl;

	packed_nodo_t pn1;
	packed_nodo_t pn2;
	packed_nodo_t pn3;

	pn3.arreglo = arr_3;
	pn3.categoria = 0x00;
	pn3.longitud = 4;
	pn3.next = NULL;

	pn2.arreglo = arr_2;
	pn2.categoria = 0x00;
	pn2.longitud = 2;
	pn2.next = &pn3;

	pn1.arreglo = arr_1;
	pn1.categoria = 0x00;
	pn1.longitud = 3;
	pn1.next = &pn2;

	pl.head = &pn1;

	assert(cantidad_total_de_elementos_packed(&pl) == 9);

	free(arr_1);
	free(arr_2);
	free(arr_3);
	return 0;
}
