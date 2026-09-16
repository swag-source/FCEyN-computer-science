#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej1.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
bool EJERCICIO_1A_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - indice_a_inventario
 */
bool EJERCICIO_1B_HECHO = true;

bool es_indice_ordenado(item_t **inventario, uint16_t *indice, uint16_t tamanio, comparador_t comparador)
{
	for (uint16_t i = 0; i < tamanio - 1; i++)
	{
		if (!comparador(inventario[indice[i]], inventario[indice[i + 1]]))
		{
			return 0;
		}
	}
	return 1;
}

item_t **indice_a_inventario(item_t **inventario, uint16_t *indice, uint16_t tamanio)
{
	// ¿Cuánta memoria hay que pedir para el resultado?
	item_t **resultado;

	resultado = malloc(tamanio * sizeof(item_t *)); // n * sizeof(inventario)

	for (uint16_t i = 0; i < tamanio; i++)
	{
		resultado[i] = inventario[indice[i]];
	};

	return resultado;
}
