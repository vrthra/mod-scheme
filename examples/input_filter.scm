;;input filter
;;using an imperative form
(use apache:util_filter)
(use apache:httpd)
(use apache:apr_buckets)
(scheme:trace 0)

(function (do_input_filter type f pbbOut mode block bytes)
  (let* ((r (apache:ap_filter_t->r f))
         (c (apache:request_rec->connection r))
         (ctx (apache:ap_filter_t->ctx f)) (tmp 0))
    (if (apr:brigade_empty (apache:scheme_filter_ctx->bb ctx))
      (let ((ret (ap:get_brigade (apache:ap_filter_t->next f) (apache:scheme_filter_ctx->bb ctx) mode	block	bytes)))
        (if (or (= mode ap:mode_eatcrlf) (not (= ret apr:success))) 
          (return ret))))
    (let loop ();;while (brigade!=empty)
      (if (not (apr:brigade_empty (apache:scheme_filter_ctx->bb ctx)));begin loop//#empty?
        (let ((pbktIn (apr:brigade_first (apache:scheme_filter_ctx->bb ctx)))
              (ret_val 0)	(len 0) (pbktOut 0)
              (data (apache:new_ptr)))
          (if (apr:bucket_is_eos pbktIn)
            (begin
              (apr:bucket_remove pbktIn)
              (apr:brigade_insert_tail pbbOut pbktIn);eos
              apr:success)
            (let ((tmp))
              (set! ret_val (apr:bucket_read pbktIn data len block))
              (set! tmp (apache:nread_string data len))
              (set! tmp (string-append "{" tmp "}"))
              (set! tmp (apache:make_string tmp))
              (if (not (= ret_val apr:success))
                ret_val
                (begin
                  (set! pbktOut (apr:bucket_heap_create tmp (+ 2 len) 0 (apache:conn_rec->bucket_alloc c)))
                  (apr:brigade_insert_tail pbbOut pbktOut)
                  (apr:bucket_delete pbktIn)
                  (loop))))))
        apr:success))))

