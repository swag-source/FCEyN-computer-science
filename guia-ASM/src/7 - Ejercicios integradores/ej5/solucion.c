#include <stdlib.h>
#include <string.h>

#include "ejercicio.h"

/**
 * Marca el ejercicio 1 como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - hay_accion_que_toque
 */
bool EJERCICIO_1_HECHO = true;

/**
 * Marca el ejercicio 2 como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - invocar_acciones
 */
bool EJERCICIO_2_HECHO = true;

/**
 * Marca el ejercicio 3 como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - contar_cartas
 */
bool EJERCICIO_3_HECHO = true;

/**
 * Dada una secuencia de acciones determinar si hay alguna cuya carta tenga un
 * nombre idéntico (mismos contenidos, no mismo puntero) al pasado por
 * parámetro.
 *
 * El resultado es un valor booleano, la representación de los booleanos de C es
 * la siguiente:
 *   - El valor `0` es `false`
 *   - Cualquier otro valor es `true`
 */
bool hay_accion_que_toque(accion_t *accion, char *nombre)
{
	accion_t **idx = &accion;

	while ((*idx) != NULL)
	{
		if (!strcmp((*idx)->destino->nombre, nombre))
		{
			return true;
		}
		(*idx) = (*idx)->siguiente;
	}

	return false;
}

void invocar_acciones(accion_t *accion, tablero_t *tablero)
{
}

/**
 * Cuenta la cantidad de cartas rojas y azules en el tablero.
 *
 * Dado un tablero revisa el campo de juego y cuenta la cantidad de cartas
 * correspondientes al jugador rojo y al jugador azul. Este conteo incluye
 * tanto a las cartas en juego cómo a las fuera de juego (siempre que estén
 * visibles en el campo).
 *
 * Se debe considerar el caso de que el campo contenga cartas que no pertenecen
 * a ninguno de los dos jugadores.
 *
 * Las posiciones libres del campo tienen punteros nulos en lugar de apuntar a
 * una carta.
 *
 * El resultado debe ser escrito en las posiciones de memoria proporcionadas
 * como parámetro.
 */
void contar_cartas(tablero_t *tablero, uint32_t *cant_rojas, uint32_t *cant_azules)
{
	*cant_rojas = *cant_azules = 0;

	for (int i = 0; i < ALTO_CAMPO; i++)
	{
		for (int j = 0; j < ANCHO_CAMPO; j++)
		{
			if (tablero->campo[i][j] != NULL)
			{
				if (tablero->campo[i][j]->jugador == JUGADOR_AZUL)
				{
					*cant_azules = *cant_azules + 1;
				}
				if (tablero->campo[i][j]->jugador == JUGADOR_ROJO)
				{
					*cant_rojas = *cant_rojas + 1;
				}
			}
		}
	}
}
