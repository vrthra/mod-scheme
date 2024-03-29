;;Example for output filter
;;
(use apache:util_filter)
(use apache:httpd)
(use apache:apr_buckets)
(scheme:trace 1)
(define (do_output_filter type f pbbIn mode block bytes)
  (let* ((r (apache:ap_filter_t->r f))
         (c (apache:request_rec->connection r))
         (pbbOut (apr:brigade_create (apache:request_rec->pool r) (apache:conn_rec->bucket_alloc c))) 
         (outbkt "")
         (len 0)
         (tmp 0)
         (buf (apache:new_ptr)))
    (let loop ((curr_bucket (apr:brigade_first pbbIn)))
      (if (eqv? (apr:brigade_sentinel pbbIn) curr_bucket)
        (ap:pass_brigade (apache:ap_filter_t->next f) pbbOut)
        (if (apr:bucket_is_eos curr_bucket)
          (begin
            (apr:bucket_remove curr_bucket)
            (apr:brigade_insert_tail pbbOut curr_bucket)
            (ap:pass_brigade (apache:ap_filter_t->next f) pbbOut))
          (begin
            (apr:bucket_read curr_bucket buf len apr:block_read)
            (set! tmp (apache:nread_string buf len))
            (set! tmp (string-append "[[[[" tmp "]]]]"))
            (set! tmp (apache:make_string tmp))
            (set! outbkt (apr:bucket_heap_create
                           tmp (+ 8 len) 0 (apache:conn_rec->bucket_alloc c)))
            (apr:brigade_insert_tail pbbOut outbkt)
            (loop (apr:bucket_next curr_bucket))))))))

