/*      callback.h
 *      contains datastructures for callbacks [esp filter]
 * */

#ifndef _CALLBACK_H
#define _CALLBACK_H


#ifndef NO_APACHE
#include "pcreposix.h"
#include "httpd.h"
#include "util_filter.h"
#include "http_config.h"
#include "http_log.h"
#include "http_protocol.h"

#include "http_core.h"
#include "http_log.h"
#include "http_main.h"
#include "http_protocol.h"
#include "http_request.h"
#include "util_script.h"
#include "http_connection.h"

#include "apr_strings.h"

#include "scheme-private.h"
#endif

#define HANDLER 1
#define FILTER 2

struct list_node {
    char* val;
    struct list_node * next;
    struct list_node * prev;
};
typedef struct list_node item;

typedef struct {
    int trace;
    int type;
    union {
        request_rec *r;
        struct filter {
            int is_input;
            ap_filter_t *f;
            apr_bucket_brigade *bb;
            ap_input_mode_t mode;
            apr_read_type_e block;
            apr_off_t readbytes;
            char * handler;
            char *dir;
            item* buffer;
            struct readmark {
                item* page;
                int position;
            } mark;
        } _filter;
    } _callback;
    char * post_args;
    request_rec *r;//this is a common feature amoung all
} callback_data;

typedef struct {
    apr_bucket_brigade *bb;
    pointer *context;
    scheme * interp;
} scheme_filter_ctx;

int callback_putc(int c,void *xtData);
int callback_write(const void *buf, int nbyte, void *xtData);

int callback_getc(void *xtData);
char* callback_read(void *xtData);


void scheme_load_context_symbols(scheme *);
#endif
