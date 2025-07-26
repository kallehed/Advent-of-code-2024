#lang racket

(define in (open-input-file "data.txt"))

(define (parse-a-line line)
    (if (= 0 (string-length line))
        (list)
        (map string->number (regexp-split #rx" +" line))
    )
)

(define list-of-num-tuples (filter (λ (x) (= (length x ) 2)) (map parse-a-line (regexp-split #rx"\n" (port->string in)))))
(define a-list (map first list-of-num-tuples))
(define b-list (map second list-of-num-tuples))
(foldl + 0 (map (λ (a) (* a (count (λ (x) (= a x)) b-list))) a-list))