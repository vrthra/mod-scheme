/* Original Todd G
 * Changes .30 - rahul
 *    Output Filter (but breaks apache pipe-line)
 *    Updation to TinyScheme 1.33
 *  Todo :
 *    Input Filter, Post Args, and correct OFilter
 * Changes .31 - rahul
 *    Input Fiter works,
 *    older dir opening and files to use apr,
 *    Filters obey pipe-lining now.
 *    Updation to TinyScheme 1.33
 *  Todo :
 *    better error handling, more brigade apis, provide support for saving data
 *    in context (for use in filter underruns)
 *    get a better schemish api over the current reflected apache api
 *    (beginings in code (sc_))
 * Changes .35 - rahul
 *    Most Apache APIs added. Code simplified. updated to Apache 2.2.6
 */

#include "httpd.h"
#include "http_config.h"
#include "http_protocol.h"
#include "http_log.h"
#include "http_connection.h"
#include "http_request.h"
#include "http_core.h"
#include "http_main.h"
#include "apr_lib.h"
#include "apr_hash.h"
#include "apr_general.h"
#include "apr_thread_cond.h"
#include "ap_config.h"
#include "tinyscheme/scheme-private.h"
#include "tinyscheme/scheme.h"
#include "mod_scheme.h"
#include "callback.h"
#include "apr_file_info.h"
#include "apr_file_io.h"
#include "apr_strings.h"
#include "apache_tie.h"

#include "apache/macros.h"

#include "internal.h"
module AP_MODULE_DECLARE_DATA scheme_module;
/*
 Loads *.scm in the given directory
 */
void scheme_load_all_symbols(scheme *sc);


int scheme_load_libs(scheme *sc,const char *init_dir,apr_pool_t *p) {
    apr_status_t rv;
    apr_dir_t *dir;
    apr_finfo_t finfo;
    apr_file_t *file;
    rv = apr_dir_open(&dir, init_dir, p);
    if (rv != APR_SUCCESS) return rv;
    rv = apr_dir_read(&finfo, APR_FINFO_DIRENT, dir);
    rv = apr_dir_read(&finfo, APR_FINFO_DIRENT, dir);
    while(APR_SUCCESS == apr_dir_read(&finfo, APR_FINFO_DIRENT, dir) ) {
        apr_status_t rc;
        char * fullname = apr_pstrcat(p,init_dir,finfo.name,NULL);
        rc = apr_file_open(&file, fullname, APR_READ | APR_XTHREAD , APR_OS_DEFAULT, p);
        if(rc != APR_SUCCESS) {
            ap_log_perror(APLOG_MARK, APLOG_NOERRNO | APLOG_DEBUG, rc, p,
                    "couldn't open file \"%s\"", finfo.name);
            continue;
        }
        scheme_load_file(sc,file);
        apr_file_close(file);
    }
    rv = apr_dir_close(dir);
    return 0;
}

/* init after DSO load */
int scheme_post_config(apr_pool_t *pconf, apr_pool_t *plog,apr_pool_t *ptemp,
        server_rec *s) {
    scheme *interp;
    scheme_config_rec *conf;
    int interp_count,i;
    const char *init_dir;
    conf = ap_get_module_config(s->module_config, &scheme_module);
    interp_count = conf->max_interps;
    init_dir = conf->init_dir;
    queue_init(&interp_queue);
    for(i = 0;i < interp_count;i++) {
        interp = apr_pcalloc(pconf,sizeof(scheme));
        scheme_init(interp);
        interp->gc_verbose = 0;
        scheme_load_all_symbols(interp);
        scheme_load_libs(interp,init_dir,plog);
        queue_add(&interp_queue,interp);
    }
    return OK;
}
/*
 Called by create_dir_config and create_srv_config
 */
sc_config *scheme_create_config(apr_pool_t *p) {
    sc_config *conf = (sc_config *) apr_pcalloc(p, sizeof(sc_config));
    conf->authoritative = 1;
    conf->options = apr_table_make(p, 4);
    conf->directives = apr_table_make(p, 4);
    conf->hlists = apr_hash_make(p);
    conf->in_filters = apr_hash_make(p);
    conf->out_filters = apr_hash_make(p);

    return conf;
}

void *create_scheme_server_config(apr_pool_t *p, server_rec *d) {
    scheme_config_rec *conf = apr_palloc(p, sizeof(*conf));
    return (void *)conf;
}
/*
 Allocate memory and initialize the strucure that will hold configuration
 parametes.  This function is called on every hit it seems.
 */
void *create_scheme_dir_config(apr_pool_t *p, char *dir) {
    sc_config *conf = scheme_create_config(p);
    /* make sure directory ends with a slash */
    if (dir && (dir[strlen(dir) - 1] != SLASH))
        conf->config_dir = apr_pstrcat(p, dir, SLASH_S, NULL);
    else
        conf->config_dir = apr_pstrdup(p, dir);
    return conf;
}

void scheme_exception(scheme *sc,char * str) {
    scheme_log(sc,"Exception: [");
    scheme_log(sc,str);
    scheme_log(sc,"]\n");

}

void scheme_log(scheme *sc,char * str) {
    CDATA
        if ( cdata->type == HANDLER )
            ap_log_rerror(APLOG_MARK, APLOG_ERR, 0, cdata->r, str);
        else if ( cdata->type == FILTER )
            ap_log_rerror(APLOG_MARK, APLOG_ERR, 0,
                    cdata->_callback._filter.f->r, str);
}

pointer scm_log(scheme *sc, pointer args) {
    if (args != sc->NIL) {
        scheme_log(sc,string_value(pair_car(args)));
        return sc->T;
    }
    return sc->F;
}

int scheme_read_post_data(request_rec *r , char** buf);

pointer scm_read_post_data(scheme *sc, pointer args) {
    if (args != sc->NIL) {
        void * req = ptr_value(pair_car(args));
        char * buf;
        int retVal = scheme_read_post_data(req,&buf);
        if (retVal != APR_SUCCESS) return mk_pointer(sc,0);
        return mk_pointer(sc,buf);
    } else  scheme_exception(sc,"apache:read_post_data [no args]"); \
        return sc->NIL;
}

void scheme_load_all_symbols(scheme *sc) {
    DEF_SYMBOL("apache:log",scm_log)
    DEF_SYMBOL("apache:read_post_data",scm_read_post_data)
    scheme_load_apache_symbols(sc);
    scheme_load_apache_tie_symbols(sc);
    scheme_load_context_symbols(sc);
}

const char* set_init_dir(cmd_parms *parms, void *mconfig, const char *arg) {
    scheme_config_rec *c = ap_get_module_config(parms->server->module_config,
            &scheme_module);
    c->init_dir =(char*) arg;
    return NULL;
}

const char* set_max_interps(cmd_parms *parms, void *mconfig,const char *arg) {
    scheme_config_rec *c = ap_get_module_config(parms->server->module_config,
            &scheme_module);
    c->max_interps = atoi(arg);
    return NULL;
}

const char* set_min_interps(cmd_parms *parms, void *mconfig, const char *arg) {
    scheme_config_rec *c = ap_get_module_config(parms->server->module_config,
            &scheme_module);
    c->min_interps = atoi(arg);
    return NULL;
}

scheme* init_scheme_interp(callback_data *cdata) {
    scheme* interp;
    interp = scheme_get_interp(cdata->r->pool);
    if (interp == 0) ap_log_rerror(APLOG_MARK, APLOG_DEBUG, 0, cdata->r,
            "get_interp failed ");
    return interp;
}

int load_scheme_file(sc_handler *fh, callback_data *cdata,scheme * interp) {
    apr_file_t* file;
    apr_status_t rc = apr_file_open(&file, fh->handler, APR_READ | APR_XTHREAD,
            APR_OS_DEFAULT, cdata->r->pool);
    if(rc != APR_SUCCESS) {
        ap_log_rerror(APLOG_MARK, APLOG_DEBUG, 0, cdata->r, "openSchemeFile");
        return 404;
    }
    scheme_load_file(interp,file);
    SCM_RETURN(interp);
}

apr_status_t plain_cleanup (void* sc) {
    scheme_release_interp(sc);
    return APR_SUCCESS;
}

apr_status_t child_cleanup(void* data) {
    return APR_SUCCESS;
}

apr_status_t scheme_filter(int type,ap_filter_t *f, apr_bucket_brigade *bb,
        ap_input_mode_t eMode, apr_read_type_e eBlock, apr_off_t nBytes) {
    int is_input = type;
    ap_input_mode_t mode = eMode;
    apr_read_type_e block = eBlock;
    apr_off_t readbytes = nBytes;

    sc_config * conf;
    request_rec *req;
    scheme_filter_ctx *ctx;
    callback_data *cdata;
    sc_handler *fh;
    int err = 0;
    // we only allow request level filters so far *
    req = f->r;

    conf = (sc_config *) ap_get_module_config(req->per_dir_config,
            &scheme_module);
    if (is_input)//get the handler we registered in set_output_filter
        fh = apr_hash_get(conf->in_filters, f->frec->name,
                APR_HASH_KEY_STRING);
    else
        fh = apr_hash_get(conf->out_filters, f->frec->name,
                APR_HASH_KEY_STRING);

    cdata =  apr_pcalloc(req->pool, sizeof(callback_data));
    cdata->r = req;
    cdata->type = FILTER;
    cdata->_callback._filter.f = f;
    cdata->_callback._filter.bb = bb;
    cdata->_callback._filter.is_input = is_input;
    cdata->_callback._filter.mode = mode;
    cdata->_callback._filter.block = block;
    cdata->_callback._filter.readbytes = readbytes;
    cdata->_callback._filter.handler = fh->handler;
    cdata->_callback._filter.dir = fh->dir;

    if (!f->ctx) {//contains the transparent parameter to verify error.
        ctx = (scheme_filter_ctx *) apr_pcalloc(req->pool,
                sizeof(scheme_filter_ctx));
        ctx->interp = init_scheme_interp(cdata);
        cdata->trace = 0;//tracing off
        if (ctx->interp == 0 ) return 500;
        apr_pool_cleanup_register(req->pool,(void *)(ctx->interp),
                plain_cleanup,child_cleanup);
        f->ctx = (void *)ctx;
        ctx->bb = apr_brigade_create(f->r->pool, f->c->bucket_alloc);
        scheme_set_output_port_callback(ctx->interp,callback_write,
                callback_putc,cdata);
        load_scheme_file(fh,cdata,ctx->interp);
    } else {
        ctx = (scheme_filter_ctx *) f->ctx;
    }
    scheme_set_output_port_callback(ctx->interp,callback_write,callback_putc,
            cdata);
    {
        pointer arg_cons =
            cons(ctx->interp,mk_integer(ctx->interp,type),
             cons(ctx->interp,mk_pointer(ctx->interp,(void *)f),
              cons(ctx->interp,mk_pointer(ctx->interp,(void *)bb),
               cons(ctx->interp,mk_integer(ctx->interp,eMode),
                cons(ctx->interp,mk_integer(ctx->interp,eBlock),
                 cons(ctx->interp,mk_int64(ctx->interp,nBytes),
                  ctx->interp->NIL))))));
        if (type) {
            scheme_call_func(ctx->interp,"do_input_filter",arg_cons);
        } else  {
            scheme_call_func(ctx->interp,"do_output_filter",arg_cons);
        }
    }
    SCM_RETURN(ctx->interp);
}


apr_status_t scheme_output_filter(ap_filter_t *f, apr_bucket_brigade *bb) {
    return scheme_filter(0,f,bb,0,0,0);
}

apr_status_t scheme_input_filter(ap_filter_t *f, apr_bucket_brigade *bb,
        ap_input_mode_t mode, apr_read_type_e block, apr_off_t readbytes) {
    return scheme_filter(1,f,bb,mode,block,readbytes);
}

const char *set_filter(int type,cmd_parms *cmd, void *mconfig,
        const char *handler, const char *name,ap_filter_type pos) {
    sc_config *conf;
    sc_handler *fh;
    ap_filter_rec_t *frec;

    if (!name) name = apr_pstrdup(cmd->pool, handler);

    // register the filter NOTE - this only works so long as the
    //  directive is only allowed in the main config. For .htaccess we
    //  would have to make sure not to duplicate this
    if (type)
        frec = ap_register_input_filter(name, scheme_input_filter, NULL, pos);
    else
        frec = ap_register_output_filter(name, scheme_output_filter, NULL, pos);

    conf = (sc_config *) mconfig;

    fh = (sc_handler *) apr_pcalloc(cmd->pool, sizeof(sc_handler));
    fh->handler = (char *)handler;
    fh->dir = conf->config_dir;
    if (type)
        apr_hash_set(conf->in_filters, frec->name, APR_HASH_KEY_STRING, fh);
    else
        apr_hash_set(conf->out_filters, frec->name, APR_HASH_KEY_STRING, fh);

    return NULL;
}
ap_filter_type get_pos(const char * position) {
    if (position == 0 ) return AP_FTYPE_RESOURCE;
    else if (strcmp(position,"ap:ftype_resource") == 0 )
        return AP_FTYPE_RESOURCE;
    else if (strcmp(position,"ap:ftype_content_set") == 0 )
        return AP_FTYPE_CONTENT_SET;
    else if (strcmp(position,"ap:ftype_protocol") == 0 )
        return AP_FTYPE_PROTOCOL;
    else if (strcmp(position,"ap:ftype_transcode") == 0 )
        return AP_FTYPE_TRANSCODE;
    else if (strcmp(position,"ap:ftype_connection") == 0 )
        return AP_FTYPE_CONNECTION;
    else if (strcmp(position,"ap:ftype_network") == 0 )
        return AP_FTYPE_NETWORK;
    else return AP_FTYPE_RESOURCE;
}

const char *set_input_filter(cmd_parms *cmd, void *mconfig,
        const char *handler, const char *name,const char *position) {
    return set_filter(1,cmd,mconfig,handler,name,get_pos(position));
}

const char *set_output_filter(cmd_parms *cmd, void *mconfig,
        const char *handler, const char *name,const char *position) {
    return set_filter(0,cmd,mconfig,handler,name,get_pos(position));
}

const command_rec scheme_conf_cmds[] = {
    AP_INIT_TAKE1("InitDirectory",
            set_init_dir,
            (void *) 1,
            RSRC_CONF,
            "Directory of scheme scripts to be loaded on start-up."),
    AP_INIT_TAKE1("SchemeMaxInterpreters",
            set_max_interps,
            (void *) 1,
            RSRC_CONF,
            "Maximum number of interpreters kept in the pool."),
    AP_INIT_TAKE1("SchemeMinInterpreters",
            set_min_interps,
            (void *) 1,
            RSRC_CONF,
            "Minimum number of interpreters kept in the pool."),
    AP_INIT_TAKE23(
            "SchemeOutputFilter", set_output_filter, NULL,
            RSRC_CONF|ACCESS_CONF,
            "Scheme output filter."),
    AP_INIT_TAKE23(
            "SchemeInputFilter", set_input_filter, NULL,
            RSRC_CONF|ACCESS_CONF,
            "Scheme input filter."),

    {NULL}
};

/* The sample content handler
TODO:This needs to be rewritten to look and act like apache's own content handler.
*/

int scheme_handler(request_rec *r) {
    apr_file_t *file;
    scheme *interp;
    callback_data* cdata;
    apr_status_t rc;
    if (strcmp(r->handler, "scheme-handler"))
        return DECLINED;
    r->content_type = "text/html";
    rc = apr_file_open(&file, r->filename, APR_READ | APR_XTHREAD,
            APR_OS_DEFAULT, r->pool);
    if(rc != APR_SUCCESS) {
        ap_log_rerror(APLOG_MARK, APLOG_DEBUG, 0, r,
                "Could not open file %s\n",r->filename);
        return 404;
    }
    interp = scheme_get_interp(r->pool);
    if (interp == 0) {
        ap_log_rerror(APLOG_MARK, APLOG_DEBUG, 0, r,"get_interp failed ");
        return 500;
    }
    cdata =  apr_pcalloc(r->pool, sizeof(callback_data));
    cdata->r = r;
    cdata->type = HANDLER;
    scheme_set_output_port_callback(interp,callback_write,
            callback_putc,cdata);
    scheme_load_file(interp,file);
    {
        pointer arg_cons = cons(interp,mk_pointer(interp,r),interp->NIL);
        scheme_call_func(interp,"do_service",arg_cons);
    }
    scheme_release_interp(interp);
    return OK;
}

struct List;
typedef struct List {
    struct List * next;
    char * data;
    int len;
} LinkedList;

struct Linker {
    int len;
    LinkedList * first;
    LinkedList * last;
};


int scheme_read_post_data(request_rec *r , char** buf){
    apr_bucket_brigade *bb = apr_brigade_create(r->pool,
            r->connection->bucket_alloc);
    int seen_eos = 0;

    char * postdata = 0;
    int start = 0;
    LinkedList* leaf = 0;

    struct Linker linker;
    linker.first = 0;
    linker.last = 0;
    linker.len = 0;
    do {
        apr_bucket *bucket;
        int rv = ap_get_brigade(r->input_filters, bb, AP_MODE_READBYTES,
                APR_BLOCK_READ, HUGE_STRING_LEN);
        if (rv != APR_SUCCESS)  return rv;

        for (bucket = APR_BRIGADE_FIRST(bb);
                bucket != APR_BRIGADE_SENTINEL(bb);
                bucket = APR_BUCKET_NEXT(bucket)) {
            const char *data;
            LinkedList * node;
            apr_size_t len;
            if (APR_BUCKET_IS_EOS(bucket)) {
                seen_eos = 1;
                break;
            }
            if (APR_BUCKET_IS_FLUSH(bucket))  continue;
            apr_bucket_read(bucket, &data, &len, APR_BLOCK_READ);
            node =(LinkedList *) apr_palloc(r->pool, sizeof(LinkedList));
            node->data = (char * ) apr_palloc(r->pool, len + 1);
            apr_cpystrn(node->data, data,len+1);//allow for null;
            node->len = len;
            node->next = 0;
            if (linker.first == 0) {
                linker.first = node;
                linker.last = node;
            } else {
                linker.last->next = node;
                linker.last = node;
            }
            linker.len += len;
        }
        apr_brigade_cleanup(bb);
    } while (!seen_eos);
    postdata =(char *) apr_palloc(r->pool, linker.len);
    for (leaf = linker.first; leaf != 0 ; leaf = leaf->next) {
        apr_cpystrn((postdata + start), leaf->data,leaf->len + 1);
        start = start + leaf->len;
    }
    postdata[linker.len] = '\0';
    (*buf) = postdata;

    return 0;
}


int scheme_read_post_data_1(request_rec *r, char **rbuf) {
    apr_size_t len = 1024, tlen=0,count_bytes = 4096;
    apr_bucket_brigade *brigade = apr_brigade_create(r->pool,
            r->connection->bucket_alloc);
    char * buf;
    buf =(char *) apr_palloc(r->pool, count_bytes);
    //
    // This loop is needed because ap_get_brigade() can return us partial data
    // which would cause premature termination of request read. Therefor we
    // need to make sure that if data is avaliable we fill the buffer completely.
    //

    while (ap_get_brigade(r->input_filters, brigade, AP_MODE_READBYTES,
                APR_BLOCK_READ, len) == APR_SUCCESS) {
        apr_brigade_flatten(brigade, buf, &len);
        apr_brigade_cleanup(brigade);
        tlen += len;
        if (tlen == count_bytes || !len) {
            break;
        }
        buf += len;
        len = count_bytes - tlen;
    }
    (*rbuf) = (buf-tlen);
    return tlen;
}

void scheme_register_hooks(apr_pool_t *p) {
    ap_hook_post_config(scheme_post_config, NULL, NULL, APR_HOOK_MIDDLE);
    ap_hook_handler(scheme_handler, NULL, NULL, APR_HOOK_MIDDLE);
}

/* Dispatch list for API hooks */
module AP_MODULE_DECLARE_DATA scheme_module = {
    STANDARD20_MODULE_STUFF,
    create_scheme_dir_config,     // create per-dir    config structures
    NULL,                         // merge  per-dir    config structures
    create_scheme_server_config,  // create per-server config structures
    NULL,                         // merge  per-server config structures
    scheme_conf_cmds,             // table of config file commands
    scheme_register_hooks         // register hooks
};

