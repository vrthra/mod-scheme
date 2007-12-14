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


//---------------auto struct
#include "./scheme_util_filter_aux.stpl.o.c"
//---------------end auto struct
//---------------auto
#include "./scheme_util_filter_aux.tpl.o.c"

//-------endauto

}

