/**
 * @file apr_buckets.h
 * @brief APR-UTIL Buckets/Bucket Brigades
 */
/*
#include "apu.h"
#include "apr_network_io.h"
#include "apr_file_io.h"
#include "apr_general.h"
#include "apr_mmap.h"
#include "apr_errno.h"
#include "apr_ring.h"
#include "apr.h"
#include "apr_buckets.h"

#include "apache/macros.h"
#include "tinyscheme/scheme-private.h"
#include "apache/ptr_types.h"
#include "callback.h"
*/
//We dont do unions yet
//union apr_bucket_structs {
//    apr_bucket      b;      /**< Bucket */
//    apr_bucket_heap heap;   /**< Heap */
//    apr_bucket_pool pool;   /**< Pool */
//#if APR_HAS_MMAP
//    apr_bucket_mmap mmap;   /**< MMap */
//#endif
//    apr_bucket_file file;   /**< File */
//};

//---------------auto structs
#include "scheme_apr_buckets_aux.stpl.i.c"
//-------endauto structs


//---------------auto
#include "./scheme_apr_buckets_aux.tpl.i.c"
//-------endauto
pointer scheme_apr_bucket_read(scheme *sc, pointer args) {
	pointer tempargs,p_readbuff,p_len,p_blocktype,bucket;
	int len,ret,block_type;
	TRACE ("apr:bucket_read")
    if (args != sc->NIL) {
		ARG_ASSERT(bucket, args, "apr:bucket_read [no apr_bucket]")
		tempargs = pair_cdr(args);
		ARG_ASSERT(p_readbuff, tempargs, "apr:bucket_read [no str]")
		tempargs = pair_cdr(tempargs);
		ARG_ASSERT(p_len, tempargs, "apr:bucket_read [no len]")
		tempargs = pair_cdr(tempargs);
		ARG_ASSERT(p_blocktype, tempargs, "apr:bucket_read [no block]")
		//readbuff = ptr_value(p_readbuff);
		len = int_value(p_len);
		block_type = int_value(p_blocktype);
		//the & object thingie is actualy ptr_value
		ret = apr_bucket_read((apr_bucket *)ptr_value(bucket), &(p_readbuff)->_object._string._svalue , &int_value(p_len), block_type);
		return mk_integer(sc,ret);
    }
    return sc->NIL;
}





void load_scheme_apr_buckets_symbols_aux(scheme *sc) {
//	ap_assert(0);
scheme_define(sc,sc->global_env, 
   mk_symbol(sc,"apr:block_read"), 
   mk_integer(sc,APR_BLOCK_READ));
scheme_define(sc,sc->global_env, 
   mk_symbol(sc,"apr:nonblock_read"), 
   mk_integer(sc,APR_NONBLOCK_READ));
scheme_define(sc,sc->global_env, 
   mk_symbol(sc,"apr:bucket_data"), 
   mk_integer(sc,APR_BUCKET_DATA));
scheme_define(sc,sc->global_env, 
   mk_symbol(sc,"apr:bucket_metadata"), 
   mk_integer(sc,APR_BUCKET_METADATA));

//---------------auto structs
#include "./scheme_apr_buckets_aux.stpl.o.c"
//-------endauto structs


//---------------auto
#include "./scheme_apr_buckets_aux.tpl.o.c"
//-------endauto

}

