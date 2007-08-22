/*      ptr_types.h
 *      necessary typedefs.
 * */

#ifndef PTR_TYPES_H
	#define PTR_TYPES_H
#include "apr.h"
#include "apr_buckets.h"
#include "util_filter.h"
#include "httpd.h"

typedef struct iovec  iovec;
typedef struct iovec  structiovec;
typedef unsigned char unsignedchar;
typedef unsigned int unsignedint;

typedef void (*P_free_func)(void *data) ;

typedef struct htaccess_result htaccess_result;
typedef struct proxy_remote proxy_remote;
typedef struct proxy_alias  proxy_alias;
typedef struct dirconn_entry  dirconn_entry;
typedef struct noproxy_entry  noproxy_entry;

#endif

