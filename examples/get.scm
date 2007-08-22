(use apache:httpd)
(use apache:util_filter)
(use apache:apr_buckets)
(scheme:trace 0)
(define (do_service req)
      (display (apache:read_string 
                           (apache:request_rec->args req)))
  ;    (display  (apache:read_string 
  ;        (apache:read_post_data req)))
  (display (read_post_data req)))

(function (for_each_brigade_loop bb)
          (let loop_brigades ((bucket (apr:brigade_first bb)))
            (if (not (eq? bucket (apr:brigade_sentinel bb)))
              (begin
                (if (apr:bucket_is_eos bucket)
                  (return 1));;break / return from for_each
                (if (not (apr:bucket_is_flush bucket))
                  (let ((data (apache:new_ptr))(len 0))
                    (apr:bucket_read bucket data len apr:block_read)
                    (display (apache:nread_string data len))
                    (loop_brigades (apr:bucket_next bucket)))
                  (loop_brigades (apr:bucket_next bucket))))
              0)));;if sentinel return seen_eos 0


(function (read_post_data req)
          (let* ((bb 
                   (apr:brigade_create 
                     (apache:request_rec->pool req) 
                     (apache:request_rec->connection req) 
                     (apache:conn_rec->bucket_alloc (apache:request_rec->connection req))))
                 (seen_eos 0)
                 (postdata (apache:new_ptr))
                 (start 0)
                 (huge_len 8192))
            ;;while !seen_eos
            (let while_not_seen_eos_loop ((rv))
              (set! rv (ap:get_brigade (apache:request_rec->input_filters req) bb ap:mode_readbytes apr:block_read huge_len))
              (if (not (= apr:success rv)) (return rv))
              (set! seen_eos (for_each_brigade_loop bb))
              (apr:brigade_cleanup bb)
              (if (= 0 seen_eos) (while_not_seen_eos_loop)))));;while !seen_eos


