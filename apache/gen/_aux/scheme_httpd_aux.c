/**
 * @file httpd.h
 * @brief HTTP Daemon routines
 */
/* Headers in which EVERYONE has an interest... */
#include "scheme-private.h"
#include "apache/macros.h"
#include "apache/ptr_types.h"
#include "callback.h"

/*#include "httpd.h"
#include "apr_general.h"
#include "apr_tables.h"
#include "apr_pools.h"
#include "apr_time.h"
#include "apr_network_io.h"
#include "apr_buckets.h"

#include "os.h"

#include "pcreposix.h"
//typedef struct htaccess_result htaccess_result;
#include "apr_uri.h"
*/
#include "scheme_httpd_aux.stpl.i.c"
#include "scheme_httpd_aux.tpl.i.c"

//-------endauto

void load_scheme_httpd_symbols_aux(scheme *sc) {

#include "scheme_httpd_aux.stpl.o.c"
#include "scheme_httpd_aux.tpl.o.c"

    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"apache:declined"), 
    mk_integer(sc,DECLINED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"apache:done"), 
    mk_integer(sc,DONE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"apache:ok"), 
    mk_integer(sc,OK));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:continue"), 
    mk_integer(sc,HTTP_CONTINUE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:switching_protocols"), 
    mk_integer(sc,HTTP_SWITCHING_PROTOCOLS));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:processing"), 
    mk_integer(sc,HTTP_PROCESSING));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:ok"), 
    mk_integer(sc,HTTP_OK));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:created"), 
    mk_integer(sc,HTTP_CREATED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:accepted"), 
    mk_integer(sc,HTTP_ACCEPTED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:non_authoritative"), 
    mk_integer(sc,HTTP_NON_AUTHORITATIVE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:no_content"), 
    mk_integer(sc,HTTP_NO_CONTENT));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:reset_content"), 
    mk_integer(sc,HTTP_RESET_CONTENT));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:partial_content"), 
    mk_integer(sc,HTTP_PARTIAL_CONTENT));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:multi_status"), 
    mk_integer(sc,HTTP_MULTI_STATUS));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:multiple_choices"), 
    mk_integer(sc,HTTP_MULTIPLE_CHOICES));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:moved_permanently"), 
    mk_integer(sc,HTTP_MOVED_PERMANENTLY));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:see_other"), 
    mk_integer(sc,HTTP_SEE_OTHER));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:not_modified"), 
    mk_integer(sc,HTTP_NOT_MODIFIED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:use_proxy"), 
    mk_integer(sc,HTTP_USE_PROXY));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:temporary_redirect"), 
    mk_integer(sc,HTTP_TEMPORARY_REDIRECT));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:bad_request"), 
    mk_integer(sc,HTTP_BAD_REQUEST));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:unauthorized"), 
    mk_integer(sc,HTTP_UNAUTHORIZED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:payment_required"), 
    mk_integer(sc,HTTP_PAYMENT_REQUIRED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:forbidden"), 
    mk_integer(sc,HTTP_FORBIDDEN));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:not_found"), 
    mk_integer(sc,HTTP_NOT_FOUND));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:method_not_allowed"), 
    mk_integer(sc,HTTP_METHOD_NOT_ALLOWED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:not_acceptable"), 
    mk_integer(sc,HTTP_NOT_ACCEPTABLE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:proxy_authentication_required"), 
    mk_integer(sc,HTTP_PROXY_AUTHENTICATION_REQUIRED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:request_time_out"), 
    mk_integer(sc,HTTP_REQUEST_TIME_OUT));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:conflict"), 
    mk_integer(sc,HTTP_CONFLICT));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:gone"), 
    mk_integer(sc,HTTP_GONE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:length_required"), 
    mk_integer(sc,HTTP_LENGTH_REQUIRED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:precondition_failed"), 
    mk_integer(sc,HTTP_PRECONDITION_FAILED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:request_entity_too_large"), 
    mk_integer(sc,HTTP_REQUEST_ENTITY_TOO_LARGE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:request_uri_too_large"), 
    mk_integer(sc,HTTP_REQUEST_URI_TOO_LARGE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:unsupported_media_type"), 
    mk_integer(sc,HTTP_UNSUPPORTED_MEDIA_TYPE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:range_not_satisfiable"), 
    mk_integer(sc,HTTP_RANGE_NOT_SATISFIABLE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:expectation_failed"), 
    mk_integer(sc,HTTP_EXPECTATION_FAILED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:unprocessable_entity"), 
    mk_integer(sc,HTTP_UNPROCESSABLE_ENTITY));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:locked"), 
    mk_integer(sc,HTTP_LOCKED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:failed_dependency"), 
    mk_integer(sc,HTTP_FAILED_DEPENDENCY));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:upgrade_required"), 
    mk_integer(sc,HTTP_UPGRADE_REQUIRED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:internal_server_error"), 
    mk_integer(sc,HTTP_INTERNAL_SERVER_ERROR));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:not_implemented"), 
    mk_integer(sc,HTTP_NOT_IMPLEMENTED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:bad_gateway"), 
    mk_integer(sc,HTTP_BAD_GATEWAY));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:service_unavailable"), 
    mk_integer(sc,HTTP_SERVICE_UNAVAILABLE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:gateway_time_out"), 
    mk_integer(sc,HTTP_GATEWAY_TIME_OUT));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:version_not_supported"), 
    mk_integer(sc,HTTP_VERSION_NOT_SUPPORTED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:variant_also_varies"), 
    mk_integer(sc,HTTP_VARIANT_ALSO_VARIES));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:insufficient_storage"), 
    mk_integer(sc,HTTP_INSUFFICIENT_STORAGE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:not_extended"), 
    mk_integer(sc,HTTP_NOT_EXTENDED));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_get"), 
    mk_integer(sc,0));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_put"), 
    mk_integer(sc,1));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_post"), 
    mk_integer(sc,2));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_delete"), 
    mk_integer(sc,3));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_connect"), 
    mk_integer(sc,4));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_options"), 
    mk_integer(sc,5));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_trace"), 
    mk_integer(sc,6));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_patch"), 
    mk_integer(sc,7));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_propfind"), 
    mk_integer(sc,8));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_proppatch"), 
    mk_integer(sc,9));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_mkcol"), 
    mk_integer(sc,10));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_copy"), 
    mk_integer(sc,11));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_move"), 
    mk_integer(sc,12));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_lock"), 
    mk_integer(sc,13));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_unlock"), 
    mk_integer(sc,14));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_version_control"), 
    mk_integer(sc,15));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_checkout"), 
    mk_integer(sc,16));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_uncheckout"), 
    mk_integer(sc,17));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_checkin"), 
    mk_integer(sc,18));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_update"), 
    mk_integer(sc,19));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_label"), 
    mk_integer(sc,20));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_report"), 
    mk_integer(sc,21));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_mkworkspace"), 
    mk_integer(sc,22));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_mkactivity"), 
    mk_integer(sc,23));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_baseline_control"), 
    mk_integer(sc,23));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_merge"), 
    mk_integer(sc,24));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"http:m_invalid"), 
    mk_integer(sc,25));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"apache:request_no_body"), 
    mk_integer(sc,REQUEST_NO_BODY));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"apache:request_chunked_error"), 
    mk_integer(sc,REQUEST_CHUNKED_ERROR));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"apache:request_chunked_dechunk"), 
    mk_integer(sc,REQUEST_CHUNKED_DECHUNK));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"ap:req_accept_path_info"), 
    mk_integer(sc,AP_REQ_ACCEPT_PATH_INFO));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"ap:req_reject_path_info"), 
    mk_integer(sc,AP_REQ_REJECT_PATH_INFO));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"ap:req_default_path_info"), 
    mk_integer(sc,AP_REQ_DEFAULT_PATH_INFO));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"ap:proxyreq_none"), 
    mk_integer(sc,PROXYREQ_NONE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"ap:proxyreq_proxy"), 
    mk_integer(sc,PROXYREQ_PROXY));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"ap:proxyreq_reverse"), 
    mk_integer(sc,PROXYREQ_REVERSE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"ap:proxyreq_response"), 
    mk_integer(sc,PROXYREQ_RESPONSE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"ap:conn_unknown"), 
    mk_integer(sc,AP_CONN_UNKNOWN));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"ap:conn_close"), 
    mk_integer(sc,AP_CONN_CLOSE));
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"ap:conn_keepalive"), 
    mk_integer(sc,AP_CONN_KEEPALIVE));
}
