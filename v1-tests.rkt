#lang typed/racket

(require "v1-typed.rkt")

(define *view* #f)
(define *counter* 1)
(define *failed* '())

(define-syntax test
  (syntax-rules ()
    [(_ name expected exp)
     (cond
      [*view* (view exp)]
      [else
       (begin
         (printf "test ~a: ~a" *counter* name)
         (let ([result (view exp)])
           (cond
            [(equal? result expected)
             (printf "~n[\033[92mpass\033[0m]~n")]
            [else
             (set! *failed*
                   (append *failed* (list (list name expected exp))))
             (printf "~n[\033[91mfail\033[0m]~n")
             (printf "\033[92mexpected\033[0m:~n")
             (pretty-print expected)
             (printf "\033[91mactual\033[0m:~n")
             (pretty-print result)
             (printf "\033[93minput\033[0m:~n")
             (pretty-print exp)]))
         (set! *counter* (+ 1 *counter*)))])]))

(define (summary)
  (let ([nfailed (length *failed*)])
    (cond
     [(= 0 nfailed)
      (printf "all tests passed")]
     [else
      (printf "~a tests failed~n" nfailed)
      (pretty-print *failed*)])))


;; ------------------ parser tests ------------------
;; (parse '(f (:+ x 1) (:+ y 2)))
;; (parse '(f x y))
;; (parse '(f x (:+ y 2)))
;; (unparse (parse '(vec 1 2 3)))
;; (unparse (parse '(f (:+ x 1) (:+ y 2))))
;; (unparse (parse '(:+ (f x (:+ y 1)) (+ x y))))
;; (unparse (parse '(import r x y z)))
;; (unparse (parse 'x.y.z.w))
;; (unparse (parse '(return 1)))
;; (unparse (parse '(f 'x)))
;; (parse '(op + 1 2))
;; (unparse (parse '(begin x y z)))
;; (unparse (parse '(:+ x 1)))


(test
 "begin with only one statement"
 1
 '(begin
    1))

(test
 "function with no arguments"
 1
 '(begin
    (defun (f) 1)
    (f)))

(test
 "single positional arg"
 1
 '(begin
    (defun (f x) x)
    (f 1)))

(test
 "function positional param single keyword arg"
 1
 '(begin
    (defun (f x) x)
    (f (:+ x 1))))

(test
 "function with multiple positional args"
 '(vec 3 5)
 '(begin
    (defun (f x y)
      (vec x y))
    (f 3 5)))

(test
 "function mutiple positional param with keyword args same order"
 '(vec 2 3 5)
 '(begin
    (defun (f x y z)
      (vec x y z))
    (f (:+ x 2)
       (:+ y 3)
       (:+ z 5))))

(test
 "function mutiple positional param with keyword args (different order)"
 '(vec 2 3 5)
 '(begin
    (defun (f x y z)
      (vec x y z))
    (f (:+ y 3)
       (:+ z 5)
       (:+ x 2))))

(test
 "function mutiple keyword params with keyword args (full)"
 '(vec 2 3 5)
 '(begin
    (defun (f x (:+ y 42) (:+ z 7))
      (vec x y z))
    (f (:+ y 3)
       (:+ z 5)
       (:+ x 2))))

(test
 "function mutiple keyword params with keyword args (missing z)"
 '(vec 2 5 7)
 '(begin
    (defun (f x (:+ y 3) (:+ z 7))
      (vec x y z))
    (f (:+ y 5)
       (:+ x 2))))

(test
 "mixed parameter full keyword args"
 6
 '(begin
    (defun (f x (:+ y 1))
      (* x y))
    (f (:+ x 2) (:+ y 3))))

(test
 "mixed parameters default keyword arg for y"
 2
 '(begin
    (defun (f x (:+ y 1))
      (* x y))
    (f (:+ x 2))))

(test
 "function access field of arbitrary record arg"
 42
 '(begin
    (:+ f (fun (x) x.a))
    (:+ o (rec (:+ a 42)))
    (f o)))


(test
 "assignment in true branch"
 "true"
 '(begin
    (:+ x 1)
    (if (< x 2)
        (<- x "true")
        (<- x "false"))
    x))

(test
 "assignment in true branch"
 "false"
 '(begin
    (:+ x 5)
    (if (< x 2)
        (<- x "true")
        (<- x "false"))
    x))

(test
 "import from record simple"
 1
 '(begin
    (:+ r1 (rec (:+ x 1) (:+ y 2)))
    (import r1 (x))
    x))

(test
 "import from record nested"
 1
 '(begin
    (:+ r1 (rec (:+ x 1)))
    (:+ r2 (rec (:+ y r1)))
    (import r2.y (x))
    x))

(test
 "import from record nested"
 1
 '(begin
    (:+ r1 (rec (:+ x 1)))
    (:+ r2 (rec (:+ y r1)))
    (import r2 (y))
    (import y (x))
    x))

(test
 "import function and fields"
 30
 '(begin
    (:+ r1 (rec (:+ x 2) (:+ y 3)))
    (:+ r2 (rec (:+ z 5)
                (:+ f (fun (x y z) (* (* x y) z)))))
    (import r1 (x y))
    (import r2 (f z))
    (f x y z)))

(test
 "import inside function"
 6
 '(begin
    (:+ r1 (rec (:+ x 1)
                (:+ y 2)))
    (defun (f z)
      (import r1 (y))
      (* y z))
    (f 3)))

(test
 "return in middle"
 3
 '(begin
    (:+ x 1)
    (:+ y 2)
    (return (+ x y))
    10))

(test
 "defs to same var in different branches"
 "yes"
 '(begin
    (:+ x 1)
    (if (< x 2)
        (:+ s "yes")
        (:+ s "no"))
    s))

(test
 "defs to same var in different branches"
 "no"
 '(begin
    (:+ x 5)
    (if (< x 2)
        (:+ s "yes")
        (:+ s "no"))
    s))

(test
 "defs to same func name in different branches (true)"
 8
 '(begin
    (:+ x 1)
    (if (< x 2)
        (begin
          (:+ g (fun (y) (* y 2))))
        (begin
          (:+ g (fun (y) (/ y 2)))))
    (g 4)))

(test
 "defs to same func name in different branches (false)"
 2
 '(begin
    (:+ x 5)
    (if (< x 2)
        (begin
          (:+ g (fun (y) (* y 2))))
        (begin
          (:+ g (fun (y) (/ y 2)))))
    (g 4)))

(test
 "defs to same func name in different branches (func syntax, true)"
 8
 '(begin
    (:+ x 1)
    (if (< x 2)
        (begin
          (defun (g y) (* y 2)))
        (begin
          (defun (g y) (/ y 2))))
    (g 4)))

(test
 "defs to same func name in different branches (func syntax, false)"
 2
 '(begin
    (:+ x 5)
    (if (< x 2)
        (begin
          (defun (g y) (* y 2)))
        (begin
          (defun (g y) (/ y 2))))
    (g 4)))

(test
 "assignment inside function into environment"
 42
 '(begin
    (:+ x 1)
    (:+ f (fun (y) (<- x y)))
    (f 42)
    x))


;; even & odd mutural recursion
;; (define (even x) (if (= x 0) #t (odd (- x 1))))
;; (define (odd x) (if (= x 0) #f (even (- x 1))))
(test
 "mutural recursion (even 9 = false)"
 'false
 '(begin
    (defun (not x) (if (eq? x true) false true))
    (defun (even x) (if (= x 0) true (odd (- x 1))))
    (defun (odd x) (if (= x 0) false (even (- x 1))))
    (even 9)))

(test
 "mutural recursion (even 100 = true)"
 'true
 '(begin
    (:+ not (fun (x) (if (eq? x true) false true)))
    (:+ even (fun (x) (if (= x 0) true (odd (- x 1)))))
    (:+ odd (fun (x) (if (= x 0) false (even (- x 1)))))
    (even 100)))


(test
 "definition of not"
 'false
 '(begin
    (:+ not (fun (x) (if (eq? x true) false true)))
    (not true)))


(test
 "direct recursion (fact 5)"
 120
 '(begin
    (:+ fact (fun (x) (if (= x 0) 1 (* x (fact (- x 1))))))
    (fact 5)))

(test
 "conditional (simple)"
 "<"
 '(begin
    (:+ x 2)
    (:+ f (fun (x) (* x 2)))
    (if (< (f x) 5) "<" ">=")))

(test
 "conditional (simple)"
 ">="
 '(begin
    (:+ x 3)
    (:+ f (fun (x) (* x 2)))
    (if (< (f x) 5) "<" ">=")))

(test
 "comparison operator"
 "no"
 '(if (> 1 2) "yes" "no"))

(test
 "comparison operator"
 "yes"
 '(if (< 1 2) "yes" "no"))

(test
 "function goes through identity function"
 6
 '(begin
    (:+ f (fun (x) x))
    (:+ g (fun (x) (* x 2)))
    (:+ fg (f g))
    (fg 3)))

(test
 "function stored in record field"
 10
 '(begin
    (:+ r1 (rec (:+ x (fun (y) (* y 2)))))
    (r1.x 5)))

(test
 "function field pass to function and apply"
 10
 '(begin
    (defun (bar x) (x.foo 5))
    (bar (rec (:+ foo (fun (y) (* y 2)))))))

;; ----------------- pattern binding ------------------
(test
 "pattern binding, keyword, simple"
 '(vec 2 5)
 '(begin
    (:+ (rec (:+ x foo) (:+ y bar))
        (rec (:+ y 5) (:+ x 2)))
    (vec foo bar)))

(test
 "pattern binding, keyword, nested"
 '(vec 2 3 5)
 '(begin
    (:+ (rec (:+ x foo)
             (:+ y (rec (:+ u bar)
                        (:+ v baz))))
        (rec a
             (:+ y (rec (:+ v 5)
                        (:+ u 3)))
             (:+ x 2)))
    (vec foo bar baz)))

(test
 "pattern binding, vector, simple"
 '(vec 2 3 5)
 '(begin
    (:+ (vec x y z) (vec 2 3 5))
    (vec x y z)))

(test
 "pattern binding, vector, nested"
 '(vec 2 3 5 7)
 '(begin
    (:+ (vec x y (vec u v)) (vec 2 3 (vec 5 7)))
    (vec x y u v)))

(test
 "pattern binding, vector, nested, with wildcards"
 '(vec 1 5 9)
 '(begin
    (:+ (vec (vec x _ _)
             (vec _ y _)
             (vec _ _ z))
        (vec (vec 1 2 3)
             (vec 4 5 6)
             (vec 7 8 9)))
    (vec x y z)))

(test
 "pattern binding, vector, nested, with wildcards"
 '(vec 1 3 5 7 9)
 '(begin
    (:+ (vec (vec a _ b)
             (vec _ c _)
             (vec d _ e))
        (vec (vec 1 2 3)
             (vec 4 5 6)
             (vec 7 8 9)))
    (vec a b c d e)))

(test
 "pattern binding, vector, nested"
 '(vec 1 2 3 4 5 6 7 8 9)
 '(begin
    (:+ (vec (vec x y z)
             (vec u v w)
             (vec a b c))
        (vec (vec 1 2 3)
             (vec 4 5 6)
             (vec 7 8 9)))
    (vec x y z u v w a b c)))

(test
 "pattern binding, record and vector, nested"
 '(vec 2 3 5 7 11)
 '(begin
    (:+ (rec (:+ w foo)
             (:+ y (vec x y (vec u v))))
        (rec (:+ y (vec 2 3 (vec 5 7)))
             (:+ w 11)))
    (vec x y u v foo)))

(test
 "positionally bind vector into record"
 '(vec 3 5)
 '(begin
    (:+ (rec (:+ x 1) (:+ y 2))
        (vec 3 5))
    (vec x y)))

(test
 "function parameter destrcuturing binding (positional only)"
 '(vec 1 2 3)
 '(begin
    (defun (f (vec x (vec y z)))
      (vec x y z))
    (f (vec 1 (vec 2 3)))))

(test
 "hyper-nested destructuring binding test 1"
 '(vec 2 3 5)
 '(begin
    (:+ (rec (:+ u (vec x (rec (:+ w (vec y z))))))
        (rec (:+ u (vec 2 (rec (:+ w (vec 3 5)))))))
    (vec x y z)))

(test
 "hyper-nested destructuring binding test 2"
 '(vec 2 3 5 7 11)
 '(begin
    (:+ (rec (:+ w t)
             (:+ u (vec x (rec (:+ u foo)
                               (:+ w (vec y z))))))
        (rec (:+ u (vec 2 (rec (:+ w (vec 3 5))
                               (:+ u 11))))
             (:+ w 7)))
    (vec x y z t foo)))

(test
 "destructuring bind into record from function return"
 '(vec 2 3)
 '(begin
    (defun (f x) (rec (:+ a 2) (:+ b 3)))
    (:+ (rec (:+ b bar) (:+ a foo))
        (f 1))
    (vec foo bar)))

(test
 "destructuring bind into record from function return from parameter"
 '(vec 2 3)
 '(begin
    (:+ r1 (rec (:+ u 2) (:+ v 3)))
    (defun (f x) (rec (:+ a x.u) (:+ b x.v)))
    (:+ (rec (:+ b bar) (:+ a foo))
        (f r1))
    (vec foo bar)))

(test
 "attribute reference - 3 levels simple"
 42
 '(begin
    (:+ r1 (rec (:+ x (rec (:+ y (rec (:+ z 42)))))))
    r1.x.y.z))

(test
 "attribute reference - 3 levels from function"
 42
 '(begin
    (defun (f)
      (rec (:+ x (rec (:+ y (rec (:+ z 42)))))))
    (:+ r1 (f))
    r1.x.y.z))

(test
 "field acess after application - level 1"
 6
 '(begin
    (defun (f y) (rec (:+ x (* y 2))))
    (f 3).x))

(test
 "field acess after application - level 2"
 6
 '(begin
    (defun (f n) (rec (:+ x (rec (:+ y (* n 2))))))
    (f 3).x.y))

(test
 "field acess after application - level 3"
 6
 '(begin
    (defun (f n) (rec (:+ x (rec (:+ y (rec (:+ z (* n 2))))))))
    (f 3).x.y.z))

(test
 "complex field acess - func inside rec, returns rec"
 6
 '(begin
    (:+ r1 (rec
            (defun (f n) (rec (:+ x (* n 2))))))
    (r1.f 3).x))

(test
 "complex field access - func returns rec, contains func returns rec"
 6
 '(begin
    (defun (f n)
      (rec (:+ x (fun (m) (rec (:+ y (* n m)))))))
    ((f 2).x 3).y))

(test
 "complex field access - func applies to field, returns rec, contains func returns rec"
 6
 '(begin
    (:+ u (rec (:+ v 3)))
    (defun (f n)
      (rec (:+ x (fun (m) (rec (:+ y (* n m)))))))
    ((f 2).x u.v).y))

;; ending
(summary)