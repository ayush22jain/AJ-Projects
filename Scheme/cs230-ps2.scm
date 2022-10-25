;;; Set Language to Full Swindle
;;; ps2.scm ; BRD/PS 2022
(require racket/base) ;;This allows the type system to work.
(require rnrs/mutable-pairs-6)
(define square
  (lambda ((n <number>))
    (* n n)))

;; ----- Data type definitions -----

;; Keys are implemented as simple pairs
(define <key> <pair>)

;; Constructors and accessors for RSA keys:
(define make-key
  (lambda ((exponent <integer>) (modulus <integer>))
    (cons exponent modulus)))

(define key-exponent car)
(define key-modulus  cdr)

;; A key pair is just a pair whose head is the public key and
;; whose tail is the private key
(define <key-pair> <pair>)

;; Constructor and accessors for key pairs
(define make-key-pair
  (lambda ((public <key>) (private <key>))
    (cons public private)))

(define key-pair-public  car)
(define key-pair-private cdr)

;; A message is a list of integers, the blocks of the message
(define <message> <list>)

;; A signed message consists of a message + a signature
(define <signed-message> <pair>)

;; Constructor and accessors for signed messages
(define make-signed-message
  (lambda ((message <message>) (signature <integer>))
    (cons message signature)))

(define signed-message-body car)
(define signed-message-signature cdr)

;; ----- The RSA transformation -----

(define rsa-transform
  (lambda ((number <integer>) (key <key>))
    (exptmod number 
	     (key-exponent key) 
	     (key-modulus key))))

(define rsa-convert-list
  (lambda ((lst <list>) (key <key>))
    (let ((n (key-modulus key)))
      (let loop ((rst lst) (prev 0))
	(cond ((null? rst) rst)
	      (else
	       (let ((cur (rsa-transform (modulo (+ (car rst) prev) n) key)))
		 (cons cur 
		       (loop (cdr rst) cur)))))))))
			     

(define rsa-encrypt
  (lambda ((msg <string>) (key <key>))
    (rsa-convert-list (string->intlist msg) key)))

(define rsa-decrypt
  (lambda ((msg <message>) (key <key>))
    (intlist->string (rsa-unconvert-list msg key))))

;; ----- RSA key generation functions -----

;; (choose-prime smallest range)
;; Find an odd prime by sequential search, beginning at a random
;; point within 'range' of 'smallest'

(define choose-prime
  (lambda ((smallest <integer>) (range <integer>))
    (let ((start (+ smallest (bigrand range))))
      (search-prime
       (if (even? start) 
	   (+ start 1) 
	   start)))))

;; Sequentially search for an odd prime beginning at 'guess'
;; Assumes 'guess' is odd
(define search-prime
  (lambda ((guess <integer>))
    (cond ((divisible-by-primes? guess)
	   (search-prime (+ guess 2)))
	  ((fast-prime? guess)
           guess)
          (else
           (search-prime (+ guess 2))))))

;; Uses Fermat's theorem to quickly test if a number is composite
;; Returns #f if 'candidate' is definitely composite, #t if it may
;; be prime.
(define fermat-test
  (lambda ((candidate <integer>) (witness <integer>))
    (= (exptmod witness candidate candidate) witness)))

;; Uses fermat-test to test whether a candidate is prime
;; Returns #f if candidate is definitely composite, #t if it may 
;; be prime.
(define fast-prime?
  (lambda ((candidate <integer>))
    (and (fermat-test candidate 2)
         (fermat-test candidate 3)
         (fermat-test candidate 5)
         (fermat-test candidate 7))))

;; Test whether candidate is divisible by some small known primes.
;; This eliminates a lot of candidates quickly, and avoids the more
;; expensive fermat-test (this is important when you are generating
;; big keys!  It also helps avoid Carmichael numbers.

(define *small-primes* (list 2 3 5 7 11 13 17 23))

(define divisible-by-primes?
  (lambda ((candidate <integer>))
    (let loop ((primes *small-primes*))
      (cond ((null? primes) #f)
	    ((divides? (car primes) candidate) (car primes))
	    (else
	     (loop (cdr primes)))))))

;; Generate an RSA key pair with a modulus of 'bits' significant bits.
(define generate-rsa-key-pair
  (lambda ((bits <integer>))
    (let* ((base (expt 2 (quotient bits 2)))
           (p (choose-prime base base))
           (q (choose-prime base base)))
      (if (= p q)   ; Try again if we choose the same prime twice
          (generate-rsa-key-pair bits)
          (let* ((n (* p q))        ; key modulus
                 (m (- n p q -1))   ; m = (p - 1)(q - 1) = n - p - q + 1
                 (z (select-exponents m)) ; choose e and d
                 (e (car z))
                 (d (cdr z)))
            (make-key-pair (make-key e n)
                           (make-key d n)))))))

;; Choose a random encryption exponent and compute the corresponding
;; decryption exponent, given phi(n) = (p - 1)(q - 1)
(define select-exponents
  (lambda ((m <integer>))
    (let* ((e (random (expt 2 15)))
           (z (euclid e m))
           (g (caddr z)))
      (if (= g 1)
          (cons e (modulo (car z) m))
          (select-exponents m)))))  ; try again if e doesn't work

;; ----- Encoding and decoding messages -----
;;
;; These procedures convert between strings and lists of integers in
;; the range 0 .. 2^14.  You don't need to study this code; you can
;; just use it as is.

(define (make-string-padder size)
  (lambda ((str <string>))
    (let ((rem (modulo (string-length str) size)))
      (if (zero? rem)
	  str
	  (string-append str (make-string (- size rem)))))))

(define (make-string-to-intlist-func bits)
  (let* ((size (quotient (+ bits 6) 7))
	 (pad (make-string-padder size)))
    (lambda ((str <string>))
      (let loop ((in (map char->integer (string->list (pad str))))
		 (out '()))
	(cond ((null? in) (reverse out))
	      (else
	       (let-values (((firstk rest) (first-k in size)))
		  (let ((value
			 (let accum ((tot 0) (lst firstk))
			   (cond ((null? lst) tot)
				 (else
				  (accum (+ (* tot 128) (car lst))
					 (cdr lst)))))))
		    (loop rest (cons value out))))))))))

(define (make-intlist-to-string-func bits)
  (define (split-val val size)
    (cond ((zero? size) '())
	  (else 
	   (cons (modulo val 128) 
		 (split-val (quotient val 128) 
			    (- size 1))))))
  (let* ((size (quotient (+ bits 6) 7)))
    (lambda ((lst <list>))
      (let loop ((in lst) (out '()))
	(cond ((null? in)
	       (list->string
		(map integer->char
		     (filter (lambda (c) (not (zero? c))) (reverse out)))))
	      (else
	       (loop (cdr in)
		     (append (split-val (car in) size) out))))))))

;; Convert a string to a list of numbers 
(define string->intlist (make-string-to-intlist-func 14))

;; Convert a list of numbers to a string
(define intlist->string (make-intlist-to-string-func 14))

;; Returns two values, the first k elements of the list, and the rest
;; of the list
(define (first-k lst k)
  (let loop ((n k) (out '()) (rst lst))
    (cond ((or (null? rst)
	       (zero? n))
	   (values (reverse out) rst))
	  (else
	   (loop (- n 1)
		 (cons (car rst) out)
		 (cdr rst))))))

;; ----- Useful mathematical functions -----

;; (bigrand value) - returns a pseudorandom number in the range
;; 0 .. value-1.
(define bigrand
  (lambda ((value <integer>))
    (let loop ((cur 0))
      (cond ((> cur value)
             (modulo cur value))
            (else
             (loop (+ (* cur 256) (random 256))))))))

;; (divides? a m)
;; Returns true iff a divides m
(define divides?
  (lambda ((a <integer>) (m <integer>))
    (zero? (modulo m a))))

;; (exptmod b e m)
;; Compute b to the e power, modulo m (i.e., b^e (mod m))
(define exptmod
  (lambda ((b <integer>) (e <integer>) (m <integer>))
    (cond ((zero? e) 1)
          ((even? e)
           (modulo (square (exptmod b (quotient e 2) m)) m))
          (else
           (modulo (* b (exptmod b (- e 1) m)) m)))))

;; (euclid a m)
;; Computes the greatest common divisor of a and m using 
;; an extension of Euclid's algorithm.  Returns a list 
;; (s t g) where g = (a, m) and s, t are constants satisfying
;; Bezout's identity (sa + tm = g)
(define euclid
  (lambda ((a <integer>) (m <integer>))
    (cond ((zero? m) (list 1 0 a))
          (else
           (let* ((q (quotient a m))
                  (r (modulo a m))
                  (z (euclid m r))
                  (u (car z))
                  (v (cadr z))
                  (g (caddr z)))
             (list v (- u (* q v)) g))))))

;; (smallest-divisor n)
;; Finds the smallest divisor d > 1 of n by trial division

(define smallest-divisor
  (lambda ((n <integer>))
    (if (even? n)
	2
	(let ((sqrt-n (floor (sqrt n))))
	  (let loop ((try 3))
	    (cond ((> try sqrt-n) n)        ; stop if we get to sqrt(n)
		  ((divides? try n) try)    ; stop if we find a divisor
		  (else
		   (loop (+ try 2)))))))))  ; try the next odd divisor

;; ----- Compression (hash) function -----

;; Returns a compression function for values up to the specified size
;;
;; Each value is squared and multiplied by the index of its position
;; in the sequence, modulo a suitable prime.  The output is the
;; modular sum of these over all elements of the sequence.

(define (make-compression-func bits)
  ;; Find the first prime less than or equal to start (assumed odd)
  (define (find-modulus start)
    (cond ((or (divisible-by-primes? start)
	       (not (fast-prime? start)))
	   (find-modulus (- start 2)))
	  (else start)))

  (let* ((start (- (expt 2 bits) 1))
	 (modulus (find-modulus start)))

    (lambda ((lst <list>) (key <key>))
      (define (nexthash prev x i m)
	(modulo (+ prev (* x x i) i) m))

      (let loop ((index 1) (hash 0) (rst lst))
	(cond ((null? rst) (modulo hash (key-modulus key)))
	      (else
	       (loop (+ index 1)
		     (nexthash hash (car rst) index modulus)
		     (cdr rst))))))))

;; A compression function suitable for 18-bit integers
(define compress (make-compression-func 18));


;; ----- Test data and sample keys -----

;; Public keys
;; Change these keys every year
(define Ellie (make-key 32455 108371))
(define Jacob (make-key 30529 216221))
(define Paige (make-key 28859 135659))
(define Kyle  (make-key 28559 171967))
(define Rhea  (make-key 27089 89701))

;; Key pairs for testing purposes
(define test-key-1
  (make-key-pair 
   (make-key 2587 573193) 
   (make-key 28947 573193)))

(define test-key-2
  (make-key-pair
   (make-key 13889 557983)
   (make-key 269249 557983)))

(define big-key-1
  (make-key-pair
   (make-key 19307 43565950551638075623)
   (make-key 35440349052136018387 43565950551638075623)))

(define big-key-2
  (make-key-pair 
   (make-key 22059 30199096579027135423)
   (make-key 22743442190663818579 30199096579027135423)))

(define secret-message
	(make-signed-message
		'(3174 38202 77138 71385 81038 71311 26466 45345 64330 63743 41048 5249 55422
                       84941 13614 23637 76535 68461 81164 31479 69731 86306 21687 89307 57745
                       31010 71640 21027 30303 73381 13543 41338 85082 72323 23270 70995 25730
                       26285 80156 7293 75716 7665 86421 51686 20951 48544 49062 27938 36311
                       31950 65006 24797 37764 77038 31377 11571 51867 6239)
		53503))

;; ------------------------------------------------------------------------
;; here there be dragons

(define result-1
     (rsa-encrypt "test message" (key-pair-public test-key-1)))

;;Problem 1

(define rsa-unconvert-list
    (lambda ((lst <list>) (key <key>))
      (let ((n (key-modulus key)))
        (let loop((rst lst) (prev 0))
          (cond ((null? rst) rst)
                (else
                 (let ((cur (modulo (- (rsa-transform (car rst) key) prev) n)))
                   (cons cur
                         (loop (cdr rst) (car rst))))))))
      ))

#|(rsa-unconvert-list result-1 (key-pair-private test-key-1))
(rsa-decrypt result-1 (key-pair-private test-key-1))

(define test-message-long 
   (rsa-encrypt 
    "Cryptography plays an important role in establishing and maintaining privacy in a world that increasingly relies on digital records and communication. Whereas once, encryption was the sole province of powerful government and military institutions, today it is an essential tool for virtually every citizen of a modern nation." 
    (car test-key-2)))

(rsa-decrypt test-message-long (cdr test-key-2))
|#

;;Problem 2

(define encrypt-and-sign
  (lambda ((msg <string>) (recipient-pub-key <key>) (sender-priv-key <key>))
    (cons (rsa-encrypt msg recipient-pub-key) (rsa-transform(compress (rsa-encrypt msg recipient-pub-key) sender-priv-key) sender-priv-key)))
    )

(define decrypt-and-verify
  (lambda ((msg <string>) (sender-pub-key <key>) (recipient-priv-key <key>))
    (if (= (compress (signed-message-body msg) sender-pub-key)
           (rsa-transform (signed-message-signature msg) recipient-priv-key))
           (rsa-decrypt (signed-message-body msg) sender-pub-key)
         #f) 
    ))

#|(define result-2
     (encrypt-and-sign "Test message from User 1 to User 2"
                       (key-pair-public test-key-2)
                       (key-pair-private test-key-1)))

(signed-message-body result-2)
(signed-message-signature result-2)

(decrypt-and-verify result-2 
                     (key-pair-private test-key-2)
                     (key-pair-public test-key-1))
(decrypt-and-verify result-2
                     (key-pair-private test-key-1)
                     (key-pair-public test-key-2))

|#

;;Problem 3

(define crack-rsa
  (lambda ((pub-key <key>))
    (let* ((n (key-modulus pub-key))
          (p (smallest-divisor n))
          (q (/ n p))
          (m (* (- p 1)(- q 1)))
          (a (car (euclid (key-exponent pub-key) m)))
          (d (modulo a m)))
      (make-key d (* p q)))
  ))

#|  (crack-rsa (make-key 1763 132731))
  (crack-rsa (make-key 19883 159197))
  (crack-rsa (make-key 25639 210281))
|#

;;Problem 4

;; Testing Keys to find sender and recipent, only 20 permutations, so ill just try all of them

#|(decrypt-and-verify  secret-message  (crack-rsa Ellie) Jacob)
(decrypt-and-verify  secret-message (crack-rsa Ellie) Paige)
(decrypt-and-verify  secret-message (crack-rsa Ellie)  Kyle)
(decrypt-and-verify  secret-message (crack-rsa Ellie)  Rhea)

(decrypt-and-verify  secret-message  (crack-rsa Jacob) Ellie)
(decrypt-and-verify  secret-message (crack-rsa Jacob) Paige)
(decrypt-and-verify  secret-message (crack-rsa Jacob)  Kyle)
(decrypt-and-verify  secret-message  (crack-rsa Jacob) Rhea)

(decrypt-and-verify  secret-message  (crack-rsa Paige) Ellie)
(decrypt-and-verify  secret-message (crack-rsa Paige) Jacob)
(decrypt-and-verify  secret-message (crack-rsa Paige)  Kyle)
(decrypt-and-verify  secret-message  (crack-rsa Paige) Rhea)

(decrypt-and-verify  secret-message  (crack-rsa Kyle) Ellie)
(decrypt-and-verify  secret-message (crack-rsa Kyle) Jacob)
(decrypt-and-verify  secret-message (crack-rsa Kyle)  Paige)
(decrypt-and-verify  secret-message  (crack-rsa Kyle) Rhea)

(decrypt-and-verify  secret-message  (crack-rsa Rhea) Ellie)
(decrypt-and-verify  secret-message  (crack-rsa Rhea) Jacob)
(decrypt-and-verify  secret-message (crack-rsa Rhea) Paige)
(decrypt-and-verify  secret-message (crack-rsa Rhea)  Kyle)

|#

; Rhea is the recipient, Paige is the sender
;the message is "A little bit of math can accomplish what all the guns and barbed wire can't: a little bit of math can keep a secret."

;;Problem 5
(define pollard
  (lambda ((n <integer>)(base <integer>)(max (<integer>)))
    (letrec ((iter
             (lambda (k rkprev)
               (letrec ((r (exptmod rkprev k n))
                        (d (caddr(euclid (- r 1) n))))
             (cond
               ((> k max) #f)
               ((equals? d 1)
                   (iter (+ k 1) r))
               ((equals? d n)
                   (iter ((+ k 1) r)))
             (else d))))))
      (iter base (exptmod base 1 n)))
    ))


  (pollard 29958343 2 20)                 
  (pollard 13549648109 3 150)             
  (pollard 5157437 2 7)
(pollard 39173679876983836729 3 3000)
(pollard 2278570691794489592002651 2 27000)