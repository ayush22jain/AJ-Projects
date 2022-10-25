(require racket/base)

;;tail recursive
(define deep-reverse
  (lambda((lst <list>))
    (letrec ((iter
              (lambda (l final)
                (cond ((null? l) final)
                      ((list? (car l)) (iter (cdr l) (cons (deep-reverse (car l)) final)))
                    (else(iter (cdr l)(cons (car l) final)))))))
                (iter lst '()))))
              
(deep-reverse '(1 (2 3) (4 (5 6) 7) (8 9 (10 11 (12)))))
(deep-reverse '())
(deep-reverse '(1))
(deep-reverse '(1 (2 3) 4 5))