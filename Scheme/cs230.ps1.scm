;;; Go to Language, Choose Language, Other Languages, Swindle, Full Swindle
;;; This may have to be done in cs230-graphics.scm as well
;;; cs230.ps1.scm


(require racket/base) ;;This allows the type system to work.
(require (file "cs230-graphics.scm")) ;;Pull in the definitions for the drawing window and stuff. Assumes the file is in the same directory. 

;; Here are the procedures you will modify in the problem set
(define side
  (lambda ((length <real>) (heading <real>) (level <integer>))
    (if (zero? level)
        (drawto heading length)
        (let ((len/3 (/ length 3))
              (lvl-1 (- level 1)))
          (side len/3 heading lvl-1)
          (side len/3 (- heading PI/3) lvl-1)
          (side len/3 (+ heading PI/3) lvl-1)
          (side len/3 heading lvl-1)))))

(define snowflake:0
  (lambda ((length <real>) (level <integer>))
    (side length 0.0 level)
    (side length (* 2 PI/3) level)
    (side length (- (* 2 PI/3)) level)))

;; Make the graphics window visible, and put the pen somewhere useful
(init-graphics 640 480)
(clear)
(moveto 100 100)

;;P1

(define flip-side
  (lambda ((length <real>) (heading <real>) (level <integer>))
    (if (zero? level)
        (drawto heading length)
        (let ((lenside (/ length (* (sqrt 2) 2)))
              (lvl-1 (- level 1)))
          (side lenside (- heading PI/4) lvl-1)
          (side (* 2 lenside) (+ heading PI/4) lvl-1)
          (side lenside (- heading PI/4) lvl-1)))))

(define pentagon-snowflake:1
  (lambda ((length <real>) (level <integer>))
    (flip-side length 0.0 level)
    (flip-side length (/(* 2 PI) 5) level)
    (flip-side length (/(* 4 PI) 5) level)
    (flip-side length (/(* 6 PI) 5) level)
    (flip-side length (/(* 8 PI) 5) level)))

;;(pentagon-snowflake:1 150 3)

;;P2

(define snowflake:2
  (lambda ((length <real>) (level <integer>) (gen <function>))
    (gen length 0.0 level)
    (gen length (* 2 PI/3) level)
    (gen length (- (* 2 PI/3)) level)))

(define pentagon-snowflake:2
  (lambda ((length <real>) (level <integer>) (gen <function>))
    (gen length 0.0 level)
    (gen length (* (/ 2 5)PI) level)
    (gen length (* (/ 4 5)PI) level)
    (gen length (- (* (/ 2 5)PI)) level)
    (gen length (- (* (/ 4 5)PI)) level)))

;; van Koch initiator with van Koch generator
;;(snowflake:2 200 3 side)

;; van Koch initiator with flip-side generator
;;(snowflake:2 150 3 flip-side)

;; pentagon initiator with van Koch generator
;;(pentagon-snowflake:2 200 3 side)

;; pentagon initiator with flip-side generator
;;(pentagon-snowflake:2 150 3 flip-side)

;;P3

(define snowflake-inv
  (lambda ((length <real>) (level <integer>) (gen <function>) (inverter <function>))
    (gen length 0.0 level inverter)
    (gen length (* 2 PI/3) level inverter)
    (gen length (- (* 2 PI/3)) level inverter)))

(define side-inv
  (lambda ((length <real>) (heading <real>) (level <integer>) (inverter <function>))
    (if (zero? level)
        (drawto heading length)
        (let ((len/3 (/ length 3))
              (lvl-1 (- level 1)))
          (side-inv len/3 (* (inverter level) heading) lvl-1 inverter)
          (side-inv len/3 (* (inverter level) (- heading PI/3)) lvl-1 inverter)
          (side-inv len/3 (* (inverter level) (+ heading PI/3)) lvl-1 inverter)
          (side-inv len/3 (* (inverter level) heading) lvl-1 inverter)))))


;; (snowflake-inv 150 3 side-inv
  ;;            (lambda ((level <integer>)) 
;;	         (if (odd? level) 1 -1)))

;;(snowflake-inv 150 3 side-inv
  ;;             (lambda ((level <integer>)) 
;;	         (if (even? level) 1 -1)))

;;P4

(define snowflake-length
  (lambda ((length <real>) (level <integer>) (gen <function>) (inverter <function>))
    (+ (gen length 0.0 level inverter)
    (gen length (* 2 PI/3) level inverter)
    (gen length (- (* 2 PI/3)) level inverter))))

(define side-length
  (lambda ((length <real>) (heading <real>) (level <integer>) (inverter <function>))
    (if (zero? level)
        length
        (let ((len/3 (/ length 3))
              (lvl-1 (- level 1)))
          (+(side-length len/3 (* (inverter level) heading) lvl-1 inverter)
          (side-length len/3 (* (inverter level) (- heading PI/3)) lvl-1 inverter)
          (side-length len/3 (* (inverter level) (+ heading PI/3)) lvl-1 inverter)
          (side-length len/3 (* (inverter level) heading) lvl-1 inverter))))))

;;(snowflake-length 100.0 3 side-length 
                ;; (lambda ((level <integer>)) 1))
