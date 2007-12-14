/*      internal.c 
 *      Contains the functions necessary for creating storing and releasing
 *      interpretors.
*/
#include "scheme_code.h"
#include "internal.h"

void queue_init(interp_queue_t *queue) {
    queue->head = NULL;
    queue->tail = NULL;
    queue->recycled = 0;
}

int queue_count(interp_queue_t *queue) {
    pair_t *pair = queue->head;
    int counter = 1;
    while(pair->cdr != NULL) {
        ++counter;
        pair = pair->cdr;
    }
    return counter;
}

void queue_add(interp_queue_t *queue,scheme *sc) {
    pair_t *new_pair;
    if(NULL == queue->tail) {
        queue->tail = (pair_t *) malloc(sizeof(pair_t));
        queue->tail->car = (void *)sc;
        queue->tail->cdr = NULL;
        queue->head = queue->tail;
    } else {
        new_pair = (pair_t *) malloc(sizeof(pair_t));
        new_pair->car = (void *)sc;
        new_pair->cdr = NULL;
        queue->tail->cdr = new_pair;
        queue->tail = new_pair;
    }
}

scheme *queue_get(interp_queue_t *queue) {
    scheme *sc = 0;
    pair_t *head = queue->head;
    if (NULL != head) {
        sc = head->car;
        queue->head = head->cdr;
        free(head);
        return sc;
    }
    return sc;
}

scheme* scheme_get_interp(void * p) {
    scheme * sc = queue_get(&interp_queue);
    sc->ext_data = p;
    scheme_load_string(sc,scheme_init_code);
    return sc;
}

void scheme_release_interp(scheme *interp) {
    queue_add(&interp_queue,interp);
}

