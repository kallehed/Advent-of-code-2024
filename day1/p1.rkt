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
(define sorted-a-list (sort a-list <))
(define sorted-b-list (sort b-list <))
(define distances (map (λ (x) (abs (- (first x) (second x)))) (for/list ([a sorted-a-list] [b sorted-b-list]) (list a b))))
(define res (foldl + 0 distances))
(displayln res)
