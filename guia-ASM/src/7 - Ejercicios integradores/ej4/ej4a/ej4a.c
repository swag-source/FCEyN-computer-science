#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej4a.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - init_fantastruco_dir
 */
bool EJERCICIO_1A_HECHO = true;

void init_fantastruco_dir(fantastruco_t *card)
{
    // Pido memoria para un array de entries
    directory_entry_t **arr = malloc(2 * sizeof(directory_entry_t *));

    // Pido memoria para dos entries por separado
    directory_entry_t *entry_1 = malloc(sizeof(directory_entry_t));
    directory_entry_t *entry_2 = malloc(sizeof(directory_entry_t));

    // Seteo los valores de name y ptr para cada habilidad
    strcpy(entry_1->ability_name, "sleep");
    entry_1->ability_ptr = &sleep;

    strcpy(entry_2->ability_name, "wakeup");
    entry_2->ability_ptr = &wakeup;

    arr[0] = entry_1;
    arr[1] = entry_2;

    card->__dir = arr;
    card->__dir_entries = 2;
}

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - summon_fantastruco
 */
bool EJERCICIO_1B_HECHO = true;

// OPCIONAL: implementar en C
fantastruco_t *summon_fantastruco()
{
    fantastruco_t *res = malloc(sizeof(fantastruco_t));

    init_fantastruco_dir(res);

    res->__archetype = NULL;

    res->face_up = 1;

    return res;
}
