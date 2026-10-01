#include "../ejs.h"
#include <string.h>

void agregar_tuit_al_feed(tuit_t* tuit, feed_t* feed) {
  
  // Generamos la publicación
  publicacion_t* publicacion = (publicacion_t*) malloc(sizeof(publicacion_t));

  // TODA publicación tiene un tuit asociado
  publicacion->value = tuit;

  // Nos falta nada más decir qué tuit le sigue a la publicación
  publicacion_t* next = feed->first;  // El primero que tiene el feed actualmente (antes de nuestra publicación)
  publicacion->next = next;

  feed->first = publicacion;

}

// Función principal: publicar un tuit
tuit_t *publicar(char *mensaje, usuario_t *user) {

  // Generamos el tuit
  tuit_t* tuit = (tuit_t*) malloc(sizeof(tuit_t));

  // Agregamos toda la información para el tuit
  // * Retuits
  // * Favs
  // * Autor
  // * MENSAJE
  tuit->retuits = 0;
  tuit->favoritos = 0;
  tuit->id_autor = user->id;
  strcpy(tuit->mensaje, mensaje);

  // Solo nos queda agregarle el tuit al feed del CREADOR y sus SEGUIDORES
  agregar_tuit_al_feed(tuit, user->feed);

  for (int i = 0; i < user->cantSeguidores; i++) {
    usuario_t* seguidor = user->seguidores[i];
    agregar_tuit_al_feed(tuit, seguidor->feed);
  }

  return tuit;
  
}
