(require racket/base)

(define true-for-all-pairs?
  (lambda (pred list)
    (cond ((equals? (length list) 1) #t)
          ((pred (car list) (car (cdr list)))
           (true-for-all-pairs? pred (cdr list)))
          (else
           #f)
          )))

(true-for-all-pairs? equal? '(a b c c d))

(true-for-all-pairs? equal? '(a a a a a))

(true-for-all-pairs? < '(20 16 5 8 6))

(true-for-all-pairs? < '(3 7 19 22 43))

(true-for-all-pairs? > '(20 16 8 6))

(true-for-all-pairs? > '(9 7 19 22 43))