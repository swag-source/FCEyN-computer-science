#include "../ejs.h"

void resolver_automaticamente(funcionCierraCasos_t *funcion, caso_t *arreglo_casos, caso_t *casos_a_revisar, int largo)
{
    for (int i = 0; i < largo; i++)
    {
        switch (arreglo_casos[i].usuario->nivel)
        {
        // Usuario nivel 1
        case 1:
            /* code */
            break;

        // Usuario nivel 2
        case 2:
            break;

        // Usuario nivel 0
        default:
            break;
        }
    }
}
