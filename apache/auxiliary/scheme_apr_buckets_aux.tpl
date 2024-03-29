#macro?	ReturnType	pointer0|int1  lib_name function_name arg_type pointer|int 
#-------------------------------------------------------------------
1,	^_apr_bucket,		0,	apr,	brigade_sentinel	,^_apr_bucket_brigade,0
1,	bool,			1,	apr,	brigade_empty		,^_apr_bucket_brigade,0
1,	^_apr_bucket,		0,	apr,	brigade_first		,^_apr_bucket_brigade,0
1,	^_apr_bucket,		0,	apr,	brigade_last		,^_apr_bucket_brigade,0
1,	void,			0,	apr,	brigade_insert_tail	,^_apr_bucket_brigade,0,^_apr_bucket,	0
1,	^_apr_bucket,		0,	apr,	bucket_next		,^_apr_bucket,0
1,	^_apr_bucket,		0,	apr,	bucket_prev		,^_apr_bucket,0
1,	void,			0,	apr,	bucket_remove		,^_apr_bucket,0
1,	void,			0,	apr,	bucket_init		,^_apr_bucket,0
1,	bool,			0,	apr,	bucket_is_metadata	,^_apr_bucket,0
1,	bool,			0,	apr,	bucket_is_flush		,^_apr_bucket,0
1,	bool,			0,	apr,	bucket_is_eos		,^_apr_bucket,0
1,	bool,			0,	apr,	bucket_is_file		,^_apr_bucket,0
1,	bool,			0,	apr,	bucket_is_pipe		,^_apr_bucket,0
1,	bool,			0,	apr,	bucket_is_socket	,^_apr_bucket,0
1,	bool,			0,	apr,	bucket_is_heap		,^_apr_bucket,0
1,	bool,			0,	apr,	bucket_is_transient	,^_apr_bucket,0
1,	bool,			0,	apr,	bucket_is_immortal	,^_apr_bucket,0
1,	bool,			0,	apr,	bucket_is_mmap		,^_apr_bucket,0
1,	bool,			0,	apr,	bucket_is_pool		,^_apr_bucket,0
#0,	^_apr_bucket_brigade,	0,	apr,	brigade_create		,^_apr_pool_t,0,^_apr_bucket_alloc_t,0
#0,	apr_status_t,		1,	apr,	brigade_destroy		,^_apr_bucket_brigade,0
#0,	apr_status_t,		1,	apr,	brigade_cleanup		,^_void,0
#0,	^_apr_bucket_brigade,	0,	apr,	brigade_split		,^_apr_bucket_brigade,0,^_apr_bucket,0
#0,	apr_status_t,		1,	apr,	brigade_partition	,^_apr_bucket_brigade,0,apr_off_t,1,^^_apr_bucket,0
#0,	apr_status_t,		1,	apr,	brigade_length		,^_apr_bucket_brigade,0,int,1,^_apr_off_t,1
#0,	apr_status_t,		1,	apr,	brigade_flatten		,^_apr_bucket_brigade,0,^_char,0,^_apr_size_t,0
#0,	apr_status_t,		1,	apr,	brigade_pflatten	,^_apr_bucket_brigade,0,^^_char,0,^_apr_size_t,0,^_apr_pool_t,0
#0,	apr_status_t,		1,	apr,	brigade_split_line	,^_apr_bucket_brigade,0,^_apr_bucket_brigade,0,apr_read_type_e,1,apr_off_t,0
#0,	apr_status_t,		1,	apr,	brigade_to_iovec	,^_apr_bucket_brigade,0,^_iovec,0,^_int,0
#0,	apr_status_t,		1,	apr,	brigade_vputstrs	,^_apr_bucket_brigade,0,apr_brigade_flush,0,^_void,0,va_list,0
#0,	apr_status_t,		1,	apr,	brigade_write		,^_apr_bucket_brigade,0,apr_brigade_flush,0,^_void,0,^_char,0,apr_size_t,1
#0,	apr_status_t,		1,	apr,	brigade_writev		,^_apr_bucket_brigade,0,apr_brigade_flush,0,^_void,0,^_iovec,0,apr_size_t,1
#0,	apr_status_t,		1,	apr,	brigade_puts		,^_apr_bucket_brigade,0,apr_brigade_flush,0,^_void,0,^_char,0
#0,	apr_status_t,		1,	apr,	brigade_putc		,^_apr_bucket_brigade,0,apr_brigade_flush,0,^_void,0,char,1
#0,	apr_status_t,		1,	apr,	brigade_vprintf		,^_apr_bucket_brigade,0,apr_brigade_flush,0,^_void,0,^_char,0,va_list,0
#0,	^_apr_bucket_alloc_t,	0,	apr,	bucket_alloc_create	,^_apr_pool_t,0
#0,	^_apr_bucket_alloc_t,	0,	apr,	bucket_alloc_create_ex	,^_apr_allocator_t,0
#0,	void,			0,	apr,	bucket_alloc_destroy	,^_apr_bucket_alloc_t,0
#0,	^_void,			0,	apr,	bucket_alloc		,apr_size_t,1,^_apr_bucket_alloc_t,0
#0,	void,			0,	apr,	bucket_free		,^_void,0
#bucket-delete is a macro and also the rest of bucket ops
0,	void,			0,	apr,	bucket_delete		,^_apr_bucket,0
0,	void,			0,	apr,	bucket_setaside		,^_apr_bucket,0,^_apr_pool_t,0
0,	void,			0,	apr,	bucket_split		,^_apr_bucket,0,apr_size_t,1
0,	void,			0,	apr,	bucket_copy		,^_apr_bucket,0,^^_apr_bucket,0
0,	void,			0,	apr,	bucket_destroy		,^_apr_bucket,0
#0,	apr_status_t,		1,	apr,	bucket_simple_split	,^_apr_bucket,0,apr_size_t,1
#0,	apr_status_t,		1,	apr,	bucket_simple_copy	,^_apr_bucket,0,^^_apr_bucket,0
#0,	^_apr_bucket,		0,	apr,	bucket_shared_make	,^_apr_bucket,0,^_void,0,apr_off_t,1,apr_size_t,1
#0,	int,			1,	apr,	bucket_shared_destroy	,^_void,0
#0,	apr_status_t,		1,	apr,	bucket_shared_split	,^_apr_bucket,0,apr_size_t,1
#0,	apr_status_t,		1,	apr,	bucket_shared_copy	,^_apr_bucket,0,^^_apr_bucket,0
#0,	^_apr_bucket,		0,	apr,	bucket_eos_create	,^_apr_bucket_alloc_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_eos_make		,^_apr_bucket,0
#0,	^_apr_bucket,		0,	apr,	bucket_flush_create	,^_apr_bucket_alloc_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_flush_make	,^_apr_bucket,0
#0,	^_apr_bucket,		0,	apr,	bucket_immortal_create	,^_char,0,apr_size_t,1,^_apr_bucket_alloc_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_immortal_make	,^_apr_bucket,0,^_char,0,apr_size_t,1
#0,	^_apr_bucket,		0,	apr,	bucket_transient_create	,^_char,0,apr_size_t,1,^_apr_bucket_alloc_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_transient_make	,^_apr_bucket,0,^_char,0,apr_size_t,1
#heap create , the function chaged to int to facilitate 0
#0,	^_apr_bucket,		0,	apr,	bucket_heap_create	,^_char,0,apr_size_t,1,int,1,^_apr_bucket_alloc_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_heap_make	,^_apr_bucket,0,^_char,0,apr_size_t,1,int,1
#0,	^_apr_bucket,		0,	apr,	bucket_pool_create	,^_char,0,apr_size_t,1,^_apr_pool_t,0,^_apr_bucket_alloc_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_pool_make	,^_apr_bucket,0,^_char,0,apr_size_t,1,^_apr_pool_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_mmap_create	,^_apr_mmap_t,0,apr_off_t,1,apr_size_t,1,^_apr_bucket_alloc_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_mmap_make	,^_apr_bucket,0,^_apr_mmap_t,0,apr_off_t,1,apr_size_t,1
#0,	^_apr_bucket,		0,	apr,	bucket_socket_create	,^_apr_socket_t,0,^_apr_bucket_alloc_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_socket_make	,^_apr_bucket,0,^_apr_socket_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_pipe_create	,^_apr_file_t,0,^_apr_bucket_alloc_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_pipe_make	,^_apr_bucket,0,^_apr_file_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_file_create	,^_apr_file_t,0,apr_off_t,0,apr_size_t,1,^_apr_pool_t,0,^_apr_bucket_alloc_t,0
#0,	^_apr_bucket,		0,	apr,	bucket_file_make	,^_apr_bucket,0,^_apr_file_t,0,apr_off_t,1,apr_size_t,1,^_apr_pool_t,0
#0,	apr_status_t,		1,	apr,	bucket_file_enable_mmap	,^_apr_bucket,0,int,1
1,	void,			0,	apr,	brigade_concat		,^_apr_bucket_brigade,0,^_apr_bucket_brigade,0
1,	void,			0,	apr,	brigade_prepend		,^_apr_bucket_brigade,0,^_apr_bucket_brigade,0
1,	void,			0,	apr,	bucket_insert_before	,^_apr_bucket,0,^_apr_bucket,0
1,	void,			0,	apr,	bucket_insert_after	,^_apr_bucket,0,^_apr_bucket,0
1,	void,			0,	apr,	brigade_insert_head	,^_apr_bucket_brigade,0,^_apr_bucket,0
