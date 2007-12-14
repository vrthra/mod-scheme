#include "apache/macros.h"
#include "apache/ptr_types.h"

/*
#include "apr.h"
#include "apr_buckets.h"
#include "util_filter.h"
#include "httpd.h"
#include "tinyscheme/scheme-private.h"
#if APR_HAVE_STDARG_H
#include <stdarg.h>
#endif

#include "callback.h"
*/

//---------------auto struct
#include "scheme_util_filter_aux.stpl.i.c"
//---------------end auto struct
//---------------auto
#include "./scheme_util_filter_aux.tpl.i.c"

//-------endauto


void load_scheme_util_filter_symbols_aux(scheme *sc) {

DEFINE_APACHE_REF_CONST("ap:nobody_wrote",AP_NOBODY_WROTE);
DEFINE_APACHE_REF_CONST("ap:nobody_read",AP_NOBODY_READ);
DEFINE_APACHE_REF_CONST("ap:filter_error",AP_FILTER_ERROR);
DEFINE_APACHE_REF_CONST("ap:mode_readbytes",AP_MODE_READBYTES);
DEFINE_APACHE_REF_CONST("ap:mode_getline",AP_MODE_GETLINE);
DEFINE_APACHE_REF_CONST("ap:mode_eatcrlf",AP_MODE_EATCRLF);
DEFINE_APACHE_REF_CONST("ap:mode_speculative",AP_MODE_SPECULATIVE);
DEFINE_APACHE_REF_CONST("ap:mode_exhaustive",AP_MODE_EXHAUSTIVE);
DEFINE_APACHE_REF_CONST("ap:mode_init",AP_MODE_INIT);
DEFINE_APACHE_REF_CONST("ap:ftype_resource",AP_FTYPE_RESOURCE);
DEFINE_APACHE_REF_CONST("ap:ftype_content_set",AP_FTYPE_CONTENT_SET);
DEFINE_APACHE_REF_CONST("ap:ftype_transcode",AP_FTYPE_TRANSCODE);
DEFINE_APACHE_REF_CONST("ap:ftype_connection",AP_FTYPE_CONNECTION);
DEFINE_APACHE_REF_CONST("ap:ftype_network",AP_FTYPE_NETWORK);


//---------------auto struct
#include "./scheme_util_filter_aux.stpl.o.c"
//---------------end auto struct
//---------------auto
#include "./scheme_util_filter_aux.tpl.o.c"

//-------endauto

}

