(require racket/base)

(define multiply-tail
  (lambda (a b)
    (letrec ((iter
              (lambda(c final d)
                (if(= c 0)
                   final
                   (if(odd? c)
                      (iter(quotient c 2)(+ final d)(+ d d))              
                   (iter(quotient c 2) final (+ d d)))))))
    (iter b 0 a))))

(multiply-tail 24 8)
(multiply-tail 4 0)
(multiply-tail 64 2)
(multiply-tail 17 7)

