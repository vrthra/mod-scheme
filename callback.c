/*      callback.c
 *      contains call back procedures [now only filters use it]
 * */

#include "callback.h"
#include "apache/macros.h"
int callback_putc(int c,void *xtData){
	callback_data *cdata;
	cdata = (callback_data*)xtData;
	if ( cdata->type == HANDLER ) return	ap_rputc(c,cdata->r);
		else return 0;
}

int filter_write(  char *buff, int len,callback_data *data) {
    //It is an error as direct filter write is not supported through (display).
    ap_log_rerror(APLOG_MARK, APLOG_ERR, 0, data->_callback._filter.f->r, buff);
	return 0;
}


int callback_write(const void *buf, int nbyte, void *xtData){
	callback_data *cdata;
	cdata = (callback_data*)xtData;
	if ( cdata->type == HANDLER ) return ap_rwrite(buf,nbyte,cdata->r);
    
	if ( cdata->type == FILTER ) return filter_write((char *)buf,nbyte,cdata);
		else return 0;
}

#include "apache/auxiliary/callback.stpl.i.c"

void scheme_load_context_symbols(scheme *sc) {
//scheme_filter_ctx
	#include "apache/auxiliary/callback.stpl.o.c"
}
