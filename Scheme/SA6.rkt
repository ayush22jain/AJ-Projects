(require racket/base)

;;recursive

(define reverse-rec
  (lambda ((lst <list>))
    (if (null? lst)
        lst
        (append (reverse-rec (cdr lst)) (list (car lst))))))

;;tail recursive
(define reverse-tail
  (lambda((lst <list>))
    (letrec ((iter
              (lambda (l final)
                (if (null? l)
                    final
                    (iter (cdr l)(cons (car l) final))))))
                (iter lst '()))))
              
(reverse-tail '(1 2 3 4 5))
(reverse-tail '())
(reverse-tail '(1))
(reverse-tail '(1 (2 3) 4 5))