(use apache:httpd)

(define (do_service req)
  (display (apache:read_string
             (apache:request_rec->args req)))
  (display (myfunct)))


(function (myfunct)
  (display "Testing")
  (return "imperative return")
  (display "Dont come here"))

;(apache:request_rec->the_request req)
;(apache:request_rec->method req)
;(apache:request_rec->hostname req)
;(apache:request_rec->content_type req)
;(apache:request_rec->handler req)
;(apache:request_rec->content_encoding req)
;(apache:request_rec->uri req)

;(apache:request_rec->args req)
;(apache:request_rec->path_info req)

;(define (do_service req)
;(display (oblist)))

