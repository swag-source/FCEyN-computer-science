#include "../ejs.h"
// Función auxiliar para contar casos por categoria

estadisticas_t *calcular_estadisticas(caso_t *arreglo_casos, int largo, uint32_t usuario_id)
{
    estadisticas_t *user_statistics = calloc(1, sizeof(estadisticas_t));

    if (usuario_id != 0)
    {
        for (int i = 0; i < largo; i++)
        {
            if (arreglo_casos[i].usuario->id == usuario_id)
            {

                if (!strcmp(arreglo_casos[i].categoria, "CLT"))
                {
                    user_statistics->cantidad_CLT++;
                }
                else if (!strcmp(arreglo_casos[i].categoria, "RBO"))
                {
                    user_statistics->cantidad_RBO++;
                }
                else if (!strcmp(arreglo_casos[i].categoria, "KSC"))
                {
                    user_statistics->cantidad_KSC++;
                }
                else
                {
                    user_statistics->cantidad_KDT++;
                }
                if (arreglo_casos[i].estado == 0)
                {
                    user_statistics->cantidad_estado_0++;
                }
                else if (arreglo_casos[i].estado == 1)
                {
                    user_statistics->cantidad_estado_1++;
                }
                else
                {
                    user_statistics->cantidad_estado_2++;
                }
            }
        }
    }
    else
    {
        for (int i = 0; i < largo; i++)
        {

            if (!strcmp(arreglo_casos[i].categoria, "CLT"))
            {
                user_statistics->cantidad_CLT++;
            }
            else if (!strcmp(arreglo_casos[i].categoria, "RBO"))
            {
                user_statistics->cantidad_RBO++;
            }
            else if (!strcmp(arreglo_casos[i].categoria, "KSC"))
            {
                user_statistics->cantidad_KSC++;
            }
            if (!strcmp(arreglo_casos[i].categoria, "KDT"))
            {
                user_statistics->cantidad_KDT++;
            }

            if (arreglo_casos[i].estado == 0)
            {
                user_statistics->cantidad_estado_0++;
            }
            else if (arreglo_casos[i].estado == 1)
            {
                user_statistics->cantidad_estado_1++;
            }
            else
            {
                user_statistics->cantidad_estado_2++;
            }
        }
    }

    return user_statistics;
}
