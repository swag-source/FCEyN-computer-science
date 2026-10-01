#include "../ejs.h"

uint32_t cuantos_tuits_trending_topic(feed_t* feed, uint32_t user_id, 
                                      uint8_t (*esTuitSobresaliente)(tuit_t *)) {
    
    uint32_t contador = 0;
    publicacion_t* actual = feed->first;
    while (actual != NULL) {
        tuit_t* tuit = actual->value;
        if (esTuitSobresaliente(tuit) && tuit->id_autor == user_id) {
            contador++;
        }
        actual = actual->next;
    }
    return contador;

}

tuit_t **trendingTopic(usuario_t *user, uint8_t (*esTuitSobresaliente)(tuit_t *)) {
    
    uint32_t cantidad_tuits = cuantos_tuits_trending_topic(user->feed, user->id, esTuitSobresaliente);

    // Si no hay tuits trending topic, devolvemos NULL
    if (cantidad_tuits == 0) return NULL;
    
    // Caso contrario, pedimos memoria
    tuit_t** tuits = (tuit_t**) malloc((cantidad_tuits + 1) * sizeof(tuit_t*));

    uint32_t index = 0;
    publicacion_t* actual = user->feed->first;
    while (actual != NULL) {

        tuit_t* tuit = actual->value;
        if (tuit->id_autor == user->id && esTuitSobresaliente(tuit)) {
            tuits[index] = tuit;
            index++;
        }
        
        actual = actual->next;

    }

    tuits[index] = NULL;
    return tuits;

}
