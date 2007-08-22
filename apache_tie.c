/*      apache_tie.c
 *      Contains procedures that convert between scheme and apache datatypes.
 * */
#include "apr_lib.h"
#include "apr_hash.h"
#include "scheme-private.h"
#include "scheme.h"
#include "mod_scheme.h"
#include "callback.h"

#include "apache/macros.h"
#include "apache_tie.h"
/*
The procedure that converts a char pointer to a string and returns a scheme string
*/

pointer scheme_read_apache_string(scheme *sc, pointer args) {
	TRACE("apache:read_string");
    if (args != sc->NIL) {
		pointer string = pair_car(args);
		char * buf = ptr_value(string);
		if (buf != 0) return mk_string(sc,buf);
		else return mk_string(sc,"");
    }
    return sc->NIL;
}

pointer scheme_make_apache_string(scheme *sc, pointer args) {
	TRACE("apache:make_string");
    if (args != sc->NIL) {
		pointer string = pair_car(args);
		char * buf = string_value(string);
		int l = string_length(string);
		buf[l] = '\0';
		return mk_pointer(sc,buf);
    }
    return sc->NIL;
}

pointer scheme_make_apache_string_len(scheme *sc, pointer args) {
	TRACE("apache:nmake_string");
    if (args != sc->NIL) {
		pointer string = pair_car(args);
		char * buf = string_value(string);
		pointer tempargs = pair_cdr(args);
		pointer len = pair_car(tempargs);
		int l = ivalue(len);
		buf[l] = '\0';
		return mk_pointer(sc,buf);
    }
    return sc->NIL;
}

pointer scheme_new_apache_string(scheme *sc, pointer args) {
	TRACE("apache:new_string");
    if (args != sc->NIL) {

		char * buf;
		pointer len = pair_car(args);
		int l = ivalue(len);
		apr_pool_t *pool;

		CDATA
		if ( cdata->type == HANDLER )
			pool =  cdata->r->pool;
		else if ( cdata->type == FILTER )
			pool =  cdata->_callback._filter.f->r->pool;

		buf =(char *) apr_palloc(pool, l);
		return mk_pointer(sc,buf);
    }
    return sc->NIL;
}

pointer scheme_trace(scheme *sc, pointer args) {
    if (args != sc->NIL) {
		pointer ival = pair_car(args);
		int flag = ivalue(ival);
		CDATA
		cdata->trace = flag;
	}
    return sc->NIL;
}


pointer scheme_read_apache_string_len(scheme *sc, pointer args) {
	TRACE("apache:nread_string");
    if (args != sc->NIL) {
		pointer string = pair_car(args);
		char * buf = ptr_value(string);
		pointer tempargs = pair_cdr(args);
		pointer len = pair_car(tempargs);
		int l = ivalue(len);
		if (l == 0) return mk_counted_string(sc,"",l);//take care of cases when the buf is zero
		buf[l] = '\0';
		return mk_counted_string(sc,buf,l);
    }
    return sc->NIL;
}

pointer scheme_new_ptr(scheme *sc, pointer args) {
	  return mk_pointer(sc,0);
}



void scheme_load_apache_tie_symbols(scheme *sc){
//The symbols used for identifying which symbol-groups to load. used as >> (use apache:util_filter)
	DEF_SYMBOL("apache:read_string",scheme_read_apache_string)
	DEF_SYMBOL("apache:nread_string",scheme_read_apache_string_len)

	DEF_SYMBOL("apache:make_string",scheme_make_apache_string)
	DEF_SYMBOL("apache:nmake_string",scheme_make_apache_string_len)

	DEF_SYMBOL("apache:new_string",scheme_new_apache_string)
	DEF_SYMBOL("apache:new_ptr",scheme_new_ptr)
	DEF_SYMBOL("scheme:trace",scheme_trace)
//Variables
	DEF_CONST("apr:success",APR_SUCCESS)
	DEF_CONST("ap:mode_eatcrlf",AP_MODE_EATCRLF)
	DEF_CONST("apr:block_read",APR_BLOCK_READ)
}
