//*************************************
// Declaración de estructuras
//*************************************

// Lista de arreglos de enteros de 32 bits sin signo.
// next: Siguiente elemento de la lista o NULL si es el final
// categoria: Categoría del nodo
// arreglo: Arreglo de enteros
// longitud: Longitud del arreglo
typedef struct nodo_s
{
    struct nodo_s *next; // NODO_OFFSET_NEXT: 0
    uint8_t categoria;   // NODO_OFFSET_CATEGORIA: 8 (+ 7 PADDING)
    uint32_t *arreglo;   // NODO_OFFSET_ARREGLO: 16
    uint32_t longitud;   // NODO_OFFSET_LONGITUD: 24 (+ 4 PADDING)
} nodo_t;                // NODO_SIZE = 28 BYTES

typedef struct __attribute__((__packed__)) packed_nodo_s
{
    struct packed_nodo_s *next; // PACKED_NODO_OFFSET_NEXT: 0
    uint8_t categoria;          // PACKED_NODO_OFFSET_CATEGORIA: 8
    uint32_t *arreglo;          // PACKED_NODO_OFFSET_ARREGLO: 9
    uint32_t longitud;          // PACKED_NODO_OFFSET_LONGITUD: 17
} packed_nodo_t;                // PACKED_NODO_SIZE = 21 BYTES

// Puntero al primer nodo que encabeza la lista
typedef struct lista_s
{
    nodo_t *head; // LISTA_OFFSET_HEAD: 0
} lista_t;        // LISTA_SIZE = 8 BYTES

// Puntero al primer nodo que encabeza la lista
typedef struct __attribute__((__packed__)) packed_lista_s
{
    packed_nodo_t *head; // PACKED_LISTA_OFFSET_HEAD: 0
} packed_lista_t;        // PACKED_LISTA_SIZE = 8 BYTES
