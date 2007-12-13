;;input filter
;;
(use apache:util_filter)
(use apache:httpd)
(use apache:apr_buckets)
;(*imperative define*)
(scheme:trace 1)

(macro (function form)
  `(define ,(cadr form)
     (call/cc (lambda (return) ,@(cddr form)))))


(function (input_filter type f pbbOut mode block bytes)
  (let* ((r (apache:ap_filter_t->r f))
         (c (apache:request_rec->connection r))
         (ctx (apache:ap_filter_t->ctx f)) (tmp 0))
    (if (apr:brigade_empty (apache:scheme_filter_ctx->bb ctx))
      (let ((ret (ap:get_brigade (apache:ap_filter_t->next f) (apache:scheme_filter_ctx->bb ctx) mode	block	bytes)))
        (if (or (eq? mode ap:mode_eatcrlf) (not (eq? ret apr:success))) 
          (return	ret))));return immediatly
    (let loop ();;while (brigade!=empty)
      (if (not (apr:brigade_empty (apache:scheme_filter_ctx->bb ctx)));begin loop//#empty?
        (let ((pbktIn (apr:brigade_first (apache:scheme_filter_ctx->bb ctx)))
              (ret_val 0)	(len 0) (pbktOut 0) (data (apache:new_ptr)))
          (if (apr:bucket_is_eos pbktIn)
            (begin
              (apr:bucket_remove pbktIn)
              (apr:brigade_insert_tail pbbOut pbktIn);eos
              (return apr:success)))
          (set! ret_val (apr:bucket_read pbktIn data len block))
          ;(apache:log data)
          ;(set! tmp (apache:nread_string data len))
          ;(set! tmp (string-append "{" tmp "}"))
          ;(set! tmp (apache:make_string tmp))
          (if (not (eq? ret_val apr:success))
            (return ret_val))
          (apache:log ">>[Inner Loop]>>------------<<")
          (set! pbktOut (apr:bucket_heap_create data len 0 (apache:conn_rec->bucket_alloc c)))
          (apr:brigade_insert_tail pbbOut pbktOut)
          (apr:bucket_delete pbktIn)
          (loop))
        (return apr:success)))))

(define (do_input_filter type f pbbOut mode block bytes)
	(input_filter type f pbbOut mode block bytes))
