#include "../ejs.h"

// Función auxiliar para contar casos por nivel
int contar_casos_por_nivel(caso_t *arreglo_casos, int largo, int nivel)
{
    int res = 0;
    for (int i = 0; i < largo; i++)
    {
        if (arreglo_casos[i].usuario->nivel == nivel)
        {
            res++;
        }
    }
    return res;
}

segmentacion_t *segmentar_casos(caso_t *arreglo_casos, int largo)
{

    int n_0 = contar_casos_por_nivel(arreglo_casos, largo, 0); // Devuelve cuantos casos en el arreglo de casos son de tipo 0
    int n_1 = contar_casos_por_nivel(arreglo_casos, largo, 1); // Devuelve cuantos casos en el arreglo de casos son de tipo 1
    int n_2 = contar_casos_por_nivel(arreglo_casos, largo, 2); // Devuelve cuantos casos en el arreglo de casos son de tipo 2

    // [casos_0, casos_1, casos_2] y typeof(casos_1) = caso_t*
    segmentacion_t *segmentado = calloc(3, sizeof(caso_t *));

    caso_t *casos_0 = (n_0 == 0) ? NULL : malloc(n_0 * sizeof(caso_t));
    caso_t *casos_1 = (n_1 == 0) ? NULL : malloc(n_1 * sizeof(caso_t));
    caso_t *casos_2 = (n_2 == 0) ? NULL : malloc(n_2 * sizeof(caso_t));

    segmentado->casos_nivel_0 = casos_0;
    segmentado->casos_nivel_1 = casos_1;
    segmentado->casos_nivel_2 = casos_2;

    uint32_t i_0 = 0; // r8
    uint32_t i_1 = 0; // r9
    uint32_t i_2 = 0; // r10

    for (int i = 0; i < largo; i++)
    {
        if (arreglo_casos[i].usuario->nivel == 0)
        {
            casos_0[i_0] = arreglo_casos[i];
            i_0++;
        }
        if (arreglo_casos[i].usuario->nivel == 1)
        {
            casos_1[i_1] = arreglo_casos[i];
            i_1++;
        }
        if (arreglo_casos[i].usuario->nivel == 2)
        {
            casos_2[i_2] = arreglo_casos[i];
            i_2++;
        }
    }

    return segmentado;
}
