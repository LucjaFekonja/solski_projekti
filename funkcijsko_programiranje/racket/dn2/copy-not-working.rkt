#lang racket

(provide false true int .. empty exception
         trigger triggered handle
         if-then-else
         ?int ?bool ?.. ?seq ?empty ?exception
         add mul ?leq ?= head tail ~ ?all ?any
         vars valof fun proc closure call
         greater rev binary filtering folding mapping
         fri)

; Podatkovni tipi
(struct int (n) #:transparent)
(struct true () #:transparent)
(struct false () #:transparent)
(struct .. (e1 e2) #:transparent)
(struct empty () #:transparent)
(struct exception (exn) #:transparent)

; Nadzor toka
(struct trigger (exception) #:transparent)
(struct triggered (exception) #:transparent)
(struct handle (e1 e2 e3) #:transparent)
(struct if-then-else (condition e1 e2) #:transparent)
(struct ?int (e) #:transparent)
(struct ?bool (e) #:transparent)
(struct ?.. (e) #:transparent)
(struct ?seq (e) #:transparent)
(struct ?empty (e) #:transparent)
(struct ?exception (e) #:transparent)
(struct add (e1 e2) #:transparent)
(struct mul (e1 e2) #:transparent)
(struct ?leq (e1 e2) #:transparent)
(struct ?= (e1 e2) #:transparent)
(struct head (e) #:transparent)
(struct tail (e) #:transparent)
(struct ~ (e) #:transparent)
(struct ?all (e) #:transparent)
(struct ?any (e) #:transparent)

; Spremenljivke
(struct vars (s e1 e2) #:transparent)
(struct valof (s) #:transparent)

; Funkcije
(struct fun (name farg body) #:transparent)
(struct proc (name body) #:transparent)
(struct closure (env f) #:transparent)
(struct call (e args) #:transparent)

; FRIntrepreter
(define (fri e env) 
  (cond [(int? e) e]
        [(true? e) e]
        [(false? e) e]
        [(..? e)
         (let ((v1 (fri (..-e1 e) env))
               (v2 (fri (..-e2 e) env)))
           (.. v1 v2))]
        [(empty? e) e]
        [(exception? e) e]

        ; Proženje izjem
        [(trigger? e)
         (let ((v (fri (trigger-exception e) env))) 
           (cond [(triggered? v) v]
                 [(exception? v) (triggered v)]
                 [#t (triggered (exception "trigger: wrong argument type"))]))]

        ; Lovljenje izjem
        [(handle? e)
         (let ((v1 (fri (handle-e1 e) env)))
           (cond [(triggered? v1) v1]
                 [(not (exception? v1)) (triggered (exception "handle: wrong argument type"))]
                 [#t (let ((v2 (fri (handle-e2 e) env)))
                       (cond 
                         [(and (triggered? v2) (exception? v1) (equal? v1 (triggered-exception v2))) (fri (handle-e3 e) env)]
                         [#t v2]))]))]

        ; Vejitev
        [(if-then-else? e)
         (let ([c (fri (if-then-else-condition e) env)]
               [v1 (fri (if-then-else-e1 e) env)]
               [v2 (fri (if-then-else-e2 e) env)])
           (if (false? c)
               v2
               v1))]

        ; Preverjanje tipov
        [(?int? e)
         (let ((v (fri (?int-e e) env)))
           (if (int? v) (true) (false)))]
        [(?bool? e)
         (let ((v (fri (?bool-e e) env)))
           (if (triggered? v)
               v
               (if (or (true? v) (false? v)) (true) (false))))]
        [(?..? e)
         (let ((v (fri (?..-e e) env)))
           (if (..? v) (true) (false)))]
        [(?seq? e) 
         (let ((v (fri (?seq-e e) env)))
           (cond [(empty? v) (true)]
                 [(not (..? v)) (false)]
                 [(empty? (fri (..-e2 v) env)) (true)]
                 [#t (fri (?seq (fri (..-e2 v) env)) null)]))]
        [(?empty? e) 
         (let ((v (fri (?empty-e e) env)))
           (if (empty? v) (true) (false)))]
        [(?exception? e)
         (let ((v (fri (?exception-e e) env)))
           (if (exception? v) (true) (false)))]

        ; Seštevanje
        [(add? e)
         (let ((v1 (fri (add-e1 e) env))
               (v2 (fri (add-e2 e) env)))
           (cond [(triggered? v1) v1]
                 [(triggered? v2) v2]
                 [(and (int? v1) (int? v2)) (int (+ (int-n v1) (int-n v2)))]
                 [(and (equal? (fri (?bool v1) env) (true))
                       (equal? (fri (?bool v2) env) (true)))
                  (if (or (true? v1) (true? v2))
                      (true)
                      (false))]
                 [(and(equal? (fri (?seq v1) env) (true))
                       (equal? (fri (?seq v2) env) (true)))
                  (if (empty? v1)
                      v2
                      (let ((head (..-e1 v1))
                            (tail (..-e2 v1)))
                        (if (empty? tail)
                            (.. head v2)
                            (.. head (fri (add tail v2) env)))))]
                 [#t (triggered (exception "add: wrong argument type"))]
                 ))]

        ; Množenje
        [(mul? e)
         (let ((v1 (fri (mul-e1 e) env))
               (v2 (fri (mul-e2 e) env)))
           (cond [(triggered? v1) v1]
                 [(triggered? v2) v2]
                 [(and (int? v1) (int? v2)) (int (* (int-n v1) (int-n v2)))]
                 [(and (equal? (fri (?bool v1) env) (true))
                       (equal? (fri (?bool v2) env) (true)))
                  (if (and (true? v1) (true? v2))
                      (true)
                      (false))]
                 [#t (triggered (exception "mul: wrong argument type"))]
                 ))]

        ; Primerjanje
        [(?leq? e)
         (let ((v1 (fri (?leq-e1 e) env))
               (v2 (fri (?leq-e2 e) env)))
           (cond [(and (int? v1) (int? v2))
                  (if (<= (int-n v1) (int-n v2)) (true) (false))]
                 [(and (equal? (fri (?bool v1) env) (true))
                       (equal? (fri (?bool v2) env) (true)))
                  (cond [(equal? v1 (false)) (true)]
                        [(equal? v2 (true)) (true)]
                        [(equal? v2 (false)) (false)])]
                         
                 [(and (equal? (fri (?seq v1) env) (true))
                       (equal? (fri (?seq v2) env) (true)))
                  (if (empty? v1)
                      (true)
                      (if (empty? v2)
                          (false)
                          (let ((tail1 (..-e2 v1))
                                (tail2 (..-e2 v2)))
                            (fri (?leq tail1 tail2) env))))]
                 [#t (triggered (exception "?leq: wrong argument type"))]
                 ))]

        ; Ujemanje
        [(?=? e)
         (let ((v1 (fri (?=-e1 e) env))
               (v2 (fri (?=-e2 e) env)))
           (if (equal? v1 v2) (true) (false)))]

        ; Ekstrakcija
        [(head? e)
         (let ((v (fri (head-e e) env)))
           (cond [(empty? v) (triggered (exception "head: empty sequence"))]
                 [(..? v) (..-e1 v)]
                 [#t (triggered (exception "head: wrong argument type"))]))]
        [(tail? e)
         (let ((v (fri (tail-e e) env)))
           (cond [(empty? v) (triggered (exception "tail: empty sequence"))]
                 [(..? v) (..-e2 v)]
                 [#t (triggered (exception "tail: wrong argument type"))]))]

        ; Nasprotna vrednost 
        [(~? e)
         (let ((v (fri (~-e e) env)))
           (cond [(int? v) (int (- (int-n v)))]
                 [(true? v) (false)]
                 [(false? v) (true)]
                 [#t (triggered (exception "~: wrong argument type"))]))]

        ; All
        [(?all? e)
         (let ((v (fri (?all-e e) env)))
           (cond [(equal? (fri (?seq v) env) (false)) (triggered (exception "?all: wrong argument type"))]
                 [(empty? v) (true)]
                 [(equal? (fri (head v) env) (false)) (false)]
                 [#t (fri (?all (tail v)) env)]))]

        ; Any
        [(?any? e)
         (let ((v (fri (?any-e e) env)))
           (cond [(equal? (fri (?seq v) env) (false)) (triggered (exception "?any: wrong argument type"))]
                 [(empty? v) (false)]
                 [(not (equal? (fri (head v) env) (false))) (true)]
                 [#t (fri (?any (tail v)) env)]))]

        ; Lokalno okolje
        [(vars? e)
         (let* ([s (vars-s e)]
                [e1 (vars-e1 e)]
                [e2 (vars-e2 e)])
           (if
             (and (list? s) (list? e1))
             (cond
               [(triggered? (fri (car e1) env)) (fri (car e1) env)]
               [(member (car s) (cdr s)) (triggered (exception "vars: duplicate identifier"))]
               [(= (length s) 0) (fri e2 env)]
               [(> (length s) 1) (fri (vars (cdr s) (cdr e1) e2) (cons (cons (car s) (fri (car e1) env)) env))]
               [#t (fri e2 (reverse (cons (cons (car s) (fri (car e1) env)) env)))])
             (if (triggered? (fri e1 env))
                 (fri e1 env)
                 (fri e2 (cons (cons s (fri e1 env)) env)))))]
  

                  
            ;      (fri e2 (cons (cons (car s) (fri (car e1) env)) env)))]
            ; [(and (list? s) (list? e1))
            ;  (if (member (car s) (cdr s))
            ;      (triggered (exception "vars: duplicate identifier"))
            ;      (fri (vars (cdr s) (cdr e1) e2) (extend-environment s e1 env)))]
       
        [(valof? e)
         (let* ([s (valof-s e)]
                [var-value (lookup-variable-value s env)])
           (if (exception? var-value)
               (triggered var-value)
               var-value))]

        [(fun? e)
         (let ((name (fun-name e))
               (farg (fun-farg e))
               (body (fun-body e)))
           (cond [(triggered? body) body]
                 [(check-duplicates farg) (triggered (exception "fun: duplicate argument identifier"))]
                 [(missing-variable env body) (triggered (exception "closure: undefined variable"))]
                 [#t (closure env (fun name farg body))]))]

        [(proc? e) e]
        
        [(call? e)
         (let ([func (fri (call-e e) env)]
               [args (call-args e)])
           (cond
             [(triggered? func) func]
             [(closure? func)
              (let* ([f (closure-f func)]
                    [name (fun-name f)]
                    [fargs (fun-farg f)]
                    [extended-env
                     (if (check-duplicates (cons name fargs))
                         (extend-environment fargs args env)
                         (cons (cons name func) (extend-environment fargs args env)))])
                (if (not (= (length fargs) (length args)))
                    (triggered (exception "call: arity mismatch"))
                    (fri (fun-body f) extended-env)))]

             [(proc? func)
              (let* ([proc-body (proc-body func)]
                     [proc-env (cons (cons (proc-name func) func) env)])
                (fri proc-body proc-env))]
             
             [#t (triggered (exception "call: wrong argument type"))]))]))
                


; Pomožne funkcije za vars in valof
(define (lookup-variable-value var env)
  (cond
    [(null? env) (exception "valof: undefined variable")]
    [(eq? (caar env) var) (cdar env)]
    [else (lookup-variable-value var (cdr env))]))

; Pomožne funkcije za funkcije
(define (missing-variable env body)
  (cond [(trigger? body) body]
        [(exception? body) #f]
        [(valof? body) (member (valof-s body) (get-first-elements env))]
        [(int? body) #f]
        [(true? body) #f]
        [(false? body) #f]
        [(empty? body) #f]
        [(..? body) (or (missing-variable env (..-e1 body)) (missing-variable env (..-e2 body)))]
        [(handle? body) (or (missing-variable env (handle-e1 body)) (missing-variable env (handle-e2 body)) (missing-variable env (handle-e3 body)))]
        [(if-then-else? body) (or (missing-variable env (if-then-else-condition body)) (missing-variable env (if-then-else-e1 body)) (missing-variable env (if-then-else-e2 body)))]
        [(?int? body) (missing-variable env (?int-e body))]
        [(?bool? body) (missing-variable env (?bool-e body))]
        [(?..? body) (missing-variable env (?..-e body))]
        [(?seq? body) (missing-variable env (?seq-e body))]
        [(?empty? body) (missing-variable env (?empty-e body))]
        [(?exception? body) (missing-variable env (?exception-e body))]
        [(add? body) (or (missing-variable env (add-e1 body)) (missing-variable env (add-e2 body)))]
        [(mul? body) (or (missing-variable env (mul-e1 body)) (missing-variable env (mul-e2 body)))]
        [(?leq? body) (or (missing-variable env (?leq-e1 body)) (missing-variable env (?leq-e2 body)))]
        [(?=? body) (or (missing-variable env (?=-e1 body)) (missing-variable env (?=-e2 body)))]
        [(head? body) (missing-variable env (head-e body))]
        [(tail? body) (missing-variable env (tail-e body))]
        [(~? body) (missing-variable env (~-e body))]
        [(?all? body) (missing-variable env (?all-e body))]
        [(?any? body) (missing-variable env (?any-e body))]))

(define (get-first-elements pairs)
  (map (lambda (pair) (car pair)) pairs))


;(define (copy-environment env)
;  (map (lambda (binding) (cons (car binding) (cdr binding))) env))

(define (extend-environment vars vals env)
  (if (null? vars)
      env
      (let ([new-env (cons (cons (car vars) (fri (car vals) env)) env)])
        (extend-environment (cdr vars) (cdr vals) new-env))))

(define (lookup-closure-variable-value var env)
  (cond
    [(null? env) (exception "closure: undefined variable")]
    [(eq? (caar env) var) (cdar env)]
    [else (lookup-closure-variable-value var (cdr env))]))

(define (closed-env? env)
  (and (list? env)
       (for-each (lambda (x) (and (symbol? (car x)) (not (eq? (cdr x) 'unbound))))
              env)))


; #########################################################
; ########################  MAKRO #########################
; #########################################################

; Večji
(define (greater e1 e2)
  (?leq e1 e2))

; Obrni
(define (rev seq)
  (let ((v (fri seq null)))
  (if (equal? (fri (?empty v) null) (true))
      (empty)
      (add (rev (..-e2 v)) (.. (..-e1 v) (empty))))))

; Pretvorba v binarni zapis
(define (binary n)
  (let ([m (int-n (fri n null))])
    (cond
      [(> m 0) (add (binary (int (quotient m 2))) (.. (int (modulo m 2)) (empty)))]
      [(= m 0) (empty)])))
       
(define (mapping f seq) seq)
(define (filtering f seq) seq)
(define (folding f init seq) seq)
