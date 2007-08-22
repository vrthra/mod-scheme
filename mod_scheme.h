#ifndef MOD_SCHEME_H
	#define MOD_SCHEME_H
#define SLASH '\\'
#define SLASH_S "\\"

typedef struct
{
    char *handler;
    char *dir;
} sc_handler;

/* structure describing per directory configuration parameters */
typedef struct {
    int           authoritative;
    char         *config_dir;
    apr_table_t  *directives;
    apr_table_t  *options;
    apr_hash_t   *hlists; /* hlists for every phase */
    apr_hash_t   *in_filters;
    apr_hash_t   *out_filters;
} sc_config;

void scheme_set_output_port_callback(scheme *sc, void *output_fxn,void *output_char_fxn, void *data);
#endif
