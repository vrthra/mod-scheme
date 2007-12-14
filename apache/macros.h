/*    Useful macros. Unlike the decl.h macros, these depend upon the definitions in scheme.h
 * */
#ifndef MACROS_H
	#define MACROS_H
#ifndef WIN32
#include "tinyscheme/scheme.h"
#else
struct scheme;
typedef struct scheme scheme;
#endif
#define int_value(p)        ((p)->_object._number.value.ivalue)

void scheme_log(scheme* sc,char * str);
void scheme_exception(scheme* sc,char * str);

#define CDATA \
	callback_data* cdata = (callback_data*)sc->outport->_object._port->rep.callback.data;

#define TRACE(str) \
{ \
	CDATA \
	if (cdata->trace) scheme_log(sc,str); \
}
typedef void* ptrval;
#define ptr_value(p)        ((void *)(p)->_object._string._svalue)

#define mk_int64(INTERP,VAL) \
	mk_integer(INTERP,(long)VAL)

#define SCM_RETURN(INTERP)\
		return INTERP->value->_object._number.value.ivalue;

#include "decl.h"
#endif

