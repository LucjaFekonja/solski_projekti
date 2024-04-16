#lang racket

(define (power base e)
  (if (= e 0)
  1
  (* base (power base (- e 1)))))

(define (gcd a b) (
  if (= 0 b)
  a
  (gcd b (modulo a b))))

(define (fib n)
  (cond [(= n 1) 1]
        [(= n 2) 1]
        [#t (+ (fib (- n 2)) (fib (- n 1)))]))

(define (reverse l)
  (if (null? l)
      l
      (append (reverse (cdr l)) (list (car l)))))

(define (remove x l)
  (cond [(null? l) l]
        [(= (car l) x) (remove x (cdr l))]
        [#t (cons (car l) (remove x (cdr l)))]))

(define (map f l)
  (cond [(null? l) l]
        [#t (cons (f (car l)) (map f (cdr l)))]))

(define (filter f l)
  (cond [(null? l) l]
        [(f (car l)) (cons (car l) (filter f (cdr l)))]
        [#t (filter f (cdr l))]))

(define (zip l s)
  (cond [(or (null? l) (null? s)) (list)]
        [#t (cons (cons (car l) (car s)) (zip (cdr l) (cdr s)))]))

(define (range zacetek konec korak)
  (cond [(> zacetek konec) (list)]
        [#t (cons zacetek (range (+ zacetek korak) konec korak))]))

(define (is-palindrome l)
  (equal? l (reverse l)))
