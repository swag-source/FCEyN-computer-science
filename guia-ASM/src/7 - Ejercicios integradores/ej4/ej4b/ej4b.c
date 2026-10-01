#include "ej4b.h"

#include <string.h>

void verificar_arqueotipo(card_t *carta, char *habilidad)
{
	// Caso base
	if (carta == NULL)
	{
		return;
	}

	// Paso recursivo
	for (int i = 0; i < carta->__dir_entries; i++)
	{
		if (!strcmp(carta->__dir[i]->ability_name, habilidad))
		{
			ability_function_t *call = carta->__dir[i]->ability_ptr;
			call(carta);
		}
	}

	verificar_arqueotipo(carta->__archetype, habilidad);
}

// OPCIONAL: implementar en C
void invocar_habilidad(void *carta_generica, char *habilidad)
{
	card_t *carta = carta_generica;

	// Itero sobre el __dir de la carta actual para verificar si la habilidad pertenece a la carta
	for (int i = 0; i < carta->__dir_entries; i++)
	{
		if (!strcmp(carta->__dir[i]->ability_name, habilidad))
		{
			ability_function_t *call = carta->__dir[i]->ability_ptr;
			call(carta);
		};
	}

	// Reviso si la habilidad se encuentra en el arqueotipo de la carta
	verificar_arqueotipo(carta->__archetype, habilidad);
}
