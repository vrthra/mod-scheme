#macro?	ReturnType	pointer0|int1  lib_name function_name arg_type pointer|int 
#-------------------------------------------------------------------
#0,	apr_status_t,		1,	ap,	get_brigade,			^_ap_filter_t,0,^_apr_bucket_brigade,0,ap_input_mode_t,1,apr_read_type_e,1,apr_off_t,1
#0,	apr_status_t,		1,	ap,	pass_brigade,			^_ap_filter_t,0,^_apr_bucket_brigade,0
#0,	^_ap_filter_rec_t,	0,	ap,	register_input_filter,		^_char,0,ap_in_filter_func,0,ap_init_filter_func,0,ap_filter_type,1
#0,	^_ap_filter_rec_t,	0,	ap,	register_output_filter,		^_char,0,ap_out_filter_func,0,ap_init_filter_func,0,ap_filter_type,1
#0,	^_ap_filter_t,		0,	ap,	add_input_filter,		^_char,0,^_void,0,^_request_rec,0,^_conn_rec,0
#0,	^_ap_filter_t,		0,	ap,	add_input_filter_handle,	^_ap_filter_rec_t,0,^_void,0,^_request_rec,0,^_conn_rec,0
#0,	^_ap_filter_rec_t,	0,	ap,	get_input_filter_handle,	^_char,0
#0,	^_ap_filter_t,		0,	ap,	add_output_filter,		^_char,0,^_void,0,^_request_rec,0,^_conn_rec,0
#0,	^_ap_filter_t,		0,	ap,	add_output_filter_handle,	^_ap_filter_rec_t,0,^_void,0,^_request_rec,0,^_conn_rec,0
#0,	^_ap_filter_rec_t,	0,	ap,	get_output_filter_handle,	^_char,0
#0,	void,			0,	ap,	remove_input_filter,		^_ap_filter_t,0
#0,	void,			0,	ap,	remove_output_filter,		^_ap_filter_t,0
#0,	apr_status_t,		1,	ap,	save_brigade,			^_ap_filter_t,0,^^_apr_bucket_brigade,0,^^_apr_bucket_brigade,0,^_apr_pool_t,0
#0,	apr_status_t,		1,	ap,	filter_flush,			^_apr_bucket_brigade,0,^_void,0
#0,	apr_status_t,		1,	ap,	fflush,				^_ap_filter_t,0,^_apr_bucket_brigade,0
0,	apr_status_t,		1,	ap,	fwrite,				^_ap_filter_t,0,^_apr_bucket_brigade,0,^_char,0,apr_size_t,1
0,	apr_status_t,		1,	ap,	fputs,				^_ap_filter_t,0,^_apr_bucket_brigade,0,^_char,0
0,	apr_status_t,		1,	ap,	fputc,				^_ap_filter_t,0,^_apr_bucket_brigade,0,char,1
