#lang racket

(define ones (cons 1 (lambda () ones)))

(define naturals (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))])
                  (f 1)))

(define fibs
  (letrec ([f (lambda (x y) (cons x (lambda () (f y (+ x y)))))])
    (f 1 1)))


(define (first n tok)
  (define (first-helper proc remaining result)
    (if (= remaining 0)
        result
        (first-helper ((cdr proc)) (- remaining 1)
                                (cons (car proc) result))))
  (reverse (first-helper tok n '())))


(define (squares tok)
  (letrec ([f (lambda (proc)
                (cons (* (car proc) (car proc))
                      (lambda () (f ((cdr proc))))))])
    (f tok)))


(define-syntax sml
  (syntax-rules (nil null :: hd tl)
    [(sml nil) '()]
    [(sml x :: xs) (cons x xs)]
    [(sml null l) (null? l)]
    [(sml hd l) (car l)]
    [(sml tl l) (cdr l)]))

(define (my-delay thunk) 
  (mcons (mcons 0 0) thunk))

(define (my-force prom)
  (if (and (not (= (modulo (mcdr (mcar prom)) 5) 0)) (not (= (mcdr (mcar prom)) 0)))
      (begin (set-mcdr! (mcar prom) (+ (mcdr (mcar prom)) 1))
        (mcar(mcar prom)))
      (begin (set-mcdr! (mcar prom) (+ (mcdr (mcar prom)) 1))
             (set-mcar! (mcar prom) ((mcdr prom)) )
             (mcar (mcar prom)))))

(define (partitions k n)
  (cond [(and (= k 1) (= n 1)) 1]
        [(and (= k 0) (= n 0)) 1]
        [(or (<= k 0) (< n 0)) 0]
        [(+ (partitions k (- n k)) (partitions (- k 1) (- n 1)))])) 