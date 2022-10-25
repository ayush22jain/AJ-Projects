(require racket/base)
(require racket/stream)

(define add-series 
  (lambda (s1 s2)
    (cond ((stream-empty? s1) s2)
          ((stream-empty? s2) s1)
          (else (stream-cons (+ (stream-first s1) (stream-first s2))
                             (add-series (stream-rest s1) (stream-rest s2)))))))

(define smul-series 
  (lambda (c s)
    (cond ((stream-empty? s) '())
          (else (stream-cons (* c (stream-first s))
                             (smul-series c (stream-rest s)))))))

(define mul-series 
  (lambda (s1 s2)
    (cond ((stream-empty? s1) '())
          ((stream-empty? s2) '())
          (else (add-series (smul-series (stream-first s2) s1)
                            (stream-cons 0 (mul-series (stream-rest s2) s1))))))) 

(define ones (stream-cons 1 ones))

(define test (add-series ones ones))
(define test2 (smul-series 6 ones))
(define test3 (mul-series ones ones))

(define stream->listn
  (lambda ((s <stream>) (n <integer>))
    (cond ((or (zero? n) (stream-empty? s)) '())
          (else (cons (stream-first s)
                      (stream->listn (stream-rest s) (- n 1)))))))


(stream->listn test3 10)