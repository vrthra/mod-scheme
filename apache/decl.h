/*   decl.h
 *   defines the auxiliary symbols needed to include some of 
 *   separately defined functions and structs
 *   defines common macros, used in most of the files,
 * */

#ifndef DECL_H
	#define DECL_H

#define QUOTE(s) # s


#define DEF_SYMBOL(S_NAME,S_FUNC) \
scheme_define(sc,sc->global_env, \
    mk_symbol(sc,S_NAME), \
    mk_foreign_func(sc,S_FUNC));

#define DEF_CONST(S_NAME,S_CONST) \
scheme_define(sc,sc->global_env, \
    mk_symbol(sc,S_NAME), \
    mk_integer(sc,S_CONST));

#define ARG_ASSERT(PTR,ARGLST,STR) \
	PTR = pair_car(ARGLST); \
	if (PTR == sc->NIL) { \
		scheme_exception(sc,QUOTE(STR)); \
		return sc->NIL; \
	}

#define DEFINE_APACHE_REF_CONST(LIB_FUNCTION,CONST) \
scheme_define(sc,sc->global_env, \
    mk_symbol(sc,LIB_FUNCTION), \
    mk_integer(sc,CONST));


#define _defined_scheme_apr_buckets_aux
#define _defined_scheme_httpd_aux
#define _defined_scheme_util_filter_aux

#endif
