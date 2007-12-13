/*      internal.h
 *      contains the interpretor queue datastructure definitions
 * */
#ifndef INTERNAL_H
    #define INTERNAL_H
#include "scheme-private.h"
#include "scheme.h"
#include "callback.h"
#ifndef WIN32
#include <stdlib.h>
#else
#include <malloc.h>
#endif

struct pair_t {
    void   *car;
    void   *cdr;
};

typedef struct pair_t pair_t;


struct interp_queue_t {
    pair_t *head;
    pair_t *tail;
    int                 recycled;
    int                 terminated;
};
typedef struct interp_queue_t interp_queue_t;

interp_queue_t interp_queue;

typedef struct {
    char *init_dir;
    int min_interps;
    int max_interps;
} scheme_config_rec;

void queue_init(interp_queue_t *queue); 
int queue_count(interp_queue_t *queue);
void queue_add(interp_queue_t *queue,scheme *sc);
scheme *queue_get(interp_queue_t *queue);
scheme* scheme_get_interp(void * p);
void scheme_release_interp(scheme *interp);
int scheme_post_config(apr_pool_t *pconf, apr_pool_t *plog,apr_pool_t *ptemp, server_rec *s);

#endif

