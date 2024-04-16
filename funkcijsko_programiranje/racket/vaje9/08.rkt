#lang racket

(struct int (int) #:transparent)
(struct true () #:transparent)
(struct false () #:transparent)
(struct add (e1 e2) #:transparent)
(struct mul (e1 e2) #:transparent)
(struct ?leq (e1 e2) #:transparent)
(struct ~ (e) #:transparent)
(struct ?int (e) #:transparent)
(struct if-then-else (condition e1 e2) #:transparent)

(define (fri e)
  (cond [(int? e) e]  
        [(true? e) e]
        [(false? e) e]
        [(add? e)
         (let ([v1 (fri (add-e1 e))]
               [v2 (fri (add-e2 e))])
           (cond [(and (int? v1) (int? v2)) (int (+ (int-int v1) (int-int v2)))]
                 [(or (true? v1) (true? v2)) (true)]
                 [(and (false? v1) (false? v2)) (false)]
                 [#t (error "tipa se ne ujemata")]))]
        [(mul? e)
         (let ([v1 (fri (mul-e1 e))]
               [v2 (fri (mul-e2 e))])
           (cond [(and (int? v1) (int? v2)) (int (* (int-int v1) (int-int v2)))]
                 [(or (false? v1) (false? v2)) (false)]
                 [(and (true? v1) (true? v2)) (true)]
                 [#t (error "tipa se ne ujemata")]))]
        [(?leq? e)
         (let ([v1 (fri (?leq-e1 e))]
               [v2 (fri (?leq-e2 e))])
           (cond [(and (int? v1) (int? v2) (<= (int-int v1) (int-int v2))) (true)]
                 [(and (int? v1) (int? v2) (> (int-int v1) (int-int v2))) (false)]
                 [(and (true? v1) (false? v2)) (false)]
                 [(false? v1) (true)]
                 [(and (true? v1) (true? v2)) (true)]
                 [#t (error "tipa se ne ujemata")]))]
        [(~? e)
         (let ([v (fri (~-e e))])
           (cond [(int? v) (int (- (int-int v)))]
                 [(true? v) (false)]
                 [(false? v) (true)]
                 [#t (error "tipa se ne ujemata")]))]
        [(?int? e)
         (let ([v (fri (?int-e e))])
           (if (and (int? v) (number? (int-int v)))
               (true)
               (false)))]
        [(if-then-else? e)
         (let ([c (fri (if-then-else-condition e))]
               [v1 (fri (if-then-else-e1 e))]
               [v2 (fri (if-then-else-e2 e))])
           (if (true? c)
               v1
               v2))]
         ))

(define-syntax (?geq stx)
  (syntax-case stx ()
    [(_ e1 e2)
     #'(?leq e2 e1)]))

(define-syntax (conditional stx)
  (syntax-case stx ()
    [(_ clause ...)
     #'(if-then-else (true) (unroll-conditionals clause) ... (error "No true condition found"))]))

(define-syntax (unroll-conditionals stx)
  (syntax-case stx ()
    [(else expr ...)
     #'(begin expr ...)]
    [(test-expr expr more-clauses ...)
     #'(if-then-else test-expr expr (unroll-conditionals more-clauses) ...)]
    [(test-expr expr ...)
     #'(if-then-else test-expr (expr ...) (error "No else clause provided"))]))
