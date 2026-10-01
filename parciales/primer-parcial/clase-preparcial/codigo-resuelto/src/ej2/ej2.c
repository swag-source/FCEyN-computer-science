#include "../ejs.h"

void eliminar_publicaciones_del_usuario(feed_t* feed, uint32_t id_usuario) {
  
  publicacion_t* actual = feed->first;
  publicacion_t* previa = NULL;
  bool encontramos_nuevo_first = false;

  while (actual != NULL) {

    publicacion_t* siguiente = actual->next;

    // Primero tenemos que ver si la publicación es del usuario bloqueado/bloqueador o no
    bool es_del_usuario = (actual->value->id_autor == id_usuario);

    if (es_del_usuario) {

      // Tenemos que eliminar la publicación del arreglo
      if (previa != NULL) {
        previa->next = siguiente;
      }
      free(actual);

    } else {

      // No hacemos nada, no tenemos que borrar la pubicación
      if (!encontramos_nuevo_first) {
        feed->first = actual;
        encontramos_nuevo_first = true;
      }
      previa = actual;

    }

    actual = siguiente;

  }

  if (!encontramos_nuevo_first) {
    feed->first = NULL;
  }

}

void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear) {
  
  // Agregamos a usuarioABloquear al arreglo de bloqueados de usuario
  usuario->bloqueados[usuario->cantBloqueados] = usuarioABloquear;
  usuario->cantBloqueados++;

  // Eliminamos del feed del usuario las publicaciones de usuarioABloquear
  eliminar_publicaciones_del_usuario(usuario->feed, usuarioABloquear->id);

  // Eliminamos del feed del usuarioABloquear las publicaciones de usuario
  eliminar_publicaciones_del_usuario(usuarioABloquear->feed, usuario->id);

}
